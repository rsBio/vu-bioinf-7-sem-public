#!/usr/bin/perl

use warnings;
use strict;

my $n;

sub _next_idx {
     my ($i) = shift;
     $i += qw(1 -1)[ $n % 2 ];
     $i %= 3;
}

while ($n = <>){
    chomp $n;   

    my %hash;    
    map { @{ $hash{ $_ } } = () } 'A' .. 'C';
    @{ $hash{ 'A' } } = reverse 1 .. $n;
    print map "{$_}\n", join ", ", map { "(@{ $hash{ $_ } })" } 'A' .. 'C';

    my $i = 0;
    my @letters = 'A' .. 'C';
    my $f = 0;
    my $last_moved = undef;
    print @{$hash{$letters[0]}},"<", $/;

    while ( 1 ){
#    print "-----\n>>i: $i\n";
#    print map "{$_}\n", join ", ", map { "(@{ $hash{ $_ } })" } 'A' .. 'C';

        if ( not @{ $hash{ $letters[ $i ] } } ){
             $i = _next_idx($i);
 #            print "[$i]\n";
             next;
        }
        else {
             my $top = pop @{ $hash{ $letters[ $i ] } };
 #            print " TOP: ", $top , $/;
             
             if ( $last_moved and $top == $last_moved ){
 #                print "lastmoved!\n";
                 push @{ $hash{ $letters[ $i ] } }, $top;
                 @{ $hash{ $letters[ $i ] } } == $n and last;
                 $i = _next_idx($i);
                 next;
             }
             
             my $j = _next_idx($i);
             while ($j != $i){
#                 print "   while\n";
                 if (
                     not @{ $hash{ $letters[ $j ] } }
                     or  @{ $hash{ $letters[ $j ] } }[-1]
                         > $top
                     ){
                     push @{ $hash{ $letters[ $j ] } }, $top;
                     $last_moved = $top;
 #                    print "From $letters[$i] to $letters[$j]: $top\n";
 #   print map "{$_}\n", join ", ", map { "(@{ $hash{ $_ } })" } 'A' .. 'C'; 
                     $i = _next_idx($j);
                     last;
                 }
                 $j = _next_idx($j);
             }
             if ( $i == $j ){
                 push @{ $hash{ $letters[ $i ] } }, $top;
#                 print "END\n";
                 $i = _next_idx($i);
                 next;
             }

        }
        
    }
    print "ATS: \n";
    print map "{$_}\n", join ", ", map { "(@{ $hash{ $_ } })" } 'A' .. 'C';
    
    
}
