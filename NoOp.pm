#!/usr/bin/perl

package NoOp;

use warnings;
use strict;

use parent 'AST';

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
