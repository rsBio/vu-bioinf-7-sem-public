#!/usr/bin/perl

use warnings;
use strict;

print "Iveskite elementus atskirtus tarpais:\n";
my @arr = split ' ', <>;

my %hash;
$hash{ $_ } ++ for @arr;

my @set = sort keys %hash;
my $galia = @set;

# '|' atskirti visi poaibiai:
print join "|", map {
    map "($_)",
    join ',',
    @set[
        map { s/1/ '{' . pos . '}' /ge; m/ (?<={) \d+ (?=}) /xg } 
            sprintf "%0${galia}b", $_
    ]
} 0 .. (1 << $galia) - 1;
