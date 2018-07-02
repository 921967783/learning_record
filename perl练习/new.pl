#! /usr/bin/perl

use strict;

my %hash =();
my $ls = 'sss';
if (!defined($hash{$ls}))
{
	$hash{$ls} = 'lsd'.",".'new';
	
}
# if (defined($hash{$ls}))
# {
	# $hash{$ls} = 'lsd';
# }
print("$hash{$ls}\n");
my @a = ();
push @a,'sss';
push @a,'sdsa';
my $a =@a;
if ($a >1)
{
	print "yes dayu 1\n";
}
print ($a);