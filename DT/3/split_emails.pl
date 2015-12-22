#!/usr/bin/perl -0777

use warnings;
use strict;

my $class = shift @ARGV;

while(<>){
	my $i = 0;
	my $out;
	$i ++,
	(open $out, '>', "mail_${class}_$i" or "$0: can't create! $!\n"),
	print $out $_
    	for split /(?<!\A)^(?=From)/mx;
}
