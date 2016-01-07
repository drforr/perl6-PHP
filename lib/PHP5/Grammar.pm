use v6;
grammar PHP5::Grammar
	{
	token PHP-START { '<?php' }
	token PHP-END { '?>' }

	token IF { 'if' }
	token ELSE { 'else' }

	token WHILE { 'while' }
	token FOR { 'for' }
	token FOREACH { 'foreach' }

	token ARRAY { 'array' }

	token CLASS { 'class' }
	token FUNCTION { 'function' }

	# Declarations
	token GLOBAL { 'global' }

	token STATIC { 'static' }

	token PUBLIC { 'public' }
	token PRIVATE { 'private' }

	token ECHO { 'echo' } # Only because the lack of parens after it.
	token NEW { 'new' } # Same reason as 'echo'.
	token PRINT { 'print' } # Same reason as 'echo'.
	token RETURN { 'return' } # Same reason as 'echo'

	token CLASS-NAME { ( <[ a .. z A .. Z 0 .. 9 ]>+ )+ %% '::' }
	token FUNCTION-NAME { <[ a .. z A .. Z _ 0 .. 9 ]>+ }
	token CONSTANT-NAME { <[ a .. z ]>+ '::' <[ A .. Z ]>+ }
	token MACRO-NAME { '__' <[ A .. Z ]>+ '__' }

	token DIGITS { <[ 0 .. 9 ]>+ }
	token FLOATING-POINT { <[ 0 .. 9 ]>+ '.' <[ 0 .. 9 ]>+ }
	token SCALAR { '$' <[ a .. z A .. Z ]> <[ a .. z A .. Z 0 .. 9 ]>* }

	token DQ-STRING { '"' <-[ " ]>* '"' } # Will need work later.
	token SQ-STRING { '\'' <-[ ' ]>* '\'' } # Will need work later.

	token COMMENT
		{ '/*' .*? '*/'
		| '//' .*? \n
		}

	rule argument
		{ <SQ-STRING>
		| <CLASS-NAME>
		| <DQ-STRING>
		| <DIGITS>
		| <SCALAR>
		}

	rule parameter
		{ <SCALAR> '=' <CONSTANT-NAME>
		| <SCALAR>
		}

	rule function-call
		{ <FUNCTION-NAME> <arguments>
		}

	rule arguments
		{ '(' <argument>* %% ',' ')'
		}

	rule parameters
		{ '(' <parameter>* %% ',' ')'
		}

	rule method-call
		{ <SCALAR> '->' <FUNCTION-NAME> <arguments>
		}

	rule constructor-call
		{ <NEW> <CLASS-NAME>
		}

	rule global-expression
		{ <GLOBAL> <SCALAR>
		}

	rule parameter-list
		{ '(' <parameter>* %% ',' ')'
		}

	rule pair
		{ <SQ-STRING> '=>' <SQ-STRING>
		}

	rule array-call
		{ <ARRAY> '(' <pair>+ %% ',' ',' ')'
		| <ARRAY> '(' ')'
		}

	rule math-expression
		{ <SCALAR> '+' <DIGITS>
		| <SCALAR> '-' <DIGITS>
		| <SCALAR> '*' <DIGITS>
		| <SCALAR> '/' <DIGITS>
		}

	rule assignment-expression
		{ <SCALAR> '=' <constructor-call>
		| <SCALAR> '=' <array-call>
		| <SCALAR> '=' <method-call>
		| <SCALAR> '=' <function-call>
		| <SCALAR> '=' <math-expression>
		| <SCALAR> '=' <DQ-STRING>
		| <SCALAR> '=' <SCALAR>
		| <SCALAR> '=' <FLOATING-POINT>
		| <SCALAR> '=' <DIGITS>
		}

	rule comparison-expression
		{ <SCALAR> '<' <SCALAR>
		| <SCALAR> '<=' <SCALAR>
		| <SCALAR> '<=' <DIGITS>
		| <SCALAR> '<' <DIGITS>
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
	{ <ECHO> <DQ-STRING>
	| <ECHO> <MACRO-NAME> '.' <DQ-STRING>
	}
rule return-expression
	{ <RETURN> <function-call>
	| <RETURN> <math-expression>
	}
rule print-expression
	{ <PRINT> <DQ-STRING>
	}

	rule statement
		{ <assignment-expression>
| <echo-expression>
| <return-expression>
| <global-expression>
	| <print-expression> ';'
		| <postincrement-expression>
		| <method-call>
		| <function-call>
		| <array-call>
		}

	rule line
		{ <statement>+ %% ';' ';'
		| <COMMENT>
		| <for-expression> <statement> ';'
	#| <print-expression> ';'
		| <class-declaration>
		| <function-declaration>
		| <while-declaration>
		}

	rule for-expression
		{
		<FOR>	'('
			<assignment-expression> ';'
			<comparison-expression> ';'
			( <postincrement-expression>
			| <postdecrement-expression> )?
			')'
		}

	rule if-expression
		{
		<IF> '(' ( <function-call>
			 | <comparison-expression> ) ')'
		}

	rule while-expression
		{
		<WHILE> '(' ( <comparison-expression>
			    | <postdecrement-expression>
			    | <DIGITS> ) ')'
		}

	rule while-declaration
		{
		<while-expression>
			'{'
			<line>+
			'}'
		}

	rule if-declaration
		{
		<if-expression>
			'{'
			<line>+
			'}'
		}

	rule else-declaration
		{
		<ELSE>
			'{'
			<line>+
			'}'
		}

	rule function-declaration
		{
		<STATIC>? <PUBLIC>? <FUNCTION> <FUNCTION-NAME> <parameter-list>
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
  '$recen=-.45;'
<line>+
  '$s=2*$r/$w1;'
<line>+
  <FOR> '(' <assignment-expression> ';' <comparison-expression> '; $y=$y+1) {
    $imc=$s*($y-$h2)+$imcen;'
    <FOR> '($x=0 ;' <comparison-expression> ';' <assignment-expression> ') {
      $rec=$s*($x-$w2)+$recen;'
<line>+
      '$re2=$re*$re;
      $im2=$im*$im;'
      <WHILE> '( ((($re2+$im2)<1000000) && $color>0)) {
        $im=$re*$im*2+$imc;
        $re=$re2-$im2+$rec;
        $re2=$re*$re;
        $im2=$im*$im;
        $color=$color-1;
      }'
<if-declaration>
<else-declaration>
    '}'
    <line>+
  '}
}'

<line>+

<FUNCTION> 'mandel2() {'
  <line>+
  <FOR> '(' <assignment-expression> '; printf("\n"), $C = $y*0.1 - 1.5,' <postdecrement-expression> ';' '){'
    <FOR> '($x=0; $c = $x*0.04 - 2, $z=0, $Z=0,' <postincrement-expression> '< 75;){'
      <FOR> '($r=$c, $i=$C, $k=0; $t = $z*$z - $Z*$Z + $r, $Z = 2*$z*$Z + $i, $z=$t, $k<5000;' <postincrement-expression> ')'
        <IF> '($z*$z + $Z*$Z > 500000) break;'
      <ECHO> '$b[$k%16];
    }
  }
}'

<line>

<FUNCTION> 'Ack($m, $n){'
<if-expression> <statement> ';'
<if-expression> <RETURN> 'Ack(' <math-expression> ', 1);'
  <RETURN> 'Ack(' <math-expression> ', Ack($m, (' <math-expression> ')));
}'

