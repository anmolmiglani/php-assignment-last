#!/usr/bin/perl

use strict;

# Function: Upload source code into the DB, with parameters. This program follows Q&A approach

use DBI;
my $dbh1	= DBI->connect( "dbi:mysql:database=lampas;host=127.0.0.1;port=3306", "user", "" );

my $pid		= $ARGV[0];	# Get the PID from the commandline args
my $branch	= 1;		# Set the default branch
my $version	= 1;		# Set the default version

if( $pid ) {

	# Get the branches
	my %branchseen	= ();
	my $sql1	= "SELECT DISTINCT `branch` FROM `package_src` WHERE `pid` = 1";
	my $sth1	= $dbh1->prepare( $sql1 );
	$sth1->execute();
	print "Select one of the following branches:\n\n";
	while( my $dbbranch = $sth1->fetchrow_array() ) {
	
		print "\t$dbbranch\n";
		$branchseen{ $dbbranch }++;
		
	
	}
	
	print "\nSelection: ";
	my $input	= <STDIN>;
	chomp( $input );
	$input		=~ /(\d+)/;
	$branch		= $1;
	if( $branchseen{ $branch } ) {
	
		# get the last version number for this branch
		print "\nRetrieving the last version number for branch $input :\n\n";
		my $sql2	= "SELECT `version` FROM `package_src` WHERE `pid` = $pid AND `branch` = $branch ORDER BY `version` DESC LIMIT 0,1";
		my $sth2	= $dbh1->prepare( $sql2 );
		if( $sth2->execute() ) {
		
			while( my $dbversion = $sth2->fetchrow_array() ) {
		
				print "\tLast version number        : $dbversion\n";
				$version	= $dbversion + 1;
				print "\tNext version number set to : $version\n\n";
		
			}
		
		} else {
		
			print STDERR "DB Error [001]. Quiting.\n\n";
			exit;
		
		}
	
	} else {
	
		print STDERR "It seems there is an error with your selection. Please re-run this script and try again.\n\n";
		exit;
	
	}


} else {

	print STDERR "You must supply a PID as the only parameter.\n\n";
	exit;

}

print "Please supply the complete path and filename of the file to commit:\n\t> ";
my $input	= <STDIN>;
chomp( $input );
if( -e $input ) {

	my $src;
	open( INF, "< $input" );
	while( <INF> ) {
	
		$src	.= $_;
	
	}
	close( INF );
	
	$src	= $dbh1->quote( $src );	# Escape our source code - this will escape characters like ' and " and & (I think)
	
	$dbh1->do( "insert into package_src ( `pid`, `version`, `branch`, `entrytimestamp`, `uploadedby`, `src` ) values ( $pid, $version, $branch, NOW(), 1, $src )" );

} else {

	print STDERR "Sorry - it seems the file does not exists yet (file: $input)\n\n";
	exit;

}
