#!/usr/bin/perl

package LAMPAS::did2;

use strict;
#use warnings;
use warnings FATAL => 'all';
use Apache2::RequestRec ();				# required by mod_perl
use Apache2::RequestIO ();				# required by mod_perl
use Apache2::Const -compile => qw(:common REDIRECT);	# Use common constants
use Apache2::Log;					# For DEBUG logging
use APR::Table;						# Required for headers_in() function
use DBI;						# MySQL connectivity (hint: use with Apache::DBI in startup.pl)
use MIME::Base64::URLSafe;				# Base64 encoding routines
use Crypt::CBC;						# Encryption routines (requires Crypt::Blowfish)

# Set our start-up variables
my $did		= 1;					# Package deployment ID
my $domid	= 1;					# Domain ID
my $pid		= 1;					# Package ID
my $version	= 1;					# Package Version
my $branch	= 1;					# Package Branch
my $live_date	= "";					# Init the live date variable
my $dbhost	= "localhost";
my $dbport	= "3306";
my $dbuser	= "root";
my $dbpass	= "";
my $dbdriver	= "mysql";
my $localmime	= "text/html";
my $thispackage	= __PACKAGE__;
my $systemid	= 1;					# Set the default sysid
my $cryptkey	= "";					# Init the encryption/decryption key
my $debug	= 0;

