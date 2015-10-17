#!/usr/bin/perl

use warnings;
use strict;

my $n;
my $kelimo_id = 0;
my @letters = 'A' .. 'C';

my %hash;
map { @{ $hash{ $_ } } = () } @letters;

my $last_moved;

# sekancio indekso gavimo funkcija
sub _next_idx {
    my ($i) = shift;
    $i += qw(1 -1)[ $n % 2 ];
    $i %= 3;
}

# Perkelimu spausdinimo procedura
sub _print_arr {
    my @arr = map { "$_ = (@{ $hash{ $_ } })" } @letters ;
    my @l_arr = map length, @arr;
    print $arr[ 0 ], 
        ( $n % 2 ? ' ' x $l_arr[ 2 ] : ' ' . '-' x ($l_arr[ 2 ]-3) . '> '),
        $arr[ 1 ],
        "\n";
    print '',
        ( $n % 2 ? ' \'' . '-' x ($l_arr[ 0 ]-4) . '> ' : ' ' x $l_arr[ 0 ]),
        $arr[ 2 ],
        ( $n % 2 ? '' : ' <' . '-' x ($l_arr[ 1 ]-4) . '\''),
        "\n";
}

# BEGIN {main}

for ( 1 ){
    $n = <>;
    chomp $n;   

    # 1. Tikrinamas ivestojo n lyginumas
    print "Ivesta n = ${n} yra ", ('', 'NE')[ $n % 2 ], "LYGINIS,\n";
    print "Todel keliama ", qw(pagal pries)[ $n % 2 ], 
        " laikrodzio rodykle.\n";

    map { @{ $hash{ $_ } } = () } @letters;
    @{ $hash{ $letters[ 0 ] } } = reverse 1 .. $n;

    # 2. Isspausdinama pradine busena
    print "Pradine busena: \n";
    &_print_arr;

    my $i = 0; # einamasis deklo indeksas
    undef $last_moved; # paskutines perkeltos lekstes dydis

    while ( 1 ){

        if ( not @{ $hash{ $letters[ $i ] } } ){
             $i = _next_idx($i);
             next;
        }
        else {
             my $top = pop @{ $hash{ $letters[ $i ] } };
             
             if ( $last_moved and $top == $last_moved ){
                 push @{ $hash{ $letters[ $i ] } }, $top;
                 @{ $hash{ $letters[ $i ] } } == $n and last;
                 $i = _next_idx($i);
                 next;
             }
             
             my $j = _next_idx($i);
             while ($j != $i){
                 if (
                     not @{ $hash{ $letters[ $j ] } }
                     or  @{ $hash{ $letters[ $j ] } }[-1]
                         > $top
                     ){
                     push @{ $hash{ $letters[ $j ] } }, $top;
                     $last_moved = $top;
                     print ++ $kelimo_id, ": ";
                     printf "Keliamas diskas %2d", $top;
                     print  " nuo '$letters[$i]' ant '$letters[$j]':\n";
                     &_print_arr;
                     $i = _next_idx($j);
                     last;
                 }
                 $j = _next_idx($j);
             }
             if ( $i == $j ){
                 push @{ $hash{ $letters[ $i ] } }, $top;
                 $i = _next_idx($i);
                 next;
             }

        }
        
    }
}

# END {main}
