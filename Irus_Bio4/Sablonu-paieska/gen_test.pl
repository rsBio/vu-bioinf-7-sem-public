#!/usr/bin/perl

use warnings;
use strict;

srand( time ^ $$ );

my $az;
print "Įveskite simbolių aibę:\n";
while( $az = <> ){
    chomp $az;
    my $sorted = join '', sort split //, $az;
    my $sqeezed = $sorted =~ y///csr;
    $sorted ne $sqeezed ?
        do { print "Įveskite iš naujo, be pasikartojimų:\n" ; 
            next } 
        : last
}
my $len_az = length $az;

my $patt;
print "Įvesite šabloną [Yy] ar sugeneruoti šabloną?\n";
    if (<> =~ /y/i){
        print "Įveskite šabloną:\n";
        chomp( $patt = <> );
    }
    else {
        print "Kokio ilgio šabloną sugeneruoti?\n";
        chomp( my $len_patt = <> );
        $patt .= substr $az, (rand $len_az), 1  for 1 .. $len_patt;
    }

print "Kokio ilgio eilutę sugeneruoti?\n";
chomp( my $len = <> );

print "Kaip užvadinti failą?\n";
chomp( my $fname = <> );

print "Ar sukurti 'out-\$fname' failą naudojantis regex paieška [Yy]?\n";
    my $create_out = <> =~ /y/i;

my $string;
$string .= substr $az, (rand $len_az), 1  for 1 .. $len;

open my $fh, '>', "$fname" or die "$0:!!!:$!\n";
print $fh $az, "\n";
print $fh $patt, "\n";
print $fh $string, "\n";

if ($create_out){
    my @pos;
    push @pos, pos $string while $string =~ m/(?=$patt)/g;
    open my $out, '>', "out-$fname" or die "$0:!!!:$!\n";
    print $out "@pos\n";
}
