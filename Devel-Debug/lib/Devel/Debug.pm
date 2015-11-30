package Devel::Debug;

use 5.018002;
use strict;
use warnings;
use Carp;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Devel::Debug ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
);

our $VERSION = '0.01';

our $Debug = 0;
our $FunctionNameSpaceTabulations = 10;

my $debugCurrentDecalage = 0;

# debug function
# [in] $level :debug level
# [in] $functionName : The function name in which the debug function is call
# [in] @a_String : String array to display
sub debug (){
  my ( $level, $functionName, @stringArray ) = @_;

  if ( ( $level > 0 ) and ( $level < 10 ) ) {
    if ( ( $level == 9 ) && ( join( '', @stringArray ) =~ /^END / ) ) {
      $debugCurrentDecalage --;
    }
  
    if ( $Debug >= $level ) {
      my $space = '>';
      for ( my $i = 0; $i < $debugCurrentDecalage; $i++ ) {
        $space = '=='.$space;
      }
  
      my @stringDisplayedArray = split( "\n", join( '', @stringArray ) );
      for ( my $i = 0; $i < scalar( @stringDisplayedArray ); $i++ ) {
        print( '# DEBUG ['.$level.'] '.sprintf( '(%'.$FunctionNameSpaceTabulations.'s)', $functionName ).' :'.
               $space.$stringDisplayedArray[$i]."\n" );
      }
    }
  
    if ( ( $level == 9 ) && ( join( '', @stringArray ) =~ /^BEGIN / ) ) {
      $debugCurrentDecalage ++;
    }
  } else {
    croak( 'Bad debug level. Debug level must be between 1 and 9.' );
  }
}

1;
__END__

=head1 NAME

Devel::Debug - Perl extension for easy debug messages in perl scripts or modules

=head1 SYNOPSIS

Usage :
  use Devel::Debug;
 
  Global variable for setting debugging level
  $Devel::Debug::Debug = <debug level>;

  Space tabulation for function names (default to 10 spaces)
  $Devel::Debug::FunctionNameSpaceTabulations = <number of space tabulations>;

  Function for displaying debug message to stdout
  &Devel::Debug::debug( <level>, <function name>, <debug message> );

Example:
  Code :
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

  Output :
    # DEBUG [9] (      main) :>BEGIN main
    # DEBUG [1] (      main) :==>Some debug "Hello world ..."
    # DEBUG [9] (       foo) :==>BEGIN foo
    # DEBUG [5] (       foo) :====>Some debug in foo function "Hello world ..."
    # DEBUG [9] (       foo) :==>END foo
    # DEBUG [9] (      main) :>END main
   
=head1 DESCRIPTION

Devel::Debug is a package providing a debug function. It allows 9 levels 
of debug, and print function name and debug messages below defined global level. 

Conventionnals use for this function :

  You must start a function by : 
  &Devel::Debug::debug( 9, <function name>', 'BEGIN <function name>' );

  You must end a function by   : 
  &Devel::Debug::debug( 9, <function name>', 'END <function name>' );

  The function name for an OO function should be : 
  blessed( $self ).'::<function name>' i.e. &Devel::Debug::debug( 9, blessed( $self ).'<function name>', 'END <function name>' );

=head1 AUTHOR

This code is maintained by Christophe Marteau <christophe.marteau(at)gmail.com>.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2014 by Christophe Marteau

This library is free software; you can redistribute it and/or modify it under the 
same terms as Perl itself.

=cut
