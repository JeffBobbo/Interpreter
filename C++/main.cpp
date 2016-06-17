#include <iostream>
#include <sstream>
#include <fstream>

#include "Token.h"
#include "Parser.h"
#include "Lexer.h"
#include "Interpreter.h"

void getInputFromStdIn(std::string& script)
{
  std::getline(std::cin, script);
}

void readScript(std::string& script, std::string const& filename)
{
  std::ifstream file(filename.c_str());
  if (file.is_open() && file.good())
  {
    std::stringstream ss;
    std::string line;
    while (std::getline(file, line))
      ss << line << "\n";
    file.close();
    script = ss.str();
  }
  else
  {
    throw std::string("failed to read script");
  }
}

int main(int argc, char** argv)
{
  std::string file;
  if (argc > 1)
    file = std::string(argv[1]);

  Interpreter* interpreter = nullptr;
  try
  {
    std::string script;
    if (file.length() == 0)
      getInputFromStdIn(script);
    else
      readScript(script, file);

    interpreter = new Interpreter(new Parser(new Lexer(script, file)));
    interpreter->interpret();
  }
  catch (std::string error)
  {
    std::cerr << error << std::endl;
  }
  if (interpreter)
    delete interpreter;
  return 0;
}
