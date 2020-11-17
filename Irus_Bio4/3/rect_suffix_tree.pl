#!/usr/bin/perl

use warnings;
use strict;

while(<>){
	chomp;
	
	my @suffixes;
	
	push @suffixes, $' while m/(?=\w)/g;

	@suffixes = map [ split // ], sort @suffixes;
	
#	{local $" = $/; print "@suffixes"}
	{local $" = " "; print "@{ $_ }\n" for @suffixes; }	

	for my $j (0 .. @suffixes -1){
		my $letter;
		for my $i (0 .. @suffixes -1){
            next if not defined $suffixes[ $i ][ $j ];
			( defined $letter and $letter eq $suffixes[ $i ][ $j ] ) ?
                ( $suffixes[ $i ][ $j ] = 'X' )
            :
                ( $letter = $suffixes[ $i ][ $j ] )
			
		}
		
	}
    
	{local $" = " "; print "@{ $_ }\n" for @suffixes; }	
	print "\n\n";
}
