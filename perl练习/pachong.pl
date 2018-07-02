#! /usr/bin/perl
use warnings;
use strict;
use Cwd;
use File::Basename;
use File::Spec qw(catfile catdir);
use Getopt::Std;

open(FILE1,'<','C:/Users/Administrator/Desktop/esb/file1.txt') or die "can't open file1:$!";
open(FILE2,'<','C:/Users/Administrator/Desktop/esb/file2.txt') or die "can't open file2:$!";


my %hash;
my @base = ();
while(<FILE1>){
	chomp;
	my @base = split(/\s+/,$_);
	$hash{"$base[0]\t$base[1]"} = $base[2];
	}

while(<FILE2>){
	chomp;
	
	my @line =split(/\s+/,$_);
	my $head ="$line[0]\t$line[1]";
	my @array =();
	for my $i (2..@line-1){
		if ($line[$i] eq 'NA'){
			push @array,$hash{$head};

			}
			else{
			push @array,$line[$i];
			
			}
		}
			printf ( "$head\t@array\n");
	}

