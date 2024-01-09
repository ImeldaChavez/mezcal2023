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
SINGLECOMMENT MULTILINECOMMENT QUOTES DOLLAR_SIGN NTOL CHARACTERS_BLOCK EXCLAMATION_SYMBOL
SIG_MENOR SIG_MAYOR MAS MENOS MULT IF ELSE ARROBA LOAD SHOW INT DEC BLN STR TRU FLS ANSWER_CERO EQUAL DOBLE_EQUAL
DOBLE_COLON LEFT_CORCH RIGHT_CORCH MY MN MYE MNE DIF INCREMENTO DECREMENTO SLASH SLASHIN COMA NUMBER_VALUE DECIMAL_VALUE 

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
	name DOBLE_COLON LEFT_CORCH RIGHT_CORCH RIGHT_ARROW LEFT_CORCH INT RIGHT_CORCH
	COLON LEFT_CURLY_BRACE statements RIGHT_CURLY_BRACE 
	{	
		if ($1 == "main")
		{
			$$ = std::string("int main(int argc, char *argv[]){ \n") + $11 + "\n}\n";
		}else {
			$$ = std::string(" void ") + "_" + $1 + "()" + "{ \n" + $11 + "\n}\n";
			}
	}
	;


statements:
	statements statement {$$ = $1 + $2;}
	|
	%empty {$$ = ""; }
	;


statement:
	ANSWER_CERO { $$ = "return 0;"; }
	|
	bifurcation { $$ = $1; }
	|
	loops { $$ = $1; }
	|
	std_input SEMICOLON { $$ = $1; }
	|
	unitaryOperation SEMICOLON {$$ = $1 + ";\n";}
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

loops:
	LEFT_CORCH logicalComparison RIGHT_CORCH ARROBA LEFT_CURLY_BRACE statements RIGHT_CURLY_BRACE 
	{ $$ = "while(" + $2 + "){\n" + $6 + "}\n"; }
	|
	LEFT_CORCH name COLON number_value SLASHIN logicalComparison SLASHIN unitaryOperation RIGHT_CORCH ARROBA
	LEFT_CURLY_BRACE statements RIGHT_CURLY_BRACE 
	{ $$ = "for(int" + $2 + "=" + $4 + ";" + $6 + ";" + $8 "){\n" + $12 + "}\n"; }
	;

bifurcation:
	LEFT_CORCH logicalComparison RIGHT_CORCH IF LEFT_CURLY_BRACE statements RIGHT_CURLY_BRACE
	{ $$ = "if(" + $2 + "){\n" + $6 + "}\n"; }
	|
	LEFT_CORCH logicalComparison RIGHT_CORCH IF LEFT_CURLY_BRACE statements RIGHT_CURLY_BRACE 
	ELSE LEFT_CURLY_BRACE statements RIGHT_CURLY_BRACE 
	{ $$ = "if(" +$2 + "){\n" $6 + "}\n" +  "else{\n" + $10 + "}\n"; }
	|
	LEFT_CORCH logicalComparison RIGHT_CORCH IF LEFT_CURLY_BRACE statements RIGHT_CURLY_BRACE 
	LEFT_CORCH logicalComparison RIGHT_CORCH IF LEFT_CURLY_BRACE statements RIGHT_CURLY_BRACE 
	ELSE LEFT_CURLY_BRACE statements RIGHT_CURLY_BRACE
	{ $$ = "if(" + $2 +  "){\n" + $6 + "}\n" + "if(" + $9 + "){\n" + $13 "}\n" + "else(" + $17 + "}\n";  }
	;


