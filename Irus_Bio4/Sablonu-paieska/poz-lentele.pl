#!/usr/bin/perl

use warnings;
use strict;

while( do { local $/ ; $_ = <> } ){
    
    my ($az, $patt, $string) = split /\n/;
    
    print "Kiek kartų atlikti paiešką?\n";
    chomp( my $repeats = <STDIN> );
    
    my $wide;
    print "Kokio pločio įrašai pozicinėje lentelėje?\n";
    while( $wide = <STDIN> ){
        chomp $wide;
        $wide >= length $patt ?
            do { print "Įveskite iš naujo. (Plotis neturi turi būti" 
                    . " didesnis už šablono ilgį)\n";
                next }
              : last
    }

    for my $i (1 .. $repeats){
        
        my %poz_lent;
        my $len_az = length $az;
        
        for my $j (0 .. $len_az ** $wide -1){
            
            my @pre_key;
            
            for my $k (1 .. $wide){

                unshift @pre_key, substr $az, $j % $len_az, 1;
                $j = int $j / $len_az;
            }
            
            $poz_lent{ join '', @pre_key } = [];
            
        }
        
        print map "$_\n", join '', map { "[$_]" } keys %poz_lent;
        
        for my $key (sort keys %poz_lent){
            
            my $q_key = quotemeta $key;
            
            while( $string =~ m/(?= $q_key )/gx ){
                push @{ $poz_lent{ $key } }, 
                    pos $string;
##>                    -$wide + pos $string;
##>                (pos $string) -= $wide -1;
            }
            
        }
        
        print map "$_\n", join '', 
            map { "[$_ -> " . "(@{ $poz_lent{ $_ } }) ]" } keys %poz_lent;

##        (pos $patt) = 0;
        my @possible_pos;
        my $re_wide = '.' x $wide;
        
        while( $patt =~ m/(?= ($re_wide) )/gx ){
            
            print "(". (pos $patt) ." > $1)";
            my $key = $1;
            if (0 == pos $patt){
                @possible_pos = @{ $poz_lent{ $key } };
            }
            else {
                my @new_possible_pos;
                my %candidate_pos = map { $_, 1 } @{ $poz_lent{ $key } };
                for (@possible_pos){
                    exists $candidate_pos{ $_ + 1 } 
                        and push @new_possible_pos, $_ + 1;
                }
                @possible_pos = @new_possible_pos;
            }
            print " <<@possible_pos>>\n";
            last if not @possible_pos;
        }
        
        if (@possible_pos){
            print "Pattern found at positions (starting from):\n";
            print map "$_\n", join ' ', 
                map $_ + $wide - length $patt, @possible_pos;
        }
        else {
            print "Pattern not found!\n";
        }
        
    }
    
}
