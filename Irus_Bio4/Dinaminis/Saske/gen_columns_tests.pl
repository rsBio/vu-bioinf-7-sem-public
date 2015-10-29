#!/usr/bin/perl

use warnings;
use strict;

print "Įveskite pavadinimą failui:\n";
chomp( my $fh = <> );

print "Įveskite lentos dydį (eilutės, stulpeliai):\n";
chomp( my ($lines, $rows) = split ' ', <> );

print "Įveskite pradinį stulpelį, kuriame stovi šaškė:\n";
chomp( my $st_pos = <> );

print "Įveskite stulpelius, kuriuose bus bonusai:\n";
chomp( my @bonus_rows = split ' ', <> );

my @first_line = ($lines, $rows, $st_pos);
my @second_line = ('0') x $rows;
    $second_line[ $st_pos -1 ] = '2';

my $first_line = join ' ', @first_line;
my $second_line = join ' ', @second_line;

my @next_lines = map {
        
        my @weights = ('0') x $rows;
        $weights[ $_ ] = '1' for map $_ - 1, @bonus_rows;
        join ' ', @weights;
        
    } 2 .. $lines;

open my $out, '>', "$fh" or die "$0: Can't create: $!\n";

print $out join "\n", $first_line, $second_line, @next_lines;

