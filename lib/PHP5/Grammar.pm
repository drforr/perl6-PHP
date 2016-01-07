use v6;
grammar PHP5::Grammar
	{
	token PHP-START
		{ '<?php'
		}
	token PHP-END
		{ '?>'
		}

	token IF
		{ 'if'
		}
	token ELSE
		{ 'else'
		}

	token WHILE
		{ 'while'
		}
	token FOR
		{ 'for'
		}
	token FOREACH
		{ 'foreach' }

	token ARRAY
		{ 'array'
		}

	token CLASS
		{ 'class'
		}
	token FUNCTION
		{ 'function'
		}

	# Declarations
	token GLOBAL
		{ 'global'
		}

	token STATIC
		{ 'static'
		}

	token PUBLIC
		{ 'public'
		}
	token PRIVATE
		{ 'private'
		}

	# These keywords don't need parens.
	token ECHO
		{ 'echo'
		}
	token NEW
		{ 'new'
		}
	token PRINT
		{ 'print'
		}
	token RETURN
		{ 'return'
		}

	token CLASS-NAME
		{ ( <[ a .. z A .. Z 0 .. 9 ]>+ )+ %% '::'
		}
	token FUNCTION-NAME
		{ <[ a .. z A .. Z _ 0 .. 9 ]>+
		}
	token CONSTANT-NAME
		{ <[ a .. z ]>+ '::' <[ A .. Z ]>+
		}
	token MACRO-NAME
		{ '__' <[ A .. Z ]>+ '__'
		}

	token DIGITS
		{ <[ 0 .. 9 ]>+
		}
	token FLOATING-POINT
		{ <[ 0 .. 9 ]>+ '.' <[ 0 .. 9 ]>+
		}
	token SCALAR
		{ '$' <[ a .. z A .. Z ]> <[ a .. z A .. Z 0 .. 9 ]>*
		}

	token DQ-STRING
		{ '"' <-[ " ]>* '"'
		} # Will need work later.
	token SQ-STRING
		{ '\'' <-[ ' ]>* '\''
		} # Will need work later.

	token COMMENT
		{ '/*' .*? '*/'
		| '//' .*? \n
		}

	rule argument
		{ <SQ-STRING>
		| <CLASS-NAME>
		| <DQ-STRING>
		| <array-element>
		| <SCALAR>
		| <DIGITS>
		| <math-expression>
		}

	rule parameter
		{ <SCALAR> '=' <CONSTANT-NAME>
		| <SCALAR>
		}

	rule argument-list
		{ '(' <argument>* %% ',' ')'
		}

	rule parameter-list
		{ '(' <parameter>* %% ',' ')'
		}

	rule pair-list
		{ '(' <pair>+ %% ',' ',' ')'
		}

	rule function-call
		{ <FUNCTION-NAME> <argument-list>
		}

	rule method-call
		{ <SCALAR> '->' <function-call>
		}

	rule constructor-call
		{ <NEW> <CLASS-NAME>
		}

	rule global-expression
		{ <GLOBAL> <SCALAR>
		}

	rule pair
		{ <SQ-STRING> '=>' <SQ-STRING>
		}

	rule array-call
		{ <ARRAY> <pair-list>
		| <ARRAY> '(' ')'
		}

	rule math-expression
		{ <SCALAR> ( '+'
                           | '-'
			   | '-'
			   | '*'
			   | '/'
			   | '<<'
			   ) <DIGITS>
		}

	rule array-element
		{
		<SCALAR>
		'['
			( <SCALAR>
			| <DIGITS>
			)
		']'
		}

	rule hash-element
		{ <SCALAR> '[' <DQ-STRING> ']'
		}

	rule assignment-expression
		{ <array-element> '=' <math-expression>
		| <array-element> '=' <function-call>
		| <array-element> '=' <array-element>
		| <array-element> '=' <SCALAR>
		| <array-element> '=' <DIGITS>
		| <hash-element> '=' <SCALAR>
		| <hash-element> '=' <DIGITS>
		| <SCALAR> '=' <assignment-expression>
		| <SCALAR> '=' <constructor-call>
		| <SCALAR> '=' <array-call>
		| <SCALAR> '=' <method-call>
		| <SCALAR> '=' <function-call>
		| <SCALAR> '=' <math-expression>
		| <SCALAR> '=' <DQ-STRING>
		| <SCALAR> '=' <SCALAR>
		| <SCALAR> '=' <FLOATING-POINT>
		| <SCALAR> '=' <DIGITS>
		}

	rule plus-assignment-expression
		{ <array-element> '+=' <array-element>
		}

	rule dot-assignment-expression
		{ <array-element> '.=' <DQ-STRING>
		}

	rule comparison-expression
		{ <SCALAR> '<'  ( <array-element>
				| <SCALAR>
				| <DIGITS>
				)
		| <SCALAR> '<=' ( <SCALAR>
				| <DIGITS>
				)
		| <SCALAR> '>' <DIGITS>
		| <SCALAR> '>=' <DIGITS>
		| <SCALAR> '==' <DIGITS>
		}

	rule postincrement-expression
		{ <SCALAR> '++'
		}
	rule postdecrement-expression
		{ <SCALAR> '--'
		}

rule echo-expression
	{ <ECHO> ( <DQ-STRING>
		 | <MACRO-NAME> '.' <DQ-STRING>
		 )
	}
rule return-expression
	{ <RETURN> ( <function-call>
		   | <math-expression>
		   )
	}
rule print-expression
	{ <PRINT> <DQ-STRING>
	}

	rule statement
		{ <assignment-expression>
		| <plus-assignment-expression>
		| <dot-assignment-expression>
		| <echo-expression>
		| <return-expression>
		| <global-expression>
		| <print-expression>
		| <postincrement-expression>
		| <postdecrement-expression>
		| <method-call>
		| <function-call>
		| <array-call>
| <if-expression> ( <statement> | '{' <line>+ '}' )
		}

	rule line
		{ <statement>+ %% ';' ';'
		| <COMMENT>
		| <class-declaration>
		| <for-declaration>
		| <function-declaration>
		| <while-declaration>
		}

	rule for-expression
		{
		<FOR>	'('
			<assignment-expression> ';'
			<comparison-expression> ';'
			( <postincrement-expression>
			| <postdecrement-expression>
			| <assignment-expression>
			)?
			')'
		}

	rule if-expression
		{
		<IF>	'('
			( <function-call>
			| <comparison-expression>
			)
			')'
		}

	rule while-expression
		{
		<WHILE> '('
			( <comparison-expression>
			| <postdecrement-expression>
			| <DIGITS>
			)
			')'
		}

	rule for-declaration
		{
		<for-expression>
			( '{' <line>+ '}'
			| <statement> ';'
			)
		}

	rule while-declaration
		{ <while-expression> '{' <line>+ '}'
		}

	rule if-declaration
		{
		<if-expression>
			( <statement> ';'
			| '{' <line>+ '}'
			)
		}

	rule else-declaration
		{ <ELSE> '{' <line>+ '}'
		}

	rule function-declaration
		{
		<STATIC>? <PUBLIC>? <FUNCTION> <FUNCTION-NAME>
			'('
			<parameter>* %% ','
			')'

			'{'
			<line>*
			'}'
		}

	rule class-declaration
		{
		<CLASS> <CLASS-NAME>
			'{'
			<function-declaration>*
			'}'
		}

#Expr    ← Sum
#Sum     ← Product (('+' / '-') Product)*
#Product ← Value (('*' / '/') Value)*
#Value   ← [0-9]+ / '(' Expr ')'

rule _line_
	{ <SCALAR> '=' <_math-expr_> ';'
	}

rule _math-expr_
	{ <_math-sum_>
	}
rule _math-sum_
	{ <_math-product_> ( ( '+' | '-' ) <_math-product_> )*
	}
rule _math-product_
	{ <_math-value_> ( ( '*' | '/' ) <_math-value_> )*
	}
rule _math-value_
	{ <SCALAR>
	| <DIGITS>
	| '(' <_math-expr_> ')'
	}

	rule TOP
		{
# addglob.php
# addpattern.php
# a.php
		<PHP-START>
		<line>+

|

# corpus-5/bench.php
<PHP-START>
<if-declaration>

<line>+

<FUNCTION> 'mandel() {'
<line>+
  '$recen=-.45' ';'
<line>+
  <_line_>+
<line>+
<for-expression> '{'
  <_line_>+
<for-expression> '{'
  <_line_>+
<line>+
  <_line_>+
      <WHILE> '( ((' <_math-expr_> '<1000000) && $color>0))' '{'
  <_line_>+
      '}'
<if-declaration>
<else-declaration>
    '}'
    <line>+
  '}
}'

<line>+

<FUNCTION> 'mandel2() {'
  <line>+
  <FOR> '(' <assignment-expression> ';' 'printf("\n"), $C = $y*0.1 - 1.5,' <postdecrement-expression> ';' ')' '{'
    <FOR> '($x=0' ';' '$c = $x*0.04 - 2, $z=0, $Z=0,' <postincrement-expression> '< 75' ';' ')' '{'
      <FOR> '($r=$c, $i=$C, $k=0' ';' '$t = $z*$z - $Z*$Z + $r, $Z = 2*$z*$Z + $i, $z=$t, $k<5000' ';' <postincrement-expression> ')'
        <IF> '(' <_math-expr_> '> 500000) break' ';'
      <ECHO> '$b[$k%16]' ';'
    '}'
  '}'
'}'

<line>

<FUNCTION> 'Ack($m, $n)' '{'
<line>+
<if-expression> <RETURN> 'Ack(' <math-expression> ',' <DIGITS> ')' ';'
  <RETURN> 'Ack(' <math-expression> ', Ack($m, (' <math-expression> ')))' ';'
'}'

<line>+

<FUNCTION> 'ary2($n)' '{'
<for-expression> '{'
<line> '++$i' ';'
<line> '++$i' ';'
<line> '++$i' ';'
<line> '++$i' ';'
<line> '++$i' ';'

<line> '++$i' ';'
<line> '++$i' ';'
<line> '++$i' ';'
<line> '++$i' ';'
<line> '++$i' ';'
  '}'
<for-expression> '{'

<line> '--$i' ';'
<line> '--$i' ';'
<line> '--$i' ';'
<line> '--$i' ';'
<line> '--$i' ';'

<line> '--$i' ';'
<line> '--$i' ';'
<line> '--$i' ';'
<line> '--$i' ';'
<line> '--$i' ';'
  '}'
  <line>+
'}'

<line>+

<FUNCTION> 'fibo_r($n)' '{'
    <RETURN> '(' '(' <comparison-expression> ') ? 1 : fibo_r(' <_math-expr_> ') + fibo_r($n - 1))' ';'
'}'

<line>+

<FUNCTION> 'hash1($n)' '{'
<for-expression> '{'
    '$X[dechex($i)] = $i' ';'
  '}'
<line>+
<for-expression> '{'
    <IF> '($X[dechex($i)])' '{' <line>+ '}'
  '}'
  <line>+
'}'

<line>+

<FUNCTION> 'hash2($n)' '{'
<line>+
<for-expression> '{'
    <FOREACH> '(' <SCALAR> 'as' <SCALAR> '=>' <SCALAR> ')' '$hash2[$key] += $value' ';'
  '}'
<line>+
  '$last  = "foo_".' '(' <math-expression> ')' ';'
<line>+
'}'

<line>+

<FUNCTION> 'gen_random ($n)' '{'
<line>+
    <RETURN> '( ($n * ($LAST = ($LAST * IA + IC) % IM)) / IM )' ';'
'}'

<FUNCTION> 'heapsort_r($n, &$ra)' '{'
    '$l = ($n >> 1) + 1' ';'
    <line>+

<while-expression> '{'
  <if-expression> '{'
	    '$rra = $ra[--$l]' ';'
	'}' <ELSE> '{'
	    '$rra = $ra[$ir]' ';'
<line>+
	    <IF> '(--$ir == 1)' '{'
<line>+
		<RETURN> ';'
	    '}'
	'}'
	<line>+
<while-expression> '{'
	    <IF> '(' '(' <comparison-expression> ') && ($ra[$j] < $ra[$j+1])' ')' '{'
		<line>+
	    '}'
<if-expression> '{'
<line>+
		'$j += ($i = $j)' ';'
	    '}'
<else-declaration>
	'}'
<line>+
    '}'
'}'

<line>+

<FUNCTION> <FUNCTION-NAME> '($rows, $cols)' '{'
<line>+
<for-expression> '{'
  <for-expression> '{'
	    '$mx[$i][$j] =' <postincrement-expression> ';'
	'}'
    '}'
<line>+
'}'

<FUNCTION> 'mmult ($rows, $cols, $m1, $m2)' '{'
<line>+
<for-expression> '{'
  <for-expression> '{'
    <line>+
	    <for-expression> '{'
		'$x += $m1[$i][$k] * $m2[$k][$j]' ';'
	    '}'
	    '$m3[$i][$j] = $x' ';'
	'}'
    '}'
<line>+
'}'

<line>+

<FUNCTION> 'nestedloop($n)' '{'
<line>+
<for-expression>
  <for-expression>
    <for-expression>
      <for-expression>
        <for-expression>
          <for-expression> <statement> ';'
  <line>+
'}'

<line>+

<FUNCTION> <FUNCTION-NAME> '($n)' '{'
<line>+
  <WHILE> '(' '$n-- > 0' ')' '{'
<line>+
    <for-expression> '{'
      <IF> '(' <array-element> '>' '0' ')' '{'
        <FOR> '(' '$k=' <_math-expr_> ';' <comparison-expression> ';' '$k+=$i' ')' '{'
<line>+
        '}'
<line>+
      '}'
    '}'
  '}'
  <line>+
'}'

<line>+

<FUNCTION> 'strcat($n)' '{'
<line>+
  <WHILE> '(' '$n-- > 0' ')' '{'
    '$str .= "hello\n"' ';'
  '}'
  <line>+
'}'

<line>+

<FUNCTION> 'getmicrotime()' '{'
<line>+
  <RETURN> '($t[\'sec\'] + $t[\'usec\'] /' <DIGITS> ')' ';'
'}'

<line>+

<FUNCTION> 'end_test($start, $name)' '{'
<line>+
  '$total +=' <_math-expr_> ';'
  '$num = number_format(' <_math-expr_> ',' <DIGITS> ')' ';'
  '$pad = str_repeat(" ", 24-strlen($name)-strlen($num))' ';'

  <ECHO> <SCALAR> '.' <SCALAR> '.' <SCALAR> '.' <DQ-STRING> ';'
<line>+
'}'

<FUNCTION> 'total()' '{'
<line>+
  <ECHO> <SCALAR> '.' <DQ-STRING> ';'
<line>+
  '$pad = str_repeat(" ", 24-strlen("Total")-strlen($num))' ';'
  <ECHO> <DQ-STRING> '.' <SCALAR> '.' <SCALAR> '.' <DQ-STRING> ';'
'}'

<line>+
<PHP-END>
		}
	}
 
# vim: ft=perl6
