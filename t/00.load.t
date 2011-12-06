use Test::More tests => 9;

system("echo foo");

use Test::Carp;

BEGIN {
use_ok( 'Test::Mock::Cmd', sub { 1 } );
use_ok( 'Test::Mock::Cmd', sub { 1 }, sub { 2 }, sub { 3 } );
}

diag( "Testing Test::Mock::Cmd $Test::Mock::Cmd::VERSION" );

my $import = sub { require Test::Mock::Cmd;Test::Mock::Cmd->import(@_) };
my $arg_regex = qr/import\(\) requires 1 or 3 code references as arguments/;
my $code_regex = qr/Not a CODE reference/;

does_croak_that_matches($import, $arg_regex);
does_croak_that_matches($import, sub {1}, sub {2}, $arg_regex);
does_croak_that_matches($import, sub {1}, sub {2}, sub {3}, sub {4}, $arg_regex);

does_croak_that_matches($import, 1, $code_regex);
does_croak_that_matches($import, 1, sub {2}, sub {3}, $code_regex);
does_croak_that_matches($import, sub {1}, 2, sub {3}, $code_regex);
does_croak_that_matches($import, sub {1}, sub {2}, 3, $code_regex);