#!/usr/bin/perl

use warnings;
use strict;
use Term::ANSIColor;
use Time::HiRes qw( usleep );

my $clear = `clear`;

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
my $L;  # atstumo nuo pradžios taško žymė
my $ar_terminaline;  # ar pasiekta terminalinė būsena
my $bandymu_sk;  # bandymų atlikti ėjimą skaitliukas
my @isejimo_marsrutas; 

sub _spausdinti_lenta {
	my ($n, $m) = @_;
	my $l_n = length $n;
	my $l_m = length $m;
    my $l_nm = length $n * $m;
    $l_nm < 2 and $l_nm = 2;
	
    print ' ' x ($l_n - 1), ' ' , 'y', "\n";
	print ' ' x $l_n, ' ' , '^', "\n";
	
	for my $i (reverse 1 .. $n){
		print sprintf "%${l_n}d", $i;
		print ' ', colored("|",'yellow');
		print map { 
                defined $keisti_siena and s/^$siena$/$keisti_siena/;
                do {
                    if (defined $keisti_siena and $_ eq $keisti_siena){
                        colored((sprintf " %${l_nm}s", $_ ),'yellow on_magenta');
                    }
                    elsif ( $_ eq $siena ){
                        colored((sprintf " %${l_nm}s", $_ ),'blue on_magenta');
                    }
                    elsif ( $_ >= 2 ){
                        colored((sprintf " %${l_nm}s", $_ ),'red on_bright_yellow');
                    }
                    elsif ( $_ < 0 ){
                        colored((sprintf " %${l_nm}s", $_ ),'red on_yellow');
                    }
                    elsif ( $_ == 0 ){
                        colored((sprintf " %${l_nm}s", $_ ),'white');
                    }
                }
            } @{ $langeliai[$i] }[1 .. $m];
		print "\n";
	}
	print ' ' x ($l_n + 1), colored( (join '', ' ', '-' x (($l_nm + 1) * $m), 
        ), 'yellow'), '>', ' x', "\n";
	print ' ' x $l_n, ' ' x 2, 
        (map { sprintf " %${l_nm}s", $_ } 1 .. $m), "\n";
    print "\n";
}

sub _spausdinti_isejima {
    my ($ar_term, @isejimas) = @_;

    if(not $ar_term){
	    print "Išėjimas iš labirinto neegzistuoja.\n\n"
	}
    else {
        print "Išėjimo maršrutas:\n";
        
        for my $pro_kur (@isejimas){
	        my ($RN, $x, $y) = @{ $pro_kur };
	        print $RN, "";
                print map "[$_] ", join ";",
                   (
                    "x=" . $x,
                    "y=" . $y,
                 );
        }
    
        print "\n";
    }
    print "\n";
}

# Paieškos į gylį algoritmas.
sub _eiti_gilyn {
    my ($x, $y, $siena, $n, $m) = @_;
 #%   print "eiti [y][x]: $y $x\n";

    # Prieš einant tikriname ar būsena yra terminalinė:
    for my $kryptis (@kryptys){
        my ($dx, $dy) = split ' ', $kryptis;
        if (not defined $langeliai[ $y + $dy ][ $x + $dx ]){
            $langeliai[ $y ][ $x ] = ++ $L;
            $ar_terminaline = 1;
            last;
        }
    }
    
    if ($ar_terminaline){
        print "Pasiekta terminalinė būsena.\n";
        return;
    }

    # Jei ne terminalinė, bandome eiti:

    my $ejimo_nr = 0;
    for my $kryptis (@kryptys){
        ++ $ejimo_nr;
        $bandymu_sk ++;
        my ($dx, $dy) = split ' ', $kryptis;
                
        print(  # spausdinamas atitraukimas
#>            (' ' x 3)
#>            ('*' x 3)
            ('*' . ' ' x 2)
                x ($L - 1)
            );

        # spausdinamos ėjimų bandymų koordinatės ir kliūtys (kai yra)
        print "R${ejimo_nr}. x=", $x + $dx, ", y=", $y + $dy, ".";
        if ($langeliai[ $y + $dy ][ $x + $dx ] ne '0'){
            print map " ($_)", do {
                  if ($langeliai[ $y + $dy ][ $x + $dx ] eq $siena){
                        "siena";
                  }
                  elsif ($langeliai[ $y + $dy ][ $x + $dx ] eq '-1'){
                        "dvigubas siūlas";
                  }
                  elsif ($langeliai[ $y + $dy ][ $x + $dx ] > 1){
                        "viengubas siūlas";
                  }
                };
        }
        print "\n";

        if ($langeliai[ $y + $dy ][ $x + $dx ] eq '0'){
            push @isejimo_marsrutas, ["R${ejimo_nr}.", $x + $dx, $y + $dy];
            $langeliai[ $y ][ $x ] = ++ $L;
            print $clear;
            _spausdinti_lenta( $n, $m );
            usleep(3e5);
            print $clear;
  #%          print "[$y $x: $L]\n";
            # REKURSYVUS KVIETIMAS:
            _eiti_gilyn( $x + $dx, $y + $dy, $siena, $n, $m );
            return if $ar_terminaline;
        }
        else { ; }
    }
    
            print $clear;
            _spausdinti_lenta( $n, $m );
            usleep(3e5);
            print $clear;
    $langeliai[ $y ][ $x ] = -1;
    pop @isejimo_marsrutas; 
    $L --;
}