logicalComparison:
	DOLLAR_SIGN name LEFT_CORCH DOLLAR_SIGN name RIGHT_CORCH logicalOperator DOLLAR_SIGN name 
	{ $$ = $2 + "[" + $5 "]" + $7 + $9;}
	| 
	DOLLAR_SIGN name LEFT_CORCH DOLLAR_SIGN name RIGHT_CORCH logicalOperator
	DOLLAR_SIGN name LEFT_CORCH DOLLAR_SIGN name RIGHT_CORCH 
	{ $$ = $2 + "[" + $5 + "]" + $7 +  $9 + "[" + $12 + "]"; }
	|
	number_value logicalOperator number_value { $$ = $1 + $2 + $3;}
	|
	DOLLAR_SIGN name logicalOperator number_value { $$ = $2 + $3 + $4; }
	| 
	number_value logicalOperator DOLLAR_SIGN name { $$ = $1 + $2 + $4;}
	|
	DOLLAR_SIGN name logicalOperator DOLLAR_SIGN name { $$ = $2 + $3 + $5;} 
	;

logicalOperator:
	EQUAL { $$ = "="; }
	|
	MY { $$ = ">"; }
	|
	MYE { $$ = ">="; }
	|
	MN { $$ = "<"; }
	|
	MNE { $$ = "<="; }
	|
	DIF { $$ = "!="; }
	;


std_input:
	LOAD COLON name { $$ = "std::cin >> " + $3 + ";\n"; }
	;


unitaryOperation:
	name INCREMENTO number_value {$$ = $2 + "+=" + $3; }
	|
	name DECREMENTO number_value {$$ = $2 + "-=" + $3; }
	;


assignment:
	name COLON DOLLAR_SIGN name MULT number_value
	{ $$ = $1 + "=" + "(int)" + $4 + "*" + $6 + ";\n"; }
	|
	name COLON DOLLAR_SIGN name SLASH decimal_value
	{ $$ = $1 + "=" + "(float)" + $4 + "/" + $6 + ";\n"; }
	|
	name COLON LEFT_CORCH number_value COMA number_value RIGHT_CORCH
	{ $$ = $1 + "[" + $4 + "]" + "=" + $6 + ";\n"; }
	|
	name COLON LEFT_CORCH DOLLAR_SIGN name COMA DOLLAR_SIGN name RIGHT_CORCH
	{ $$ = $1 + "[" + $5 + "]" + "=" + $8 + ";\n"; }
	|
	name COLON LEFT_CORCH number_value COMA DOLLAR_SIGN name RIGHT_CORCH
	{ $$ = $1 + "[" + $4 + "]" + "=" + $7 + ";\n"; }	
	|
	name COLON LEFT_CORCH DOLLAR_SIGN name COMA number_value RIGHT_CORCH 
	{ $$ = $1 + "[" + $5 + "]" + "=" + $7 + ";\n"; }
	|
	name COLON DOLLAR_SIGN name LEFT_CORCH number_value RIGHT_CORCH
	{ $$ = $1 + "=" + $4 + "[" + $6 + "]" + ";\n"; }
	|
	name COLON DOLLAR_SIGN name LEFT_CORCH DOLLAR_SIGN name RIGHT_CORCH
	{ $$ = $1 + "=" + $4 + "[" + $7 + "]" + ";\n"; }
	|
	name LEFT_CORCH DOLLAR_SIGN name RIGHT_CORCH COLON DOLLAR_SIGN name LEFT_CORCH DOLLAR_SIGN name RIGHT_CORCH
	{ $$ = $1 + "[" + $4 + "]" + "=" + $8 + "[" + $11 + "]" + ";\n"; }
	|
	name LEFT_CORCH DOLLAR_SIGN name RIGHT_CORCH COLON DOLLAR_SIGN name	
	{ $$ = $1 + "[" + $4 + "]" + "=" + $8 + ";\n"; }
	|
	name LEFT_CORCH DOLLAR_SIGN name RIGHT_CORCH COLON number_value
	{ $$ = $1 + "[" + $4 "]" + "=" + $7 ";\n"; }
	|
	name LEFT_CORCH DOLLAR_SIGN name RIGHT_CORCH INCREMENTO number_value
	{ $$ = $1 + "[" + $4 + "]" + "+=" + $7 + ";\n"; }
	|
	name LEFT_CORCH DOLLAR_SIGN name RIGHT_CORCH DECREMENTO number_value
	{ $$ = $1 + "[" + $4 + "]" + "-=" + $7 + ";\n"; }
	|
	name INCREMENTO DOLLAR_SIGN name LEFT_CORCH DOLLAR_SIGN name RIGHT_CORCH
	{ $$ = $1 + "+=" + $4 + "[" + $7 + "]" + ";\n"; }
	|
	name DECREMENTO DOLLAR_SIGN name LEFT_CORCH DOLLAR_SIGN name RIGHT_CORCH
	{ $$ = $1 + "-=" + $4 + "[" + $7 + "]" + ";\n"; }
	|
	name COLON FLS
	{ $$ = $1 + "=false; \n"; }
	|
	name COLON TRU
	{ $$ = $1 + "=true; \n"; }
	|
	name COLON number_value
	{ $$ = $1 + "=" + $3 + ";\n"; }
	|
	name COLON decimal_value
	{ $$ = $1 + "=" + $3 + ";\n"; }
	|
	name COLON characters_block
	{ $$ = $1 + "=" + $3 + ";\n"; }
	|
	name COLON DOLLAR_SIGN name 
	{ $$ = $1 + "=" + $4 + ";\n"; }
	|
	name COLON DOLLAR_SIGN name MULT number_value
	{$$ = $1 + "=" + $4 + "*" + $6 + ";\n"; }
	|
	name COLON DOLLAR_SIGN name MAS number_value
	{ $$ = $1 + "=" + $4 + "+" + $6 + ";\n"; }
	|
	name COLON DOLLAR_SIGN name MENOS number_value
	{ $$ = $1 + "=" + $4 + "-" + $6 + ";\n"; }
	;


