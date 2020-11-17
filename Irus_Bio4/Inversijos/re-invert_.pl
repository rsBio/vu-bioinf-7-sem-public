#!/usr/bin/perl

use warnings;
use strict;

my @inverted = split ' ', <>;

my ($length, $times) = split ' ', <>;
my @moves = <> =~ /\d+ \d+/g;

print "@moves\n";

print "@inverted\n";

@inverted = (0, @inverted, @inverted + 1);
print "@inverted\n";

my $jj = 0;

while( "@inverted" ne join ' ', 0 .. @inverted - 1 and $jj ++ < 10){

    print "@inverted\n";

    my $i = 0;
    my $ok = 0;
    my $min;
    my $max;

    while ( $i < @inverted - 1 ){
        while ($inverted[ $i ] == $inverted[ $i+1 ] + 1
#            and $i < @inverted - 1
        ){
            $i ++;
            $ok ++;
        }
        $ok and $min = $inverted[ $i ];
        $ok and $max = $inverted[ $i - $ok ];
        $ok and print "[$max $min]";
        $ok and last;
        $i ++;
    }
    
    my $index;

    if ($ok){
        print "ok\n";

        for my $j (1 .. $i - $ok - 1){
            $min - 1 == $inverted[ $j ] and do { $index = $j; last };
        }
        defined $index and print ":1:<$index>\n";
        if (defined $index){ 
            splice @inverted, $index + 1, $i - $index,
                ( reverse @inverted[ $index + 1 .. $i ] );
            next;
        }
        
        for my $j ($i + 1 .. @inverted - 2){
            $max + 1 == $inverted[ $j ] and do { $index = $j; last };
        }
        defined $index and print ":2:<$index>\n";
        if (defined $index){ 
            splice @inverted, $i - $ok, $index - $i + $ok,
                ( reverse @inverted[ $i - $ok .. $index - 1 ] );
            next;
        }
    }
    else {
        $i = 1;
        $ok = 0;

        print "no\n";
        
        while ( $i < @inverted - 1 ){
            
            while ($inverted[ $i ] == $inverted[ $i+1 ] - 1
                    and $i < @inverted - 1
                ){
                if ($inverted[ $i ] != $inverted[ $i-1 ] + 1){
                    $ok = 0;
                }
                $i ++;
                $ok ++;
            }
         #   $ok and last;
            $i ++;
        }
        print ">[$ok]";
        if ($ok){
            splice @inverted, $i - $ok, $ok + 1,
                ( reverse @inverted[ $i - $ok .. $i ] );
        }
        else {
            ;
        }
    }

}

#my @arr = 1 .. $length;
#my @moves = ();

#for my $i (1 .. $times){
#
#    my $same;
#    my @indexes = sort {$a <=> $b or $same ++} 
#        map { int rand $length } 1 .. 2;
#    redo if $same;
#
#    splice @arr, $indexes[0], 0, reverse
#        ( splice @arr, $indexes[0], $indexes[1] - $indexes[0] + 1);
#
##    push @moves, @indexes;
#}
#
#print "@arr", "\n";
#print "$length $times\n";
##print "@moves", "\n";
