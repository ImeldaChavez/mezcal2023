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
SINGLECOMMENT MULTILINECOMMENT QUOTES PUTS NUMBER NUMBER_VALUE SET DOLLAR_SIGN INC DEC LOGICAL TRUE FALSE NTOL
GET STDIN CHARACTERS_BLOCK IF GT LT QUESTION_MARK EXCLAMATION_SYMBOL FI

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
	bifurcation { $$ = $1; }
	|
	std_input SEMICOLON { $$ = $1; }
	|
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
	;
bifurcation:
	IF LEFT_PARENTHESIS logicalComparison RIGHT_PARENTHESIS QUESTION_MARK statements EXCLAMATION_SYMBOL statements 
	FI
	{ $$ = "if(" + $3 + "){\n" + $6 + "} else {" + $8 + "\n}\n";}
	|
	IF LEFT_PARENTHESIS logicalComparison RIGHT_PARENTHESIS QUESTION_MARK statements
	{ $$ = "if(" + $3 + "){\n" + $6 + "\n}\n";}
	;
logicalComparison:
	DOLLAR_SIGN name logicalOperator DOLLAR_SIGN name { $$ = $2 + $3 + $5;}
	| 
	number_value logicalOperator number_value { $$ = $1 + $2 + $3;}
	|
	number_value logicalOperator DOLLAR_SIGN name { $$ = $1 + $2 + $4;}
	|
	DOLLAR_SIGN name logicalOperator number_value { $$ = $2 + $3 + $4;} 
	;
logicalOperator:
	GT { $$ = ">";}
	LT { $$ = "<";}
	;
std_input:
	GET STDIN name { $$ = "std::cin >> " + $3 + ";\n"; }
	;
unitaryOperation:
	INC identifiers {$$ = $2 + "++; \n";}
	|
	DEC identifiers {$$ = $2 + "--; \n";}
	;
assignment:
	SET name DOLLAR_SIGN name { $$ = $2 + "=" + $4 + ";"; }
	|
	SET name number_value {$$ = $2 + "=" + $3 + "; \n";}
	|
	SET name TRUE {$$ = $2 + "= true;\n";}
	|
	SET name FALSE {$$ = $2 + "= false;\n";}
	;
number_value:
	NUMBER_VALUE {$$ = std::string(yytext);}
	;
definition:
	LOGICAL identifiers {$$ = "bool " + $2 + ";\n";}
	|

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
	PUTS NTOL DOLLAR_SIGN name {$$ = "std::cout << ((" + $4 + "==1) ? \"TRUE\" : \"FALSE\") << std::endl;";}
	|
	PUTS characters_block { $$ = "std::cout << " + $2 + " << std::endl;\n"; }
	|
	PUTS DOLLAR_SIGN name {$$ = "std::cout << " + $3 + " <<std::endl; \n";}
	;
characters_block:
	CHARACTERS_BLOCK { $$ = std::string(yytext); }
	;
name:
	NAME	{$$ = std::string(yytext);}
	;
%%

//std::unique_ptr<compiler::SyntaxTree> root;

void yyerror(char const *x){
	printf("Error %s\n", x);
	exit(1);
}
