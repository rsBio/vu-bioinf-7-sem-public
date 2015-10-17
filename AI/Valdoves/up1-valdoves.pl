#!/usr/bin/perl

# Standartiniai moduliai
use warnings;
use strict;

my $N = <>;
chomp $N;
my $NM1 = $N - 1;
my $N2M1 = $N * 2 - 1;

my @x;
my @vert;	# Vertikales
my @kyl;	# Kylancios istrizaines
my @leid;	# Besileidziancios istrizaines
my $yra;
my ($i, $j);
my $band_sk;	# Bandymu skaicius

sub try{
	my ( $i ) = shift;	# Iejimas ${i} - ejimo numeris
	my $yra;		# Isejimas ${yra} - ar pavyko nustatyti
	my $k = 0;
	do {
		$k ++; $band_sk ++;
		$vert[ $k ] and $kyl[ $N+$k-$i ] and $leid[ $i+$k-1]
		and do {  # Vertikale, kyl. ir besileidzianti istr. -- laisvos.
			$x[ $i ] = $k;
			( $vert[ $k ], $kyl[ $N+$k-$i ], $leid[ $i+$k-1] ) =
			(undef) x 3;
			$i < $N ? do {
				$yra = &try( $i + 1 );
				not $yra and do {	# Nerastas kelias toliau
					( $vert[ $k ], $kyl[ $N+$k-$i ], 
					$leid[ $i+$k-1] ) =
					(1) x 3;	# Atlaisvinamas langelis
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

print "Programa pradeda darba."
	. " [Autorius: Robertas Stankevic, IV-o k. bioinformatikas]\n";

# 1. Kintamuju inicializacija: 
++ $vert[ $_ ] for         1 .. $N;
++ $kyl[  $_ ] for $N - $NM1 .. $N + $NM1;
++ $leid[ $_ ] for         1 .. $N2M1;

$yra = undef; $band_sk = 0;

# 2. Funkcijos kvietimas:
$yra = &try( 1 );

# 3. Spausdinama lenta:
$yra ? do {
	for my $i (reverse 1 .. $N){
		printf "I = %2d ", $i;
		for my $j (1 .. $N){
			printf "%3s",  $x[ $i ] == $j ?
				1
			:
				0
		}
		print "\n";
	}
	print "-" x (7 + 3 * $N) . "\n";
	printf "J =    %s\n" , join '', map { sprintf "%3d", $_ } 1 .. $N;
	print "Bandymu skaicius: ${band_sk}\n";
}
:
do { print "Sprendinys neegzistuoja\n"};

print "Programa baigia darba\n";

# END {main}
