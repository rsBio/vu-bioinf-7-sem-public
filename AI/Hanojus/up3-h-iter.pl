#!/usr/bin/perl

$" = ',';
use warnings;
use strict;

my $n;
my $kelimo_id = 0;
my @letters = 'A' .. 'C';

my %hash;
map { @{ $hash{ $_ } } = () } @letters;

my $last_moved;
my $kiek = 1;

# sekancio indekso gavimo funkcija
sub _next_idx {
    my ($i) = shift;
    $i += qw(1 -1)[ $n % 2 ];
    $i %= 3;
}

# Perkelimu spausdinimo procedura
sub _print_arr {
    my ($direction) = join '', @_;
    my @arr = map { "$_=(@{ $hash{ $_ } })" } @letters ;
    my @l_arr = map length, @arr;
    my $atitr = 5;
    my $l_all = eval join '+', @l_arr;
    my $msg = '';
        
    $msg = join "\n",
        map "  $_  ",
        (
        ' ' x $l_all,
        $arr[0] . ' ' x $l_arr[2] . $arr[1],
        ' ' x $l_arr[0] . $arr[2] . ' ' x $l_arr[1],
        ' ' x $l_all
        );

    my $change = '';
    if ($kiek == 2){
        if ($direction =~ /AB|BA/){
            $msg =~ s/\) *\n   \K / '|' /mse;
            $msg =~ s/    \n *\Z/ "^   \n   '" . '-' x ($l_all-4) . "'   " /mse;
            }
        if ($direction =~ /BC|CB/){
            $msg =~ s/ (?= A)/|/ms;
            $msg =~ s/ *(?= C)/ ($change = $&) =~ s! !-!gr =~ s!-$!>!r =~ s!-!'!r /mse;
            $msg =~ s/ +(?=   )/ ($change = $&) =~ s! !-!gr =~ s!-$!,!r =~ s!-!,!r /mse;
            }
        if ($direction =~ /CA|AC/){
            $msg =~ s/\)\K  $/ |/ms;
            $msg =~ s/\) \K +$/ ($change = $&) =~ s! !-!gr =~ s!-$!'!r /mse;
            $msg =~ s/   \K +/ ($change = $&) =~ s! !-!gr =~ s!-$!,!r =~ s!-!v!r /mse;
            }
        if (not $n % 2){
            $direction eq "BA" and ($msg =~ y/^|/|^/);
            $direction eq "CB" and ($msg =~ s/,$/v/, $msg =~ s/>/-/);
            $direction eq "AC" and ($msg =~ s/v/,/, $msg =~ s/\) \K-/</);
        }
    }
    else {
        if ($direction =~ /AB|BA/){
            $msg =~ s/\) \K\s+\B/ ($change = $&) =~ s! !-!gr =~ s!-$!>!r /mse;
            }
        if ($direction =~ /BC|CB/){
            $msg =~ s/.*\) \K +/ '<' . '-' x ($l_arr[1]-4) . "'" . ' ' x 3 /mse;
            }
        if ($direction =~ /CA|AC/){
            $msg =~ s/ +(?=C)/ ' ' x 3 . '^' . '-' x ($l_arr[0]-3) . ' ' x 1 /mse;
            }
        if ($n % 2){
            $direction eq "BA" and ($msg =~ s/-/</, $msg =~ s/>/-/);
            $direction eq "CB" and ($msg =~ s/'/^/, $msg =~ s/</-/);
            $direction eq "AC" and ($msg =~ s/\^/'/, $msg =~ s/-*\K-/>/);
        }
    }

    $msg =~ s/^/' ' x $atitr/msge;
    print $msg , "\n";
}

# BEGIN {main}

for ( 1 ){
    $n = <>;
    chomp $n;   
    print "Programa pradeda darba.\nAutorius: Robertas Stankevic, IV k. bioinformatika.\n";

    # 1. Tikrinamas ivestojo n lyginumas
    print "Ivesta n = ${n} yra ", ('', 'NE')[ $n % 2 ], "LYGINIS, ";
    print "todel keliama ", qw(pagal pries)[ $n % 2 ], 
        " laikrodzio rodykle.\n";

    map { @{ $hash{ $_ } } = () } @letters;
    @{ $hash{ $letters[ 0 ] } } = reverse 1 .. $n;

    # 2. Isspausdinama pradine busena
    print "Pradine busena: \n";
    &_print_arr();

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
             $kiek = 0;
             while ($j != $i){
                 $kiek ++;
                 if (
                     not @{ $hash{ $letters[ $j ] } }
                     or  @{ $hash{ $letters[ $j ] } }[-1]
                         > $top
                     ){
                     push @{ $hash{ $letters[ $j ] } }, $top;
                     $last_moved = $top;
                     print ++ $kelimo_id, ": ";
                     printf "Keliamas diskas %2d", $top;
                     print  " nuo $letters[$i] ant $letters[$j] per " 
                         . qw(viena du)[$kiek - 1] . ":\n";
                     &_print_arr( $letters[$i] . $letters[$j] );
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
    print "Programa baige darba.\n";
}

# END {main}
