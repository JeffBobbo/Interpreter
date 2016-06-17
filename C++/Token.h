#ifndef TOKEN_H_INCLUDE
#define TOKEN_H_INCLUDE

#include <sstream>
#include <string>

class Token
{
public:
  enum Type
  {
    END_OF_FILE    =    0x1,
    NUMBER         =    0x2,
    ADDITION       =    0x4,
    SUBTRACTION    =    0x8,
    MULTIPLICATION =   0x10,
    DIVISION       =   0x20,
    MODULO         =   0x40,
    POWER          =   0x80,
    BITWISE_AND    =  0x100,
    BITWISE_OR     =  0x200,
    BITWISE_NOT    =  0x400,
    BITWISE_XOR    =  0x800,
    BITSHIFT_L     = 0x1000,
    BITSHIFT_R     = 0x2000,
    PARENTHESIS_L  = 0x4000,
    PARENTHESIS_R  = 0x8000,
    BLOCK_BEGIN    =0x10000,
    BLOCK_END      =0x20000,
    SEMICOLON      =0x40000,
    ID             =0x80000,
    ASSIGN         =0x100000
  };

  static std::string fromType(const Token::Type& t)
  {
    switch (t)
    {
      case Token::END_OF_FILE:
        return "EOF";
      case Token::NUMBER:
        return "NUMBER";
      case Token::ADDITION:
        return "ADDITION";
      case Token::SUBTRACTION:
        return "SUBTRACTION";
      case Token::MULTIPLICATION:
        return "MULTIPLICATION";
      case Token::DIVISION:
        return "DIVISION";
      case Token::MODULO:
        return "MODULO";
      case Token::POWER:
        return "POWER";
      case Token::BITWISE_AND:
        return "BITWISE_AND";
      case Token::BITWISE_OR:
        return "BITWISE_OR";
      case Token::BITWISE_NOT:
        return "BITWISE_NOT";
      case Token::BITWISE_XOR:
        return "BITWISE_XOR";
      case Token::BITSHIFT_L:
        return "BITSHIFT_L";
      case Token::BITSHIFT_R:
        return "BITSHIFT_R";
      case Token::PARENTHESIS_L:
        return "PARENTHESIS_L";
      case Token::PARENTHESIS_R:
        return "PARENTHESIS_R";
      case Token::BLOCK_BEGIN:
        return "BLOCK_BEGIN";
      case Token::BLOCK_END:
        return "BLOCK_END";
      case SEMICOLON:
        return "SEMICOLON";
      case ID:
        return "ID";
      case ASSIGN:
        return "ASSIGN";
    }
    return "??";
  }


  Token() {};
  virtual ~Token() {};

  virtual Token::Type getType() const = 0;

  template <typename T>
  friend std::ostream& operator<<(std::ostream& os, const Token& t)
  {
    t.print(os);
    return os;
  }

protected:
  virtual void print(std::ostream& os) const
  {
    os << "Token(" << fromType(getType()) << ")";
  }
};

class TokenEOF : public Token
{
public:
  TokenEOF() {};
  virtual ~TokenEOF() {};

  virtual Token::Type getType() const { return END_OF_FILE; };
};


class TokenNumber : public Token
{
public:
  TokenNumber(const double v) : value(v) {};
  virtual ~TokenNumber() {};

  virtual Token::Type getType() const { return NUMBER; };
  inline const double& getValue() const { return value; };
private:
  virtual void print(std::ostream& os) const
  {
    os << "Token(" << fromType(getType()) << ", " << value << ")";
  }
  double value;
};

class TokenAddition : public Token
{
public:
  TokenAddition() {};
  virtual ~TokenAddition() {};

  virtual Token::Type getType() const { return ADDITION; };
};

class TokenSubtraction : public Token
{
public:
  TokenSubtraction() {};
  virtual ~TokenSubtraction() {};

  virtual Token::Type getType() const { return SUBTRACTION; };
};

class TokenMultiplication : public Token
{
public:
  TokenMultiplication() {};
  virtual ~TokenMultiplication() {};

  virtual Token::Type getType() const { return MULTIPLICATION; };
};

class TokenDivision : public Token
{
public:
  TokenDivision() {};
  virtual ~TokenDivision() {};

  virtual Token::Type getType() const { return DIVISION; };
};

class TokenModulo : public Token
{
public:
  TokenModulo() {};
  virtual ~TokenModulo() {};

  virtual Token::Type getType() const { return MODULO; };
};

class TokenPower : public Token
{
public:
  TokenPower() {};
  virtual ~TokenPower() {};

  virtual Token::Type getType() const { return POWER; };
};

class TokenBitwiseAND : public Token
{
public:
  TokenBitwiseAND() {};
  virtual ~TokenBitwiseAND() {};

  virtual Token::Type getType() const { return BITWISE_AND; };
};

class TokenBitwiseOR : public Token
{
public:
  TokenBitwiseOR() {};
  virtual ~TokenBitwiseOR() {};

  virtual Token::Type getType() const { return BITWISE_OR; };
};

class TokenBitwiseNOT : public Token
{
public:
  TokenBitwiseNOT() {};
  virtual ~TokenBitwiseNOT() {};

  virtual Token::Type getType() const { return BITWISE_NOT; };
};

class TokenBitwiseXOR : public Token
{
public:
  TokenBitwiseXOR() {};
  virtual ~TokenBitwiseXOR() {};

  virtual Token::Type getType() const { return BITWISE_XOR; };
};

class TokenBitshiftL : public Token
{
public:
  TokenBitshiftL() {};
  virtual ~TokenBitshiftL() {};

  virtual Token::Type getType() const { return BITSHIFT_L; };
};

class TokenBitshiftR : public Token
{
public:
  TokenBitshiftR() {};
  virtual ~TokenBitshiftR() {};

  virtual Token::Type getType() const { return BITSHIFT_R; };
};

class TokenParenthesisL : public Token
{
public:
  TokenParenthesisL() {};
  virtual ~TokenParenthesisL() {};

  virtual Token::Type getType() const { return PARENTHESIS_L; };
};

class TokenParenthesisR : public Token
{
public:
  TokenParenthesisR() {};
  virtual ~TokenParenthesisR() {};

  virtual Token::Type getType() const { return PARENTHESIS_R; };
};

class TokenBlockBegin : public Token
{
public:
  TokenBlockBegin() {};
  virtual ~TokenBlockBegin() {};

  virtual Token::Type getType() const { return BLOCK_BEGIN; };
};

class TokenBlockEnd : public Token
{
public:
  TokenBlockEnd() {};
  virtual ~TokenBlockEnd() {};

  virtual Token::Type getType() const { return BLOCK_END; };
};

class TokenSemicolon : public Token
{
public:
  TokenSemicolon() {};
  virtual ~TokenSemicolon() {};

  virtual Token::Type getType() const { return SEMICOLON; };
};

class TokenID : public Token
{
public:
  TokenID(const std::string& n) : name(n) {};
  ~TokenID() {};

  virtual Token::Type getType() const { return ID; };
  const std::string& getName() const { return name; };
private:
  virtual void print(std::ostream& os) const
  {
    os << "Token(" << fromType(getType()) << ", " << name << ")";
  }

  std::string name;
};

class TokenAssign : public Token
{
public:
  TokenAssign() {};
  virtual ~TokenAssign() {};

  virtual Token::Type getType() const { return ASSIGN; };
};


#endif
