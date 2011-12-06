package Test::Mock::Cmd::TestUtils;

use strict;
use warnings;

sub test_more_is_like_return_42 {
    my ( $got, $expected, $name ) = @_;
    ref($expected) eq 'Regexp' ? Test::More::like( $got, $expected, $name ) : Test::More::is( $got, $expected, $name );
    return 42;
}

# use Test::Output; # rt 72976
sub tmp_stdout_like_rt_72976 {
    my ( $func, $regex, $name ) = @_;
    my $output = '';
    {
        unlink "tmp.$$.tmp";

        no warnings 'once';
        open OLDOUT, '>&STDOUT' or die "Could not dup STDOUT: $!";
        close STDOUT;

        open STDOUT, '>', "tmp.$$.tmp" or die "Could not redirect STDOUT: $!";

        # \$output does not capture system()
        # open STDOUT, '>', \$output or die "Could not redirect STDOUT: $!";

        $func->();
        open STDOUT, '>&OLDOUT' or die "Could not restore STDOUT: $!";

        chomp( $output = `cat tmp.$$.tmp` );
        unlink "tmp.$$.tmp";
    }

    # use Data::Dumper;diag(Dumper([$output,$regex,$name]));
    Test::More::like( $output, $regex, $name );
}

1
