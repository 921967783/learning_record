#! /usr/bin/perl

use warnings;
use strict;
use Cwd;
use File::Path;

#set env,按照实际环境修改


my $dir='/home/cpauto/release';
my $list1 =0;
my $list2 =0;

open(FILE,"/home/cpauto/file_diff/cnaps.txt") or die "can't open cnaps.txt";
while(<FILE>)
{
	my $allist = $_;
	my @list =split(/&/,$allist);
	foreach my $list (@list){
		if ($list =~ m/^prevRev/g){
			$list1 = $list;
			$list1 =~ s/^prevRev\=//g;
		}
		elsif($list =~ m/^currRev/g){
			$list2 = $list;
			$list2 =~ s/^currRev\=//g;
		}
	}
}
close FILE;
chdir $dir;

system qq(rm -rf ffnew1.txt);
system qq(rm -rf ffnew2.txt);
system qq(touch ffnew2.txt);
system("svn diff --no-auth-cache -r $list2:$list1 --su,,arize > /home/znzfauto/release/ffnew1.txt");

open(FILE2,">>","/home/cpauto/release/ffnew2.txt") or die "can't open ffnew2.txt";
open(FILE1,"<","/home/cpauto/release/ffnew1.txt") or die "can't open ffnew1.txt";
while(<FILE1>{
	chomp(my $line =$_);
	if($line =~ m/^(U|M+|A)\s+/g and $line =~ m/(.*)\./){
		$line =~ s/^s+|s+$//g;
		$line =~ s/^([A-Z]+)//g;
		$line =~ s/^s+|s+$//g;
		print FILE2 "$line\n";
	}
}
close FILE1;
close FILE2;