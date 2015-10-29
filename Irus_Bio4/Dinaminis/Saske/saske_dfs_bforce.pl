#!/usr/bin/perl -0777

use warnings;
use strict;

my $max;
my $curr;
my @next_lines;
my $right_border;

sub _bforce {
    my ($pos, $line, $curr, $depth) = @_;
    return if $line == $depth;

    for my $i (-1 .. 1){
        next if $pos + $i < 1 or $pos + $i > $right_border;
        $curr += @{ $next_lines[ $line -1 ] }[$pos + $i -1];
        $curr > $max and $max = $curr;
        _bforce( $pos + $i, $line + 1, $curr, $depth );
        $curr -= @{ $next_lines[ $line -1 ] }[$pos + $i -1];
    }
}

while(<>){
    
    my ($first_line, $second_line, @remain) = split /\n/;
    @next_lines = map { [split ' '] } @remain;
    
    my ($lines, $rows, $st_pos) = split ' ', $first_line;
    $right_border = $rows;
    
    my $st_line = 1;
    my $depth = $lines;
    
    $max = 0;
    $curr = 0;
    
    _bforce( $st_pos, $st_line, $curr, $depth );
    
    print "$max\n";
}
