#! /usr/bin/perl
use warnings;
use strict;
use Cwd;
use File::Basename;
use File::Spec qw(catfile catdir);
use Getopt::Std;
use Data::Dumper;

my @line =();
open (FILE1,'<','C:/Users/Administrator/Desktop/esb/file5.txt') or die "cna't open file5.txt:$!";
# while(<FILE1>){
	# my $line =$_;
	# chomp;
	# if ($line =~ m/\>/g){
			# $line =~ s/\>//g;
			# chomp $line;
			# printf ("$line\t");	
			# }
			# else{
			# my $len = length($line);
			# printf ("$len\n");
			# }
	# }
	# close FILE1;