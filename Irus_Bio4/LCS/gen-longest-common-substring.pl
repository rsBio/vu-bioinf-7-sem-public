#!/usr/bin/perl

# Trenituotems :) 

use warnings;
use strict;

my $str_width = 40;
my $substr_width = 5;
my $rows = 8;

srand( time ^ $$ );

my @dict = split //, 'ACGT';

sub _gen_line{
    my ($length) = shift;
    return join '', map { $dict[ rand(@dict) ] } 1 .. $length;
}

my $substr = _gen_line( $substr_width );


print "\n";
my @lines;

for my $i (1 .. $rows){
    my $line = _gen_line( $str_width );
    $line = lc $line;
    my $index = rand $str_width - $substr_width;
    substr $line, $index, $substr_width, $substr;
    push @lines, $line;
    $line = uc $line;
    print $line . "\n";
}

<>;

print join "\n", "substr: $substr", @lines, '';
