#!/usr/bin/perl

use strict;

#######################################
#
# C O N F I G
#
#######################################

my $version	= "0.0.1";	# The version of setup.pl
my @dirstruct	= (
			'conf',
			'conf/vhosts',
			'sbin',
			'bin',
			'logs',
			'docs',
			'tmp',
			'www',
			'www/www.lampas.tld',
			'mods',
			'mods/LAMPAS',
		  );

#######################################
#
# M A I N
#
#######################################

( my $action, my $basedir, my $initdir, my $app, my $mkdir ) = @ARGV;

print "info     : input, action=$action and basedir=$basedir and initdir=$initdir\n";
print "question : Do you want to continue?\n";
if( getInput() =~ /^n/i ) {

	print "info     : quiting...\n";
	exit;
	
}

if( $action =~ /^install/i ) {

	actionInstall( $basedir );

} elsif( $action =~ /^uninstall/i ) {

	actionUninstall( $basedir );

} else {

	print STDERR "error    : we couldn't figure out what you want to do. Please use 'make install' or 'make uninstall'\n";

}

exit;

#######################################
#
# S U B S
#
#######################################

sub actionInstall {

	my $basedir = shift;
	
	foreach my $dir ( @dirstruct ) {

		my $targetdir	= $basedir . "/" . $dir . "/";
		if( -e $targetdir ) {

			print STDERR "warning  : The directory '$targetdir' already exists.\n";

		} else {
			
			my $cmd	= "$mkdir -pv $targetdir";
			print "info     : running command '$cmd'\n";
			my $res	= `$cmd`;
			if( -e $targetdir ) {

				# do nothing
				
			} else {

				print STDERR "error    : Could't create directory '$targetdir' - please check permissions. We suggest running as root.\n";
				return 0;
				
			}

		}

		# Copy the local files
		my $cmd	= "$app -vf $dir/* $targetdir/";
		print "info     : running command '$cmd'\n";
		my $res	= `$cmd`;
		print "$res\n\n";

	}
	
	return 1;

}

sub actionUninstall {

	my $basedir = shift;

	# Check if the 'rm' command is available
	if( -e $app ) {

		my $cmd	= "$app -vfrR $basedir";
		print "info     : running command '$cmd'\n";
		my $res	= `$cmd`;
		print "$res\n\n";
		
	} else {

		# Can't uninstall
		print STDERR "error    : actionUninstall(): can not find the application '$app'. Aborting...\n";
		return 0;

	}

	return 1;

}

sub getInput {

	print "> ";		# Put a prompt
	my $input	= <STDIN>;
	chomp( $input );

	return $input;

}
