#!/usr/bin/perl -0777

use warnings;
use strict;

while(<>){
    
    my ($first_line, @remain) = split /\n/;
    my @next_lines = map { [split ' '] } @remain;
    
    my ($lines, $rows, $st_pos) = split ' ', $first_line;
    
    @{ $next_lines[ 0 ] } = map { $_ ? 0 : undef } @{ $next_lines[ 0 ] };
#%    print map "$_:\n", join '', map "[$_]", 
#%        map { sprintf "%2s", defined $_ ? $_ : '.' } @{ $next_lines[ 0 ] }; 
    
    for my $i (1 .. @next_lines -1){
        
        for my $row ( grep { $_ > 0 and $_ <= $rows } 
                       map { $st_pos + $_ } -$i .. $i
        ){
#%            print "{$row}\n";
            my @idxs = grep { $_ > 0 and $_ <= $rows }
                grep { $_ > $st_pos - $i and $_ < $st_pos + $i } 
                map { $row + $_ } -1 .. 1;
#%            print "[@idxs]\n";
            my @to_sort = grep defined, 
                @{ $next_lines[ $i -1 ] }[ map $_ - 1, @idxs ];
            my $max_prev = @to_sort ? (sort {$b <=> $a} @to_sort)[ 0 ] : undef;
#%            print "[@to_sort]->($max_prev)\n";
            $next_lines[ $i ][ $row -1 ] += $max_prev;      
##            $next_lines[ $i ][ $row -1 ] = 
##            defined $max_prev ? $next_lines[ $i ][ $row -1 ] + $max_prev : undef;
        }

#%        print map "$_\n", join '', map "[$_]", 
#%            map { sprintf "%2s" , defined $_ ? $_ : '.' } @{ $next_lines[ $i ] };
    }
    
    print( (sort {$b <=> $a} @{ $next_lines[ $lines -1 ] }[
            ( map $_-1, grep { $_ > 0 and $_ <= $rows } 
                       map { $st_pos + $_ } -(@next_lines -1) .. (@next_lines -1)
            )
        ]
        )[ 0 ], "\n" );

}
