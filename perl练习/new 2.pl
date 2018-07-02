#! /usr/bin/perl

use strict;

open(FILE1,"<","C:/Users/Administrator/Desktop/esb/file1.txt") or die "can't open FILE1:$!";
open(FILE2,"<","C:/Users/Administrator/Desktop/esb/file2.txt") or die "can't open FILE1:$!";

my %hash;

while(<FILE1>){
	my $line1  =$_;
	my @line1 =split(/\s+/,$line1);
	$hash{"$line1[0]\t$line1[1]"} = $line1[2];
	
	}
while(<FILE2>){
	my $line2 =$_;
	my @line2 = split(/\s+/,$line2);
	my @new = ();

	# my @line2 =();
	for my $i (2..@line2-1){
		if ($line2[$i] eq 'NA'){

			push @new,$hash{"$line2[0]\t$line2[1]"};
			}
			else{
			push @new,$line2[$i];
			}
		}
		printf ("@new\n");
	}