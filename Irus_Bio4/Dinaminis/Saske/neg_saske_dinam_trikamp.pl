#!/usr/bin/perl -0777

use warnings;
use strict;

#my *from;

while(<>){
    
    my ($first_line, @remain) = split /\n/;
    my @next_lines = map { [ map { $_ == -1 ? -1e3 : $_ } split ' '] } @remain;
    my @from = map [], ();
    
    my ($lines, $rows, $st_pos) = split ' ', $first_line;
    
    @{ $next_lines[ 0 ] } = map { $_ ? 0 : undef } @{ $next_lines[ 0 ] };
#%    print map "$_:\n", join '', map "[$_]", 
#%        map { sprintf "%2s", defined $_ ? $_ : '.' } @{ $next_lines[ 0 ] }; 
    
    for my $i (1 .. @next_lines -1){
        
        for my $row ( grep { $_ > 0 and $_ <= $rows } 
                       map { $st_pos + $_ } -$i .. $i
        ){
            my @idxs = grep { $_ > 0 and $_ <= $rows }
                grep { $_ > $st_pos - $i and $_ < $st_pos + $i } 
                map { $row + $_ } -1 .. 1;
#%            print "[@idxs]";
            my $max_prev = (sort {$b <=> $a} grep defined, 
                @{ $next_lines[ $i -1 ] }[ map $_ - 1, @idxs ])[ 0 ];
my $k = -1;            
for ( grep defined, @{ $next_lines[ $i -1 ] }[ map $_ - 1, @idxs ] ){

    $max_prev == $_ and last;
    $k ++;
}
print "<$k>";
            $from[ $i ][ $row -1 ] = $k;
            $next_lines[ $i ][ $row -1 ] += $max_prev;      
##            $next_lines[ $i ][ $row -1 ] = 
##            defined $max_prev ? $next_lines[ $i ][ $row -1 ] + $max_prev : undef;
        }
	last if not grep $_ >= 0, @{ $next_lines[ $i ] };
#%        print map "$_\n", join '', map "[$_]", 
#%            map { sprintf "%2s" , defined $_ ? $_ : '.' } @{ $next_lines[ $i ] };
    }
    
    my $max_back = -1e3;
    print  ( $max_back = (sort {$b <=> $a} grep defined, 
                @{ $next_lines[ $lines -1 ] })[ 0 ], "\n" );



    my $j = 0;
#% print "[[@{ $next_lines[ $lines -1 ] }]] [[$j]]\n";
    for (@{ $next_lines[ $lines -1 ] }){
        $_ == $max_back and do { $next_lines[ $lines -1 ][ $j ] = '*'; last };
        $j ++;
    }
#% print "[[@{ $next_lines[ $lines -1 ] }]] [[$j]]\n";

    for my $i (reverse 1 .. @next_lines -2){
        my $max = -1e3;
        for (grep { $_ >= 0 and $_ < $rows } map $j + $_, -1 .. 1){
            $max < $next_lines[ $i ][ $_ ] and $max = $next_lines[ $i ][ $_ ]
        }
        for (grep { $_ >= 0 and $_ < $rows } map $j + $_, -1 .. 1){
            $max == $next_lines[ $i ][ $_ ] and do {
                $next_lines[ $i ][ $_ ] = '*';
                $j = $_;
                last
            }
        }
#% print "-- [[@{ $next_lines[ $i ] }]] [[$j]]\n";
    }

    print map "$_\n", join "\n", map { join '', 
        map { sprintf "[%5s]", $_ } @{ $next_lines[ $_ ]}  
        } 1 .. $rows -1;

    print map "$_\n", join "\n", map { join '', 
        map { sprintf "[%5s]", $_ } @{ $from[ $_ ]}  
        } 1 .. $rows -1;

}
