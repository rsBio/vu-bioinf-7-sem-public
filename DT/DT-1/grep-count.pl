#!/usr/bin/perl

use warnings;
use strict;

for(<@ARGV>){

#% print "$_\n";
open my $in, '<', $_ or die "$0: Can't open $1!\n";

@_ = <$in>;

my $last_attribute = ( grep /\@attribute/, @_ )[-1];
my $count_of_last = join '', 
	map { /{(.*?)}/xms; 0 + split ',', $1 } $last_attribute;

@_ = grep m/^'/, @_;

my %hA = ();
my %hB = ();

my ($A, $B, $v);

map { ($A, $B, $v) = map { 
		chomp;
#>		# Intervalo isrengimas:
#>		/^'(.*)'$/xms and $_ = $1;
#>		/^\\'(.*)\\'$/xms and $_ = $1;
#>		/^(?: \( | \[ ) (.*) (?: \) | \] )$/xms and $_ = $1;
		s/\b inf \b/ 1e10 /xe;
#%		(print "$_\n");
		s/[^-.\d]//g;
		s/\b-.*//;
##		/^-?\d+/xms and $_ = $&;
#%		(print "$_\n");
		$_
		} split /,/;
	$hA{$A} .= " $v"; 
	$hB{$B} .= " $v"; 
} @_;

print "\n*****";
print "\n-----\n";
for my $key (sort {$a <=> $b} keys %hA){
#%	print map "[[[ $_ ]]]\n", $hA{$key};
	my @A = ();
	map { $A[ $_ ] ++ } split ' ', $hA{$key};
	print join "\n", map { $A[$_] // 0 } 1 .. $count_of_last;
	print "\n\n";
}
print "\n-----\n";
for my $key (sort {$a <=> $b} keys %hB){
#%	print map "[[[ $_ ]]]\n", $hB{$key};
	my @B = ();
	map { $B[ $_ ] ++ } split ' ', $hB{$key};
	print join "\n", map { $B[$_] // 0 } 1 .. $count_of_last;
	print "\n\n";
}

} # END for
