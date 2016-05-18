#!/usr/bin/perl

package Compound;

use warnings;
use strict;

use parent 'AST';

use Exporter qw(import);
our @EXPORT = qw();

sub new
{
  my $class = shift();

  my $self = {};
  $self->{children} = [];

  bless($self, $class);

  return $self;
}

1;
