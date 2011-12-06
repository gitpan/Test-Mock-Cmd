package Test::Mock::Cmd::TestUtils::X;

use strict;
use warnings;

sub i_call_system {
    system(@_);
}

sub i_call_exec {
    exec(@_);
}

sub i_call_readpipe {
    readpipe( $_[0] );
}

sub i_call_qx {
    qx(/bin/echo QX);
}

sub i_call_backticks {
    `/bin/echo BT`;
}

1;
