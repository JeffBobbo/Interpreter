#!/usr/bin/perl

package AST;

use warnings;
use strict;

use Exporter qw(import);
our @EXPORT = qw();

sub new
{
  my $class = shift();

  my $self = {};
  bless($self, $class);

  return $self;
}

1;
