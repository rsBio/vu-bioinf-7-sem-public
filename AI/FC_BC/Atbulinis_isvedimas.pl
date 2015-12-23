#!/usr/bin/perl

use strict;
use warnings;
no  warnings "experimental::smartmatch"; 
# operatorius 'smartmatch' ('~~') naudojamas elemento buvimui masyve patikrinti

print "Programa pradeda darbą." .
    " [Autorius: Robertas Stankevič, bioinformatikos 4 k.]\n\n";

# Kviečiamas failo nuskaitymas
# Sudaromos duomenų struktūros:
#   1) taisykles : ARRAY OF taisykle
#      taisykle :
#        HASH : BEGIN
#          'premises'   => ARRAY OF CHAR
#          'conclusion' => CHAR
#        END
#   2) pradiniai_faktai : ARRAY OF CHAR
#   3) tikslas : CHAR
my( $taisykles, $pradiniai_faktai, $tikslas ) = _nuskaityti_is_failo();

# Atspausdinamas failo turinys
print "1) Pateikti pradiniai duomenys:\n\n";
	_spausdinti_turini( $taisykles, $pradiniai_faktai, $tikslas );

print "-" x 50 . "\n";

print "2) Sprendimas:\n\n";

# Kintamieji - nuorodos į tuščius anoniminius masyvus.
my $tikslai = [];
my $gautieji_faktai = [];
my $taisykliu_seka = [];

# Kviečiama rekursinė atbulinio išvedimo funkcija.
my $BC_ok = _backward_chaining( $tikslas, 0 );

print "-" x 50 . "\n";

# Spausdinamas rezultatas:
print "3) Rezultatas:\n\n"
	. do {
		if( $BC_ok ){
			if( @$taisykliu_seka ){
				"Tikslas pasiekiamas.\n"
				. ( join '', map "Planas: [$_]\n",
					join ', ', map "R$_", @$taisykliu_seka )
				. _verifikavimo_grafas( $taisykliu_seka, 
					$pradiniai_faktai, $gautieji_faktai );
			}
			else {
				"Tikslas faktų aibėje.\n"
			}
		}
		else {
			"Tikslas nepasiekiamas.\n"
		}
	};

print "\n";
print "Programa baigė darbą.\n";

# Algoritmo žingsnių skaitliukas.
my $step = 0;

# Atbulinio išvedimo rekursinė funkcija
sub _backward_chaining {
	my ($tikslas, $tab) = @_;

	return undef  if $tikslas ~~ @$tikslai 			and print 				# {1}
									_sp_tikslas( ++ $step, $tab, $tikslas ),
									" FAIL - ciklas.\n";
	return 'true' if $tikslas ~~ @$pradiniai_faktai	and print				# {2}
									_sp_tikslas( ++ $step, $tab, $tikslas ),
									" Faktas (duotas).\n";
	return 'true' if $tikslas ~~ @$gautieji_faktai	and print				# {3}
									_sp_tikslas( ++ $step, $tab, $tikslas ),
									" Faktas (buvo naujai gautas).\n";
	push @$tikslai, $tikslas;												# {4}

	my $taisykles_nr;
	for my $taisykle ( @$taisykles ){										# {5}

		$taisykles_nr ++;

		if( $taisykle->{'conclusion'} eq $tikslas ){						# {6}

			print _sp_tikslas( ++ $step, $tab, $tikslas );
			printf " Randame %s. Nauji tikslai: %s\n", 
				_produkcijos_aprasas( $taisykle, $taisykles_nr ),
				join ', ', @{$taisykle->{'premises'}};

			my $issaugotas_gautuju_faktu_skaicius = @$gautieji_faktai;		# {7.1}
			my $issaugotas_taisykliu_sekoje_skaicius = @$taisykliu_seka;	# {7.2}
			my $naudotina = 'true';											# {8}

			for my $faktas ( @{ $taisykle->{'premises'} } ){				# {9}
				if( not _backward_chaining( $faktas, $tab + 1 ) ){			# {10}
					splice @$gautieji_faktai,
						$issaugotas_gautuju_faktu_skaicius;
					splice @$taisykliu_seka,
						$issaugotas_taisykliu_sekoje_skaicius;
					undef $naudotina;
					last;
				}
			}
			if( $naudotina ){
	
				# Taisyklės išvada pridedama prie gautųjų faktų sąrašo
				push @$gautieji_faktai, $taisykle->{'conclusion'};			# {11}
				# Taisyklės numeris pridedamas prie rezultato taisyklių sekos
				push @$taisykliu_seka, $taisykles_nr;						# {12}

				print _sp_tikslas( ++ $step, $tab, $tikslas );
				printf " Faktas (dabar naujai gautas) ir GDB = {%s}.\n",
					join ", ", @$pradiniai_faktai, @$gautieji_faktai;
				
				# Tikslas ištrinamas iš visų tikslų sąrašo
				@$tikslai = grep $_ ne $tikslas, @$tikslai;					# {13}
				return 'true';
			}
		}	
	}

	print _sp_tikslas( ++ $step, $tab, $tikslas );
	print " FAIL, nes daugiau nėra taisyklių išvesti šį tikslą.\n";
	pop @$tikslai;
	return undef;															# {14}
}

