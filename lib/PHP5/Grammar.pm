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

	token ECHO { 'echo' } # Only because the lack of parens after it.
	token NEW { 'new' } # Same reason as 'echo'.
	token PRINT { 'print' } # Same reason as 'echo'.
	token RETURN { 'return' } # Same reason as 'echo'

	token CLASS-NAME { ( <[ a .. z A .. Z 0 .. 9 ]>+ )+ %% '::' }
	token FUNCTION-NAME { <[ a .. z A .. Z _ 0 .. 9 ]>+ }
	token CONSTANT-NAME { <[ a .. z ]>+ '::' <[ A .. Z ]>+ }
	token MACRO-NAME { '__' <[ A .. Z ]>+ '__' }

	token DIGITS { <[ 0 .. 9 ]>+ }
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

	rule assignment-expression
		{ <SCALAR> '=' <constructor-call>
		| <SCALAR> '=' <array-call>
		| <SCALAR> '=' <method-call>
		| <SCALAR> '=' <function-call>
		| <SCALAR> '=' <DQ-STRING>
		| <SCALAR> '=' <SCALAR>
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


rule echo-expression
	{ <ECHO> <DQ-STRING>
	}
rule return-expression
	{ <RETURN> <function-call>
	}

	rule statement
		{ <assignment-expression>
| <echo-expression>
| <return-expression>
| <global-expression>
		| <postincrement-expression>
		| <method-call>
		| <function-call>
		| <array-call>
		}

	rule statements
		{ <statement>+ %% ';' ';'
		}

	rule line
		{ <statements>
		| <COMMENT>
		}

	rule lines
		{ <line>+
		}

	rule function-declaration
		{
		<FUNCTION> <FUNCTION-NAME> <parameter-list>
			'{'
			<lines>?
			'}'
		}

	rule TOP
		{
		<PHP-START>
		<CLASS> <CLASS-NAME> '{'
			<function-declaration>
		'}'
		<PHP-END>

|
# addglob.php
# addpattern.php
		<PHP-START>
		<lines>

|

# a.php
		<PHP-START>
		<CLASS> <CLASS-NAME> '{'
			<PUBLIC> <FUNCTION> <FUNCTION-NAME> <parameters> '{'
				<ECHO> <MACRO-NAME> '.' <DQ-STRING> ';'
			'}'

			<STATIC> <PUBLIC> <function-declaration>
		'}'

|

# corpus-5/bench.php
<PHP-START>
<IF> '(' <function-call> ')' '{'
	<lines>
'}'

<FUNCTION> <FUNCTION-NAME> '(' ')' '{'
	<lines>
  <FOR> '(' <assignment-expression> ';' <comparison-expression> ';' <postincrement-expression> ')'
	<lines>
  <FOR> '(' <assignment-expression> ';' <comparison-expression> ';' <postincrement-expression> ')'
<statement> ';'
'}'

<COMMENT>

<FUNCTION> 'simplecall() {'
  <FOR> '(' <assignment-expression> ';' <comparison-expression> ';' <postincrement-expression> ')'
	<statement> ';'
'}'

<COMMENT>

<FUNCTION> <FUNCTION-NAME> '($a) {
}'

<FUNCTION> 'simpleucall() {'
  <FOR> '(' <assignment-expression> ';' <comparison-expression> ';' <postincrement-expression> ')'
	<statement> ';'
'}'

<lines>

<FUNCTION> 'simpleudcall() {'
  <FOR> '(' <assignment-expression> ';' <comparison-expression> ';' <postincrement-expression> ')'
	<statement> ';'
'}'

<function-declaration>

<lines>

<FUNCTION> 'mandel() {'
<lines>
  '$recen=-.45;
  $imcen=0.0;
  $r=0.7;'
<lines>
  '$s=2*$r/$w1;'
<lines>
  <FOR> '(' <assignment-expression> ';' <comparison-expression> '; $y=$y+1) {
    $imc=$s*($y-$h2)+$imcen;'
    <FOR> '($x=0 ;' <comparison-expression> '; $x=$x+1) {
      $rec=$s*($x-$w2)+$recen;'
<lines>
      '$re2=$re*$re;
      $im2=$im*$im;'
      <WHILE> '( ((($re2+$im2)<1000000) && $color>0)) {
        $im=$re*$im*2+$imc;
        $re=$re2-$im2+$rec;
        $re2=$re*$re;
        $im2=$im*$im;
        $color=$color-1;
      }'
      <IF> '(' <comparison-expression> ') {'
        <PRINT> '"_";
      }' <ELSE> '{'
        <PRINT> <DQ-STRING> ';'
      '}'
    '}'
    <PRINT> <DQ-STRING> ';'
    <lines>
  '}
}'

