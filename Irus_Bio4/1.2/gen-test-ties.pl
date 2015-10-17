#!/usr/bin/perl

use warnings;
use strict;

srand;

open my $out, '>', "test" or die "$0: died $!";

my @X = sort { $a <=> $b } map { (rand() - .5) * 6  } 1 .. 10;
#    print "@X";

my @Y;
push @Y, sin for @X;

print $out @X . "\n";

for my $i (1 .. @X){
    print $out map "$_\n", join " ", 
    $X[ $i - 1 ],
    $Y[ $i - 1 ]
}
