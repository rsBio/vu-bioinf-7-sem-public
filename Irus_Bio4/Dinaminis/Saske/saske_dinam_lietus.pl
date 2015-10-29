#!/usr/bin/perl -0777

use warnings;
use strict;

while(<>){
    
    my ($first_line, $second_line, @remain) = split /\n/;
    my @next_lines = map { [split ' '] } @remain;
    
    my ($lines, $rows, $st_pos) = split ' ', $first_line;
    
    my @prev_line = map { $_ ? 0 : undef } split ' ', $second_line;
#%    print map "$_:\n", join '', map "[$_]", 
#%        map { sprintf "%2s", defined $_ ? $_ : '.' } @prev_line; 
    
    for my $line (@next_lines){
        
        for my $row (1 .. $rows){
            my @idxs = grep { $_ > 0 and $_ <= $rows } 
                map { $row + $_ } -1 .. 1;
            my $max_prev = (sort {$b <=> $a} grep defined, 
                @prev_line[ map $_ - 1, @idxs ])[ 0 ];
            
            @{ $line }[ $row -1 ] = 
                defined $max_prev ? @{ $line }[ $row -1 ] + $max_prev : undef;
        }
        @prev_line = @{ $line };

#%        print map "$_\n", join '', map "[$_]", 
#%            map { sprintf "%2s" , defined $_ ? $_ : '.' } @{ $line };
    }
    
    print ( (sort {$b <=> $a} grep defined, @prev_line)[ 0 ], "\n" );

}
