#include <iostream>
#include <sstream>
#include <fstream>

#include "Lexer.h"

void getInputFromStdIn(std::string& script)
{
  std::stringstream ss;
  ss << "{" << "\n";
  ss << "  a = 5 ** 2;" << "\n";
  ss << "}" << "\n";
  script = ss.str();
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

  try
  {
    std::string script;
    if (file.length() == 0)
      getInputFromStdIn(script);
    else
      readScript(script, file);

    Lexer lexer = Lexer(script, file);
    Parser parser = Parser(lexer);
  }
  catch (std::string error)
  {
    std::cerr << error << std::endl;
  }
  return 0;
}
