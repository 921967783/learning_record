#! /usr/bin/perl
use warnings;
use strict;
use Cwd;
use File::Basename;
use File::Spec qw(catfile catdir);
use Getopt::Std;
use Data::Dumper;


my %hash_line = (
	fred => 'flintston',
	barney => 'rubble',
	wilma => 'flintstone',
	);

	printf ( "please input your first name!\n");
	
	chomp(my $name=<STDIN>);
	printf ("this name's lastname is\n $hash_line{$name}");