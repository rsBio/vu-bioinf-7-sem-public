#!/usr/bin/perl

use warnings;
use strict;
use Data::Dumper;

while(<>){
	chomp;
    my $len = length;
	
	my @preff;
	
	push @preff, $` while m/(?<=\w)/g;
	
#%	{local $" = $/; print "@preff"}
	
	my %H;
	
	for my $i (@preff){
		
		my @suff;
		push @suff, $' while $i =~ m/(?=\w)/g;
#%		{local $" = $/; print "@suff"}
		
		SUFF:
		for my $j (@suff){
			
#			for (keys %H){
#				if ($j =~ m/^$_/){
#					$H{ $j } = $H{ $_ };
#					delete $H{ $_ };
#					next SUFF;
#				}
#			}
			
			
			my $tmp;
			while ($j =~ m/./g){
				my $lett = $&;
				$tmp or $tmp = \%H;
#%				print "[$lett,", keys %{ $tmp },"]\n";
				exists ${ $tmp }{ $lett } ?
					( $tmp = ${ $tmp }{ $lett } )
				:
					( ${ $tmp }{ $lett } = {} );
#%				print map "keys tmp: $_\n", join '', map "[$_]", keys %{ $tmp };
			}
			
#			(substr $preff[ $j ], 0, 1) 
			
		}
		
	}

	print Dumper \%H;

	my @substrs;
	while( /./g ){
		push @substrs, $`, $'
	}
	@substrs = sort grep $_, @substrs;

    my %G = %H;

	for (@substrs, 'ae', 'mi', 'mis', 'mi', 'im'){
        my %Hcopy = %H;
        my $value = eval '$Hcopy' . join '', map "{$_}", split //;
		print map "$_\n", join '', 
			"$_ -> ",
			defined $value ? "FOUND" : "NOT found"
	}
	
#%    print map "$_\n", join '', map "[$_]", sort keys %H;
    print "\n";

    my $ref = \%G;

    sub glue {
        my $ref = shift;
        my @keys = keys %{ $ref };
        while ( @keys ){
            $_ = shift @keys;
#%            print "key: [$_]\n";

    		1 == keys ${ $ref }{ $_ } and do {
	    		my ($single_key) = keys ${ $ref }{ $_ } ;
	    		my ($single_value) = values ${ $ref }{ $_ } ;
#%	    		print "!!!\n";
	    		${ $ref }{ $_ . $single_key } = ${ $ref }{ $_ }{ $single_key };
	    		delete ${ $ref }{ $_ };
                push @keys, $_ . $single_key;
	    	}
        }
        my @new_keys = keys %{ $ref };
#%        print "new keys: [@new_keys]\n";
        for (keys %{ $ref }){
            glue( ${ $ref }{ $_ } );
        }
    }

    glue( $ref );

	print Dumper \%G;

    print "-" x 30 . "\n";

    my $D = Dumper \%G;

    $D =~ s/^\$VAR1/TREE/;
    $D =~ s/{},?/|leaf/g;
    $D =~ s/'(\w*)' => /"(" . ($len + 1 - length $1) . ":$1)"/ge;

    print "$D";

    print "-" x 30 . "\n";

    my $match;
    my $space_len1;
    my $space_len2;

    while(
        $D =~ s/{[^{}]*}[,;]?/
            $match = "$&",
            $match =~ y!{},;!!d,
#%            (print "<$match>\n"),
            $match =~ m!^\s*\(!m,
            $space_len1 = -3 + length $&,
            $space_len2 = -2 + length $&,
            $match =~ s!^\s{$space_len1,$space_len2}\K\s!|!gm,
            $match
        /gxe
    ){
        ;
    }

    $D =~ s/^((?:\s*\|)+) (?=\() (.*? \n) ^\1 (?=\() /$1$2$1\n$1/gmx;
    $D =~ s/(\s*\|)\s*$//gm;
    
    print "$D";

	print "\n\n";
}
