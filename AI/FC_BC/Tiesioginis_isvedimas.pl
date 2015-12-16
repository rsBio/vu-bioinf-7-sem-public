#!/usr/bin/perl

use strict;
use warnings;
no warnings "experimental::smartmatch"; 
# operatorius 'smartmatch' ('~~') naudojamas elemento buvimui masyve patikrinti

print "Programa pradeda darbą." .
    " [Autorius: Robertas Stankevič, bioinformatikos 4 k.]\n\n";

# Kviečiamas failo nuskaitymas
# Sudaromos duomenų struktūros:
#   1) productions : array of production
#      production :
#        hash : begin
#          premises   => array of char
#          conclusion => char
#          flag => byte
#        end
#   2) assertion_list : array of char
#   3) goal : char
my( $productions, $assertion_list, $goal ) = nuskaityti_is_failo();

# Atspausdinamas failo turinys
print "1) Pateikti pradiniai duomenys:\n\n";
spausdinti_turini( $productions, $assertion_list, $goal );
print "-" x 50 . "\n";

print "2) Sprendimas:\n\n";

my @result;
my $move_number = 1;
my $R = 0;						                                            # { 1}
my $skyrimo_linija = 0;
while( $R < @$productions 
       && ! ( $goal ~~ @$assertion_list ) )		                            # { 2}
{                                                          	                # { 3}
  if( $R == 0 ){
        $skyrimo_linija ++ and print "-" x 20 . "\n";
        print "Iteracija nr. " . $move_number . ":\n";
    }
  print " " x 4 . ($R + 1) . "." . " " . "Taisyklė "
        . '"' . produkcijos_aprasas( $productions->[$R], $R + 1 ) . '"';

  if( $productions->[$R]->{'flag'} ){
        print " netaikoma, nes pažymėta 'flag1'.\n";
        $R++;
        next;
    }

  if( ar_posarasis( $assertion_list, $productions->[$R]->{'premises'} ) )   # { 4}
    {                                                      	                # { 5}
      if( not $productions->[$R]->{'conclusion'} ~~ @$assertion_list )      # { 6}
        {                                                                   # { 7}
          push( @$assertion_list, 
                $productions->[$R]->{'conclusion'} );    	                # { 8}
          print " taikoma ir pažymima 'flag1'.";
          print " " x 1 . "Faktų aibė po pritaikymo: {" 
            . join( ", ", @$assertion_list ) . "}\n";
          push( @result, "R" . ( $R + 1 ) );
          $productions->[$R]->{'flag'} = 1;
          $R = 0; $move_number ++;		         	                        # { 9}
        }                                                                   # {10}
        else {
            print " netaikoma, nes toks faktas jau yra.\n";
            $R++;                                                           # {11}
        }
    }                                                    	                # {12}
    else { 
        printf " netaikoma, nes nėra 'prerekvizito' (%s) sąraše.\n",
            kurio_nera( $assertion_list, $productions->[$R]->{'premises'} );
        $R++;                                                               # {13}
    }
}                                                                           # {14}

print "\n";
print "-" x 50 . "\n";
# Jei išvestų faktų sąraše esama tikslo, pranešama, 
# jog tikslas pasiektas
print "3) Rezultatas:\n";
if( $goal ~~ @$assertion_list ) {
  print "Tikslas \'$goal\' pasiektas.\nSprendimo planas:\n" 
    . "{" . join( ", ", @result ) . "}" . "\n";
} else {
  print "Tikslas \'$goal\' nepasiektas.\n";
}
print "\n";
print "Programa baigė darbą.\n";

sub nuskaityti_is_failo
{
    my( @productions, @assertion_list, $goal );

    <>, <>;                   # Praleidžiamos pirmos dvi failo eilutės

    while( <> ) {             # Po vieną skaitomos tolimesnės įvesties failo eilutės
        last if $_ =~ /^$/;   # Ciklas paliekamas, jei sutinkama tuščia eilutė

        # Perskaitytos eilutės pabaigoje ištrinamas komentaras (jeigu yra).
        $_ =~ s{ //.* }{}x;
        # Perskaityta eilutė apkarpoma (trim) ir skaldoma pagal tarpų simbolius,
        # pagaminant sąrašą iš simbolių
        my @production = split ' ', $_;
        # Paskutinis perskaitytos eilutės simbolis yra išvada
        my $conclusion = pop @production;
        # Į masyvo pabaigą pridedamas įrašas, atitinkantis produkciją
        push( @productions, 
            { 'premises' => \@production, 'conclusion' => $conclusion, 'flag' => 0 } 
        );
    }

    <>;                        # Praleidžiama sekanti failo eilutė

    # Kita failo eilutė apkarpoma (trim) ir skaldoma pagal tarpų simbolius,
    # pagaminant masyvą iš simbolių
    @assertion_list = split ' ', <>;

    <>, <>;                        # Praleidžiamos dvi sekančios failo eilutės
    <> =~ /./ or warn "Ši eilutė neturi būti be simbolių!\n";

    # Kitos failo eilutės pirmas simbolis priskiriamas tikslui
    $goal = $&; 
    return( \@productions, \@assertion_list, $goal );
}

# Procedūra, struktūrizuotai spausdinanti failo turinį
sub spausdinti_turini
{
    my( $productions, $assertion_list, $goal ) = @_;
    print "Įvestos taisyklės:\n";

    # Atspausdinama kiekviena produkcija
    for( my $i = 0; $i < @$productions; $i++ ) {
        print " " x 4 
          . produkcijos_aprasas( $productions->[$i], $i + 1 ) . "\n";
    }

    # Atspausdinami faktai, jų pavadinimus atskyrus kableliu
    print "Pradiniai faktai: {" 
      . join( ", ", @$assertion_list ) . "}\n";
    print "Tikslas: " . $goal . "\n";
}

# Funkcija, grąžinanti tekstinę produkcijos reprezentaciją
# "Produkcijos vardas: prerekvizitai, atskirti kableliais -> išvada"
sub produkcijos_aprasas
{
    my( $production, $number ) = @_;
    return "R" . $number . " : "
        . join( ", ", @{ $production->{'premises'} } )
        . " -> " . $production->{'conclusion'};
}

# Funkcija, tikrinanti, ar visi vieno sąrašo elementai 
# yra kitame sąraše
sub ar_posarasis
{
    my( $list, $sublist ) = @_;

    # Kintamajam $_ priskiriamas kaskart vis kitas sąrašo elementas
    foreach( @$sublist ) {

        # Jei elemento $_ nėra sąraše, grąžinama 0
        return 0 if not $_ ~~ @$list;
    }
    return 1;  # Suradus visus elementus, grąžinama 1
}

# Funkcija, grąžinanti, kurio iš vieno sąrašo elementų 
# nėra kitame sąraše
sub kurio_nera
{
    my( $list, $sublist ) = @_;

    # Kintamajam $_ priskiriamas kaskart vis kitas sąrašo elementas
    foreach( @$sublist ) {

        # Jei elemento $_ nėra sąraše, jis grąžinamas
        return $_ if not $_ ~~ @$list;
    }
    warn "Elementas turėjo būti surastas!\n";  # Pranešimas apie klaidą
}

