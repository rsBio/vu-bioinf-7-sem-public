#!/usr/bin/perl

use warnings;
use strict;

my @aibe;
my @sandaugos;
my $j = 0;
my @stack;

# rekursyviai:
sub _paimk_elementa {
    my ($aibes_i) = @_;
    return if $aibes_i >= @aibe;

    for my $i (@{ $aibe[ $aibes_i ] }){
            push @stack, $i;
#%            print "($aibes_i) -> [@stack]\n";
            if (@stack == @aibe){ @{ $sandaugos[ $j++ ] } = @stack }
            _paimk_elementa( $aibes_i + 1 );
            pop @stack;
        }
}

# iteratyviai:
sub _sudaugink {
    my $galia = eval join '*', map { scalar @{ $_ } } @aibe;
    print $galia, "\n";
    print
    map {
        my $turinys = $_;
        map "[$_]\n", join '+',
        reverse map {
            (
                @{ $aibe[ $_ ] }[ $turinys % @{ $aibe[ $_ ] } ],
                $turinys /= @{ $aibe[ $_ ] }
            )[0]
        } reverse 0 .. @aibe - 1;
    } 0 .. $galia - 1;
}

#BEGIN {main}

print "Iveskite keleta aibiu per kelias eilutes, ",
     "elementus atskiriant tarpais:\n";

my $i = -1;
map { $i ++; @{ $aibe[ $i ] } = split } <>;

_paimk_elementa( 0 );

for my $i (@sandaugos){
    print "[@{ $i }]\n";
}

_sudaugink();

#END {main}
