#!/usr/bin/perl

use warnings;
use strict;

my $N = 5;
# Šachmatų lentos dydis
my $NN = 25;
# Langelių skaičius šachmatų lentoje 5x5
my @INDEX = 1..$N;
my @LENTA; # Globali duomenų bazė
my (@CX, @CY); # Produkcijų aibė visada iš 8 prod.
my ($I, $J);
my $YRA;

sub INICIALIZUOTI {
    my ($I, $J) = @_;
    # 1) Suformuojama produkcijų aibė
    $CX[1] = 2;
    $CY[1] = 1;
    $CX[2] = 1;
    $CY[2] = 2;
    $CX[3] = -1;
    $CY[3] = 2;
    $CX[4] = -2;
    $CY[4] = 1;
    $CX[5] = -2;
    $CY[5] = -1;
    $CX[6] = -1;
    $CY[6] = -2;
    $CX[7] = 1;
    $CY[7] = -2;
    $CX[8] = 2;
    $CY[8] = -1;
    # 2) Inicializuojama globali duomenų bazė
    for ($I = 1; $I <= $N; $I++){
        for ($J = 1; $J <= $N; $J++){
            $LENTA[$I][$J] = 0;
        }
    }
} # INICIALIZUOTI

sub EITI {
    # Įėjimo parametrai L – ėjimo numeris; X, Y – paskutinė žirgo  padėtis
    my ($L, $X, $Y) = @_;
    # Išėjimo parametras (t.y. rezultatas) YRA
    
    my $K; # Produkcijos eilės numeris
    my ($U, $V); # Nauja žirgo padėtis
    
    $K = 0;
    do { # Perrenkamos produkcijos iš 8 produkcijų aibės
        $K ++;
        $U = $X + $CX[$K]; $V = $Y + $CY[$K];
        # Patikrinama, ar duomenų bazė tenkina produkcijos taikymo sąlygą
        if ($U >= 1 and $U <= $N and $V >= 1 and $V <= $N)
        { # Neišeinama už lentos krašto.
            # Patikrinama, ar langelis laisvas, t. y. ar žirgas jame nebuvo
            if ($LENTA[$U][$V] == 0)
            {
                # Nauja žirgo pozicija pažymima ėjimo numeriu
                $LENTA[$U][$V] = $L;
                # Patikrinama, ar dar ne visa lenta apeita
                if ($L < $NN)
                {
                    # Jeigu lenta neapeita, tai bandoma daryti ėjimą
                    $YRA = &EITI($L+1, $U, $V);
                    # Jei buvo pasirinktas nevedantis į sėkmę ėjimas,
                    # tai grįžtama atgal, t. y. langelis atlaisvinamas
                    if (not $YRA) { $LENTA[$U][$V] = 0;
                    }
                    else {$YRA = 1; } # Kai L=NN
                }
            }
        }
    }
    until $YRA or $K == 8; # Sėkmė arba perrinktos visos 8 produkcijos
} # EITI

# Pagrindinė programa (main program)
# 1. Paruošiama globali duomenų bazė ir užpildoma produkcijų aibė
&INICIALIZUOTI; $YRA = 0;
# 2. Pažymima pradinė žirgo padėtis: langelis [1,1]
$LENTA[1][1] = 1;
# 3. Kviečiama procedūra sprendinio paieškai. Daryti antrą ėjimą, 
# stovint langelyje X=1 ir Y=1, ir gauti atsakymą YRA
&EITI(2, 1, 1, $YRA);
# 4. Jeigu sprendinys rastas, tai spausdinama lenta
if ($YRA) {
    for ($I = $N; $I >= 1; $I--){
        for ($J = 1; $J <= $N; $J++){
            printf "%3", ($LENTA[$I][$J]);
        }
        print "\n";
    }
}
else { print('Sprendinys neegzistuoja', "\n") };
