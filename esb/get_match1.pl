#! /usr/bin/perl
use warnings;
use strict;
use Cwd;
use File::Basename;
use File::Spec qw(catfile catdir);
use Getopt::Std;

my @a=("abbb","b");
my $a= 0;
@a = map (ucfirst, @a);
$a = map (ucfirst, @a);
printf("$a\n");
printf("@a");