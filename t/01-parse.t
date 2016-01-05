use v6;
use PHP5::Grammar;
use PHP7::Grammar;
use Test;

plan 2;

#############################################################################

my $sample-PHP5 = q{<?php
class bug39542 {
	function bug39542() {
		echo "ok\n";
	}
}
?>};

my $sample-PHP7 = q{<?php
class bug39542 {
	function __construct() {
		echo "ok\n";
	}
}
?>};

#############################################################################

my $g5 = PHP5::Grammar.new;
my $g7 = PHP7::Grammar.new;

ok $g5.parse( $sample-PHP5 );
ok $g7.parse( $sample-PHP7 );

# vim: ft=perl6
