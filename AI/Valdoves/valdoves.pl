#!/usr/bin/perl

use warnings;
use strict;

my $N = 8;
my $NM1 = $N - 1;
my $N2M1 = $N * 2 - 1;

my @x;
my @vert;
my @kyl;
my @leid;
my $yra;
my ($i, $j);
my $band_sk;

sub try{
	my $yra;
	my ( $i ) = shift;
	my $k = 0;
	do {
		$k ++; $band_sk ++;
		$vert[ $k ] and $kyl[ $N+$k-$i ] and $leid[ $i+$k-1]
		and do {
			$x[ $i ] = $k;
			( $vert[ $k ], $kyl[ $N+$k-$i ], $leid[ $i+$k-1] ) =
			(undef) x 3;
			$i < $N ? do {
				$yra = &try( $i + 1 );
				not $yra and do {
					( $vert[ $k ], $kyl[ $N+$k-$i ], 
					$leid[ $i+$k-1] ) =
					(1) x 3;
				};
			}
			:
			do { $yra = 1 }
		}
	} 
	until $yra or $k == $N;
	return $yra
}

# BEGIN {main}

++ $vert[ $_ ] for         1 .. $N;
++ $kyl[  $_ ] for $N - $NM1 .. $N + $NM1;
++ $leid[ $_ ] for         1 .. $N2M1;

$yra = undef; $band_sk = 0;

$yra = &try( 1 );

$yra ? do {
	for my $i (reverse 1 .. $N){
		for my $j (1 .. $N){
			printf "%3d",  $x[ $i ] == $j ?
				1
			:
				0
		}
		print "\n";
	}	
	print "Bandymu skaicius: ${band_sk}\n";
}
:
do { print "Sprendinys neegzistuoja\n"};

# END {main}
