#ifndef AST_H_INCLUDE
#define AST_H_INCLUDE

#include "Token.h"
#include <vector>

class AST
{
public:
  enum Type
  {
    NO_OP = 0,
    OP_UNARY,
    OP_BINARY,
    NUMBER,
    VARIABLE,
    COMPOUND,
    ASSIGN
  };

  static std::string fromType(const AST::Type& t)
  {
    switch (t)
    {
      case AST::NO_OP:
        return "NO_OP";
      case AST::OP_UNARY:
        return "UNARY OP";
      case AST::OP_BINARY:
        return "BINARY OP";
      case AST::NUMBER:
        return "NUMBER";
      case AST::VARIABLE:
        return "VARIABLE";
      case AST::COMPOUND:
        return "COMPOUND";
      case AST::ASSIGN:
        return "ASSIGN";
    }
    return "??";
  }

  AST() {};
  virtual ~AST() {};

  virtual AST::Type getType() const = 0;
};

class NoOp : public AST
{
public:
  NoOp() {};
  ~NoOp() {};

  virtual AST::Type getType() const { return AST::NO_OP; };
};

class UnaryOp : public AST
{
public:
  UnaryOp(Token* o, AST* n) : op(o), node(n) {};
  ~UnaryOp() { delete op; delete node; };

  virtual AST::Type getType() const { return AST::OP_UNARY; };
  inline Token::Type tokenType() const { return op->getType(); };
  inline AST* const& getNode() const { return node; };
private:
  Token* op;
  AST* node;
};

class BinaryOp : public AST
{
public:
  BinaryOp(AST* l, Token* o, AST* r) : left(l), op(o), right(r) {};
  virtual ~BinaryOp() { delete left; delete op; delete right; };

  virtual AST::Type getType() const { return AST::OP_BINARY; };
  inline Token::Type tokenType() const { return op->getType(); };
  inline AST* const& getLeft() const { return left; };
  inline AST* const& getRight() const { return right; };
private:
  AST* left;
  Token* op;
  AST* right;
};

class Number : public AST
{
public:
  Number(Token* t) { token = static_cast<TokenNumber*>(t); };
  ~Number() { delete token; };

  virtual AST::Type getType() const { return AST::NUMBER; };

  double getValue() const { return token->getValue(); };
private:
  TokenNumber* token;
};

class Variable : public AST
{
public:
  Variable(Token* t) { token = static_cast<TokenID*>(t); };
  ~Variable() {};

  virtual AST::Type getType() const { return AST::VARIABLE; };
  const std::string& getName() const { return token->getName(); };
private:
  TokenID* token;
};

class Compound : public AST
{
public:
  Compound() {};
  ~Compound() { for (AST* c : children) delete c; };

  virtual AST::Type getType() const { return AST::COMPOUND; };

  void add(AST* node) { children.push_back(node); };
  const std::vector<AST*>& getChildren() const { return children; };
private:
  std::vector<AST*> children;
};

class Assign : public AST
{
public:
  Assign(Variable* v, Token* o, AST* r) : variable(v), op(o), right(r) {};
  ~Assign() { delete variable; delete op; delete right; };

  virtual AST::Type getType() const { return AST::ASSIGN; };
  const std::string& getName() const { return variable->getName(); };
  AST* const& getRight() const { return right; };
private:
  Variable* variable;
  Token* op;
  AST* right;
};

#endif
