#!/usr/bin/perl

package Parser;

use warnings;
use strict;

use Carp;

use Exporter qw(import);
our @EXPORT = qw();

use Token;

use Number;
use UnaryOp;
use BinOp;

sub new
{
  my $class = shift();

  my $self = {};
  $self->{lexer} = shift();
  $self->{token} = $self->{lexer}->nextToken();

  bless($self, $class);

  return $self;
}

sub error
{
  my $self = shift();
  my $message = shift();

  croak("Invalid syntax: " . $message);
}

sub eat
{
  my $self = shift();
  my $tokenType = shift();

  if ($self->{token}{type} == $tokenType)
  {
    $self->{token} = $self->{lexer}->nextToken();
  }
  else
  {
    $self->error("Failed to eat $tokenType");
  }
}

sub factor
{
  my $self = shift();

  my $token = $self->{token};

  if ($token->{type} == NUMBER)
  {
    $self->eat(NUMBER);
    return Number->new($token);
  }
  elsif ($token->{type} == ADDITION)
  {
    $self->eat(ADDITION);
    my $node = UnaryOp->new($token, $self->factor());
    return $node;
  }
  elsif ($token->{type} == SUBTRACTION)
  {
    $self->eat(SUBTRACTION);
    my $node = UnaryOp->new($token, $self->factor());
    return $node;
  }
  elsif ($token->{type} == L_PARENTHESIS)
  {
    $self->eat(L_PARENTHESIS);
    my $node = $self->expr();
    $self->eat(R_PARENTHESIS);
    return $node;
  }
  else
  {
    $self->error("Parser::factor() -- $token->{type}");
  }
}

sub factorial
{
  my $self = shift();

  my $node = $self->factor();
  while ($self->{token}{type} == FACTORIAL)
  {
    my $token = $self->{token};
    $self->eat(FACTORIAL);
    $node = UnaryOp->new($token, $node);
  }
  return $node;
}

sub power
{
  my $self = shift();

  my $node = $self->factorial();
  while ($self->{token}{type} == POWER)
  {
    my $token = $self->{token};
    $self->eat(POWER);
    $node = BinOp->new($node, $token, $self->factorial());
  }
  return $node;
}

sub term
{
  my $self = shift();

  my $node = $self->power();

  while ($self->{token}{type} == MULTIPLY || $self->{token}{type} == DIVIDE)
  {
    my $token = $self->{token};
    if ($token->{type} == MULTIPLY)
    {
      $self->eat(MULTIPLY);
    }
    elsif ($token->{type} == DIVIDE)
    {
      $self->eat(DIVIDE);
    }
    $node = BinOp->new($node, $token, $self->power());
  }
  return $node;
}

sub expr
{
  my $self = shift();

  my $node = $self->term();

  while ($self->{token}{type} == ADDITION || $self->{token}{type} == SUBTRACTION)
  {
    my $token = $self->{token};
    if ($token->{type} == ADDITION)
    {
      $self->eat(ADDITION);
    }
    elsif ($token->{type} == SUBTRACTION)
    {
      $self->eat(SUBTRACTION);
    }
    $node = BinOp->new($node, $token, $self->term());
  }
  return $node;
}

sub parse
{
  my $self = shift();
  return $self->expr();
}

1;
