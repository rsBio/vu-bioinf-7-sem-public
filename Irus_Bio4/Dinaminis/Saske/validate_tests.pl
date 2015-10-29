#!/usr/bin/perl -0777

use warnings;
use strict;

while (<>){

my $err = 1;

@_ = split /\n/;
chomp @_;

my @first_line = split / /, $_[0];
    3 != @first_line and do { print "F${err}\n" ; next }; ++ $err;
    3 != grep { /\A\d+\z/ } @first_line and do { print "F${err}\n" ; next }; ++ $err;

my ($lines, $rows, $st_pos) = @first_line;
    $lines < 2 || $rows < 1 and do { print "F${err}\n" ; next }; ++ $err;
    $st_pos > $rows and do { print "F${err}\n" ; next }; ++ $err;

my @second_line = split / /, $_[1];
    $rows != @second_line and do { print "F${err}\n" ; next }; ++ $err;
    $rows -1 != grep { /\A0\z/ } @second_line 
        and do { print "F${err}\n" ; next }; ++ $err;
    1 != grep { /\A2\z/ } @second_line 
        and do { print "F${err}\n" ; next }; ++ $err;
    $second_line[ $st_pos -1 ] ne '2' and do { print "F${err}\n" ; next }; ++ $err;

    $lines -1 != grep { $rows == split / / } @_[2 .. @_ -1] 
        and do { print "F${err}\n" ; next }; ++ $err;

    $lines -1 != grep { $rows == grep { /\A[01]\z/ } split / / } @_[2 .. @_ -1]
        and do { print "F${err}\n" ; next }; ++ $err;

#% print length, " ";
print $ARGV, " - ", "OK", "\n";

}
