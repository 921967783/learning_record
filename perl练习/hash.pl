#! /usr/bin/perl
use warnings;
use strict;
use Cwd;
use File::Basename;
use File::Spec qw(catfile catdir);
use Getopt::Std;

my %hash = ("a"=>1, "b"=>2, "c"=>3, "d"=>4);
$hash{"a\tb"}=1;
my $a ="a.b";
if(exists $hash{'a'})
{
        print "$hash{'a'}\n";
		print "$a"
}
