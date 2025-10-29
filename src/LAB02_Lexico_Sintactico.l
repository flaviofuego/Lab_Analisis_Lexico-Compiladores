%{
#include "y.tab.h"
#include <string.h>
#include <stdlib.h>

extern int yylineno;
%}

%option yylineno

DIGIT    [0-9]
LETTER   [a-zA-Z]
SIGNO    [+-]?
ID       ({LETTER}|_)({LETTER}|{DIGIT}|_)*
INTEGER  {SIGNO}{DIGIT}+
LONG     {SIGNO}{DIGIT}+[lL]
EXP      [eE]{SIGNO}{DIGIT}+
FORMAT1  {DIGIT}+\.{DIGIT}*
FORMAT2  {DIGIT}*\.{DIGIT}+
REAL     {SIGNO}({FORMAT1}|{FORMAT2})({EXP})?
IMAGINARY ({INTEGER}|{REAL})[jJ]
STRING   \"[^\"]*\"|\'[^\']*\'
INVALID_NUM {DIGIT}+[A-KM-Za-ik-z]+({LETTER}|{DIGIT})*
INVALID_ID  ({LETTER}|_)({LETTER}|{DIGIT}|_)*[^a-zA-Z0-9_\s\n\t\r()[\]{};:,."'=+\-*/%<>!&|^~]+({LETTER}|{DIGIT}|_|[^a-zA-Z0-9_\s\n\t\r()[\]{};:,."'=+\-*/%<>!&|^~])+

%%

#.*             { /* comentarios */ }

"and"           { yylval.str = strdup(yytext); return AND; }
"break"         { yylval.str = strdup(yytext); return BREAK; }
"continue"      { yylval.str = strdup(yytext); return CONTINUE; }
"def"           { yylval.str = strdup(yytext); return DEF; }
"elif"          { yylval.str = strdup(yytext); return ELIF; }
"else"          { yylval.str = strdup(yytext); return ELSE; }
"for"           { yylval.str = strdup(yytext); return FOR; }
"if"            { yylval.str = strdup(yytext); return IF; }
"import"        { yylval.str = strdup(yytext); return IMPORT; }
"in"            { yylval.str = strdup(yytext); return IN; }
"is"            { yylval.str = strdup(yytext); return IS; }
"not"           { yylval.str = strdup(yytext); return NOT; }
"or"            { yylval.str = strdup(yytext); return OR; }
"pass"          { yylval.str = strdup(yytext); return PASS; }
"return"        { yylval.str = strdup(yytext); return RETURN; }
"while"         { yylval.str = strdup(yytext); return WHILE; }
"print"         { yylval.str = strdup(yytext); return PRINT; }
"range"         { yylval.str = strdup(yytext); return RANGE; }
"len"           { yylval.str = strdup(yytext); return LEN; }

"True"          { yylval.str = strdup(yytext); return TRUE; }
"False"         { yylval.str = strdup(yytext); return FALSE; }

{STRING}        { yylval.str = strdup(yytext); return STRING; }
{IMAGINARY}     { yylval.str = strdup(yytext); return IMAGINARY; }
{LONG}          { yylval.str = strdup(yytext); return LONG; }
{REAL}          { yylval.str = strdup(yytext); return REAL; }
{INTEGER}       { yylval.str = strdup(yytext); return INTEGER; }
{INVALID_NUM}   { yylval.str = strdup(yytext); return ERROR_TOKEN; }
{INVALID_ID}    { yylval.str = strdup(yytext); return ERROR_TOKEN; }

"**"            { return POW; }
"//"            { return FLOORDIV; }
"<<"            { return LSHIFT; }
">>"            { return RSHIFT; }
"<>"            { return NOTEQUAL2; }
"=="            { return EQUAL; }
"!="            { return NOTEQUAL; }
">="            { return GREATEREQUAL; }
"<="            { return LESSEQUAL; }
"=?"            { return ERROR_TOKEN; }
"%"             { return MOD; }
"&"             { return BITAND; }
"|"             { return BITOR; }
"^"             { return BITXOR; }
"~"             { return BITNOT; }
"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return TIMES; }
"/"             { return DIVIDE; }
"="             { return ASSIGN; }
"<"             { return LESS; }
">"             { return GREATER; }

"//="           { return FLOORDIVASSIGN; }
"+="            { return PLUSASSIGN; }
"-="            { return MINUSASSIGN; }
"*="            { return TIMESASSIGN; }
"/="            { return DIVIDEASSIGN; }

"("             { return LPAREN; }
")"             { return RPAREN; }
"["             { return LBRACKET; }
"]"             { return RBRACKET; }
"{"             { return LBRACE; }
"}"             { return RBRACE; }
":"             { return COLON; }
";"             { return SEMICOLON; }
","             { return COMMA; }
"."             { return DOT; }

{ID}            { yylval.str = strdup(yytext); return ID; }

^[ \t]+         { /* mantener indentación */ }
[ \t]+          { /* espacios */ }
\n              { return NEWLINE; }
\r              { /* ignorar retorno de carro */ }

.               { return ERROR_TOKEN; }

%%

int yywrap(void) {
    return 1;
}
