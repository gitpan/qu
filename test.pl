use Test;
BEGIN { $| = 1; plan(tests => 30); chdir 't' if -d 't'; }

ok(1);

############################################
## setup test environment
############################################
my $user = (getpwuid($<))[0];
my $uid  = (getpwuid($<))[2];
my @dirs = qw( /usr/local/lib
	       /usr/local/bin
	       /usr/local/libexec
	       /etc
	       /usr/home/bob
	       /usr/home/joe
	     );

## check tmproot
my $root = "./tmproot.$$";
if( -e $root ) {
    die "'$root' already exists: please move it!\n";
}

## create directories
for my $dir ( @dirs ) {
    `mkdir -p "$root${dir}"`
}

## plain files
my %p_files = ( '/usr/local/lib/libfoo' 	=> 511,
		'/usr/local/lib/libbar' 	=> 1023,
		'/usr/local/lib/libbaz' 	=> 2047,
	      );

## create plain files
for my $file ( sort keys %p_files ) {
    open FILE, ">$root${file}"
      or die "Could not create test $root${file}!\nAll tests will probably fail: $!\n";
    print FILE '.' x $p_files{$file};
    close FILE;
}

## hard links
my %h_links = ( '/usr/local/lib/libfoo' => '/usr/local/lib/libfoo.2',
	      );

## create hard links
for my $file ( sort keys %h_links ) {
    link "$root${file}", "$root$h_links{$file}"
      or warn "Could not create hard links '$root${file}', '" . 
	$root . $h_links{$file} . "': $!\n";
}

## symbolic links
my %s_links = ( '/usr/local/lib/libbar.1' => '=>/usr/local/lib/libbar',
	      );

############################################
## end setup test environment
############################################

my $result = `./qu $root --summary`;
ok( $result =~ /^Total Blocks: 14$/m );


############################################
## clean up test environment
`rm -rf $root`;
############################################
