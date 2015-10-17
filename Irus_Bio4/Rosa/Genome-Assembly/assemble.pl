#!/usr/bin/perl

use warnings;
use strict;

open my $in, '<', "reads" or die "$0: !!!: $!\n";
open my $outs, '<', "outs" or die "$0: !?!?: $!\n";
open my $res, '>', "res" or die "$0: ???: $!\n";

my %outs = map { chomp; $_, 1 } <$outs>;

my @in = map { chomp; $_ } <$in>;

my %in;
map { $in{ $_ } ++ } @in;
 
print $_, " => ", $in{ $_ }, "\n" for keys %in;

my $min_repeat = ~0;
$min_repeat > $_ and $min_repeat = $_ for values %in;

print "$min_repeat\n";
