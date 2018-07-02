#! /usr/bin/perl
use warnings;
use strict;
use Cwd;
use File::Basename;
use File::Spec qw(catfile catdir);
use Getopt::Std;
use Data::Dumper;

my @array = ();
my %count;
chomp(@array = <STDIN>);
my $array;

foreach $array(@array){
	 $count{$array} +=1;
	 
	}
	foreach my $line(keys %count){
		printf ("$array was seen $count{$array}\n");
		
		}

