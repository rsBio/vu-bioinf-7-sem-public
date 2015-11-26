#!/usr/bin/perl

## use warnings;
use strict;

my @kryptys = (
        # dx dy
        ' -1  0', # kairėn
        '  0  1', # aukštyn
        '  1  0', # dešinėn
        '  0 -1', # žemyn
    );

my $siena;  # simbolis, reiškiantis sieną
my $keisti_siena;
my @langeliai;  # nuorodų į langelių masyvus masyvas (dvimačiai lentai)
## my @kryptys;
my $L;  # atstumo nuo pradžios taško žymė
my $terminaline;  # ar pasiekta terminalinė būsena
my $bandymu_sk;  # bandymų atlikti ėjimą skaitliukas
my @isejimo_marsrutas; 

sub _spausdinti {
	my ($n, $m) = @_;
	my $l_n = length $n;
	my $l_m = length $m;
    my $l_nm = length $n * $m;
	
    print ' ' x ($l_n - 1), ' ' , 'y', "\n";
	print ' ' x $l_n, ' ' , '^', "\n";
	
	for my $i (reverse 1 .. $n){
		printf "%${l_n}d", $i;
		print ' ', "|";
		print map { 
                defined $keisti_siena and s/^$siena$/$keisti_siena/;
                sprintf " %${l_nm}s", $_ 
            } @{ $langeliai[$i] }[1 .. $m];
		print "\n";
	}
	print ' ' x $l_n, ' ' x 2, '-' x (($l_nm + 1) * $m), '>', ' x', "\n";
	print ' ' x $l_n, ' ' x 2, 
        (map { sprintf " %${l_nm}s", $_ } 1 .. $m), "\n";
    print "\n";
}

sub _spausdinti_isejima {
    my @isejimas = @_;

    print "Išėjimo maršrutas:\n";
    while (@isejimas){
        print map "[$_]", join ";",
            (
            "x=" . shift @isejimas,
            "y=" . shift @isejimas,
            )
    }
    print "\n";
    print "\n";
}

sub _eiti {
    my ($x, $y, $siena, $n, $m) = @_;
    push @isejimo_marsrutas, $x, $y;
 #%   print "eiti [y][x]: $y $x\n";

    # Prieš einant tikriname ar būsena yra terminalinė:
    for my $kryptis (@kryptys){
        my ($dx, $dy) = split ' ', $kryptis;
        if (not defined $langeliai[ $y + $dy ][ $x + $dx ]){
 #%           print "not defined!!!: ", $y + $dy, " ", $x + $dx, "\n";
            $langeliai[ $y ][ $x ] = ++ $L;
            $terminaline = 1;
            last;
        }
    }
    
    if ($terminaline){
        print "Pasiekta terminalinė būsena.\n";
        return;
    }

    # Jei ne terminalinė, bandome eiti:

    my $ejimo_nr = 0;
    for my $kryptis (@kryptys){
        ++ $ejimo_nr;
        $bandymu_sk ++;
#%        _spausdinti($n, $m);
        my ($dx, $dy) = split ' ', $kryptis;
                
        print( # spausdinamas atitraukimas
#>            (' ' x 3)
#>            ('*' x 3)
            ('*' . ' ' x 2)
                x ($L - 1)
            );

        # spausdinamos ėjimų bandymų koordinatės ir kliūtys (kai yra)
        print "R${ejimo_nr}. x=", $x + $dx, ", y=", $y + $dy, ".";
        if ($langeliai[ $y + $dy ][ $x + $dx ] ne '0'){
            print do {
                  if ($langeliai[ $y + $dy ][ $x + $dx ] eq $siena){
                        " (siena)";
                  }
                  elsif ($langeliai[ $y + $dy ][ $x + $dx ] eq '-1'){
                        " (dvigubas siūlas)";
                  }
                  elsif ($langeliai[ $y + $dy ][ $x + $dx ] > 1){
                        " (viengubas siūlas)";
                  }
                }
        }
        print "\n";

        if ($langeliai[ $y + $dy ][ $x + $dx ] eq '0'){
            $langeliai[ $y ][ $x ] = ++ $L;
  #%          print "[$y $x: $L]\n";
            # REKURSYVUS KVIETIMAS:
            _eiti( $x + $dx, $y + $dy, $siena, $n, $m );
            return if $terminaline;
        }
        else { ; }
    }
    
##    $langeliai[ $y ][ $x ] eq '0' and
    $langeliai[ $y ][ $x ] = -1;
    $L --;
}

# BEGIN {main}
print "Programa pradeda darbą.\n";
print "Autorius: Robertas Stankevič, IV k. bioinformatika.\n";

print "Ar sienas atvaizduoti kitokiu simboliu (ne skaitmeniu)? [Yy]\n";
    if (<STDIN> =~ /^y$/i){
        print "Įveskite simbolį:\n";
        chomp( $keisti_siena = <STDIN> );
    }

while (<>){
	my ($n, $m) = split;
    my $pradzia;

    # 0. Nuskaitome šviežią labirintą:
	for my $i (reverse 1 .. $n){
		@{ $langeliai[$i] } = (undef, (split ' ', <>), undef);
        my $j;
        $j = -1;
        $j ++, (defined $_) and s/^2$/0/ and $pradzia = "$j $i"
            for @{ $langeliai[$i] };
##        $j = -1;
##        $j ++, m/[02]/ and $kryptys[$i][$j] = 1 for @{ $langeliai[$i] };
	}
    undef @{ $langeliai[ $n + 1 ] };
    
<<'CUT'
    # Senas bandymas:
    print "Ar sienas atvaizduoti grotelėmis? [yY]\n";
    if (<> =~ /^y$/i){
        for my $i (1 .. $n){
            for my $j (1 .. $m){
                $langeliai[$i][$j] eq $siena and $langeliai[$i][$j] = '#';
            }
        }
        $siena = '#';
    }
CUT
;

    $siena = '1';
    $L = 1;
    $terminaline = undef;
    $bandymu_sk = 0;
    @isejimo_marsrutas = ();

    print '-' x 40 . "\n";

    # 1. Spausdiname šviežią labirintą:
	_spausdinti( $n, $m );
    
    if (not defined $pradzia){ 
        print "Įveskite pradžios koordinates (x, y):\n";
        chomp( $pradzia = <STDIN> );
    }

    my ($prad_x, $prad_y) = split ' ', $pradzia;
    print "Pradinė padėtis: x = ${prad_x}, y = ${prad_y}\n";
    
    # 2. Kviečiame rekursyvią labirinto apėjimo procedūrą:
    _eiti( $prad_x, $prad_y, $siena, $n, $m );

    # 3. Spausdiname vaikščiotą labirintą:
    _spausdinti( $n, $m );

#>    print "Atlikta bandymų: ${bandymu_sk}.\n\n";

    # 4. Spausdiname išėjimo maršrutą:
    _spausdinti_isejima(@isejimo_marsrutas);
}

print "Programa baigia darbą.\n";
# END {main}
