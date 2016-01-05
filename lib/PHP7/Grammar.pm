use v6;
grammar PHP7::Grammar
	{
	rule TOP
		{
		'<?php
class bug39542 {
	function __construct() {
		echo "ok\n";
	}
}
?>'
		}
	}

# vim: ft=perl6
