use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'	=> 'qu',
    'VERSION_FROM' => 'qu',
    'AUTHOR'       => 'Scott Wiersdorf <scott@perlcode.org>',
    'EXE_FILES'     => [ 'qu' ],
);
