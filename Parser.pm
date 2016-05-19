#!/usr/bin/perl

package Parser;

use warnings;
use strict;

use Carp;

use Exporter qw(import);
our @EXPORT = qw();

use Token;

use Assign;
use Variable;
use Compound;
use Number;
use UnaryOp;
use BinOp;
use NoOp;

sub new
{
  my $class = shift();

  my $self = {};
  $self->{lexer} = shift();
  $self->{token} = $self->{lexer}->nextToken();

  bless($self, $class);

  return $self;
}

sub warning
{
  my $self = shift();
  $self->{lexer}->warning(@_);
}

sub error
{
  my $self = shift();
  $self->{lexer}->error(@_);
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
    $self->error("exptected " . fromType($tokenType) . ", got " . $self->{token}->toString());
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
    return $self->variable();
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

sub empty
{
  # don't care about self
  return NoOp->new();
}

sub variable
{
  my $self = shift();

  my $node = Variable->new($self->{token});
  $self->eat(ID);
  return $node;
}

sub assignment_statement
{
  my $self = shift();

  my $left  = $self->variable();
  my $token = $self->{token};
  $self->eat(ASSIGN);
  my $right = $self->expr();
  my $node = Assign->new($left, $token, $right);
  return $node;
}

sub statement
{
  my $self = shift();

  if ($self->{token}{type} == BLOCK_BEGIN)
  {
    return $self->compound_statement();
  }
  elsif ($self->{token}{type} == ID)
  {
    return $self->assignment_statement();
  }
  else
  {
    return $self->empty();
  }
}

sub statement_list
{
  my $self = shift();

  my @statements;

  push (@statements, $self->statement());
  while ($self->{token}{type} == SEMICOLON)
  {
    $self->eat(SEMICOLON);
    push(@statements, $self->statement())
  }

  return \@statements;
}

sub compound_statement
{
  my $self = shift();
  $self->eat(BLOCK_BEGIN);
  my $nodes = $self->statement_list();
  $self->eat(BLOCK_END);

  my $root = Compound->new();
  foreach my $node (@{$nodes})
  {
    push(@{$root->{children}}, $node);
  }
  return $root;
}

sub program
{
  my $self = shift();
  my $node = $self->compound_statement();
  #$self->eat(PERIOD);
  return $node;
}


sub parse
{
  my $self = shift();

  my $node = $self->program();
  if ($self->{token}{type} != EOF)
  {
    $self->error("unexpected end of input");
  }
  return $node;
}

1;
