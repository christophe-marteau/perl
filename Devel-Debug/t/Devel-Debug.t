# Before 'make install' is performed this script should be runnable with
# 'make test'. After 'make install' it should work as 'perl Devel-Debug.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;

use Test::More;
use Test::Trap;

BEGIN { use_ok('Devel::Debug') };

subtest 'Testing error when function debug level is bad' => sub {
  $Devel::Debug::Debug = 0;
  trap {
       &Devel::Debug::debug( 0, 'test', 'Message output' );
  };
  like( $trap->die, qr/^Bad debug level. Debug level must be between 1 and 9. at/ , 'Debug level "0" returns error at other levels than 0..9' );
  
  trap {
       &Devel::Debug::debug( 10, 'test', 'Message output' );
  };
  like( $trap->die, qr/^Bad debug level. Debug level must be between 1 and 9. at/ , 'Debug level "10" returns error at other levels than 0..9 ' );
  
  trap {
       &Devel::Debug::debug( -1, 'test', 'Message output' );
  };
  like( $trap->die, qr/^Bad debug level. Debug level must be between 1 and 9. at/ , 'Debug level "-1" returns error at other levels than 0..9 ' );
};

subtest 'Testing output between debug level and function debug level' => sub {
  for ( my $levelSet = 0; $levelSet <= 9; $levelSet ++ ) {
    $Devel::Debug::Debug = $levelSet;
  
    for( my $level = 1; $level <= 9; $level ++ ) {
      trap {
         &Devel::Debug::debug( $level, 'test', 'Message output' );
      };
  
      if ( $level > $levelSet ) {
        cmp_ok( $trap->stdout, 'eq' , '' , 'Debug level "'.$level.'" returns nothing at level "'.$levelSet.'"' );
      } else {
        cmp_ok( $trap->stdout, 'eq' , '# DEBUG ['.$level.'] (      test) :>Message output'."\n" , 'Debug level "'.$level.'" returns a message at level "'.$levelSet.'"' );
      }
    }
  }
};

subtest 'Testing function space tabulation' => sub {
  $Devel::Debug::Debug = 1;
  trap {
    &Devel::Debug::debug( 1, 'test', 'Message output' );
  };
  cmp_ok( $trap->stdout, 'eq' , '# DEBUG [1] (      test) :>Message output'."\n" , 'Debug level with default spaces tabulation displaying function\'s name.' );

  $Devel::Debug::FunctionNameSpaceTabulations = 25;
  trap {
    &Devel::Debug::debug( 1, 'test', 'Message output' );
  };
  cmp_ok( $trap->stdout, 'eq' , '# DEBUG [1] (                     test) :>Message output'."\n" , 'Debug level with 25 spaces tabulation displaying function\'s name.' );
  
  $Devel::Debug::FunctionNameSpaceTabulations = 33;
  trap {
    &Devel::Debug::debug( 1, 'test', 'Message output' );
  };
  cmp_ok( $trap->stdout, 'eq' , '# DEBUG [1] (                             test) :>Message output'."\n" , 'Debug level with 33 spaces tabulation displaying function\'s name.' );
};

subtest 'Testing BEGIN and END shifting' => sub {
  $Devel::Debug::FunctionNameSpaceTabulations = 10;
  $Devel::Debug::Debug = 9;
  trap {
    &Devel::Debug::debug( 9, 'main', 'BEGIN main' );
  };
  cmp_ok( $trap->stdout, 'eq' , '# DEBUG [9] (      main) :>BEGIN main'."\n" , 'Debug level with begin main shifting' );
  trap {
    &Devel::Debug::debug( 9, 'main', 'END main' );
  };
  cmp_ok( $trap->stdout, 'eq' , '# DEBUG [9] (      main) :>END main'."\n" , 'Debug level with end main shifting' );

  $Devel::Debug::Debug = 0;
  &Devel::Debug::debug( 9, 'main', 'BEGIN main' );
  $Devel::Debug::Debug = 9;
  trap {
    &Devel::Debug::debug( 9, 'function1', 'BEGIN function1' );
  };
  cmp_ok( $trap->stdout, 'eq' , '# DEBUG [9] ( function1) :==>BEGIN function1'."\n" , 'Debug level with begin function shifting' );
  
  trap {
    &Devel::Debug::debug( 9, 'function1', 'END function1' );
  };
  cmp_ok( $trap->stdout, 'eq' , '# DEBUG [9] ( function1) :==>END function1'."\n" , 'Debug level with end function shifting' );
};

done_testing();
