#!/usr/bin/perl

package Interpreter;

use warnings;
use strict;

use Carp;

use Exporter qw(import);
our @EXPORT = qw();

use Token;

sub new
{
  my $class = shift();

  my $self = {};
  $self->{parser} = shift();

  bless($self, $class);

  return $self;
}

sub visit
{
  my $self = shift();
  my $node = shift();

  if (ref($node) eq 'UnaryOp')
  {
    return $self->visitUnaryOp($node);
  }
  elsif (ref($node) eq 'BinOp')
  {
    return $self->visitBinOp($node);
  }
  elsif (ref($node) eq 'Number')
  {
    return $self->visitNumber($node);
  }
  else
  {
    croak("Unknown visit");
  }
}

sub visitUnaryOp
{
  my $self = shift();
  my $node = shift();

  if ($node->{op}{type} == FACTORIAL)
  {
    my $n = $self->visit($node->{expr});
    my $r = $n;
    my $i = 1;
    $r *= $i while (++$i < $n);
    return $r;
  }
  if ($node->{op}{type} == ADDITION)
  {
    return $self->visit($node->{expr});
  }
  elsif ($node->{op}{type} == SUBTRACTION)
  {
    return -$self->visit($node->{expr});
  }
  else
  {
    croak("bad unaryop visit");
  }
}

sub visitBinOp
{
  my $self = shift();
  my $node = shift();

  if ($node->{op}{type} == POWER)
  {
    return $self->visit($node->{left}) ** $self->visit($node->{right});
  }
  elsif ($node->{op}{type} == ADDITION)
  {
    return $self->visit($node->{left}) + $self->visit($node->{right});
  }
  elsif ($node->{op}{type} == SUBTRACTION)
  {
    return $self->visit($node->{left}) - $self->visit($node->{right});
  }
  elsif ($node->{op}{type} == MULTIPLY)
  {
    return $self->visit($node->{left}) * $self->visit($node->{right});
  }
  elsif ($node->{op}{type} == DIVIDE)
  {
    return $self->visit($node->{left}) / $self->visit($node->{right});
  }
  else
  {
    croak("bad binop visit");
  }
}

sub visitNumber
{
  my $self = shift();
  my $node = shift();

  return $node->{value};
}

sub interpret
{
  my $self = shift();
  my $tree = $self->{parser}->parse();
  return $self->visit($tree);
}

1;
