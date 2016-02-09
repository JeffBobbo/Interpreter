#!/usr/bin/perl

package UnaryOp;

use warnings;
use strict;

use parent 'AST';

use Exporter qw(import);
our @EXPORT = qw();

sub new
{
  my $class = shift();

  my $self = {};
  $self->{token}  = shift();
  $self->{op} = $self->{token};
  $self->{expr} = shift();

  bless($self, $class);

  return $self;
}

1;
