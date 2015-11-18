#!/usr/bin/perl

use warnings;
use strict;
use Data::Dumper;

while(<>){
	chomp;
	
	my @suffixes;
	
	push @suffixes, $` while m/(?<=\w)/g;
	
	{local $" = $/; print "@suffixes"}
	
	my %H;
	
	for my $i (@suffixes){
		
		my @suff;
		push @suff, $' while $i =~ m/(?=\w)/g;
		{local $" = $/; print "@suff"}
		
		SUFF:
		for my $j (@suff){
			
#			for (keys %H){
#				if ($j =~ m/^$_/){
#					$H{ $j } = $H{ $_ };
#					delete $H{ $_ };
#					next SUFF;
#				}
#			}
			
			
			my $tmp;
			while ($j =~ m/./g){
				my $lett = $&;
				$tmp or $tmp = \%H;
				print "[$lett,", keys %{ $tmp },"]\n";
				exists ${ $tmp }{ $lett } ?
					( $tmp = ${ $tmp }{ $lett } )
				:
					( ${ $tmp }{ $lett } = {} );
#				print keys %{ $tmp };
			}
			
#			(substr $suffixes[ $j ], 0, 1) 
			
		}
		
	}

	print Dumper \%H;

	for (keys %H){
#		print "$_ -> ", 1 == keys %{ $H{ $_ } }, "\n"
		1 == keys %{ $H{ $_ } } and do {
			my ($single_key) = keys %{ $H{ $_ } };
			my ($single_value) = values %{ $H{ $_ } };
			print "!!!\n";
			$H{ $_ . $single_key } = $H{ $_ }{ $single_key };
			delete $H{ $_ };
		}
	}

	print Dumper \%H;

	my @substrs;
	while( /./g ){
		push @substrs, $`, $'
	}
	@substrs = sort grep $_, @substrs;

	for (@substrs, 'ae', 'mi', 'mis', 'im'){
		print map "$_\n", join '', 
			"$_ -> ",
			0 + eval '$H' . join '', map "{$_}", split //
	}
	
	print "\n\n";
}
