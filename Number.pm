#!/usr/bin/perl

package Number;

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
  $self->{value} = $self->{token}->{value};

  bless($self, $class);

  return $self;
}

1;
