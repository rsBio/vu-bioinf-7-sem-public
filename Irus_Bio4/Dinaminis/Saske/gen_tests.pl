#!/usr/bin/perl

use warnings;
use strict;

print "Įveskite pavadinimą failui:\n";
chomp( my $fh = <> );

print "Įveskite lentos dydį (eilutės, stulpeliai):\n";
chomp( my ($lines, $rows) = split ' ', <> );

print "Įveskite užpildymo tankį (1 - one; 2 - quarter; 3 - half; 4 - full)\n";
chomp( my $density = <> );

srand ^ $$;

my $st_pos = 1 + int rand $rows;
my @first_line = ($lines, $rows, $st_pos);
my @second_line = ('0') x $rows;
    $second_line[ $st_pos -1 ] = '2';

my $first_line = join ' ', @first_line;
my $second_line = join ' ', @second_line;

my @next_lines = map {
        my @weights = ('1') x ( map { $rows / $_ } $rows, 4, 2, 1 )[ $density -1 ];
#%        print "@weights\n";
        for (1 .. $rows - @weights){
            splice @weights, rand 1 + @weights, 0, '0';
        }
#%        print "@weights\n";
        join ' ', @weights;
        
    } 2 .. $lines;

open my $out, '>', "$fh" or die "$0: Can't create: $!\n";

print $out join "\n", $first_line, $second_line, @next_lines;

