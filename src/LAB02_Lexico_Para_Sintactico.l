%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "LAB02_Analizador_Sintactico.tab.h"

// Para el análisis sintáctico
char* identifiers[100];
int id_counter = 0;
extern int error_count;  // Declarada en el analizador sintáctico
int lexical_error_count = 0;  // Contador de errores léxicos

// Obtener el número de un identificador
int get_id_number(char* identifier) {
    for(int i = 0; i < id_counter; i++) {
        if(strcmp(identifiers[i], identifier) == 0) {
            return i + 1;
        }
    }
    identifiers[id_counter] = malloc(strlen(identifier) + 1);
    strcpy(identifiers[id_counter], identifier);
    id_counter++;
    return id_counter;
}

// Función para imprimir estadísticas léxicas
void print_lexical_stats() {
    printf("\n");
    printf("%d Identificadores\n", id_counter);
    for(int i = 0; i < id_counter; i++) {
        printf("Id%d=%s\n", i + 1, identifiers[i]);
    }
    printf("\n%d Errores léxicos\n", lexical_error_count);
}

%}

%option noyywrap
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
INVALID_NUM {DIGIT}+[A-KM-Za-ik-z]+({LETTER}|{DIGIT})*
INVALID_ID  ({LETTER}|_)({LETTER}|{DIGIT}|_)*[$@#!?`\\|&]{1}({LETTER}|{DIGIT}|_|[$@#!?`\\|&])*

%%

#.*             { /* comentarios */ }

"and"           { return AND; }
"break"         { return BREAK; }
"continue"      { return CONTINUE; }
"def"           { return DEF; }
"elif"          { return ELIF; }
"else"          { return ELSE; }
"for"           { return FOR; }
"if"            { return IF; }
"import"        { return IMPORT; }
"in"            { return IN; }
"is"            { return IS; }
"not"           { return NOT; }
"or"            { return OR; }
"pass"          { return PASS; }
"return"        { return RETURN; }
"while"         { return WHILE; }
"print"         { return PRINT; }
"range"         { return RANGE; }
"len"           { return LEN; }

"True"          { return TRUE; }
"False"         { return FALSE; }

{STRING}        { yylval.str = strdup(yytext); return STRING; }
{IMAGINARY}     { yylval.str = strdup(yytext); return IMAGINARY; }
{REAL}          { yylval.str = strdup(yytext); return REAL; }
{LONG}          { yylval.str = strdup(yytext); return LONG; }
{INTEGER}       { yylval.str = strdup(yytext); return INTEGER; }
{INVALID_NUM}   { yylval.str = strdup(yytext); lexical_error_count++; return ERROR_TOKEN; }
{INVALID_ID}    { yylval.str = strdup(yytext); lexical_error_count++; return ERROR_TOKEN; }

"**"            { return POW; }
"//"            { return FLOORDIV; }
"<<"            { return LSHIFT; }
">>"            { return RSHIFT; }
"<>"            { return NOTEQUAL2; }
"=="            { return EQUAL; }
"!="            { return NOTEQUAL; }
">="            { return GREATEREQUAL; }
"<="            { return LESSEQUAL; }
"=?"            { return EQUALQUESASSIGN; }
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

{ID}            { 
                  get_id_number(yytext);  // Registrar el identificador
                  yylval.str = strdup(yytext); 
                  return ID; 
                }

"    "          { return TAB; }
\t              { return TAB; }
\n              { return NEWLINE; }
[ ]             { /* espacios individuales - ignorar */ }
\r              { /* ignorar retorno de carro */ }

.               { yylval.str = strdup(yytext); lexical_error_count++; return ERROR_TOKEN; }

%%