<line>+

<FUNCTION> 'ary($n) {'
<for-expression> '{'
    '$X[$i] = $i;
  }'
<for-expression> '{
    $Y[$i] = $X[$i];
  }'
  <line>+
'}'

<line>+

<FUNCTION> 'ary2($n) {'
  <FOR> '($i=0; $i<$n;) {
    $X[$i] = $i; ++$i;
    $X[$i] = $i; ++$i;
    $X[$i] = $i; ++$i;
    $X[$i] = $i; ++$i;
    $X[$i] = $i; ++$i;

    $X[$i] = $i; ++$i;
    $X[$i] = $i; ++$i;
    $X[$i] = $i; ++$i;
    $X[$i] = $i; ++$i;
    $X[$i] = $i; ++$i;
  }'
  <FOR> '($i=' <math-expression> ';' <comparison-expression> ';) {
    $Y[$i] = $X[$i]; --$i;
    $Y[$i] = $X[$i]; --$i;
    $Y[$i] = $X[$i]; --$i;
    $Y[$i] = $X[$i]; --$i;
    $Y[$i] = $X[$i]; --$i;

    $Y[$i] = $X[$i]; --$i;
    $Y[$i] = $X[$i]; --$i;
    $Y[$i] = $X[$i]; --$i;
    $Y[$i] = $X[$i]; --$i;
    $Y[$i] = $X[$i]; --$i;
  }'
  <line>+
'}'

<line>+

<FUNCTION> 'ary3($n) {'
<for-expression> '{'
    '$X[$i] =' <math-expression> ';'
    '$Y[$i] = 0;
  }'
