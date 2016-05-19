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
  $self->{file} = shift();
  $self->{pos} = 0;
  $self->{line} = 1;
  $self->{lpos} = 1;
  $self->{char} = substr($self->{text}, $self->{pos}, 1);

  bless($self, $class);
  return $self;
}

sub warning
{
  my $self = shift();
  my $message = shift();

  print $self->at() . ': warning: ' . $message . "\n";
  $self->println($self->{line}, $self->{lpos});
}

sub error
{
  my $self = shift();
  my $message = shift();

  print $self->at() . ': error: ' . $message . "\n";
  $self->println($self->{line}, $self->{lpos});
  exit();
}

sub println
{
  my $self = shift();
  my $num = shift();

  my $pointerPos = shift();

  my $i = 1;
  my $index = 0;
  while ($i < $num)
  {
    $index = index($self->{text}, "\n", $index+1) + 1;
    $i++;
  }
  my $line = substr($self->{text}, $index, index($self->{text}, "\n", $index) - $index);
  print $line . "\n";

  if (defined($pointerPos))
  {
    $pointerPos -= 2; # take 1 for 1 index, another to fit the claret in
    print ' ' x $pointerPos if ($pointerPos > 0);
    print "^\n";
  }
}

# return what the next character is, without incrementing our position
sub peek
{
  my $self = shift();
  my $pos = $self->{pos} + 1;
  if ($pos >= length($self->{text}))
  {
    return undef;
  }
  return substr($self->{text}, $pos, 1);
}

sub at
{
  my $self = shift();
  return $self->{file} . ':' . $self->{line} . ':' . $self->{lpos};
}

# advance the pos pointer and set char to the next character to parse
sub advance
{
  my $self = shift();

  $self->{pos}++;
  $self->{lpos}++;

  if ($self->{pos} >= length($self->{text}))
  {
    $self->{char} = undef;
  }
  else
  {
    $self->{char} = substr($self->{text}, $self->{pos}, 1);
    if ($self->{char} eq "\n")
    {
      $self->{line}++;
      $self->{lpos} = 1;
    }
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

sub _id
{
  my $self = shift();

  my $result = '';
  while (defined $self->{char} && $self->{char} =~ /^[\w]$/)
  {
    $result .= $self->{char};
    $self->advance();
  }

  my $reserved = {
    BLOCK_BEGIN => Token->new(BLOCK_BEGIN),
    BLOCK_END   => Token->new(BLOCK_END)
  };

  return $reserved->{$result} || Token->new(ID, $result);
}

# parse a multidigit, floating point number out
sub number
{
  my $self = shift();
  my $r = '';
  while (defined $self->{char} && $self->{char} =~ /\d|(?:\d?\.\d?)/)
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

    if (($self->{char} eq '.' && $self->peek() =~ /\d/) || $self->{char} =~ /\d/)
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
    if ($self->{char} eq '{')
    {
      $self->advance();
      return Token->new(BLOCK_BEGIN, '{');
    }
    if ($self->{char} eq '}')
    {
      $self->advance();
      return Token->new(BLOCK_END, '}');
    }
    if ($self->{char} =~ /^[\w]$/)
    {
      return $self->_id();
    }
    if ($self->{char} eq '=')
    {
      $self->advance();
      return Token->new(ASSIGN, '=');
    }
    if ($self->{char} eq ';')
    {
      $self->advance();
      return Token->new(SEMICOLON, ';');
    }
    if ($self->{char} eq '.')
    {
      $self->advance();
      return Token->new(PERIOD, '.');
    }

    # not returned anything but we're not at the end of the stream, so error out
    $self->error("unrecognized token: '" . $self->{char} . "'");
  }
  return Token->new(EOF, undef);
}

1;
