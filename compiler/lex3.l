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
MULTILINECOMMENT {SIG_MENOR}{MAS}{WILDCARD}({DOT}*{WHITESPACE}*{LINEFEED})+{WILDCARD}{MAS}{SIG_MAYOR}
LINEFEED \n
DOT . 
SLASH [/]
WILDCARD [*]
QUOTES [\"]
COLON [:]
SIG_MENOR [<]
SIG_MAYOR [>]
MAS [+]
MENOS [-]
SLASHIN [\]

%%
"?"	{ return IF; }
"|"	{ return ELSE; }
"!"	{ return EXCLAMATION_SYMBOL; }
"ntol"	{ return NTOL; }
"$"	{ return DOLLAR_SIGN;}


{DIGIT}+ { return NUMBER_VALUE; }
{DIGIT}+{DOT}{DIGIT}+ { return DECIMAL_VALUE; }
{QUOTES} { return QUOTES; }
{SINGLECOMMENT} { return SINGLECOMMENT; }
{MULTILINECOMMENT} { return MULTILINECOMMENT; }
{CHARACTERS_BLOCK}	{ return CHARACTERS_BLOCK; }
{NAME}	{ return NAME; }


"load"	{ return LOAD; }
"show"	{ return SHOW; }
"Int"	{ return INT; }
"Dec"	{ return DEC; }
"Bln"	{ return BLN; }
"Str"	{ retun STR; }
"tru"	{ return TRU; }
"fls"	{ return FLS; }


"answer:0;" { return ANSWER_CERO;}

","	{ return COMA; }
"/"	{ return SLASH; }
"\"	{ return SLASHIN; }
"=="	{ return DOBLE_EQUAL; }
"::"	{ retur DOBLE_COLON; }
"["	{ return LEFT_CORCH; }
"]"	{ return RIGHT_CORCH; }
">"	{ return MY; }
"<"	{ return MN; }
">="	{ return MYE; }
"<="	{ return MNE; }
"!="	{ return DIF;}
"="	{ return EQUAL; } 
"@"	{ return ARROBA; }
":"	{ return COLON; }
";"	{ return SEMICOLON; }
"->"	{ return RIGHT_ARROW; }
"{"	{ return LEFT_CURLY_BRACE; }
"}"	{ return RIGHT_CURLY_BRACE; }
"("	{ return LEFT_PARENTHESIS; }
")"	{ return RIGHT_PARENTHESIS; }
"*"	{ return MULT;}
"+"	{ return MAS;}
"-"	{ return MENOS;}
"+:"	{ return INCREMENTO; }
"-:"	{ return DECREMENTO; }


{WHITESPACE}
{LINEFEED}	++yylineno;

%%

#include <stdio.h>

