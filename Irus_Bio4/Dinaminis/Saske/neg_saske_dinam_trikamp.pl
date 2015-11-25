#!/usr/bin/perl -0777

use warnings;
use strict;

my $trap = -1e3;

while(<>){
		
	my ($first_line, @remain) = split /\n/;
	my @next_lines = map { [ map { $_ == -1 ? $trap : $_ } split ' '] } @remain;
	
	my ($lines, $rows, $st_pos) = split ' ', $first_line;
	
##	@{ $next_lines[ 0 ] } = map { $_ ? 0 : undef } @{ $next_lines[ 0 ] };
	@{ $next_lines[ 0 ] } = (0) x $rows;

#%	print map "$_:\n", join '', map "[$_]", 
#%		map { sprintf "%5s", defined $_ ? $_ : '.' } @{ $next_lines[ 0 ] }; 
	
	my $ended = 0;
	
	for my $i (1 .. @next_lines -1){
#%		print "i: [$i]\n";
		my $line_ok = 0;
		
		for my $row ( grep { $_ > 0 and $_ <= $rows } 
						map { $st_pos + $_ } -$i .. $i
		){
			my @idxs = grep { $_ > 0 and $_ <= $rows }
				grep { $_ > $st_pos - $i and $_ < $st_pos + $i } 
				map { $row + $_ } -1 .. 1;
#%			print "[@idxs]";
			my @to_sort = grep defined, 
				@{ $next_lines[ $i -1 ] }[ map $_ - 1, @idxs ];
			my $max_prev = (sort {$b <=> $a} @to_sort )[ 0 ];
#%			print "($max_prev)\n";
			
			$next_lines[ $i ][ $row -1 ] >= 0 and $line_ok = 1;
			$next_lines[ $i ][ $row -1 ] += $max_prev;      

        }
		$ended = $i;
#%		print "ended: $ended\n";
		last if not $line_ok;

	}

	my $idx;
	my $final_max;

	for my $i ($ended){

		my @idxs = map { $_ -1 } (grep { $_ > 0 and $_ <= $rows } 
				map { $st_pos + $_ } -$i .. $i );
#%		print "< @idxs >\n";

		$final_max = (sort {$b <=> $a} @{ $next_lines[ $i ] }[ @idxs ] )[ 0 ];

		for (@idxs){
			$final_max == $next_lines[ $i ][ $_ ] and do { $idx = 1 + $_; last} 
		}
#%		print "idx: [$idx]\n";
		$next_lines[ $i ][ $idx -1 ] = join '', map "?$_?", $next_lines[ $i ][ $idx -1 ];
	}

#%	print "[[$idx]]\n";

	for my $i (reverse 1 .. $ended -1){

		my @idxs = 
				map { $_ -1 } (grep { $_ > 0 and $_ <= $rows }
				grep { $_ > $st_pos - $i -1 and $_ < $st_pos + $i }
				map { $idx + $_ } -1 .. 1 );
#%		print "< @idxs >\n";

		my $max = (sort {$b <=> $a} @{ $next_lines[ $i ] }[ @idxs ] )[ 0 ];

		for (@idxs){
			$max == $next_lines[ $i ][ $_ ] and do { $idx = 1 + $_; last} 
		}
#%		print "idx: [$idx]\n";

		$next_lines[ $i ][ $idx -1 ] = join '', map "{$_}", $next_lines[ $i ][ $idx -1 ];

#%		print "-- [[@{ $next_lines[ $i ] }]]\n";

    }

	$next_lines[ 0 ][ $st_pos -1 ] = 'start';
	
	print map "$_\n", join "\n", map { join '', 
		map { sprintf "[%7s]", $_ } @{ $next_lines[ $_ ]}  
		} 0 .. $lines -1;

	print $final_max >= 0 ?
		"Šaškės surinkti taškai: ${final_max}!\n"
	:
		"Šaškė įkrito į duobę!! (atliko ėjimų: ${ended})\n";

	print map "[$_]\n", $final_max >= 0 ? $final_max : -1 ;

}