# Funkcija, nuskaitanti failo duomenis
sub _nuskaityti_is_failo
{
	my( @taisykles, @pradiniai_faktai, $tikslas );

	<>, <>, <>;			# Praleidžiamos pirmos trys failo eilutės

	# Po vieną skaitomos tolimesnės įvesties failo eilutės
	while( <> ) {

		# Ciklas paliekamas, jei sutinkama tuščia arba minusais uzpildyta eilutė
		last if $_ =~ /^-*$/;

		# Perskaitytos eilutės pabaigoje ištrinamas komentaras (jeigu yra).
		$_ =~ s{ //.* }{}x;
		# Perskaityta eilutė apkarpoma (trim) ir skaldoma pagal tarpų simbolius,
		# pagaminant sąrašą iš simbolių
		my @taisykle = split ' ', $_;
		# Paskutinis perskaitytos eilutės simbolis yra išvada
		my $isvada = pop @taisykle;
		# Į masyvo pabaigą pridedamas įrašas, atitinkantis produkciją
		push( @taisykles, 
			{ 'premises' => \@taisykle, 'conclusion' => $isvada } 
		);
	}

	<>;					# Praleidžiama sekanti failo eilutė

	# Kita failo eilutė apkarpoma (trim) ir skaldoma pagal tarpų simbolius,
	# pagaminant masyvą iš simbolių
	@pradiniai_faktai = split ' ', <>;

	<>, <>;				# Praleidžiamos dvi sekančios failo eilutės
	<> =~ /./ or warn "Ši eilutė neturi būti be simbolių!\n";

	# Kitos failo eilutės pirmas simbolis priskiriamas tikslui
	$tikslas = $&; 
	return( \@taisykles, \@pradiniai_faktai, $tikslas );
}

# Procedūra, struktūrizuotai spausdinanti failo turinį
sub _spausdinti_turini {
	my( $taisykles, $pradiniai_faktai, $tikslas ) = @_;
	print ' ' x 2 . "1.1) Įvestos taisyklės:\n";

	# Atspausdinama kiekviena taisyklė
	for( my $i = 0; $i < @$taisykles; $i++ ) {
		print " " x 8 
		. _produkcijos_aprasas( $taisykles->[$i], $i + 1 ) . "\n";
	}

	# Atspausdinami faktai, jų pavadinimus atskyrus kableliu
	print ' ' x 2 . "1.2) Pradiniai faktai: {" 
		. join( ", ", @$pradiniai_faktai ) . "}\n";
	print ' ' x 2 . "1.3) Tikslas: " . $tikslas . "\n";
}

# Funkcija, grąžinanti tekstinę taisyklės reprezentaciją
# "Produkcijos vardas: prerekvizitai, atskirti kableliais -> išvada"
sub _produkcijos_aprasas {
	my( $taisykle, $number ) = @_;
	return "R" . $number . " : "
		. join( ", ", @{ $taisykle->{'premises'} } )
		. " -> " . $taisykle->{'conclusion'};
}

# Funkcija, grąžinanti eilutę, su žingsnio numeriu, reikiamu atitraukimu ir tikslu
sub _sp_tikslas {
	my ($step, $tab, $tikslas) = @_;
	return sprintf "%3d. %s", $step, ' ' x 2 x $tab . "Tikslas $tikslas.";
}

# Funkcija, grąžinanti verifikavimo grafą pseudografiniu pavidalu
sub _verifikavimo_grafas {
	my $taisykliu_seka = shift;
	my @faktai = map { @$_ } @_;
	my $pradiniu_faktu_sk = @{ $_[0] };
	# Sukuriamas tuščių eilučių masyvas, 
	# prie kurių bus iteratyviai priklijuojama pseudografika.
	my @lines = ('') x (@faktai +2);
	for my $i ($pradiniu_faktu_sk +2 .. @faktai +2){
		# Skaitliukas, kiek šioje iteracijoje reikės spausdinti pseudografikos
		my $jj = 0;	
		# Priklijuojama pseudografinė aibė (užpildyto stačiakampio pavidalu)
		for my $j (1 .. @faktai +2){
			if( $j > (@faktai +2 - $i) >> 1 and $jj ++ < $i ){
				$lines[ $j-1 ] .= do {
					if   ( $jj ==  1 ){ '┏━┓' }
					elsif( $jj == $i ){ '┗━┛' }
					else {
						'┃' . $faktai[ $jj-2 ] . '┃'
					}
				};
			}
			else {
				$lines[ $j-1 ] .= ' ' x 3;
			}
		}

		last if $i == @faktai +2;
		# Priklijuojamos rodyklytės su taisyklėmis
		for my $j (1 .. @faktai +2){
			$lines[ $j-1 ] .= do {
				if( $j == (@faktai +2 +1) >> 1 ){
					'-' . 'R' . $taisykliu_seka->[$i - $pradiniu_faktu_sk -2]. '→'
				}
				else {
				' ' x (3 + length $taisykliu_seka->[$i - $pradiniu_faktu_sk -2]);
				}
			};
		}
	}
	return join "\n", "Verifikavimo grafas:", @lines
}

