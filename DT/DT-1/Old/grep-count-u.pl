#!/usr/bin/perl

use warnings;
use strict;

open my $in , '<', "my_arff-u.arff" or die "$0: died $!\n";

@_ = <$in>;
@_ = grep /^'/, @_;

my %hA = ();
my %hB = ();

my ($A, $B, $v);

map { ($A, $B, $v) = split /,/; chomp $v; 
		$hA{$A} .= " $v"; 
		$hB{$B} .= " $v"; 
} @_;

for my $key (sort keys %hA){
	print map "[[[ $_ ]]]\n", $hA{$key};
	my @A = ();
	map { $A[ $_ ] ++ } split ' ', $hA{$key};
	print join "\n", map { $A[$_] // 0 } 1 .. 7;
	print "\n";
}
print "\n-----\n";

for my $key (sort keys %hB){
	print map "[[[ $_ ]]]\n", $hB{$key};
	my @B = ();
	map { $B[ $_ ] ++ } split ' ', $hB{$key};
	print join "\n", map { $B[$_] // 0 } 1 .. 7;
	print "\n";
}
