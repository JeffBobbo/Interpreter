#!/usr/bin/perl

package Variable;

use warnings;
use strict;

use parent 'AST';

use Exporter qw(import);
our @EXPORT = qw();

sub new
{
  my $class = shift();

  my $self = {};
  $self->{token} = shift();
  $self->{name} = $self->{token}{value};

  bless($self, $class);

  return $self;
}

1;
