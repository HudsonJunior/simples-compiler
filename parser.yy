/*
 * PARSER
 */

%{

/*** C++ Declarations ***/
#include "parser.hh"
#include "scanner.hh"

#define yylex driver.scanner_->yylex

%}

%code requires {
  #include <iostream>
  #include "driver.hh"
  #include "location.hh"
  #include "position.hh"
}

%code provides {
  namespace Simples  {
    // Forward declaration of the Driver class
    class Driver;

    inline void yyerror (const char* msg) {
      std::cerr << msg << std::endl;
    }
  }
}

/* Require bison 2.3 or later */
%require "2.4"
/* enable c++ generation */
%language "C++"
%locations
/* write out a header file containing the token defines */
%defines
/* add debug output code to generated parser. disable this for release
 * versions. */
%debug
/* namespace to enclose parser in */
%define api.namespace {Simples}
/* set the parser's class identificador */
%define api.parser.class {Parser}
/* set the parser */
%parse-param {Driver &driver}
/* set the lexer */
%lex-param {Driver &driver}
/* verbose error messages */
%define parse.error verbose
/* use newer C++ skeleton file */
%skeleton "lalr1.cc"
/* Entry point of grammar */
%start program

%union
{
 /* YYLTYPE */
  int  			      integerVal;
  double 			    doubleVal;
  std::string*		stringVal;
}

/* Tokens */
%token              TOK_EOF 0     "end of file"
%token			        EOL		        "end of line"
%token <integerVal> inteiro		    "inteiro"
%token <doubleVal> 	real		    "real"
%token <stringVal> 	identificador    "identificador"
%token <stringVal> 	cadeia    "cadeia"
%token <stringVal> 	comentario    "comentario"

%%

program:  /* empty */
        | constant
        | variable

constant : inteiro { std::cout << "Inteiro: " << $1 << std::endl; }
         | real  { std::cout << "Real: " << $1 << std::endl; }
         | cadeia { std::cout << "Cadeia: " << *$1 << std::endl; }
         | comentario { std::cout << "comentario: " << *$1 << std::endl; }
         
variable : identificador {  std::cout << "Identificador: " << *$1 << std::endl; }
/* 
lista_declaracoes:
           declaracao
         | lista_declaracoes declaracao */
/* 
declaracao:
           declaracao_tipo:
         | declaracao_variavel
         | declaracao_funcao */
%%

namespace Simples {
   void Parser::error(const location&, const std::string& m) {
        std::cerr << *driver.location_ << ": " << m << std::endl;
        driver.error_ = (driver.error_ == 127 ? 127 : driver.error_ + 1);
   }
}
