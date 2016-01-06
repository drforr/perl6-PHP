use v6;
use PHP5::Grammar;
use PHP7::Grammar;
use Test;

plan 2;

subtest sub {

  my $g = PHP5::Grammar.new;

  ok $g.parsefile( 'corpus-v5/addglob.php' ), 'addglob.php';
  ok $g.parsefile( 'corpus-v5/addpattern.php' ), 'addpattern.php';
  ok $g.parsefile( 'corpus-v5/a.php' ), 'a.php';
  ok $g.parsefile( 'corpus-v5/bench.php' ), 'bench.php';

#book.php
#b.php
#bug39542.php
#build_precommand.php
#check_parameters.php
#class_tree.php
#cleanhtml5.php
#cleanhtml.php
#client_round2_interop.php
#client_round2_params.php
#client_round2.php
#client_round2_results.php
#client_round2_run.php
#collator_api.php
#comment.php
#common_api.php
#c.php
#create_data_file.php
#create.php
#datefmt_api.php
#dba_array.php
#dba_dump.php
#directorytree.php
#dir.php
#dom1.php
#domdocumentload_test_method.php
#domdocumentload_test_method_savexml.php
#domdocumentload_utilities.php
#domdocumentloadxml_test_method.php
#domdocumentloadxml_test_method_savexml.php
#dumpit5.php
#echoheadersvc.wsdl.php
#example1.php
#example.php
#extractAll.php
#extract.php
#ext_skel_win32.php
#fetch.php
#fileinfo.php
#findfile.php
#findregex.php
#find_tested.php
#fixture.php
#foo_bar.php
#foo_php_version.php
#foo_strlen.php
#fopen.php
#formatter_api.php
#generate-phpt.php
#get_error_codes.php
#get.php
#get_set_comments.php
#global_bar.php
#global_baz.php
#grapheme_api.php
#gtAutoload.php
#gtBasicTestCaseFunction.php
#gtBasicTestCaseFunctionTest.php
#gtBasicTestCaseMethod.php
#gtBasicTestCaseMethodTest.php
#gtBasicTestCase.php
#gtClassMap.php
#gtCodeSnippet.php
#gtCodeSnippetTest.php
#gtCommandLineOptions.php
#gtCommandLineOptionsTest.php
#gtErrorTestCaseFunction.php
#gtErrorTestCaseFunctionTest.php
#gtErrorTestCaseMethod.php
#gtErrorTestCaseMethodTest.php
#gtErrorTestCase.php
#gtFunction.php
#gtFunctionTest.php
#gtIfClassHasMethod.php
#gtIfClassHasMethodTest.php
#gtIsSpecifiedFunctionOrMethod.php
#gtIsSpecifiedFunctionOrMethodTest.php
#gtIsSpecifiedTestType.php
#gtIsSpecifiedTestTypeTest.php
#gtIsValidClass.php
#gtIsValidClassTest.php
#gtIsValidFunction.php
#gtIsValidFunctionTest.php
#gtIsValidMethod.php
#gtIsValidMethodTest.php
#gtMethod.php
#gtMethodTest.php
#gtMissingArgumentException.php
#gtMissingOptionsException.php
#gtOptionalSections.php
#gtOptionalSectionsTest.php
#gtPackage.php
#gtPreConditionList.php
#gtPreCondition.php
#gtTestCase.php
#gtTestCaseWriter.php
#gtTestSubject.php
#gtText.php
#gtUnknownOptionException.php
#gtUnknownSectionException.php
#gtVariationContainerFunction.php
#gtVariationContainerMethod.php
#gtVariationContainer.php
#gtVariationTestCaseFunction.php
#gtVariationTestCaseFunctionTest.php
#gtVariationTestCaseMethod.php
#gtVariationTestCaseMethodTest.php
#gtVariationTestCase.php
#html_table_gen.php
#im.php
#index.php
#ini_groups.php
#input_get_args.php
#interopB.wsdl.php
#interop.php
#interop.wsdl.php
#locale_api.php
#makestub.php
#micro_bench.php
#milter.php
#mkdist.php
#msgfmt_api.php
#mysql_users.php
#nocvsdir.php
#normalizer_api.php
#note.php
#odt.php
#oldapi.php
#pdo.php
#pear2coverage.phar.php
#phar_from_dir.php
#phar.php
#registersyslog.php
#relaxNG.php
#run-tests.php
#search_underscores.php
#security.php
#server_round2_base.php
#server_round2_groupB.php
#server_round2_groupC.php
#server-tests-config.php
#server-tests.php
#shipping.php
#shortarc.php
#skeleton.php
#spl.php
#test-pcntl.php
#test.php
#test.utility.php
#tokenizer.php
#too.php
#tree.php
#upgrade-pcre.php
#urlgrab5.php
#web-bootstrap.php
#xmlreader_file.php
#xmlreader_relaxNG.php
#xmlreader_string.php
#xmlreader_validatedtd.php
#xmlwriter_file.php
#xmlwriter_mem_ns.php
#xmlwriter_mem.php
#xmlwriter_oo.php
#xpath.php
#zend_vm_gen.php
}

# vim: ft=perl6
