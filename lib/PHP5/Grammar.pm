use v6;
grammar PHP5::Grammar
	{
	token PHP-START { '<?php' }
	token PHP-END { '?>' }

	token ARRAY { 'array' }

	token CLASS { 'class' }
	token FUNCTION { 'function' }

	token ECHO { 'echo' } # Only because the lack of parens after it.
	token NEW { 'new' } # Same reason as 'echo'.

	token CLASS-NAME { ( <[ a .. z A .. Z 0 .. 9 ]>+ )+ %% '::' }
	token FUNCTION-NAME { <[ a .. z A .. Z _ 0 .. 9 ]>+ }

	token DIGITS { <[ 0 .. 9 ]>+ }
	token SCALAR { '$' <[ a .. z ]>+ }

	token DQ-STRING { '"' <-[ " ]>* '"' } # Will need work later.
	token SQ-STRING { '\'' <-[ ' ]>* '\'' } # Will need work later.

	token COMMENT { '/*' .*? '*/' }

	rule TOP
		{
		<PHP-START>
		<CLASS> <CLASS-NAME> '{'
			<FUNCTION> <FUNCTION-NAME> '(' ')' '{'
				<ECHO> <DQ-STRING> ';'
			'}'
		'}'
		<PHP-END>

|
# addglob.php
		<PHP-START>
		<SCALAR> '=' <NEW> <CLASS-NAME> ';'
		<SCALAR> '->' <FUNCTION-NAME> '(' <SQ-STRING> ',' <CLASS-NAME> ')' ';'

<COMMENT>
		<SCALAR> '=' <ARRAY> '('
			<SQ-STRING> '=>' <SQ-STRING> ','
			<SQ-STRING> '=>' <SQ-STRING> ','
		')' ';'
		<SCALAR> '=' <SCALAR> '->' <FUNCTION-NAME> '(' <DQ-STRING> ',' <DIGITS> ',' <SCALAR> ')' ';'
		<FUNCTION-NAME> '(' <SCALAR> ')' ';'
		<SCALAR> '->' <FUNCTION-NAME> '(' ')' ';'

		}
	}
 
# vim: ft=perl6
