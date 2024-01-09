%code requires{
	#include <string>
}
%{
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <string>
#include "SyntaxTree/Includes.hpp"
#include <memory>
std::unique_ptr<compiler::SyntaxTree> root;
using namespace compiler;
std::string result; 
int yylex(void);
void yyerror(char const *);
extern char *yytext;
%}

%define api.value.type {std::string}

%token NAME COLON SEMICOLON RIGHT_ARROW LEFT_CURLY_BRACE RIGHT_CURLY_BRACE LEFT_PARENTHESIS RIGHT_PARENTHESIS 
SINGLECOMMENT MULTILINECOMMENT QUOTES PUTS NUMBER NUMBER_VALUE SET DOLLAR_SIGN INC DEC

%start input

%%

input: 
	funtion funtion_list {result = std::string("#include <stdio.h>\n #include <iostream>\n") + $1 + $2;}
	;

funtion_list:
	funtion funtion_list {$$ = $1;}
	|
	%empty {$$ = ""; }
	;

funtion:
	name COLON RIGHT_ARROW LEFT_CURLY_BRACE statements RIGHT_CURLY_BRACE 
	{	
		if ($1 == "enter")
		{
			$$ = std::string("int main(int argc, char *argv[]){ \n") + $5 + "\n}\n";
		}else {
			$$ = std::string(" void ") + "_" + $1 + "()" + "{ \n" + $5 + "\n}\n";
			}
	}
	;

statements:
	statements statement {$$ = $1 + $2;}
	|
	%empty {$$ = ""; }
	;

statement:
	unitaryOperation SEMICOLON {$$ = $1;}
	|
	assignment SEMICOLON {$$ =$1;}
	|
	definition SEMICOLON {$$ = $1;}
	|
	std_output SEMICOLON {$$ = $1;}
	|
	MULTILINECOMMENT {$$ = "";}
	|
	SINGLECOMMENT {$$ = "";}
	|
	name SEMICOLON {$$ = "\nprintf(\"%s\\n\",\"" + $1 + "\");";
			} 
			|
			expression SEMICOLON { $$ = std::move ($1);}
	;
unitaryOperation:
	INC identifiers {$$ = $2 + "++; \n";}
	|
	DEC identifiers {$$ = $2 + "--; \n";}
	;
assignment:
	SET name number_value {$$ = $2 + "=" + $3 + "; \n";}
	;
number_value:
	NUMBER_VALUE {$$ = std::string(yytext);}
	;
definition:
	NUMBER identifiers {$$ = "int " + $2 + ";\n";}
	;
identifiers:
	identifiers ids {$$ = $1 + $2;}
	|
	%empty {$$ = "";}
	;
ids:
	name {$$ = $1;}
	;
std_output:
	PUTS quotes characters_block quotes 
	{$$ = "std::cout << \"" + $3 + "\" << std::endl; \n";}
	|
	PUTS DOLLAR_SIGN name {$$ = "std::cout << " + $3 + " <<std::endl; \n";}
	;
quotes:
	QUOTES {$$ = std::string(yytext);}
	;
characters_block:
	name { $$ = $1; }
	;
expression: 
	name LEFT_PARENTHESIS RIGHT_PARENTHESIS { $$ = std::string("\n_") + $1 + "();";};
name:
	NAME	{$$ = std::string(yytext);}
	;
%%

//std::unique_ptr<compiler::SyntaxTree> root;

void yyerror(char const *x){
	printf("Error %s\n", x);
	exit(1);
}
