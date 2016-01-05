use v6;
grammar PHP5::Grammar
	{
	token PHP-START { '<?php' }
	token PHP-END { '?>' }

	token CLASS { 'class' }
	token FUNCTION { 'function' }

	token ECHO { 'echo' } # Only because the lack of parens after it.

	token CLASS-NAME { <[ a .. z 0 .. 9 ]>+ }
	token FUNCTION-NAME { <[ a .. z 0 .. 9 ]>+ }

	token SCALAR { '$' <[ a .. z ]>+ }

	token DQ-STRING { '"' <-[ " ]>* '"' }

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
		<SCALAR> '= new ZipArchive;
$z->open(\'a.zip\', ZIPARCHIVE::CREATE);

/* or \'remove_all_path\' => 0*/
$options = array(
	\'remove_path\' => \'/home/francis/myimages\',
	\'add_path\' => \'images/\',
);
$found = $z->addGlob("/home/pierre/cvs/gd/libgd/tests/*.png", 0, $options);
var_dump($found);
$z->close();'

		}
	}
 
# vim: ft=perl6
