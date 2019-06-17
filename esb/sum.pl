#! /usr/bin/perl
use warnings;
use strict;
use Cwd;
use File::Basename;
use File::Spec qw(catfile catdir);
use Getopt::Std;
use Data::Dumper;
# my $dir_name = "C:/Users/Administrator/Desktop/ssss";                                                                                                                            
# my @dir_files = <$dir_name/*>; 
                                                                                                                                                                            
# if (@dir_files) {                                                                                                                                                           
        # print Dumper @dir_files;     
# } else {     
		# system qq(rmdir  $dir_name);                                                                                                                                                       
        # print "empty"."\n";        
# }              

# open (FILE1,"<","C:/Users/Administrator/Desktop/esb/file3.txt") or die "cna't open file3.txt:$!";
# open (FILE2,">>","C:/Users/Administrator/Desktop/esb/file4.txt") or die "cna't open file4.txt:$!";
# my $line =',' x 20;
# print FILE2 "$line\n";
# while(<FILE1>){
	# chomp;

	# print FILE2 ",$_\n";
	# }
	# close FILE1;
	# close FILE2;
my $str = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
my @arr=split//,$str;
my $ss=@arr;
my $i=0;
printf ("$ss");
# for $i(0..20){
# print "@arr[$i..$i+2]\n";
# }