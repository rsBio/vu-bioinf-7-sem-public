#!/usr/bin/perl

use warnings;
use strict;
use utf8;

open my $out, '>', "spam.arff" or die "$0: can't create! $!\n";

print $out "\@RELATION mail\n\n";

my $iter1 = 1;
my @attr;

##	my $class = shift @ARGV;

foreach my $name (@ARGV) {
	open my $file, "<", $name or die "$0:$name:$!\n";
	$_ = do {local $/; <$file>};
	
	$name =~ m/mail_(\d)/;
	my $class = $1;

	my @csv_line;
	my %h;

	$h{'len'} = length;
	$h{'all'} = [ split // ];
	$h{'chunks'} = [ split ];
	$h{'num'}->{'Lett'} = () = m/\S/g;
	$h{'word_mean'} = $h{'num'}->{'Lett'} / @{ $h{'chunks'} };
	$h{'words'} = [ m/\w+/g ];

	push @csv_line, 
		$h{'len'},
		scalar @{ $h{'chunks'} },
		$h{'num'}->{'Lett'},
		$h{'word_mean'},
		scalar @{ $h{'words'} };

	$iter1 and push @attr,
		"length NUMERIC",
		"num_chunks NUMERIC",
		"num_letters NUMERIC",
		"word_mean NUMERIC",
		"num_words NUMERIC";

#--------------------
	my %symbols = map { chr, 0 } 32 .. 126;

	for my $byte (@{ $h{'all'} }){
		exists $symbols{ $byte } and $symbols{ $byte } ++
	}

#%	print "$_ -> $symbols{ $_ }\n" for sort keys %symbols;

	push @csv_line, 
		map $symbols{ $_ }, sort keys %symbols;

	$iter1 and push @attr,
		map { $_ = quotemeta ; "'num_{$_}' NUMERIC" } sort keys %symbols;

#--------------------
	for my $len (1 .. 20){
		$h{'word_len'}->{ $len }  = () = m/ (?<=\s) \S{$len} (?=\s) /gx;
		$h{'word_len'}->{ $len } += () = m/ ^       \S{$len} (?=\s) /gx;
		$h{'word_len'}->{ $len } += () = m/ (?<=\s) \S{$len} $      /gx;
		$h{'word_len'}->{ $len } += () = m/ ^       \S{$len} $      /gx;
	}

	push @csv_line, 
		map $h{'word_len'}->{ $_ }, 1 .. 20;

	$iter1 and push @attr,
		map { "'word_len_{$_}' NUMERIC" } 1 .. 20;

#--------------------
	for my $seq (2 .. 10){
		$h{'conseq'}->{ $seq } = () = m/ (?=(.)) \1{$seq} /sgx;
	}

	push @csv_line, 
		map $h{'conseq'}->{ $_ }, 2 .. 10;

	$iter1 and push @attr,
		map { $_ = quotemeta ; "'consequent_{$_}' NUMERIC" } 2 .. 10;

#--------------------
	my @spam_words;
	push @spam_words, qw[ nuolaida akcija dovana laimėjote nemokamai prizas milijonas ];
	push @spam_words, qw[ discount prize won million ];
	push @spam_words, qw[ viagra penis enlarge sex ];
	push @spam_words, qw[ help Africa poverty ];
	my %spam_words = map { $_ , 0 } @spam_words;

	for my $word (@{ $h{'words'} }){
		$h{'num'}->{'spam'} += exists $spam_words{ $word } ? 1 : 0;
	}

	push @csv_line,
		$h{'num'}->{'spam'};

	$iter1 and push @attr,
		"num_spam NUMERIC";

#--------------------
	for my $word (@{ $h{'words'} }){
		exists $spam_words{ $word } and $spam_words{ $word } ++;
	}
	
#%	print "$_ -> $spam_words{ $_ }\n" for sort keys %spam_words;

	push @csv_line, 
		map $spam_words{ $_ }, sort keys %spam_words;

	$iter1 and push @attr,
		map "'num_spam_word{$_}' NUMERIC", sort keys %spam_words;

#--------------------
	my $money_rxs = [ qr/(?:\d+\s*)+\$/s , qr/(?:\d+\s*)+(?:lit|eur|doll)/is ];

	for my $money_rx (@$money_rxs){
		$h{'num'}->{'money'} += () = m/$money_rx/g
	}

	push @csv_line,
		$h{'num'}->{'money'};

	$iter1 and push @attr,
		"num_money NUMERIC";

#--------------------
	$iter1 and print $out
		map "\@ATTRIBUTE $_\n", @attr;

	$iter1 and print $out
		"\@ATTRIBUTE class {0,1}\n",
		"\n",
		"\@DATA\n";

	print $out join ', ', @csv_line, $class;
	print $out "\n";

	$iter1 = 0;
}



