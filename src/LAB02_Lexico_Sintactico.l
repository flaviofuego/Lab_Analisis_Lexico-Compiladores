%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "y.tab.h"

extern int current_line;

void update_line() {
    current_line = yylineno;
}

%}

%option yylineno

DIGIT    [0-9]
LETTER   [a-zA-Z]
SIGNO    [+-]?
ID       ({LETTER}|_)({LETTER}|{DIGIT}|_)*
INTEGER  {SIGNO}{DIGIT}+
LONG     {SIGNO}{DIGIT}+[lL]
EXP      [eE]{INTEGER}
FORMAT1  {DIGIT}+\.{DIGIT}*
FORMAT2  {DIGIT}*\.{DIGIT}+
FORMAT3  {DIGIT}+
REAL     {SIGNO}({FORMAT1}|{FORMAT2}|{FORMAT3})({EXP})?
IMAGINARY ({INTEGER}|{REAL})[jJ]
STRING   \"[^\"]*\"|\'[^\']*\'

%%

#.*             { /* comentarios */ }

"and"           { update_line(); return AND; }
"break"         { update_line(); return BREAK; }
"continue"      { update_line(); return CONTINUE; }
"def"           { update_line(); return DEF; }
"elif"          { update_line(); return ELIF; }
"else"          { update_line(); return ELSE; }
"for"           { update_line(); return FOR; }
"if"            { update_line(); return IF; }
"import"        { update_line(); return IMPORT; }
"in"            { update_line(); return IN; }
"is"            { update_line(); return IS; }
"not"           { update_line(); return NOT; }
"or"            { update_line(); return OR; }
"pass"          { update_line(); return PASS; }
"return"        { update_line(); return RETURN; }
"while"         { update_line(); return WHILE; }
"print"         { update_line(); return PRINT; }
"range"         { update_line(); return RANGE; }
"len"           { update_line(); return LEN; }

"True"          { update_line(); return TRUE; }
"False"         { update_line(); return FALSE; }

{STRING}        { update_line(); yylval.strval = strdup(yytext); return CADENA; }
{IMAGINARY}     { update_line(); yylval.floatval = atof(yytext); return IMAGINARIO; }
{REAL}          { update_line(); yylval.floatval = atof(yytext); return REAL; }
{LONG}          { update_line(); yylval.intval = atoi(yytext); return LONG; }
{INTEGER}       { update_line(); yylval.intval = atoi(yytext); return ENTERO; }

"**"            { update_line(); return POTENCIA; }
"//"            { update_line(); return DIV_ENTERA; }
"<<"            { update_line(); return DESP_IZQ; }
">>"            { update_line(); return DESP_DER; }
"<>"            { update_line(); return DIF_ALT; }
"=="            { update_line(); return COMP; }
"!="            { update_line(); return DIF; }
">="            { update_line(); return MAYOR_IG; }
"<="            { update_line(); return MENOR_IG; }
"=?"            { update_line(); return ERROR; }

"//="           { update_line(); return ASIGN_DIV_ENTERA; }
"+="            { update_line(); return ASIGN_SUMA; }
"-="            { update_line(); return ASIGN_MENOS; }
"*="            { update_line(); return ASIGN_MULT; }
"/="            { update_line(); return ASIGN_DIV; }

"%"             { update_line(); return MODULO; }
"&"             { update_line(); return AND_BIT; }
"|"             { update_line(); return OR_BIT; }
"^"             { update_line(); return XOR_BIT; }
"~"             { update_line(); return NOT_BIT; }
"+"             { update_line(); return SUMA; }
"-"             { update_line(); return MENOS; }
"*"             { update_line(); return MULT; }
"/"             { update_line(); return DIV; }
"="             { update_line(); return ASIGN; }
"<"             { update_line(); return MENOR; }
">"             { update_line(); return MAYOR; }

"("             { update_line(); return PARABRE; }
")"             { update_line(); return PARCIERR; }
"["             { update_line(); return CORABRE; }
"]"             { update_line(); return CORCIERR; }
"{"             { update_line(); return LLAVEABRE; }
"}"             { update_line(); return LLAVECIERR; }
":"             { update_line(); return DOSPUNT; }
";"             { update_line(); return PUNTOCOMA; }
","             { update_line(); return COMA; }
"."             { update_line(); return PUNTO; }

{ID}            { update_line(); yylval.strval = strdup(yytext); return ID; }

^[ \t]+         { /* indentación */ }
[ \t]+          { /* espacios */ }
\n              { update_line(); }
\r              { /* ignorar retorno de carro */ }
.               { update_line(); return ERROR; }

%%

int yywrap() {
    return 1;
}
