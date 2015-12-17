#!/usr/bin/perl

use warnings;
use strict;

for(<@ARGV>){

	chomp;
	open my $in, '<', $_ or die "$0: $!\n";
	open my $out, '>', "n-$_" or die "$0: $!\n";
	
    my $R = 0;

	while (<$in>){
		s/(?=Tais)/1) /;
		s/(?=Fakt)/2) /;
		s/(?=Tiks)/3) /;			
        
		if (/Tais/ .. /---/ and not /Tais/ || /---/){
			chomp;
			@_ = split;
			my $last = pop @_;
			my $arr = join ', ', @_;
            $R ++;
			$_ .= "\t\t// R$R: $arr -> $last\n";
		}
		print $out $_
	}
}
