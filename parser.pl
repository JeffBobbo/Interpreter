#!/usr/bin/perl

use warnings;
use strict;

use Lexer;
use Parser;
use Interpreter;

while (1)
{
  chomp(my $input = <STDIN>);
  next if (!defined $input || length($input) == 0);
  last if ($input eq 'q');
  eval
  {
    my $lexer = Lexer->new($input);
    my $parser = Parser->new($lexer);
    my $interpreter = Interpreter->new($parser);
    my $result = $interpreter->interpret();
    print "$result\n";
  };
  if ($@)
  {
    print "$@\n";
  }
}
