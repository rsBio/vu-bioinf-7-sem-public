#!/usr/bin/perl

use strict;
use warnings;
no warnings "experimental::smartmatch"; # operatorius '~~' naudojamas elemento buvimui masyve patikrinti

print "Programa pradeda darbą.\n";

# Kviečiamas failo nuskaitymas
# Sudaromos duomenų struktūros:
#   1) productions : array of production
#      production :
#        begin
#          premises   : array of char
#          conclusion : char
#        end
#   2) assertion_list : array of char
#   3) goal : char
my( $productions, $assertion_list, $goal ) = loadFromFile();

# Atspausdinamas failo turinys
printStructures( $productions, $assertion_list, $goal );
print "-" x 20 . "\n";

my @result;
my $move_number = 1;
my $R = 0;						                                   # { 1}
while( $R < @$productions 
       && ! ( $goal ~~ @$assertion_list ) )		                   # { 2}
{                                                          	       # { 3}
  if( isSublist( $assertion_list, $productions->[$R]->[0] ) )      # { 4}
    {                                                      	       # { 5}
      if( not $productions->[$R]->[1] ~~ @$assertion_list )        # { 6}
        {                                                          # { 7}
          push( @$assertion_list, 
                $productions->[$R]->[1] );    	            # { 8}
          print $move_number . "." 
            . " " x ( 3 - length( $move_number ) )
            . "Taikoma taisyklė "
            . productionToString( $productions->[$R], $R + 1 ) . "\n";
          print " " x 4 . "Faktų aibė po pritaikymo: {" 
            . join( ", ", @$assertion_list ) . "}\n" 
            . "-" x 20 . "\n";
          push( @result, "R" . ( $R + 1 ) );
          $R = 0; $move_number++;		         	        # { 9}
        }                                                   # {10}
        else { $R++; }                                      # {11}
    }                                                    	# {12}
    else { $R++; }                                          # {13}
}                                                           # {14}

# Jei išvestų faktų sąraše esama tikslo, pranešama, 
# jog tikslas pasiektas
if( $goal ~~ @$assertion_list ) {
  print "Tikslas \'$goal\' pasiektas.\nRezultatas: " 
    . join( ", ", @result ) . "\n";
} else {
  print "Tikslas \'$goal\' nepasiektas.\n";
}
print "Programa baigė darbą.\n";

sub loadFromFile
{
    my( @productions, @assertion_list, $goal );

    <>, <>;                   # Praleidžiamos pirmos dvi failo eilutės

    while( <> ) {             # Po vieną skaitomos tolimesnės įvesties failo eilutės
        last if $_ =~ /^$/;   # Ciklas paliekamas, jei sutinkama tuščia eilutė

        # Perskaitytos eilutės pabaigoje ištrinamas komentaras (jeigu yra).
        $_ =~ s{ //.* }{}x;
        # Perskaityta eilutė apkarpoma (trim) ir skaldoma pagal tarpų simbolius, pagaminant sąrašą iš simbolių
        my @production = split ' ', $_;
        # Paskutinis perskaitytos eilutės simbolis yra išvada
        my $conclusion = pop @production;
        # Į masyvo pabaigą pridedamas įrašas, atitinkantis produkciją
        push( @productions, [ \@production, $conclusion ] );
    }

    <>;                        # Praleidžiama sekanti failo eilutė
    # Kita failo eilutė apkarpoma (trim) ir skaldoma pagal tarpų simbolius, pagaminant masyvą iš simbolių
    @assertion_list = split ' ', <>;

    <>;
    <>;                        # Praleidžiamos dvi sekančios failo eilutės
    <> =~ /./ or warn "Ši eilutė neturi būti be simbolių!\n";

    # Kitos failo eilutės pirmas simbolis priskiriamas tikslui
    $goal = $&; 
    return( \@productions, \@assertion_list, $goal );
}

# Funkcija, skirta struktūrizuotam failo turinio išvedimui
sub printStructures
{
    my( $productions, $assertion_list, $goal ) = @_;
    print "Įvestos taisyklės:\n";

    # Atspausdinama kiekviena produkcija
    for( my $i = 0; $i < @$productions; $i++ ) {    
        print " " x 4 
          . productionToString( $productions->[$i], $i + 1 ) . "\n";
    }

    # Atspausdinami faktai, jų pavadinimus atskyrus kableliu
    print "Pradiniai faktai: {" 
      . join( ", ", @$assertion_list ) . "}\n";
    print "Tikslas: " . $goal . "\n";
}

# Funkcija, grąžinanti tekstinę produkcijos reprezentaciją
# "Produkcijos vardas: prerekvizitai, atskirti kableliais -> išvada"
sub productionToString
{
    my( $production, $number ) = @_;
    return "R" . $number . " : "
        . join( ", ", @{ $production->[0] } )
        . " -> " . $production->[1];
}

# Funkcija, tikrinanti, ar visi vieno sąrašo elementai 
# yra kitame sąraše
sub isSublist
{
    my( $list, $sublist ) = @_;

    # Kintamajam $_ priskiriamas kitas sąrašo elementas
    foreach( @$sublist ) {

        # Jei elemento $_ nėra sąraše, grąžinama 0
        return 0 if not $_ ~~ @$list;
    }
    return 1;  # Jei ciklas pasibaigia, grąžinama 1
}

