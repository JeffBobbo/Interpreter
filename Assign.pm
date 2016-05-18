#!/usr/bin/perl

package Assign;

use warnings;
use strict;

use parent 'AST';

use Exporter qw(import);
our @EXPORT = qw();

sub new
{
  my $class = shift();

  my $self = {};
  $self->{left} = shift();
  $self->{token} = $self->{op} = shift();
  $self->{right} = shift();

  bless($self, $class);

  return $self;
}

1;
