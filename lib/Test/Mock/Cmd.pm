package Test::Mock::Cmd;

use strict;
use warnings;
use Carp ();

$Test::Mock::Cmd::VERSION = '0.1';

sub import {
    if ( @_ == 4 ) {
        Carp::croak('Not a CODE reference') if ref( $_[1] ) ne 'CODE' || ref( $_[2] ) ne 'CODE' || ref( $_[3] ) ne 'CODE';
    }
    elsif ( @_ == 2 ) {
        Carp::croak('Not a CODE reference') if ref( $_[1] ) ne 'CODE';
    }
    else {
        Carp::croak( __PACKAGE__ . '->import() requires 1 or 3 code references as arguments' );
    }

    no warnings 'redefine';
    *CORE::GLOBAL::system   = $_[1];
    *CORE::GLOBAL::exec     = $_[2] || $_[1];
    *CORE::GLOBAL::readpipe = $_[3] || $_[1];
}

# This doesn't make sense w/ the once-set-always-set behavior of these functions and it's just weird so we leave it out for now.
# If there is a way to get it to take effect like other use/no then patches welcome!
# sub unimport {
#     no warnings 'redefine';
#     *CORE::GLOBAL::system   = \&orig_system;    # it'd be nice to assign the CORE::system directly instead of the \&orig_system
#     *CORE::GLOBAL::exec     = \&orig_exec;      # it'd be nice to assign the CORE::exec directly instead of the \&orig_exec
#     *CORE::GLOBAL::readpipe = \&orig_qx;        # it'd be nice to assign the CORE::readpipe directly instead of the \&orig_qx
# }

sub orig_system {

    # goto &CORE::system won't work here, but it'd be nice
    return CORE::system(@_);
}

sub orig_exec {

    # goto &CORE::exec won't work here, but it'd be nice
    return CORE::exec(@_);
}

sub orig_qx {

    # goto &CORE::readpipe won't work here,  but it'd be nice
    return CORE::readpipe( $_[0] );    # we use $_[0] because @_ results in something like 'sh: *main::_: command not found'
}

1;

__END__

=encoding utf8

=head1 NAME

Test::Mock::Cmd - Mock system(), exec(), and qx() for testing

=head1 VERSION

This document describes Test::Mock::Cmd version 0.1

=head1 SYNOPSIS

    use Test::Mock::Cmd \&my_cmd_mocker;

or

    use Test::Mock::Cmd \&my_mock_system, \&my_mock_exec, \&my_mock_qx;

=head1 DESCRIPTION

Mock system(), exec(), qx() (AKA `` and readpipe()) with your own functions in order to test code that may call them. 

Some uses might be:

=over 4 

=item 1

avoid actually running the system command, just pretend we did (simulate [un]expected output, return values, etc)

=item 2 

test various return value handling (e.g. the system command core dumps how does the object handle that)

=item 3

test that the arguments that will be passed to a system command are correct

=item 4

etc etc

=back 

=head1 INTERFACE 

=head2 Commence mocking

Per the synopsis, you can provide import() with 1 code reference to replace all 3 functions or 3 code references to replace system(), exec(), and qx() (in that order).

=head3 Caveat

Any code loaded before the mock functions are setup will retain normal syatme(), etc behavior. (even if the system() does not happen until much later!)

   use X; # has functions that call system()
   use Test::Mock::Cmd ...
   use Y; # has functions that call system()
   X::i_call_system(...); # normal system() happens
   Y::i_call_system(...); # mocked system() happens

=head2 Getting access to the original, un-mocked, functionality.

Non of these are exportable.

=over 

=item Test::Mock::Cmd::orig_system()

Original, not-mocked L<perlfunc/system>

=item Test::Mock::Cmd::orig_exec()

Original, not-mocked L<perlfunc/exec>

=item Test::Mock::Cmd::orig_qx() 

Original, not-mocked L<perlfunc/readpipe>

=back

=head1 DIAGNOSTICS

=over 

=item C<< Not a CODE reference >>

The given argument is not a code reference and should be.

=item C<< Test::Mock::Cmd->import() requires 1 or 3 code references as arguments >>

You are not passing in the required one or three arguments.

=back

=head1 CONFIGURATION AND ENVIRONMENT

Test::Mock::Cmd requires no configuration files or environment variables.

=head1 DEPENDENCIES

None.

=head1 INCOMPATIBILITIES

None reported.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-test-mock-cmd@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.

=head1 See Also

L<Test::MockCommand> for a more complex (and much heavier) object based approach to this. 

=head1 AUTHOR

Daniel Muey  C<< <http://drmuey.com/cpan_contact.pl> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2011, Daniel Muey C<< <http://drmuey.com/cpan_contact.pl> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
