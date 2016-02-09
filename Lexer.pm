#!/usr/bin/perl

package Lexer;

use warnings;
use strict;

use Exporter qw(import);
our @EXPORT = qw();

use Carp;

use Token;

sub new
{
  my $class = shift();

  my $self = {};
  $self->{text} = shift();
  $self->{pos} = 0;
  $self->{char} = substr($self->{text}, $self->{pos}, 1);

  bless($self, $class);
  return $self;
}

sub error
{
  my $self = shift();
  my $message = shift();

  croak("Lexer: $message");
}

# advance the pos pointer and set char to the next character to parse
sub advance
{
  my $self = shift();

  $self->{pos}++;

  if ($self->{pos} >= length($self->{text}))
  {
    $self->{char} = undef;
  }
  else
  {
    $self->{char} = substr($self->{text}, $self->{pos}, 1);
  }
}

# skip over any whitespace using advance()
sub skipWhitespace
{
  my $self = shift();

  while (defined $self->{char} && $self->{char} =~ /\s/)
  {
    $self->advance();
  }
}

# parse a multidigit, floating point number out
sub number
{
  my $self = shift();
  my $r = '';
  while (defined $self->{char} && $self->{char} =~ /[\d\.]/)
  {
    $r .= $self->{char};
    $self->advance();
  }
  return $r;
}

# lexical analyser
sub nextToken
{
  my $self = shift();

  while (defined $self->{char})
  {
    if ($self->{char} =~ /\s/)
    {
      $self->skipWhitespace();
      next;
    }

    if ($self->{char} =~ /[\d\.]/)
    {
      return Token->new(NUMBER, $self->number());
    }

    if ($self->{char} eq '+')
    {
      $self->advance();
      return Token->new(ADDITION, '+');
    }
    if ($self->{char} eq '-')
    {
      $self->advance();
      return Token->new(SUBTRACTION, '-');
    }

    if ($self->{char} eq '*')
    {
      $self->advance();
      return Token->new(MULTIPLY, '*');
    }
    if ($self->{char} eq '/')
    {
      $self->advance();
      return Token->new(DIVIDE, '/');
    }

    if ($self->{char} eq '^')
    {
      $self->advance();
      return Token->new(POWER, '^');
    }

    if ($self->{char} eq '!')
    {
      $self->advance();
      return Token->new(FACTORIAL, '!');
    }

    if ($self->{char} eq '(')
    {
      $self->advance();
      return Token->new(L_PARENTHESIS, '(');
    }
    if ($self->{char} eq ')')
    {
      $self->advance();
      return Token->new(R_PARENTHESIS, ')');
    }

    # not returned anything but we're not at the end of the stream, so error out
    $self->error("Unknown token: " . $self->{char});
  }
  return Token->new(EOF, undef);
}

1;
