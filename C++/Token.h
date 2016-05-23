#ifndef TOKEN_H_INCLUDE
#define TOKEN_H_INCLUDE

#include <sstream>
#include <string>

class Token
{
public:
  enum Type
  {
    NUMBER = 0,
    ADDITION,
    SUBTRACTION,
    MULTIPLICATION,
    DIVISION,
    POWER,
    FACTORIAL,
    BITWISE_AND,
    BITWISE_OR,
    BITWISE_XOR,
    BITWISE_NOT,
    PARENTHESIS_L,
    PARENTHESIS_R,
    BRACE_L,
    BRACE_R,
    ID,
    ASSIGN,
    SEMICOLON,
    END_OF_FILE
  };

  static std::string fromType(Token::Type const& t)
  {
    switch (t)
    {
      case Token::NUMBER:
        return "NUMBER";
      break;
      case Token::ADDITION:
        return "ADDITION";
      break;
      case Token::SUBTRACTION:
        return "SUBTRACTION";
      break;
      case Token::MULTIPLICATION:
        return "MULTIPLICATION";
      break;
      case Token::DIVISION:
        return "DIVISION";
      break;
      case Token::POWER:
        return "POWER";
      break;
      case Token::FACTORIAL:
        return "FACTORIAL";
      break;
      case Token::BITWISE_AND:
        return "BITWISE_AND";
      break;
      case Token::BITWISE_OR:
        return "BITWISE_OR";
      break;
      case Token::BITWISE_XOR:
        return "BITWISE_XOR";
      break;
      case Token::BITWISE_NOT:
        return "BITWISE_NOT";
      break;
      case Token::PARENTHESIS_L:
        return "PARENTHESIS_L";
      break;
      case Token::PARENTHESIS_R:
        return "PARENTHESIS_R";
      break;
      case Token::BRACE_L:
        return "BRACE_L";
      break;
      case Token::BRACE_R:
        return "BRACE_R";
      break;
      case Token::ID:
        return "ID";
      break;
      case Token::ASSIGN:
        return "ASSIGN";
      break;
      case Token::SEMICOLON:
        return "SEMICOLON";
      break;
      case Token::END_OF_FILE:
        return "EOF";
      break;
      default:
        return "??";
      break;
    }
    return "??";
  }


  Token(Token::Types t, std::string const& v) : type(t), value(v) {};
  ~Token() {};

  template <typename T>
  friend std::ostream& operator<<(std::ostream& os, Token const& t)
  {
    os << "Token(" << fromType(t.type);
    if (t.value.length())
      os << ", " << t.value;
    os << ")";
    return os;
  }

  Token::Type const& getType() const { return type; };

  private:
    Token::Type type;
    std::string value;
};

#endif
