#!/usr/bin/perl

package Token;

use warnings;
use strict;

use Exporter qw(import);
our @EXPORT = qw(NUMBER ADDITION SUBTRACTION MULTIPLY DIVIDE POWER FACTORIAL L_PARENTHESIS R_PARENTHESIS EOF);

use constant
{
  NUMBER        => 0x0,
  ADDITION      => 0x1,
  SUBTRACTION   => 0x2,
  MULTIPLY      => 0x3,
  DIVIDE        => 0x4,
  POWER         => 0x5,
  FACTORIAL     => 0x6,
  L_PARENTHESIS => 0x7,
  R_PARENTHESIS => 0x8,
  EOF           => 0x9
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

  my $tStr = 'UNDEF';
  $tStr = 'NUMBER' if ($self->{type} == NUMBER);
  $tStr = 'ADDITION' if ($self->{type} == ADDITION);
  $tStr = 'SUBTRACTION' if ($self->{type} == SUBTRACTION);
  $tStr = 'MULTIPLY' if ($self->{type} == MULTIPLY);
  $tStr = 'DIVIDE' if ($self->{type} == DIVIDE);
  $tStr = 'POWER' if ($self->{type} == POWER);
  $tStr = 'FACTORIAL' if ($self->{type} == FACTORIAL);
  $tStr = '(' if ($self->{type} == L_PARENTHESIS);
  $tStr = ')' if ($self->{type} == R_PARENTHESIS);
  $tStr = 'EOF' if ($self->{type} == EOF);


  return "Token($tStr, $self->{value})";
}

1;
