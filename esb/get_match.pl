#! /usr/bin/perl
use warnings;
use strict;
use Cwd;
use File::Basename;
use File::Spec qw(catfile catdir);
use Getopt::Std;

open(FILE1,'<','C:/Users/Administrator/Desktop/esb/file1.txt') or die "can't open file1:$!";
open(FILE2,'<','C:/Users/Administrator/Desktop/esb/file2.txt') or die "can't open file2:$!";
open(FILE3,'>>','C:/Users/Administrator/Desktop/esb/file3.txt') or die "can't open file3:$!";

# system qq(touch file3.txt);
my $line = 0;
my %hKey;
while(<FILE2>){
	chomp;
	$hKey{$_} = 1;
	}
	# undef $/;
	while(<FILE1>){
	# my @opt = split(/ /,$_);
	# if ($hKey{$sKey}){
		# print ;
		# }
	# foreach my $sKey(split){
    # if($hKey{$sKey}){
      # print;
      # next;
	  chomp ;
	  $line = $_;
	  if($line =~ m/^\*|\/n$/){
	   print FILE3 "\n$line";
	  
	  }else{
	  print FILE3 "$line";
	  }
	  
    }
 
close FILE1;
close FILE2;
close FILE3;