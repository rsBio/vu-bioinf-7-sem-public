#!/usr/bin/perl

use warnings;
use strict;
use Data::Dumper;

my %H;

sub _make {
	my $key = shift;
	my %h;
	for (@_){
		/./, $' and push @{ $h{ $& } }, $';
	}
#	$H{ $key } = { map { $_, [ ] } sort keys %h };
	print "$key [",(sort keys %h),"]\n";
	return { map { $_, '$' } @_ } if not %h;
	return {
		map {
			$_, _make( $_, @{ $h{ $_ } } )
		} sort keys %h
	}
}


while(<>){
	chomp;
	
	my @suffixes;
	
	push @suffixes, $' while m/(?=\w)/g;

	@suffixes = sort @suffixes;

	{local $" = $/; print "@suffixes"}
#    _make( 'X', @suffixes );
    %H = ( $_, _make( 'X', @suffixes ) );

	print Dumper %H;
	
#	{local $" = $/; print "@suffixes"}
#	{local $" = " "; print "@{ $_ }\n" for @suffixes; }	
    
#	{local $" = " "; print "@{ $_ }\n" for @suffixes; }	
	print "\n\n";
}
