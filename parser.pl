#!/usr/bin/perl

use warnings;
use strict;

use Lexer;
use Parser;
use Interpreter;

use Data::Dumper;

my $file = $ARGV[0];
my $script;
if ($file)
{
  open(my $fh, '<', $file) or die "Can't read source file: $!\n";
  $script = join('', <$fh>);
  close($fh);
}
else
{
  $script = <STDIN>;
}

my $lexer = Lexer->new($script, $file);
my $parser = Parser->new($lexer);
my $interpreter = Interpreter->new($parser);
$interpreter->interpret();

print Dumper($interpreter->{GLOBAL});

=cut
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
    print $interpreter->interpret() . "\n";
  };
  if ($@)
  {
    print "$@\n";
  }
}
