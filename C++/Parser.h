#ifndef PARSER_H_INCLUDE
#define PARSER_H_INCLUDE

#include <string>

#include "Lexer.h"
#include "Token.h"
#include "AST.h"

class Parser
{
public:
  Parser(Lexer* l) : lexer(l) { token = lexer->nextToken(); };
  ~Parser() {if (token) delete token; delete lexer; };

  void warning(const std::string& msg)
  {
    lexer->warning(msg);
  }
  void error(const std::string& msg)
  {
    lexer->error(msg);
  }

  void eat(const Token::Type& type)
  {
    if (token->getType() == type)
      token = lexer->nextToken();
    else
      error(std::string("expected ") + Token::fromType(type) + " got " + Token::fromType(token->getType()));
  }

  // factor : (ADDITION | SUBTRACTION) factor
  //        | NUMBER
  //        | PARENTHESIS_L expr PARENTHESIS_R
  //        | variable
  AST* factor()
  {
    AST* node = nullptr;
    if (token->getType() & (Token::ADDITION|Token::SUBTRACTION|Token::BITWISE_NOT))
    {
      Token* op = token;
      eat(token->getType());
      node = new UnaryOp(op, factor());
    }
    if (token->getType() == Token::NUMBER)
    {
      node = new Number(token);
      eat(Token::NUMBER);
    }
    else if (token->getType() == Token::PARENTHESIS_L)
    {
      eat(Token::PARENTHESIS_L);
      node = expr();
      eat(Token::PARENTHESIS_R);
    }
    else
    {
      node = variable();
    }
    return node;
  }

  AST* power()
  {
    AST* node = factor();
    while (token->getType() == Token::POWER)
    {
      Token* op = token;
      eat(token->getType());
      node = new BinaryOp(node, op, factor());
    }
    return node;
  }

  // term : factor ((MULTIPLICATION | DIVISION) factor)*
  AST* term()
  {
    AST* node = power();
    while (token->getType() & (Token::MULTIPLICATION|Token::DIVISION|Token::MODULO))
    {
      Token* op = token;
      eat(token->getType());
      node = new BinaryOp(node, op, power());
    }
    return node;
  }

  // expr : term ((ADDITION | SUBTRACTION) term)*
  // term : factor ((MULTIPLICATION | DIVISION) factor)*
  // factor: NUMBER | PARENTHESIS_L expr PARENTHESIS_R
  AST* expr()
  {
    AST* node = term();
    const int64_t target = (Token::ADDITION |
                      Token::SUBTRACTION |
                      Token::BITWISE_AND |
                      Token::BITWISE_OR |
                      Token::BITWISE_XOR |
                      Token::BITSHIFT_L |
                      Token::BITSHIFT_R);
    while (token->getType() & target)
    {
      Token* op = token;
      eat(token->getType());
      node = new BinaryOp(node, op, term());
    }
    return node;
  }

  Variable* variable()
  {
    Variable* v = new Variable(token);
    eat(Token::ID);
    return v;
  }

  AST* assignment_statement()
  {
    Variable* v = variable();
    Token* t = token;
    eat(Token::ASSIGN);
    AST* r = expr();
    return new Assign(v, t, r);
  }

  AST* statement()
  {
    if (token->getType() == Token::BLOCK_BEGIN)
      return compound_statement();
    else if (token->getType() == Token::ID)
      return assignment_statement();
    if (token->getType() != Token::BLOCK_END)
      error("void expression");
    return new NoOp();
  }

  void statement_list(std::vector<AST*>& statements)
  {
    statements.push_back(statement());
    while (statements.back()->getType() == AST::COMPOUND || token->getType() == Token::SEMICOLON)
    {
      if (statements.back()->getType() != AST::COMPOUND)
        eat(Token::SEMICOLON);
      statements.push_back(statement());
    }
  }

  AST* compound_statement()
  {
    eat(Token::BLOCK_BEGIN);
    std::vector<AST*> nodes;
    statement_list(nodes);
    eat(Token::BLOCK_END);

    Compound* root = new Compound();
    for (AST* node : nodes)
      root->add(node);
    return root;
  }

  AST* program()
  {
    return compound_statement();
  }

  AST* parse()
  {
    AST* node = program();
    if (token->getType() != Token::END_OF_FILE)
      error("unexpected end of input");
    return node;
  }

private:
  Lexer* lexer;
  Token* token;
};

#endif
