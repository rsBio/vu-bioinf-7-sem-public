#!usr/bin/perl

use warnings;
use strict;

my %hash;

sub _arrays {
    map "{$_}\n", join ', ', map "($_)", 
        map { join ',', @{ $hash{ $_ } } } 'A' .. 'C';    
    }

my $it;
my @output;

sub _say {
    my ($nuo, $ant, $n) = @_;
    push @{ $hash{ $ant } }, pop @{ $hash{ $nuo } };
    $it ++;
    push @output, 
        "${it}: Nuo virbo ${nuo} perkelti ant virbo ${ant}.[$n]\n";
    push @output, _arrays, "\n";
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
    print "Parametras 'n' ($n) iseina is reziu [1;10]" and 
        next if $n < 1 or $n > 10;
    map { $hash{$_} = [] } 'A' .. 'C';
    @{ $hash{ 'A' } } = reverse 1 .. $n;
    $it = 0;
    @output = ();
    push @output, "${it}: Pradine busena:\n";
    push @output, _arrays, "\n";
    hb( 'A', 'B', 'C', $n );
    print join '', @output;
}

print "Programa baige darba\n";