# Paieškos į ploti algoritmas.
sub _eiti_platyn {
    my ($x, $y, $siena, $n, $m) = @_;

    my $bangos_nr = 1;
    my @prev = ();

    my @langeliai_tikrinimui = ();
    push @langeliai_tikrinimui, [ $y, $x ];
    push @langeliai_tikrinimui, 'bangos_pabaiga';
    
    while( @langeliai_tikrinimui ){
        
        my $tikrinimui = shift @langeliai_tikrinimui;

        $tikrinimui eq 'bangos_pabaiga'
            and do { 
                ++ $bangos_nr;
                if (! @langeliai_tikrinimui){
#%                    print "ISĖJIMO NĖR!\n";
                    last;
                }
                push @langeliai_tikrinimui, 'bangos_pabaiga';
                next
            }; 

        my ($y, $x) = @{ $tikrinimui };
        $langeliai[ $y ][ $x ] = $bangos_nr + 1;
        print $clear;
        _spausdinti_lenta( $n, $m );
        usleep(3e5);
        print $clear;

        my $ejimo_nr = 0;

        for my $kryptis (@kryptys){
            ++ $ejimo_nr;
            $bandymu_sk ++;

            my ($dx, $dy) = split ' ', $kryptis;

            # Tikriname ar būsena yra terminalinė:
            if (not defined $langeliai[ $y + $dy ][ $x + $dx ]){
                $ar_terminaline = 1;
                print "Pasiekta terminalinė būsena.\n";
                
                # Jei terminalinė, konstruojam išėjimo masyvą:
                @isejimo_marsrutas = ();              
                while( defined $prev[ $y ][ $x ] ){
                    ($ejimo_nr) = @{ $prev[ $y ][ $x ] };
                    unshift @isejimo_marsrutas, [ "R${ejimo_nr}." , $x, $y ];
                    ($y, $x) = @{ $prev[ $y ][ $x ] }[1 .. 2];
                }
                last;
            }

            print(  # spausdinamas atitraukimas
#>                (' ' x 3)
#>                ('*' x 3)
                ('*' . ' ' x 2)
                    x ($bangos_nr - 1)
                );

            # spausdinamos ėjimų bandymų koordinatės ir kliūtys (kai yra)
            print "R${ejimo_nr}. x=", $x + $dx, ", y=", $y + $dy, ".";

            if ($langeliai[ $y + $dy ][ $x + $dx ] ne '0'){ 
                print map " ($_)", do {
                  if ($langeliai[ $y + $dy ][ $x + $dx ] eq $siena){
                        "siena";
                  }
                  elsif ($langeliai[ $y + $dy ][ $x + $dx ] > 0){
                        "siūlas";
                  }
                };
            }
            print "\n";

            if ($langeliai[ $y + $dy ][ $x + $dx ] eq '0'){
                push @langeliai_tikrinimui, [ $y + $dy, $x + $dx ];
                $prev[$y + $dy][$x + $dx] = [ ${ejimo_nr} , $y, $x ];
            }

        }
        last if $ar_terminaline;
    }
    return;
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

	}
    undef @{ $langeliai[ $n + 1 ] };

    $siena = '1';
    $L = 1;
    $ar_terminaline = undef;
    $bandymu_sk = 0;
    @isejimo_marsrutas = ();

    print '-' x 40 . "\n";

    # 1. Spausdiname šviežią labirintą:
    print "Pradinė labirinto būsena:\n\n";
	_spausdinti_lenta( $n, $m );
    
    if (not defined $pradzia){ 
        print "Įveskite pradžios koordinates (x, y):\n";
        chomp( $pradzia = <STDIN> );
    }

    my ($prad_x, $prad_y) = split ' ', $pradzia;
    print "Pradinė padėtis: x = ${prad_x}, y = ${prad_y}\n";
    
    print "Įveskite kokiu būdu apeiti labirintą?"
           . " [B] - į plotį, [D] - į gylį.\n";
    
    my $budas;
    while ($budas = <STDIN>){
        $budas !~ /B|D/ and do (print "Įveskite iš naujo.\n"), next;
        
        if ($budas =~ /B/){
                # 2.v1 Kviečiame labirinto apėjimo į plotį procedūrą:
                _eiti_platyn( $prad_x, $prad_y, 
                 (defined $keisti_siena ? $keisti_siena : $siena), $n, $m );
        }
        elsif ($budas =~ /D/){
                 # 2.v2 Kviečiame rekursyvią labirinto apėjimo į gylį procedūrą:
                 _eiti_gilyn( $prad_x, $prad_y, 
                 (defined $keisti_siena ? $keisti_siena : $siena), $n, $m );
        }
        last;
    }
    
    # 3. Spausdiname vaikščiotą labirintą:

    print $clear;
#    usleep(3e5);
    _spausdinti_lenta( $n, $m );

    # 4. Spausdiname išėjimo maršrutą:
    _spausdinti_isejima( $ar_terminaline, @isejimo_marsrutas );
}

print "Programa baigia darbą.\n";
# END {main}
