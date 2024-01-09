%option noyywrap
%{
#include "grammar.tab.h"
#include "SyntaxTree/Includes.hpp"
%}

DIGIT [0-9]
ALPHA [a-zA-Z]
NAME {ALPHA}({DIGIT}*{ALPHA}*)+
CHARACTERS_BLOCK {QUOTES}({ALPHA}*{WHITESPACE}*{DIGIT}*{COLON}*)+{QUOTES}
SINGLECOMMENT {SLASH}{SLASH}({DOT}*{WHITESPACE}*)+{LINEFEED}
WHITESPACE [ \r\t\v\f]
MULTILINECOMMENT {SLASH}{WILDCARD}({DOT}*{WHITESPACE}*{LINEFEED})+{WILDCARD}{SLASH}
LINEFEED \n
DOT . 
SLASH [/]
WILDCARD [*]
QUOTES [\"]
COLON [\:]

%%
"fi" { return FI; }
"if" { return IF; }
"gt" { return GT; }
"lt" { return LT; }
"?" { return QUESTION_MARK; }
"!" { return EXCLAMATION_SYMBOL; }
"get" { return GET; }
"stdin" { return STDIN; }
"ntol" { return NTOL; }
"Logical" { return LOGICAL; }
"TRUE" { return TRUE; }
"FALSE" { return FALSE; }
"inc" { return INC; }
"dec" { return DEC; }
"$" { return DOLLAR_SIGN;}
"set" { return SET; }
"Number" { return NUMBER; }
{DIGIT}+ { return NUMBER_VALUE; }
{QUOTES} { return QUOTES; }
"put" { return PUTS; }
{SINGLECOMMENT} { return SINGLECOMMENT; }
{MULTILINECOMMENT} { return MULTILINECOMMENT; }
{CHARACTERS_BLOCK}	{ return CHARACTERS_BLOCK; }
{NAME}	{
	//printf("Lex: NAME \n");
	//yylval = new compiler::Name(yytext);
	return NAME;
	}
":"	{ 
	//printf("Lex: : \n");
	return COLON;
	}
";"	{ 
	//printf("Lex: ; \n");
	return SEMICOLON;
	}
"->"	{ 
	//printf("Lex: -> \n");
	return RIGHT_ARROW;
	}
"{"	{ 
	//printf("Lex: { ");
	return LEFT_CURLY_BRACE;
	}
"}"	{ 
	//printf("Lex: } \n");
	return RIGHT_CURLY_BRACE;
	}

"("	{
	return LEFT_PARENTHESIS;
	}
")"	{
	return RIGHT_PARENTHESIS;
	}
{WHITESPACE}
{LINEFEED}	++yylineno;

%%

#include <stdio.h>

