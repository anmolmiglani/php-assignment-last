#!/usr/bin/perl

package LAMPAS::sample;

use strict;
use warnings;
use Apache2::RequestRec ();		# Default requirement. Also for the function headers_in() (depends on APR::Table)
use Apache2::RequestIO ();		# Not too sure why I need this yet :)
use Apache2::Const -compile => qw(OK);	# Required for the return status
use APR::Table;				# Required for getting the request headers
use DBI;

# Set our start-up variables
my $pid		= 1;
my $version	= 1;
my $branch	= 1;
my $dbhost	= "localhost";
my $dbport	= "3306";
my $dbuser	= "root";
my $dbpass	= "";
my $dbdriver	= "mysql";
my $localmime	= "text/html";

sub handler {

	my $dbh1;

	if( loaddbconf() ) {

		$dbh1	= DBI->connect( "dbi:$dbdriver:database=lampas;host=$dbhost;port=$dbport", "$dbuser", "$dbpass" );

		my $sql = "SELECT `MIME_type` from `package_properties` WHERE `pid` = $pid";
		my $sth	= $dbh1->prepare( $sql );
		if( $sth->execute() ) {

			while( my $dbmime = $sth->fetchrow_array() ) {

				$localmime	= $dbmime;

			}

		}

	}
	
	my $r = shift;
	$r->content_type( "$localmime" );

	# Get our request headers
	my $headers_in	= $r->headers_in;

	#
	# Below is the actual code from src that was generated by the code compiler
	#
	print "
<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
<html>
<head>
  <title>LAMPAS Sample Module</title>
    <meta name=\"AUTHOR\" content=\"LAMPAS - http://lampas.sourceforge.net/\">
      <meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\">
        <meta name=\"KEYWORDS\" content=\"linux,apache,mysql,perl,lampas,application,server\">
	</head>
	<body>
		<p>
		<strong>Information : </strong> This is a sample script that does nothing else but to display this message. Development is under way to extend this sample script into something more usefull.
		<p><hr><p>
	\n";

	foreach my $key ( keys %($r->headers_in} ) {

		my $val	= $headers_in{ $key };
		print "<i>$key</i>=$val<br>\n";

	}

	print "
		</p><hr><p>The end...</p>
		</body>
		</html>
	\n";

	return Apache2::Const::OK;
	
}

sub loaddbconf {

	# This sub loads the db configuration from the LAMPAS main.conf file.

	if( $ENV{ 'DBHOST' } ) { $dbhost = $ENV{ 'DBHOST' }; }
	if( $ENV{ 'DBPORT' } ) { $dbport = $ENV{ 'DBPORT' }; }
	if( $ENV{ 'DBUSER' } ) { $dbuser = $ENV{ 'DBUSER' }; }
	if( $ENV{ 'DBPASS' } ) { $dbpass = $ENV{ 'DBPASS' }; }
	if( $ENV{ 'DBDRIVER' } ) { $dbdriver = $ENV{ 'DBDRIVER' }; }

	return 1;

}

1;
