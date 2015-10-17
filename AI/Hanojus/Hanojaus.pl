#!usr/bin/perl

use warnings;
use strict;

my %hash;

sub _arrays {
    map "{$_}\n", join ', ', map "($_)", map { join ',', @{ $hash{ $_ } } } 'A' .. 'C';    
    }

my $it;

sub _say {
    my ($nuo, $ant, $n) = @_;
    push @{ $hash{ $ant } }, pop @{ $hash{ $nuo } };
    $it ++;
    print "${it}: Nuo virbo ${nuo} perkelti ant virbo ${ant}.[$n]\n";
    print _arrays, "\n";
    }

sub hb {
    my ($nuo, $pap, $ant, $n) = @_;

    $n > 1 ? do {
        hb( $nuo, $ant, $pap, $n - 1);
        _say( $nuo, $ant, $n );
        hb( $pap, $nuo, $ant, $n - 1);
        }
    :
        _say( $nuo, $ant, $n );
}

print "Programa pradejo darba\n";
print "[Autorius: Robertas Stankevic, bioinformatikos IV k.]\n";

while( my $n = <> ){
    chomp $n;
    print "Parametras 'n' ($n) iseina is reziu [1;10]" and next if $n < 1 or $n > 10;
    map { $hash{$_} = [] } 'A' .. 'C';
    @{ $hash{ 'A' } } = reverse 1 .. $n;
    $it = 0;
    print "${it}: Pradine busena:\n";
    print _arrays, "\n";
    hb( 'A', 'B', 'C', $n );
}

print "Programa baige darba\n";
