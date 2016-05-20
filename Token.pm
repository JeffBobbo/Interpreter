#!/usr/bin/perl

package Token;

use warnings;
use strict;

use Exporter qw(import);
our @EXPORT = qw(NUMBER ADDITION SUBTRACTION MULTIPLY DIVIDE POWER FACTORIAL BITWISE_AND BITWISE_OR BITWISE_NOT BITWISE_XOR L_PARENTHESIS R_PARENTHESIS BLOCK_BEGIN BLOCK_END ID ASSIGN SEMICOLON PERIOD EOF fromType);

my $i = 0;
use constant
{
  NUMBER        => $i++,
  ADDITION      => $i++,
  SUBTRACTION   => $i++,
  MULTIPLY      => $i++,
  DIVIDE        => $i++,
  POWER         => $i++,
  FACTORIAL     => $i++,
  BITWISE_AND   => $i++,
  BITWISE_OR    => $i++,
  BITWISE_NOT   => $i++,
  BITWISE_XOR   => $i++,
  L_PARENTHESIS => $i++,
  R_PARENTHESIS => $i++,
  BLOCK_BEGIN   => $i++,
  BLOCK_END     => $i++,
  ID            => $i++,
  ASSIGN        => $i++,
  SEMICOLON     => $i++,
  PERIOD        => $i++,
  EOF           => $i++
};

sub new
{
  my $class = shift();
  my $self = {
    type  => shift(),
    value => shift()
  };

  bless($self, $class);

  return $self;
}

sub toString
{
  my $self = shift();

  return fromType($self->{type}, $self->{value});
}

sub fromType
{
  my $type = shift();
  my $value = shift();

  my $tStr = 'UNDEF';
  $tStr = 'NUMBER' if ($type == NUMBER);
  $tStr = 'ADDITION' if ($type == ADDITION);
  $tStr = 'SUBTRACTION' if ($type == SUBTRACTION);
  $tStr = 'MULTIPLY' if ($type == MULTIPLY);
  $tStr = 'DIVIDE' if ($type == DIVIDE);
  $tStr = 'POWER' if ($type == POWER);
  $tStr = 'FACTORIAL' if ($type == FACTORIAL);
  $tStr = 'BITWISE_AND' if ($type == BITWISE_AND);
  $tStr = 'BITWISE_OR' if ($type == BITWISE_OR);
  $tStr = 'BITWISE_NOT' if ($type == BITWISE_NOT);
  $tStr = 'BITWISE_XOR' if ($type == BITWISE_XOR);
  $tStr = 'L_PARENTHESIS' if ($type == L_PARENTHESIS);
  $tStr = 'R_PARENTHESIS' if ($type == R_PARENTHESIS);
  $tStr = 'BLOCK_BEGIN' if ($type == BLOCK_BEGIN);
  $tStr = 'BLOCK_END' if ($type == BLOCK_END);
  $tStr = 'ID' if ($type == ID);
  $tStr = 'ASSIGN' if ($type == ASSIGN);
  $tStr = 'SEMICOLON' if ($type == SEMICOLON);
  $tStr = 'PERIOD' if ($type == PERIOD);
  $tStr = 'EOF' if ($type == EOF);

  return "Token($tStr" . (defined($value) ? ", $value)" : ")");
}

1;
