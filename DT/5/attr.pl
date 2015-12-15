#!/usr/bin/perl

print '@RELATION accidents' . "\n\n" .
(join "\n", map { sprintf "\@ATTRIBUTE a%03s {0,1}", $_ } 1 .. 572) . "\n\n" .
'@DATA' . "\n"
