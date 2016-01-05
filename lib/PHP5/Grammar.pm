use v6;
grammar PHP5::Grammar
	{
	rule TOP
		{
		'<?php
class bug39542 {
	function bug39542() {
		echo "ok\n";
	}
}
?>'
		}
	}
 
# vim: ft=perl6
