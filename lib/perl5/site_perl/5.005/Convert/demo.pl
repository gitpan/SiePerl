#!/usr/local/bin/perl -w

use strict;
use blib;
use Convert::SciEng;

my $c = Convert::SciEng->new('spice');
my $s = Convert::SciEng->new('si');

print "Scalar\n";
print $c->unfix('2.34u'), "\n\n";

print "Array\n";
print join "\n", $c->unfix(qw( 30.6k  10x  0.03456m  123n 45o)), "\n";

##Note, default format is 5.5g
print "Default format is %5.5g\n";
print join "\n", $c->fix(qw( 35e5 0.123e-4 200e3 )), "";
$c->format('%8.2f');
print "Change the format is %8.2g\n";
print join "\n", $c->fix(qw( 35e5 0.123e-4 200e3 )), "";

print "Check out the SI conversion\n";
print join "\n", $s->unfix(qw( 30.6K  10M  0.03456m  123n 45o)), "";

