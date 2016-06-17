#ifndef LEXER_H_INCLUDE
#define LEXER_H_INCLUDE

#include <string>

class Lexer
{
public:
  Lexer(const std::string& t, const std::string& f) : text(t), file(f), pos(0), current(t[0]), line(1), lpos(1) {};
  ~Lexer() {};

  std::string println(int32_t ln, int32_t lp)
  {
    int32_t i = 1;
    int32_t index = 0;
    while (i < ln)
    {
      index = text.find("\n", index+1) + 1;
      ++i;
    }
    std::string line = text.substr(index, text.find("\n", index) - index) + "\n";

    if (lp >= 0)
    {
      lp -= 1;
      for (int32_t i = 0; i < lp; ++i)
        line += " ";
      line += "^";
    }
    return line;
  }

  std::string at()
  {
    std::stringstream ss;
    if (file.length())
      ss << file;
    else
      ss << "STDIN";
     ss << ":" << line << ":" << lpos;
    return ss.str();
  }

  void warning(const std::string& msg)
  {
    std::cout << at() << ": warning: " << msg << "\n" << println(line, lpos);
  }
  void error(const std::string& msg)
  {
    throw at() + std::string(": error: ") + msg + "\n" + println(line, lpos);
  }

  void advance()
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

  char peek()
  {
    if (pos+1 >= text.length())
      return 0;
    return text[pos+1];
  }

  void skipWhitespace()
  {
    while (current && std::isspace(current))
      advance();
  }

  std::string id()
  {
    std::string name;
    while (current && std::isalnum(current))
    {
      name += current;
      advance();
    }

    return name;
  }

  double number()
  {
    std::string ret;
    while (current && std::isdigit(current))
    {
      ret += current;
      advance();
    }
    return std::stod(ret);
  }

  Token* nextToken()
  {
    while (current)
    {
      if (std::isspace(current))
      {
        skipWhitespace();
        continue;
      }
      if (std::isdigit(current))
        return new TokenNumber(number());

      if (current == '+')
      {
        advance();
        return new TokenAddition();
      }
      if (current == '-')
      {
        advance();
        return new TokenSubtraction();
      }
      if (current == '*' && peek() != '*')
      {
        advance();
        return new TokenMultiplication();
      }
      if (current == '/')
      {
        advance();
        return new TokenDivision();
      }
      if (current == '%')
      {
        advance();
        return new TokenModulo();
      }
      if (current == '*' && peek() == '*')
      {
        advance();
        advance();
        return new TokenPower();
      }
      if (current == '&')
      {
        advance();
        return new TokenBitwiseAND();
      }
      if (current == '|')
      {
        advance();
        return new TokenBitwiseOR();
      }
      if (current == '~')
      {
        advance();
        return new TokenBitwiseNOT();
      }
      if (current == '^')
      {
        advance();
        return new TokenBitwiseXOR();
      }
      if (current == '<' && peek() == '<')
      {
        advance();
        advance();
        return new TokenBitshiftL();
      }
      if (current == '>' && peek() == '>')
      {
        advance();
        advance();
        return new TokenBitshiftR();
      }
      if (current == '(')
      {
        advance();
        return new TokenParenthesisL();
      }
      if (current == ')')
      {
        advance();
        return new TokenParenthesisR();
      }
      if (current == '{')
      {
        advance();
        return new TokenBlockBegin();
      }
      if (current == '}')
      {
        advance();
        return new TokenBlockEnd();
      }
      if (current == ';')
      {
        advance();
        return new TokenSemicolon();
      }
      if (std::isalpha(current))
        return new TokenID(id());
      if (current == '=')
      {
        advance();
        return new TokenAssign();
      }

      error(std::string("unexpected character: `") + current + "`");
    }
    return new TokenEOF();
  }

private:
  std::string text;
  std::string file;
  std::string::size_type pos;
  char current;
  int32_t line;
  int32_t lpos;
};

#endif
