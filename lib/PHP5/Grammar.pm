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

	rule argument-list
		{ <SQ-STRING> ',' <CLASS-NAME>
		| <DQ-STRING> ',' <DIGITS> ',' <SCALAR>
		| <DQ-STRING> ',' <DQ-STRING> ',' <SCALAR>
		| <SCALAR>
		}

	rule function-call
		{ <FUNCTION-NAME> '(' <argument-list>? ')'
		}

	rule method-call
		{ <SCALAR> '->' <FUNCTION-NAME> '(' <argument-list>? ')'
		}

	rule constructor-call
		{ <NEW> <CLASS-NAME>
		}

	rule pair
		{ <SQ-STRING> '=>' <SQ-STRING>
		}

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
		<SCALAR> '=' <constructor-call> ';'
		<method-call> ';'

<COMMENT>
		<SCALAR> '=' <ARRAY> '('
			<pair> ','
			<pair> ','
		')' ';'
		<SCALAR> '=' <method-call> ';'
		<function-call> ';'
		<method-call> ';'

|
# addpattern.php
		<PHP-START>
		<SCALAR> '=' <constructor-call> ';'
		<method-call> ';'

		<COMMENT>
		<SCALAR> '=' <ARRAY> '('
			<pair> ','
			<pair> ','
		')' ';'
		<method-call> ';'
		<function-call> ';'
		<method-call> ';'

		}
	}
 
# vim: ft=perl6
