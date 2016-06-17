#ifndef INTERPRETER_H_INCLUDE
#define INTERPRETER_H_INCLUDE

#include <cctype> // std::isalpha, std::isalnum, std::isdigit, etc
#include <string>
#include <cmath>
#include <map>

#include "Parser.h"
#include "Token.h"

class Interpreter
{
public:
  Interpreter(Parser* p) : parser(p), tree(nullptr) {};
  ~Interpreter() { if (tree) delete tree; delete parser; };

  inline void error(const std::string& msg) { throw std::string("Interpreter: ") + msg; };

  double visit(AST* node)
  {
    switch (node->getType())
    {
      case AST::Type::NO_OP:
        visitNoOp(/*static_cast<NoOp*>(node)*/);
      break;
      case AST::Type::OP_UNARY:
        return visitUnaryOp(static_cast<UnaryOp*>(node));
      case AST::Type::OP_BINARY:
        return visitBinaryOp(static_cast<BinaryOp*>(node));
      case AST::Type::NUMBER:
        return visitNumber(static_cast<Number*>(node));
      case AST::Type::VARIABLE:
        return visitVariable(static_cast<Variable*>(node));
      case AST::Type::COMPOUND:
        visitCompound(static_cast<Compound*>(node));
      break;
      case AST::Type::ASSIGN:
        visitAssign(static_cast<Assign*>(node));
      break;
      default:
        error(std::string("Unknown visit: ") + AST::fromType(node->getType()));
    }
    return 0.0; // may happen, but if it does we don't care
  }

  void visitNoOp(/*NoOp* node*/)
  {
    return;
  }

  double visitUnaryOp(UnaryOp* node)
  {
    if (node->tokenType() == Token::ADDITION)
      return visit(node->getNode());
    else if (node->tokenType() == Token::SUBTRACTION)
      return -visit(node->getNode());
    else if (node->tokenType() == Token::BITWISE_NOT)
      return ~static_cast<int64_t>(visit(node->getNode()));
    error("bad unary op visit");
    return 0.0; // not going to happen
  }

  double visitBinaryOp(BinaryOp* node)
  {
    switch (node->tokenType())
    {
      case Token::Type::ADDITION:
        return visit(node->getLeft()) + visit(node->getRight());
      case Token::Type::SUBTRACTION:
        return visit(node->getLeft()) - visit(node->getRight());
      case Token::Type::MULTIPLICATION:
        return visit(node->getLeft()) * visit(node->getRight());
      case Token::Type::DIVISION:
        return visit(node->getLeft()) / visit(node->getRight());
      case Token::Type::MODULO:
        return static_cast<int64_t>(visit(node->getLeft())) % static_cast<int64_t>(visit(node->getRight()));
      case Token::Type::POWER:
        return std::pow(visit(node->getLeft()), visit(node->getRight()));
      case Token::Type::BITWISE_AND:
        return static_cast<int64_t>(visit(node->getLeft())) & static_cast<int64_t>(visit(node->getRight()));
      case Token::Type::BITWISE_OR:
        return static_cast<int64_t>(visit(node->getLeft())) | static_cast<int64_t>(visit(node->getRight()));
      case Token::Type::BITWISE_XOR:
        return static_cast<int64_t>(visit(node->getLeft())) ^ static_cast<int64_t>(visit(node->getRight()));
      case Token::Type::BITSHIFT_L:
        return static_cast<int64_t>(visit(node->getLeft())) << static_cast<int64_t>(visit(node->getRight()));
      case Token::Type::BITSHIFT_R:
        return static_cast<int64_t>(visit(node->getLeft())) >> static_cast<int64_t>(visit(node->getRight()));
      default:
        error("bad binary op visit");
    }
    return 0.0; // not going to happen
  }

  double visitNumber(Number* node)
  {
    return node->getValue();
  }

  double visitVariable(Variable* node)
  {
    auto it = GLOBAL_SCOPE.find(node->getName());
    if (it == std::end(GLOBAL_SCOPE))
      error(std::string("variable used before assignment: ") + node->getName());
    return it->second;
  }

  void visitCompound(Compound* node)
  {
    for (AST* child : node->getChildren())
      visit(child);
  }

  void visitAssign(Assign* node)
  {
    GLOBAL_SCOPE[node->getName()] = visit(node->getRight());
  }

  void interpret()
  {
    tree = parser->parse();
    visit(tree);

    for (auto&& it : GLOBAL_SCOPE)
      std::cout << it.first << ": " << it.second << "\n";
  }

private:
  Parser* parser;
  AST* tree;
  std::map<std::string, double> GLOBAL_SCOPE;
};


#endif
