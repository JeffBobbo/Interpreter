#!/usr/bin/perl

package Token;

use warnings;
use strict;

use Exporter qw(import);
our @EXPORT = qw(NUMBER ADDITION SUBTRACTION MULTIPLY DIVIDE POWER FACTORIAL L_PARENTHESIS R_PARENTHESIS BLOCK_BEGIN BLOCK_END SEMICOLON PERIOD ASSIGN ID EOF fromType);

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
  BLOCK_BEGIN   => 0x9,
  BLOCK_END     => 0xA,
  SEMICOLON     => 0xB,
  PERIOD        => 0xC,
  ASSIGN        => 0xD,
  ID            => 0xE,
  EOF           => 0xF
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
  $tStr = '{' if ($self->{type} == BLOCK_BEGIN);
  $tStr = '}' if ($self->{type} == BLOCK_END);
  $tStr = ';' if ($self->{type} == SEMICOLON);
  $tStr = '.' if ($self->{type} == PERIOD);
  $tStr = '=' if ($self->{type} == ASSIGN);
  $tStr = 'ID' if ($self->{type} == ID);
  $tStr = 'EOF' if ($self->{type} == EOF);


  return "Token($tStr" . (defined($self->{vaule}) ? ", $self->{value})" : ")");
}

sub fromType
{
  my $type = shift();

  my $tStr = 'UNDEF';
  $tStr = 'NUMBER' if ($type == NUMBER);
  $tStr = 'ADDITION' if ($type == ADDITION);
  $tStr = 'SUBTRACTION' if ($type == SUBTRACTION);
  $tStr = 'MULTIPLY' if ($type == MULTIPLY);
  $tStr = 'DIVIDE' if ($type == DIVIDE);
  $tStr = 'POWER' if ($type == POWER);
  $tStr = 'FACTORIAL' if ($type == FACTORIAL);
  $tStr = '(' if ($type == L_PARENTHESIS);
  $tStr = ')' if ($type == R_PARENTHESIS);
  $tStr = '{' if ($type == BLOCK_BEGIN);
  $tStr = '}' if ($type == BLOCK_END);
  $tStr = ';' if ($type == SEMICOLON);
  $tStr = '.' if ($type == PERIOD);
  $tStr = '=' if ($type == ASSIGN);
  $tStr = 'ID' if ($type == ID);
  $tStr = 'EOF' if ($type == EOF);


  return "Token($tStr)";
}

1;
