#!/usr/bin/perl

#use warnings;
#use strict;


my @row = ();

sub _print {
	my ($n, $m) = @_;
	my $l_n = length $n;
	my $l_m = length $m;
	
	print ' ' x $l_n, '^', "\n";
	
	for my $i (1 .. $n){
		printf "%${l_n}d", $i;
		print "|";
		print map { sprintf " %${$l_m}s", $_ } @{ $row[$i] };
		print "\n";
	}
	print ' ' x $l_n, ' ', '-' x (($l_m + 1) * $m), '>', "\n";
	print ' ' x $l_n, ' ', (map { sprintf " %${l_m}s", $_ } 1 .. $m), "\n";
}

# BEGIN {main}
print "Programa pradeda darba.\n";
print "Autorius: Robertas Stankevic, IV k. bioinformatika.\n";

while (<>){
	my ($n, $m) = split;

	for my $i (1 .. $n){
		@{ $row[$i] } = split ' ', <>;
	}
	
	
	_print( $n, $m );

	for my $i (1 .. $n){
		;
	}
}

print "Programa baigia darba.\n";
# END {main}
