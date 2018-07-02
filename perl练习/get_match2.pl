#! /usr/bin/perl
use warnings;
use strict;
use Cwd;
use File::Basename;
use File::Spec qw(catfile catdir);
use Getopt::Std;

open(FILE1,'<','C:/Users/Administrator/Desktop/esb/file1.txt') or die "can't open file1:$!";
open(FILE2,'<','C:/Users/Administrator/Desktop/esb/file2.txt') or die "can't open file2:$!";
# open(FILE3,'>>','C:/Users/Administrator/Desktop/esb/file3.txt') or die "can't open file3:$!";

# system qq(touch file3.txt);
my $line = 0;
my $line2 = 0;
my @line2 = ();
my $line3 = 0;
my %hKey;
while(<FILE2>){
	chomp;
	$line2 = $_;
	push @line2,$line2;

}
	while(<FILE1>){
	my $line4 = $_;
foreach $line3(@line2){
# printf ("$line3\n");

 if ($line4 =~ /$line3/g){
	print ("$line4");
	}
 }
 }
close FILE1;
close FILE2;
