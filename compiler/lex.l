%option noyywrap
%{
	#include "grammar.tab.h"
%}

COLON [:]
DIGIT -?[0-9]
ALPHA [a-zA-Z]
CHARACTERS_BLOCK {QUOTES}({DOT}*{COLON}*{ALPHA}*{WHITESPACE}*{DIGIT}*)+{QUOTES}
NAME {ALPHA}([0-9]*{ALPHA}*)+
WHITESPACE [ \r\t\v\f]
LINEFEED \n
SINGLECOMMENT {MENOR}{MAS}({DOT}*{WHITESPACE}*)+{LINEFEED}+{MAS}{MAYOR}
MULTILINECOMMENT {MENOR}{MAS}({DOT}*{WHITESPACE}*{LINEFEED}*)+{MAS}{MAYOR}
DOT .
SLASH[/]
WILDCARD [*]
QUOTES [\"]
MENOR [<]
MAYOR [>]
MAS [+]
MENOS [-]


%%



"/"			{ return SLASH; }
"\\"			{ return SLASHIN; }
"["			{ return LEFT_CORCH; }
"]"			{ return RIGHT_CORCH; }
"?"			{ return IF; }
"|"			{ return ELSE;}
"="			{ return EQUAL; }
"<"			{ return MENOR; }
"<="			{ return MENOREQUAL; }
">"			{ return MAYOR; }
">="			{ return MAYOREQUAL; }
"!="			{ return DIFERENT; }
"ntol"			{ return NTOL; }
"+:"			{ return INCREMENT; }
"-:"			{ return DECREMENT; }
"load"			{ return LOAD; }
"show"			{ return SHOW; }	
"showjump"		{return NOENTER; }
"Int"			{ return INT; }
"Bln"			{ return BLN; }
"Str"			{ return STR; }
"Dec"			{ return DEC; }
"tru"			{ return TRU; }
"fls"			{ return FLS; }
"answer:0;"		{ return ANSWER; }
{DIGIT}+               { return INTEGER_VALUE; }
{DIGIT}+{DOT}{DIGIT}+  { return DECIMAL_VALUE; }
{NAME}			{ return NAME;}
{CHARACTERS_BLOCK}     { return CHARACTERS_BLOCK; }
{QUOTES}		{ return QUOTES; }
{SINGLECOMMENT}        { return SINGLECOMMENT; }
{MULTILINECOMMENT}     { return MULTILINECOMMENT; }
":"			{ return COLON; }
"::"			{ return DOBLE_COLON; }
";"			{ return SEMICOLON; }
"->"			{ return RIGHT_ARROW; }
"{"			{ return LEFT_CURLY_BRACE; }
"}"			{ return RIGHT_CURLY_BRACE; }
"("			{ return LEFT_PARENTHESIS; }
")"			{ return RIGHT_PARENTHESIS; }
"$"			{ return DOLLAR_SIGN; }
","			{ return COMA; }
"@"			{ return ARROBA; }
"+"			{ return MAS; }
"-"			{ return MENOS; }
{WHITESPACE}
{LINEFEED}		++yylineno;

%%

#include <stdio.h>
