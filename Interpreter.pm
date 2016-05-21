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
  $self->{GLOBAL} = {}; # no variables to begin with

  bless($self, $class);

  return $self;
}

sub visit
{
  my $self = shift();
  my $node = shift();

  if (ref($node) eq 'NoOp')
  {
    return $self->visitNoOp($node);
  }
  elsif (ref($node) eq 'UnaryOp')
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
  elsif (ref($node) eq 'Compound')
  {
    return $self->visitCompound($node);
  }
  elsif (ref($node) eq 'Assign')
  {
    return $self->visitAssign($node);
  }
  elsif (ref($node) eq 'Variable')
  {
    return $self->visitVariable($node);
  }
  else
  {
    croak("Unknown visit: " . ref($node));
  }
}

sub visitNoOp
{
  my $self = shift();
  my $node = shift();
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
  elsif ($node->{op}{type} == BITWISE_NOT)
  {
    return ~$self->visit($node->{expr});
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
  elsif ($node->{op}{type} == BITWISE_AND)
  {
    return $self->visit($node->{left}) & $self->visit($node->{right});
  }
  elsif ($node->{op}{type} == BITWISE_OR)
  {
    return $self->visit($node->{left}) | $self->visit($node->{right});
  }
  elsif ($node->{op}{type} == BITWISE_XOR)
  {
    return $self->visit($node->{left}) ^ $self->visit($node->{right});
  }
  elsif ($node->{op}{type} == BITSHIFT_R)
  {
    return $self->visit($node->{left}) >> $self->visit($node->{right});
  }
  elsif ($node->{op}{type} == BITSHIFT_L)
  {
    return $self->visit($node->{left}) << $self->visit($node->{right});
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

sub visitCompound
{
  my $self = shift();
  my $node = shift();

  foreach my $child (@{$node->{children}})
  {
    $self->visit($child);
  }
}

sub visitAssign
{
  my $self = shift();
  my $node = shift();

  my $vname = $node->{left}{name};
  $self->{GLOBAL}{$vname} = $self->visit($node->{right});
}

sub visitVariable
{
  my $self = shift();
  my $node = shift();

  my $vname = $node->{name};
  my $val = $self->{GLOBAL}{$vname};
  if (!defined($val))
  {
    $self->{parser}{lexer}->error("unknown variable '" . $vname . "'");
  }
  else
  {
    return $val;
  }
}

sub interpret
{
  my $self = shift();
  my $tree = $self->{parser}->parse();
  return $self->visit($tree);
}

1;