<COMMENT>

<FUNCTION> 'mandel2() {'
  <lines>
  <FOR> '(' <assignment-expression> '; printf("\n"), $C = $y*0.1 - 1.5, $y--;){'
    <FOR> '($x=0; $c = $x*0.04 - 2, $z=0, $Z=0,' <postincrement-expression> '< 75;){'
      <FOR> '($r=$c, $i=$C, $k=0; $t = $z*$z - $Z*$Z + $r, $Z = 2*$z*$Z + $i, $z=$t, $k<5000;' <postincrement-expression> ')'
        <IF> '($z*$z + $Z*$Z > 500000) break;'
      <ECHO> '$b[$k%16];
    }
  }
}'

<COMMENT>

<FUNCTION> 'Ack($m, $n){'
  <IF> '(' <comparison-expression> ')' <RETURN> '$n+1;'
  <IF> '(' <comparison-expression> ')' <RETURN> 'Ack($m-1, 1);'
  <RETURN> 'Ack($m - 1, Ack($m, ($n - 1)));
}'

<FUNCTION> 'ackermann($n) {
  $r = Ack(3,$n);'
  <PRINT> <DQ-STRING> ';'
'}'

<COMMENT>

<FUNCTION> 'ary($n) {'
  <FOR> '($i=0; $i<$n;' <postincrement-expression> ') {
    $X[$i] = $i;
  }'
  <FOR> '($i=$n-1;' <comparison-expression> ';' '$i--) {
    $Y[$i] = $X[$i];
  }
  $last = $n-1;'
  <PRINT> <DQ-STRING> ';'
'}'

<COMMENT>

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
  <FOR> '($i=$n-1;' <comparison-expression> ';) {
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
  }
  $last = $n-1;'
  <PRINT> '"$Y[$last]\n";
}'

<COMMENT>

<FUNCTION> 'ary3($n) {'
  <FOR> '($i=0; $i<$n;' <postincrement-expression> ') {
    $X[$i] = $i + 1;
    $Y[$i] = 0;
  }'
  <FOR> '($k=0; $k<1000;' <postincrement-expression> ') {'
    <FOR> '($i=$n-1;' <comparison-expression> '; $i--) {
      $Y[$i] += $X[$i];
    }
  }
  $last = $n-1;'
  <PRINT> '"$Y[0] $Y[$last]\n";
}'

<COMMENT>

<FUNCTION> 'fibo_r($n){'
    <RETURN> '((' <comparison-expression> ') ? 1 : fibo_r($n - 2) + fibo_r($n - 1));
}'

<FUNCTION> 'fibo($n) {
  $r = fibo_r($n);'
  <PRINT> '"$r\n";
}'

<COMMENT>

<FUNCTION> 'hash1($n) {'
  <FOR> '($i = 1;' <comparison-expression> ';' <postincrement-expression> ') {
    $X[dechex($i)] = $i;
  }
  $c = 0;'
  <FOR> '(' <assignment-expression> ';' <comparison-expression> '; $i--) {'
    <IF> '($X[dechex($i)]) {' <postincrement-expression> ';' '}'
  '}'
  <PRINT> '"$c\n";
}'

<COMMENT>

<FUNCTION> 'hash2($n) {'
  <FOR> '(' <assignment-expression> ';' <comparison-expression> '; $i++) {
    $hash1["foo_$i"] = $i;
    $hash2["foo_$i"] = 0;
  }'
  <FOR> '(' <assignment-expression> ';' <comparison-expression> '; $i--) {'
    <FOREACH> '($hash1 as $key => $value) $hash2[$key] += $value;
  }'
<lines>
  '$last  = "foo_".($n-1);'
  <PRINT> '"$hash1[$first] $hash1[$last] $hash2[$first] $hash2[$last]\n";
}'

<COMMENT>

<FUNCTION> 'gen_random ($n) {'
<lines>
    <RETURN> '( ($n * ($LAST = ($LAST * IA + IC) % IM)) / IM );
}'

