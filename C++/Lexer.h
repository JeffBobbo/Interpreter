#ifndef LEXER_H_INCLUDE
#define LEXER_H_INCLUDE

#include <sstream>
#include <string>
#include <iostream>

#include <cctype> // std::isalpha, std::isalnum, std::isdigit, etc
#include <stdint.h> // fixed width ints

#include "Token.h"

class Lexer
{
public:
  Lexer(std::string const& s, std::string const& f) : text(s), file(f) {
    pos = 0;
    line = 1;
    lpos = 1;
    current = text[0];
  };
  ~Lexer() {};

  // some generic stuff that might be useful
  inline std::string const& getFileName() const { return file; };

  // some error stuff
  void warning(std::string const& message) const;
  void error(std::string const& message) const;
  void println(std::stringstream& ss, uint64_t const& num, uint64_t const& pointerPos) const;
  std::string at() const;

  // string extraction and stepping through
  inline char getChar() const { return current; };
  inline char peek() const { return pos >= text.length() ? 0 : text[pos+1]; };
  void advance();
  void skipWhitespace();
private:
  Token* id();
  Token* number();
public:
  Token* nextToken();

private:
  std::string text;
  std::string file;

  uint64_t pos;
  uint64_t line;
  uint64_t lpos;
  char current;
};

void Lexer::warning(std::string const& message) const
{
  std::stringstream ss;
  ss << at() << ": warning: " << message << std::endl;
  println(ss, line, lpos);
  throw ss.str();
}

void Lexer::error(std::string const& message) const
{
  std::stringstream ss;
  ss << at() << ": error: " << message << std::endl;
  println(ss, line, lpos);
  throw ss.str();
}

void Lexer::println(std::stringstream& ss, uint64_t const& num, uint64_t const& pointerPos) const
{
  uint64_t i = 1;
  uint64_t index = 0;
  while (i < num)
  {
    index = text.find("\n", index+1)+1;
    ++i;
  }

  std::string pLine = text.substr(index, text.find("\n", index) - index);
  ss << pLine << std::endl;

  for (uint64_t i = 0; i < pointerPos-2; ++i)
    ss << ' ';
  ss << '^' << std::endl;
}

std::string Lexer::at() const
{
  std::stringstream ss;
  ss << (file.length() ? file : "STDIN") << ":" << line << ":" << lpos;
  return ss.str();
}

void Lexer::advance()
{
  ++pos;
  ++lpos;

  if (pos >= text.length())
  {
    current = 0;
  }
  else
  {
    current = text[pos];
    if (current == '\n')
    {
      ++line;
      lpos = 1;
    }
  }
}

void Lexer::skipWhitespace()
{
  while (current && std::isspace(current))
    advance();
}

Token* Lexer::id()
{
  std::string result;
  while (current && std::isalnum(current))
  {
    result += current;
    advance();
  }

  return new Token(Token::ID, result);
}

Token* Lexer::number()
{
  std::string r;
  while (current && (std::isdigit(current) || current == '.'))
  {
    r += current;
    advance();
  }
  return new Token(Token::NUMBER, r);
}

Token* Lexer::nextToken()
{
  while (current)
  {
    if (std::isspace(current))
    {
      skipWhitespace();
      continue;
    }

    if (current == '.' && (std::isdigit(peek()) || std::isdigit(current)))
    {
      return number();
    }

    if (current == '+' && peek() != '=')
    {
      advance();
      return new Token(Token::ADDITION, "+");
    }
    if (current == '-' && peek() != '=')
    {
      advance();
      return new Token(Token::SUBTRACTION, "-");
    }
    if (current == '*' && peek() != '=')
    {
      advance();
      return new Token(Token::MULTIPLICATION, "*");
    }
    if (current == '/' && peek() != '=')
    {
      advance();
      return new Token(Token::DIVISION, "/");
    }
    if (current == '*' && peek() == '*')
    {
      advance();
      advance();
      return new Token(Token::POWER, "**");
    }
    if (current == '!')
    {
      advance();
      return new Token(Token::FACTORIAL, "!");
    }

    if (current == '&' && peek() != '&')
    {
      advance();
      return new Token(Token::BITWISE_AND, "&");
    }
    if (current == '|' && peek() != '|')
    {
      advance();
      return new Token(Token::BITWISE_OR, "|");
    }
    if (current == '^')
    {
      advance();
      return new Token(Token::BITWISE_XOR, "^");
    }
    if (current == '~')
    {
      advance();
      return new Token(Token::BITWISE_NOT, "~");
    }

    if (current == '(')
    {
      advance();
      return new Token(Token::PARENTHESIS_L, "(");
    }
    if (current == ')')
    {
      advance();
      return new Token(Token::PARENTHESIS_R, ")");
    }
    if (current == '{')
    {
      advance();
      return new Token(Token::BRACE_L, "}");
    }
    if (current == '}')
    {
      advance();
      return new Token(Token::BRACE_R, "}");
    }

    if (std::isalnum(current))
    {
      return id();
    }

    if (current == '=')
    {
      advance();
      return new Token(Token::ASSIGN, "=");
    }

    if (current == ';')
    {
      advance();
      return new Token(Token::SEMICOLON, ";");
    }

    std::stringstream ss;
    ss << "unrecognized token: '" << current << "'";
    error(ss.str());
  }
  return new Token(Token::END_OF_FILE, "");
}

#endif
