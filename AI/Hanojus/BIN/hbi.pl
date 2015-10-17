#!/usr/bin/perl

use warnings;
use strict;

my $n;
my (@A, @B, @C);
my ($a, $b, $c);
my ($A, $B, $C);
my $acc;

sub print_pries{
    my ($a, $nuo, $ant) = @_;
    print "Keliamas diskas ${a} nuo ${nuo} ant ${ant}: ";
    print map "A = ($_)", join ',', @A;
    print " " x 8;
    print map "B = ($_)", join ',', @B;
    print "\n";
    print " " x 32;
    print "`--" . "-" x (2 * @A) . "> ";
    print map "C = ($_)", join ',', @C;
    print "\n";
}

while( $n = <> ){
    chomp $n;
    
    @A = reverse 1 .. $n;
    @B = ();
    @C = ();
    
    if ($n % 2) {
        print "Įvesta n = ${n} yra NELYGINIS.\n";
        print "Todėl keliama prieš laikrodžio rodyklę.\n";
        
       ($a, $b, $c) = (undef) x 3;
       ($A, $B, $C) = (0) x 3;
       $acc = 0;

        while ( $acc < 4 ){
            print "[$acc]\n";
            @A and not $A and do {
                $a = pop @A;
                if    (@C and @C[-1] > $a or not @C) {
                    push @C, $a; ($A, $B, $C) = (0, 0, 1); $acc = 0; 
                    &print_pries($a, "A", "C");
                }
                elsif (@B and @B[-1] > $a or not @B) {
                    push @B, $a; ($A, $B, $C) = (0, 1, 0); $acc = 0; 
                    &print_pries($a, "A", "B");
                }
                
            };
            $acc ++;
            
            
        }
        
        
    }
        
        
}
