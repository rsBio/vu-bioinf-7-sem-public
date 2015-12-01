#!/usr/bin/perl

# Pagamina keitini is normalios sekos pritaikius atsitiktines inversijas.

use warnings;
use strict;

srand( time ^ $$ );

my $length = defined $ARGV[0] ? $ARGV[0] : 10;
my $times = defined $ARGV[1] ? $ARGV[1] : 5;

my @arr = 1 .. $length;
my @moves = ();

for my $i (1 .. $times){

    my $same;
    my @indexes = sort {$a <=> $b or $same ++} 
        map { int rand $length } 1 .. 2;
    redo if $same;

    splice @arr, $indexes[0], 0, reverse
        ( splice @arr, $indexes[0], $indexes[1] - $indexes[0] + 1);

    push @moves, @indexes;
}

print "@arr", "\n";
print "$length $times\n";
print "@moves", "\n";
