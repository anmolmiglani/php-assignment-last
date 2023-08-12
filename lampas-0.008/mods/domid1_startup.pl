#!/usr/bin/perl

use strict;

# Set LAMPAS module directory
use lib qw(/opt/lampas/mods);
use Apache::DBI;

my $dbh1	= Apache::DBI->connect_on_init( "dbi:mysql:database=lampas;host=127.0.0.1;port=3306", "user", "" );

1;
