#!/usr/bin/perl

use warnings;
use strict;

while(<>){
	chomp;
	
	my @suffixes;
	
	push @suffixes, $' while m/(?=\w)/g;

	@suffixes = sort @suffixes;
	
	print "@suffixes";
	
	for my $i (0 .. @suffixes -1){
		
		for my $j ($i .. @suffixes -1){
			(substr $suffixes[ $i ], 0, 1) eq
			(substr $suffixes[ $j ], 0, 1) and
			
		}
		
	}
	
	print "\n\n";
}
