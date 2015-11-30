#!/usr/bin/perl

use Devel::Debug;
$Devel::Debug::Debug = 9;

sub foo() {
  &Devel::Debug::debug( 9, 'foo', 'BEGIN foo' );
  &Devel::Debug::debug( 5, 'foo', 'Some debug in foo function "Hello world ..."' );
  &Devel::Debug::debug( 9, 'foo', 'END foo' );
}

&Devel::Debug::debug( 9, 'main', 'BEGIN main' );
&Devel::Debug::debug( 1, 'main', 'Some debug "Hello world ..."' );

&foo();

&Devel::Debug::debug( 9, 'main', 'END main' );
