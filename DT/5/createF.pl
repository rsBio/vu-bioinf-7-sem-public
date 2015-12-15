#!/usr/bin/perl

while (<>) {
	next unless(int(340183*0.64)..int(340183*0.76));
	@arr = ("?") x 573;
	@words = split;
	foreach $word (@words) {
		$arr[$word] = 1;
	}
	shift @arr;
	print join ',' , @arr;
	print "\n";
}