sub handler {

	#
	# PREP Phase
	#

	my $r 		= shift;
	my $dbh1;	# Prep a DB handle

	#######################################
	#                                     #
	# Step 1 - Load configs               #
	#                                     #
	#######################################
	if( loaddbconf() ) {

		# First, identify the Deployment ID for this module
		$thispackage	=~ /LAMPAS::did(\d+)/;
		if( $1 ) {

			$did		= $1;

		} else {

			$r->content_type( "text/html" );
			print "<html><head><title>ERROR</title></head><body><h3>Error</h3><hr><p>An internal error prevents this request from being executed at this time. please try again later. [err=0002]</p></body>";
			return Apache2::Const::OK;

		}

		# try to connect to the DB
		eval {
		
			$dbh1	= DBI->connect( "dbi:$dbdriver:database=lampas;host=$dbhost;port=$dbport", "$dbuser", "$dbpass" );

		};

		# If we have a DB connection, load the resource MIME type.
		if( $dbh1 ) {

			# Get the DOMAIN ID (domid) for this deployment
			my $sql 	= "SELECT `MIME_type` from `package_properties` WHERE `pid` = $pid";
			my $sth		= $dbh1->prepare( $sql );
			if( $sth->execute() ) {

				while( my $dbmime = $sth->fetchrow_array() ) {

					$localmime	= $dbmime;

				}

			}
			
			# Get the encryption key for this domain, and check if this domain is still active.
			my $sql2	= "SELECT `status`, `key` FROM `domain_definitions` WHERE `domid` = $did";
			my $sth2	= $dbh1->prepare( $sql2 );
			if( $sth2->execute() ) {
			
				while( ( my $domstatus, my $domkey ) = $sth2->fetchrow_array() ) {
				
					if( $domstatus ) {
					
						$cryptkey = $domkey;
					
					} else {
					
						# Domain is inactive - reject any requests
						$r->content_type( "text/html" );
						print "<html><head><title>ERROR</title></head><body><h3>Error</h3><hr><p>An internal error prevents this request from being executed at this time. please try again later. [err=0007]</p></body>";
						return Apache2::Const::OK;
					
					}
				
				}
			
			}

		} else {

			# DB Error - we can not serve this request...
			$r->content_type( "text/html" );
			print "<html><head><title>ERROR</title></head><body><h3>Error</h3><hr><p>An internal error prevents this request from being executed at this time. please try again later. [err=0001]</p></body>";
			return Apache2::Const::OK;

		}

	}

	# Load all our request headers
	my $headers_in	= $r->headers_in;

	#######################################
	#                                     #
	# Step 2 - Module Auth and Authz      #
	#                                     #
	#######################################

	# TO DO
	#
	# Any authentication information will be in an encrypted form in a cookie called: lampas_session
	#
	# Steps:
	#
	#	1) Retrieve the lampas_session cookie (if possible). If cookie is not present, set "public" indicator
	#	2) Decrypt and decode cookie
	#	3) Retrieve the session_id value
	#	4) Lookup the session from the session db. Update values if required.
	#	5) If no session was present, set-up initial cookie ("public" flag -> uid=0)
	#	6) Reset the cookie value
	#
	# If a cookie has expired, or the resource requires a logon, redirect to a logon page
	
	# First get the latest branch and version for this module
	my $html	= "";
	my $sql1	= "SELECT `pid`,`branch`, `version`, `live_date` FROM `deployment_definitions` WHERE `did` = $did AND `auth_status` = 1 ORDER BY `live_date` DESC LIMIT 0,1";
	my $sth1	= $dbh1->prepare( $sql1 );
	if( $sth1->execute() ) {

		while( ( my $dbpid, my $dbbranch, my $dbversion, my $dblive_date ) = $sth1->fetchrow_array() ) {

			$pid		= $dbpid;
			$branch		= $dbbranch;
			$version	= $version;
			$live_date	= $dblive_date;

		}

	} else {

		# DB Error - we can not serve this request...
		$r->content_type( "text/html" );
		print "<html><head><title>ERROR</title></head><body><h3>Error</h3><hr><p>An internal error prevents this request from being executed at this time. please try again later. [err=0003]</p></body>";
		return Apache2::Const::OK;

	}
	
	# Start with the auth routine:
	my $userpublic	= 1;					# Set default to be a public resource
	my $uid		= 0;					# Set default UID
	my @gid		= ();					# Init GID
	my $sessionid	= 0;					# Set default session ID
	my $cookie	= $r->headers_in->{Cookie} || '';	# get the cookies
	my $referer	= $r->headers_in->{Referer} || '';	# Get the Referer if set
	my $target	= $r->uri();				# get the URI
	my @crumbs	= split( /[\,|\;]/, $cookie );		# Split the cookies into pairs
	my $cookiestr	= "";					# Prep our cookie log variable
	my $authed	= 0;					# Set default to auth denied
	
	if( $debug ) {
	
		$r->log_error("debug: did=$did pid=$pid target=$target");
	
	}
	
	foreach my $crumb ( @crumbs ) {
	
		( my $key, my $val1 ) = split( /=/, $crumb );
		
		
		# decode and decrypt the value to get the session ID
		my $decoded	= urlsafe_b64decode( $val1 );		# Decode
		my $cipher	= Crypt::CBC->new(			# Init the cipher with the domian key
					-key    => $cryptkey,
					-cipher => 'Blowfish'
					);
						
		my $val		= $cipher->decrypt( $decoded );		# Get the cookie value
		$cookiestr	.= "$key=$val ; ";
			
		if( $key =~ /^lampas_session$/i ) {
			
			$sessionid	= $val;	# Set the session ID
			
			if( $sessionid ) {
			
				# We have a session ID - get the UID and GID's
				my $sql1	= "SELECT `uid` FROM `session_tracker` WHERE `session_id` = $sessionid";
				my $sth1	= $dbh1->prepare( $sql1 );
				if( $sth1->execute() ) {
				
					while( my $dbuid = $sth1->fetchrow_array() ) {
					
						if( $dbuid ) {
						
							# We have a UID - set the global
							$uid	= $dbuid;
						
						}
					
					}
				
				}
				
				# If the UID is set, get all the groups (GID) the user belongs to
				if( $uid ) {
				
					# Get all the GID's
					my $sql2	= "SELECT `gid` FROM `user_groups` WHERE `uid` = $uid AND `status` = 1";
					my $sth2	= $dbh1->prepare( $sql2 );
					if( $sth2->execute() ) {
					
						while( my $dbgid = $sth2->fetchrow_array() ) {
						
							if( $dbgid ) { push( @gid, $dbgid ); }
						
						}
					
					}
					
					# Update the session DB
					$dbh1->do( "UPDATE `session_tracker` SET `referer` = '$referer', `target` = '$target', `timestamp` = NOW() WHERE `session_id` = $sessionid AND `uid` = $uid AND `domid` = $domid" );
					
					# Now check for authorization
					my $sql3	= "SELECT `idtype`, `id`, `flags` FROM `package_permisssions` WHERE `pid` = $pid";
					my $dbh2	= DBI->connect( "dbi:$dbdriver:database=lampas;host=$dbhost;port=$dbport", "$dbuser", "$dbpass" );
					my $sth3	= $dbh1->prepare( $sql3 );
					if( $sth3->execute() ) {
					
						my $dbh2	= DBI->connect( "dbi:$dbdriver:database=lampas;host=$dbhost;port=$dbport", "$dbuser", "$dbpass" );
					
						while( ( my $idtype, my $id, my $flags ) = $sth3->fetchrow_array() ) {
						
							# Get the flag
							$id =~ /^\d\d\d\d\d(\d).+/;
							my $idval	= $1;
						
							# For this resource we are only checkking flag position 5 (starting at 0). 
							# If we get a '1' with our UID or GID, we set $authed to '1' (status = authorised).
							# A $idtype of 'All' with flag of '1', automatically allows the resource to be executed, 
							# regardless of the login state (public execute rights).
							if( ( $idtype =~ /all/i ) && ( $idval > 0 ) ) { 
							
								$authed++; 
								$dbh2->do( "INSERT INTO `session_log` ( `session_id`, `uid`, `domid`, `timestamp`, `referer`, `target`, `cookies`, `authstatus`, `log_msg` ) VALUES ( $sessionid, $uid, $domid, NOW(), '$referer', '$target', '$cookiestr', 1, 'This resource has PUBLIC execute rights.' )" );
								
							} else {
								
								# If the idtype is "User" and the UID matces the `id`, check if we are allowed...
								if( ( $idtype =~ /user/i ) && ( $id == $uid ) && ( $idval > 0 ) ) { 
								
									$authed++; 
									$dbh2->do( "INSERT INTO `session_log` ( `session_id`, `uid`, `domid`, `timestamp`, `referer`, `target`, `cookies`, `authstatus`, `log_msg` ) VALUES ( $sessionid, $uid, $domid, NOW(), '$referer', '$target', '$cookiestr', 1, 'UID Matches and authorised' )" );
									
								} elsif( ( $idtype =~ /user/i ) && ( $id == $uid ) && ( $idval > 0 ) ) { 
								
									# User seems to be specifically denied - return security error
									$dbh2->do( "INSERT INTO `session_log` ( `session_id`, `uid`, `domid`, `timestamp`, `referer`, `target`, `cookies`, `authstatus`, `log_msg` ) VALUES ( $sessionid, $uid, $domid, NOW(), '$referer', '$target', '$cookiestr', 0, 'UID Matches but configuration denies this specific user.' )" );
									# Security Error - we can not serve this request...
									$r->content_type( "text/html" );
									print "<html><head><title>Access Denied</title></head><body><h3>Access Denied</h3><hr><p>You do not have sufficient privileges to access this resource [secerr=0001]</p></body>";
									return Apache2::Const::OK;
								
								}
								
								# If the idtype is "Group" and the UID belongs to the GID and the flag allows it, inc $authed
								if( $idtype =~ /group/i ) {
								
									foreach my $g ( @gid ) {
									
										if( ( $g == $id ) && ( $idval > 0 ) ) { 
										
											$authed++; 
											$dbh2->do( "INSERT INTO `session_log` ( `session_id`, `uid`, `domid`, `timestamp`, `referer`, `target`, `cookies`, `authstatus`, `log_msg` ) VALUES ( $sessionid, $uid, $domid, NOW(), '$referer', '$target', '$cookiestr', 1, 'User belongs to group GID which has access to this resource.' )" );
											
										}
									
									}
								
								}
							
							}
						
						}
						
					
					}
				
				}
			
			}
		
		}
	
	}
	
	# User not logged in. Now check if this resource has world execute access
	if( $uid < 1 ) {
	
		my $sql1	= "SELECT `flags` FROM `package_permisssions` where `pid` = $pid AND `idtype` = 'All' LIMIT 0,1";
		my $sth1	= $dbh1->prepare( $sql1 );
		if( $sth1->execute() ) {
				
			my $dbh2	= DBI->connect( "dbi:$dbdriver:database=lampas;host=$dbhost;port=$dbport", "$dbuser", "$dbpass" );
				
			while( my $flags = $sth1->fetchrow_array() ) {
					
				# Check flag value
				$flags		=~ /^\d\d\d\d\d(\d).+/;
				my $idval	= $1;
				if( $idval > 0 ) {
					
					$authed++; 
					$dbh2->do( "INSERT INTO `session_log` ( `session_id`, `uid`, `domid`, `timestamp`, `referer`, `target`, `cookies`, `authstatus`, `log_msg` ) VALUES ( $sessionid, $uid, $domid, NOW(), '$referer', '$target', '$cookiestr', 1, 'This resource has PUBLIC execute rights.' )" );
					
				} else {
					
					$dbh2->do( "INSERT INTO `session_log` ( `session_id`, `uid`, `domid`, `timestamp`, `referer`, `target`, `cookies`, `authstatus`, `log_msg` ) VALUES ( $sessionid, $uid, $domid, NOW(), '$referer', '$target', '$cookiestr', 0, 'No user logged in and PUBLIC access is denied.' )" );
					
				}
					
			}
				
		}
	
	}
	
	# If the authentication required for this page failed, redirect to the logon page as defined in the `domain_properties` table
	if( $authed < 1 ) {
	
		# We can not proceed due to security limitations:
		# 
		# Steps:
		#
		#	1. Get the logon resource from the `domain_properties` table
		#	2. Redirect to the logon page
		#
		my $sql1	= "SELECT `value` FROM `domain_properties` WHERE `domid` = $domid AND `key` = 'logon_uri' LIMIT 0,1";
		my $sth1	= $dbh1->prepare( $sql1 );
		if( $sth1->execute() ) {
		
			my $newtarget;
			while( ( my $dbnewtarget ) = $sth1->fetchrow_array() ) {
			
				$newtarget	= $dbnewtarget;
			
			}
			
			# Log
			my $dbh2	= DBI->connect( "dbi:$dbdriver:database=lampas;host=$dbhost;port=$dbport", "$dbuser", "$dbpass" );
			$dbh2->do( "INSERT INTO `session_log` ( `session_id`, `uid`, `domid`, `timestamp`, `referer`, `target`, `cookies`, `authstatus`, `log_msg` ) VALUES ( $sessionid, $uid, $domid, NOW(), '$referer', '$target', '$cookiestr', 0, 'Redirect did=$did to target=$newtarget' )" );
			
			# Redirect:
			$r->headers_out->set(
				'Location' => $newtarget,
				);
			return Apache2::Const::REDIRECT;
		
		} 
		
		# If we get here, something went wrong with the redirect - print an error
		$r->content_type( "text/html" );
		print "<html><head><title>Redirect Error</title></head><body><h3>Redirect Error</h3><hr><p>An internal error prevents this request from being redirected to the logon page. Please try again later. [secerr=0001]</p></body>";
		return Apache2::Const::OK;
	
	}

	#######################################
	#                                     #
	# Step 3 - Handle request             #
	#                                     #
	#######################################

	$r->content_type( "$localmime" );

	#
	# Load the src from the DB and execute
	#
	# Now get the latest src code
	my $dbh2	= DBI->connect( "dbi:$dbdriver:database=lampas;host=$dbhost;port=$dbport", "$dbuser", "$dbpass" );
	my $sql2	= "SELECT `src` FROM `package_src` WHERE `pid` = $pid AND `version` = $version AND `branch` = $branch";
	my $sth2	= $dbh2->prepare( $sql2 );
	if( $sth2->execute() ) {

		while( my $src = $sth2->fetchrow_array() ) {

			if( length( $src ) ) {

				# EXECUTE Our LAMPAS Package Code
				my $code 	= sub { my $dummy = 1; eval $src };
				my $result	= $code->();
				print "$result\n";

				# See if an error occured during code execution. If it did, print a friendly error.
				if( $@ ) {

					# SOURCE Error - we can not serve this request...
					$r->content_type( "text/html" );
					print "<html><head><title>ERROR</title></head><body><h3>Error</h3><hr><p>An internal error prevents this request from being executed at this time. please try again later. [err=0006]</p></body>";
					return Apache2::Const::OK;

				}

			} else {

				# SOURCE Error - we can not serve this request...
				$r->content_type( "text/html" );
				print "<html><head><title>ERROR</title></head><body><h3>Error</h3><hr><p>An internal error prevents this request from being executed at this time. please try again later. [err=0005]</p></body>";
				return Apache2::Const::OK;

			}

		}

	} else {

		# DB Error - we can not serve this request...
		$r->content_type( "text/html" );
		print "<html><head><title>ERROR</title></head><body><h3>Error</h3><hr><p>An internal error prevents this request from being executed at this time. please try again later. [err=0004]</p></body>";
		return Apache2::Const::OK;

	}

	#######################################
	#                                     #
	# Step 4 - Cleanup                    #
	#                                     #
	#######################################
	
	# TO DO

	#######################################
	#                                     #
	# Step 5 - Return                     #
	#                                     #
	#######################################

	return Apache2::Const::OK;
	
}

sub loaddbconf {

	# This sub loads the db configuration from the LAMPAS main.conf file.

	if( $ENV{ 'DBHOST' } ) { $dbhost = $ENV{ 'DBHOST' }; }
	if( $ENV{ 'DBPORT' } ) { $dbport = $ENV{ 'DBPORT' }; }
	if( $ENV{ 'DBUSER' } ) { $dbuser = $ENV{ 'DBUSER' }; }
	if( $ENV{ 'DBPASS' } ) { $dbpass = $ENV{ 'DBPASS' }; }
	if( $ENV{ 'DBDRIVER' } ) { $dbdriver = $ENV{ 'DBDRIVER' }; }
	if( $ENV{ 'SYSTEM_ID' } ) { $systemid = $ENV{ 'SYSTEM_ID' }; }
	if( $ENV{ 'DOMAINID' } ) { $domid = $ENV{ 'DOMAINID' }; }
	if( $ENV{ 'DEBUG' } ) { $debug = $ENV{ 'DEBUG' }; }

	return 1;

}

1;