number_value:
	NUMBER_VALUE {$$ = std::string(yytext);}
	;


decimal_value:
	DECIMAL_VALUE { $$ = std::string(yytext); }
	;


definition:
	name COLON INT LEFT_CORCH number_value RIGHT_CORCH
	{ $$ = "int" + $1 + "[" + $5 + "]';\n"; }
	|
	name COLON INT LEFT_CORCH DOLLAR_SIGN name RIGHT_CORCH 
	{ $$ = "int" $1 + "[" + $6 + "];\n"; }
	|
	name DOBLE_COLON BLN 
	{ $$ = "\t bool " + $1 + ";\n"; }
	|
	name DOBLE_COLON INT 
	{ $$ = "\t int " + $1 + ";\n"; }
	|
	name COMA name COMA name COLON INT 
	{ $$ = "\t int " + $1 + "," + $3 + "," + $5 + ";\n"; }
	|
	name DOBLE_COLON STR 
	{ $$ = "\t string" + $1 + ";\n"; }
	|
	name DOBLE_COLON DEC 
	{ $$ = "\t float" + $1 + ";\n"; }
	;



std_output:
	SHOW COLON NTOL DOLLAR_SIGN name
	{$$ = "std::cout << ((" + $5 + "==1) ? \"true\" : \"false\") << std::endl; \n ";}
	|
	SHOW COLON characters_block
	{ $$ = "std::cout << " + $3 + " << std::endl; \n"; }
	|
	SHOW COLON DOLLAR_SIGN name
	{$$ = "std::cout << " + $4 + " <<std::endl; \n"; }
	|
	SHOW COLON characters_block COMA DOLLAR_SIGN name
	{ $$ = "std::cout <<" + $3 + $6 "<<std::endl; \n"; }
	|
	SHOW COLON characters_block COMA DOLLAR_SIGN name COMA characters_block
	{ $$ = "std::cout <<" + $3 + $6 + $8 + "<<std::endl; \n"; }
	|
	SHOW COLON DOLLAR_SIGN name COMA number_value
	{ $$ = "std::cout <<" + $4 + "[" + $6 + "] <<std::endl; \n"; }
	|
	SHOW COLON DOLLAR_SIGN name COMA DOLLAR_SIGN name 
	{ $$ "std::cout<< " + $4 + "[" + $7 + "] <<std::endl; \n"; }
	;


characters_block:
	CHARACTERS_BLOCK { $$ = std::string(yytext); }
	;


name:
	NAME	{$$ = std::string(yytext);}
	;
%%


void yyerror(char const *x){
	printf("Error %s\n", x);
	exit(1);
}
