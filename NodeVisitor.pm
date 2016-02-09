#!/usr/bin/perl

package NodeVisitor;

use warnings;
use strict;

use Carp;

use Exporter qw(import);
our @EXPORT = qw();


my $visits = {
  visitNumber  => \&visitNumber,
  visitBinOp   => \&visitBinOp,
  visitGeneric => \&visitGeneric
};


use Data::Dumper;
sub visit
{
  my $self = shift();
  my $node = shift();

  my $methodName = "visit" . ref($node);
  print "$methodName\n";
  my $visitor = $visits->{$methodName} || $visits->{visitGeneric};
  return $visitor->($node);
}

sub visitGeneric
{
  my $self = shift();
  my $node = shift();

  croak("No visit")
}

sub visitNumber
{
  croak("wrong class")
}
sub visitBinOp
{
  croak("wrong class");
}

1;