<for-expression> '{'
    <FOR> '($i=$n-1;' <comparison-expression> ';' <postdecrement-expression> ')' '{
      $Y[$i] += $X[$i];
    }
  }'
  <line>+
'}'

<line>+

<FUNCTION> 'fibo_r($n){'
    <RETURN> '((' <comparison-expression> ') ? 1 : fibo_r($n - 2) + fibo_r($n - 1));
}'

<line>+

<FUNCTION> 'hash1($n) {'
<for-expression> '{'
    '$X[dechex($i)] = $i;
  }'
<line>+
<for-expression> '{'
    <IF> '($X[dechex($i)]) {' <postincrement-expression> ';' '}'
  '}'
  <line>+
'}'

<line>+

<FUNCTION> 'hash2($n) {'
<for-expression> '{'
    '$hash1["foo_$i"] = $i;
    $hash2["foo_$i"] = 0;
  }'
<for-expression> '{'
    <FOREACH> '($hash1 as $key => $value) $hash2[$key] += $value;
  }'
<line>+
  '$last  = "foo_".(' <math-expression> ');'
<line>+
'}'

<line>+

<FUNCTION> 'gen_random ($n) {'
<line>+
    <RETURN> '( ($n * ($LAST = ($LAST * IA + IC) % IM)) / IM );
}'

<FUNCTION> 'heapsort_r($n, &$ra) {
    $l = ($n >> 1) + 1;'
    <line>+

<while-expression> '{'
  <if-expression> '{'
	    '$rra = $ra[--$l];
	}' <ELSE> '{
	    $rra = $ra[$ir];
	    $ra[$ir] = $ra[1];'
	    <IF> '(--$ir == 1) {
		$ra[1] = $rra;'
		<RETURN> ';'
	    '}'
	'}'
	<line>+
	'$j = $l << 1;'
<while-expression> '{'
	    <IF> '((' <comparison-expression> ') && ($ra[$j] < $ra[$j+1])) {'
		<line>+
	    '}'
	    <IF> '($rra < $ra[$j]) {
		$ra[$i] = $ra[$j];
		$j += ($i = $j);
	    }' <ELSE> '{'
<line>+
	    '}
	}
	$ra[$i] = $rra;
    }
}'

<FUNCTION> 'heapsort($N) {'
<line>+
<for-expression> '{'
    '$ary[$i] = gen_random(1);
  }'
<line>+
  'printf("%.10f\n", $ary[$N]);
}'

<line>+

<FUNCTION> <FUNCTION-NAME> '($rows, $cols) {'
<line>+
<for-expression> '{'
  <for-expression> '{'
	    '$mx[$i][$j] =' <postincrement-expression> ';'
	'}'
    '}'
    <RETURN> '($mx);
}'

<FUNCTION> 'mmult ($rows, $cols, $m1, $m2) {'
<line>+
<for-expression> '{'
  <for-expression> '{'
    <line>+
	    <for-expression> '{'
		'$x += $m1[$i][$k] * $m2[$k][$j];
	    }
	    $m3[$i][$j] = $x;
	}
    }'
<line>+
'}'

<line>+

<FUNCTION> 'nestedloop($n) {'
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

<FUNCTION> <FUNCTION-NAME> '($n) {'
<line>+
  <WHILE> '($n-- > 0) {'
<line>+
    <for-expression> '{'
      <IF> '($flags[$i] > 0) {'
        <FOR> '($k=$i+$i;' <comparison-expression> '; $k+=$i) {
          $flags[$k] = 0;
        }'
<line>+
      '}'
    '}'
  '}'
  <line>+
'}'

<line>+

<FUNCTION> 'strcat($n) {'
<line>+
  <WHILE> '($n-- > 0) {
    $str .= "hello\n";
  }'
  <line>+
'}'

<line>+

<FUNCTION> 'getmicrotime()
{'
<line>+
  <RETURN> '($t[\'sec\'] + $t[\'usec\'] / 1000000);
}'

<function-declaration>

<FUNCTION> 'end_test($start, $name)
{'
<line>+
  '$total += $end-$start;
  $num = number_format($end-$start,3);
  $pad = str_repeat(" ", 24-strlen($name)-strlen($num));'

  <ECHO> '$name.$pad.$num."\n";'
<line>+
'}'

<FUNCTION> 'total()
{'
<line>+
  <ECHO> '$pad.' <DQ-STRING> ';'
<line>+
  '$pad = str_repeat(" ", 24-strlen("Total")-strlen($num));'
  <ECHO> '"Total".$pad.$num."\n";
}

$t0 =' <assignment-expression> ';'
<line>+
<PHP-END>
		}
	}
 
# vim: ft=perl6
