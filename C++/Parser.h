#ifndef PARSER_H_INCLUDE
#define PARSER_H_INCLUDE

class Parser
{
public:
  Parser(Lexer const& l) : lexer(l) { token = lexer.nextToken()); };
  ~Parser() {};

  void warning(std::string const& message) { lexer.warning(message); };
  void error(std::string const& message) { lexer.error(message); };

  void eat(Token::Type t);

private:
  Lexer lexer;
  Token token;
};

void Parser::eat(Token::Type t)
{
  if (token.getType() == t)
    token = lexer.nextToken();
  else
    error("expected " + Token::fromType(t) + ", got " + Token::fromType(token.getType()));
}

AST* Parser::factor()
{
  switch (token.getType())
  {
    case Token::NUMBER:
      eat(Token::NUMBER);
      return new Number(token);
    break;
    case Token::ADDITION;
      eat(Token::ADDITION);
      return new UnaryOp(token, factor());
    break;
    case Token::SUBTRACTION;
      eat(Token::SUBTRACTION);
      return new UnaryOp(token, factor());
    break;
    case Token::BITWISE_NOT;
      eat(Token::BITWISE_NOT);
      return new UnaryOp(token, factor());
    break;
    case Token::PARENTHESIS_L;
      eat(Token::PARENTHESIS_L);
      AST const* const node = expr();
      eat(Token::PARENTHESIS_R);
      return node;
    break;
    default:
      return variable();
    break;
  }
  return nullptr;
}


#endif
