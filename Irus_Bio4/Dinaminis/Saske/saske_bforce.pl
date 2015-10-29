#!/usr/bin/perl -0777

use warnings;
use strict;

while(<>){
    
    my ($first_line, $second_line, @remain) = split /\n/;
    my @next_lines = map { [split ' '] } @remain;
    
    my ($lines, $rows, $st_pos) = split ' ', $first_line;
    
    my $max = 0;

    NUMBERS:
    for my $number ( 0 .. 3 ** ($lines -1) ){
        
        my $row = $st_pos;
        my $sum = 0;
        
        for my $j ( 1 .. $lines -1 ){
            my $new_row = $row -1 + $number % 3;
            next NUMBERS if $new_row < 1 or $new_row > $rows;
            
            $sum += @{ $next_lines[ $j -1 ] }[ $new_row -1 ];
            $number = int $number / 3;
            $row = $new_row;
        }
        
        $sum > $max and $max = $sum;
    }
    
    print "$max\n";
}