<FUNCTION> 'heapsort_r($n, &$ra) {
    $l = ($n >> 1) + 1;'
    <lines>

    <WHILE> '(1) {'
	<IF> '(' <comparison-expression> ') {
	    $rra = $ra[--$l];
	}' <ELSE> '{
	    $rra = $ra[$ir];
	    $ra[$ir] = $ra[1];'
	    <IF> '(--$ir == 1) {
		$ra[1] = $rra;'
		<RETURN> ';'
	    '}'
	'}'
	<lines>
	'$j = $l << 1;'
	<WHILE> '(' <comparison-expression> ') {'
	    <IF> '((' <comparison-expression> ') && ($ra[$j] < $ra[$j+1])) {'
		<lines>
	    '}'
	    <IF> '($rra < $ra[$j]) {
		$ra[$i] = $ra[$j];
		$j += ($i = $j);
	    }' <ELSE> '{
		$j = $ir + 1;
	    }
	}
	$ra[$i] = $rra;
    }
}'

<FUNCTION> 'heapsort($N) {'
<global-expression> ';'

<function-call> ';'
<function-call> ';'
<function-call> ';'

<lines>
  <FOR> '($i=1;' <comparison-expression> '; $i++) {
    $ary[$i] = gen_random(1);
  }'
<lines>
  'printf("%.10f\n", $ary[$N]);
}'

<COMMENT>

<FUNCTION> <FUNCTION-NAME> '($rows, $cols) {'
<lines>
    <FOR> '(' <assignment-expression> ';' <comparison-expression> ';' <SCALAR> '++) {'
	<FOR> '($j=0; $j<$cols; $j++) {
	    $mx[$i][$j] = $count++;
	}
    }'
    <RETURN> '($mx);
}'

<FUNCTION> 'mmult ($rows, $cols, $m1, $m2) {'
<lines>
    <FOR> '($i=0; $i<$rows; $i++) {'
	<FOR> '($j=0; $j<$cols; $j++) {'
	    <assignment-expression> ';'
	    <FOR> '(' <assignment-expression> '; $k<$cols; $k++) {
		$x += $m1[$i][$k] * $m2[$k][$j];
	    }
	    $m3[$i][$j] = $x;
	}
    }'
<lines>
'}'

<FUNCTION> 'matrix($n) {'
<lines>
  <WHILE> '($n--) {'
<lines>
  '}'
  <PRINT> <DQ-STRING> ';'
'}'

<COMMENT>

<FUNCTION> 'nestedloop($n) {'
<lines>
  <FOR> '($a=0; $a<$n; $a++)'
    <FOR> '($b=0; $b<$n; $b++)'
      <FOR> '($c=0; $c<$n; $c++)'
        <FOR> '($d=0; $d<$n; $d++)'
          <FOR> '($e=0; $e<$n; $e++)'
            <FOR> '($f=0; $f<$n; $f++)
             $x++;'
  <PRINT> '"$x\n";
}'

<COMMENT>

<FUNCTION> <FUNCTION-NAME> '($n) {'
<lines>
  <WHILE> '($n-- > 0) {'
<lines>
    <FOR> '($i=2; $i<8193; $i++) {'
      <IF> '($flags[$i] > 0) {'
        <FOR> '($k=$i+$i;' <comparison-expression> '; $k+=$i) {
          $flags[$k] = 0;
        }'
<lines>
      '}'
    '}'
  '}'
  <PRINT> '"Count: $count\n";
}'

<COMMENT>

<FUNCTION> 'strcat($n) {'
<lines>
  <WHILE> '($n-- > 0) {
    $str .= "hello\n";
  }'
  <lines>
  <PRINT> '"$len\n";
}'

<COMMENT>

<FUNCTION> 'getmicrotime()
{'
<lines>
  <RETURN> '($t[\'sec\'] + $t[\'usec\'] / 1000000);
}'

<function-declaration>

<FUNCTION> 'end_test($start, $name)
{'
<lines>
  '$total += $end-$start;
  $num = number_format($end-$start,3);
  $pad = str_repeat(" ", 24-strlen($name)-strlen($num));'

  <ECHO> '$name.$pad.$num."\n";'
<lines>
'}'

<FUNCTION> 'total()
{'
<lines>
  <ECHO> '$pad."\n";'
<lines>
  '$pad = str_repeat(" ", 24-strlen("Total")-strlen($num));'
  <ECHO> '"Total".$pad.$num."\n";
}

$t0 = $t = start_test();'
<lines>
<PHP-END>
		}
	}
 
# vim: ft=perl6
