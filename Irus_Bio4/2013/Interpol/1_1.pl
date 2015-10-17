#!/usr/bin/perl

open (in, "in.dat") or die "Negaliu atverti failo!\n";
my @mas;
while (<in>){push @mas, $_}
if (@mas<2){die "Per maza tasku aibe!\n"}
print @mas;
 
sub bad_data{
	die "Duomenu aibeje yra tasku, su tapaciomis abscisiu reiksmemis!\n"
}

$in=<>;
for (@mas){
	/ /;
	if ($`==$in){$noInterpol++; $ans=$'; last}
	if ($`>$in){
		if ($up1 ==undef){$up1=$`; $up1y=$'}
		else{
		if ($`>$up1){if ($up2 ==undef){$up2=$`; $up2y=$'}
			elsif($`<$up2){$up2=$`; $up2y=$'}
			elsif($`==$up2){ bad_data() }}
		elsif($`<$up1){$up2=$up1; $up2y=$up1y; $up1=$`; $up1y=$'}
		else{ bad_data() }
		}
	}
	if ($`<$in){
		if ($dn1 ==undef){$dn1=$`; $dn1y=$'}
		else{
		if ($`<$dn1){if ($dn2 ==undef){$dn2=$`; $dn2y=$'}
			elsif($`>$dn2){$dn2=$`; $dn2y=$'}
			elsif($`==$dn2){ bad_data() }}
		elsif($`>$dn1){$dn2=$dn1; $dn2y=$dn1y; $dn1=$`; $dn1y=$'}
		else{ bad_data() }
		}
	}
}

# print "$dn2,$dn1,$up1,$up2\n";

if ($noInterpol){warn "Taskas su tokia abscise jau yra, jo ordinate lygi: $ans"}
else{

	if ($dn1 ==undef){$a=$up1; $ay=$up1y; $b=$up2; $by=$up2y}
	elsif($up1 ==undef){$a=$dn2; $ay=$dn2y; $b=$dn1; $by=$dn1y}
	else{$a=$dn1; $ay=$dn1y; $b=$up1; $by=$up1y}

	$k=($by-$ay)/($b-$a);
	## $k=($ay-$ans)/($a-$in);
	$ans=$ay-$k*($a-$in);

	# print "$k\n";
	print "$ans\n";
}
close (in);
