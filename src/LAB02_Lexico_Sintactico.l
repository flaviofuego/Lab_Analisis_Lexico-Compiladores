%{
#include "y.tab.h"
#include <string.h>
#include <stdlib.h>

extern int yylineno;

// Stack para manejar niveles de indentación
int indent_stack[100];
int indent_stack_ptr = 0;
int current_indent = 0;
int pending_dedents = 0;
int at_line_start = 1;

void push_indent(int level) {
    indent_stack[indent_stack_ptr++] = level;
}

int pop_indent() {
    if (indent_stack_ptr > 0) {
        return indent_stack[--indent_stack_ptr];
    }
    return 0;
}

int peek_indent() {
    if (indent_stack_ptr > 0) {
        return indent_stack[indent_stack_ptr - 1];
    }
    return 0;
}
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
INVALID_ID  ({LETTER}|_)({LETTER}|{DIGIT}|_)*[$@#!?`\\|&]{1}({LETTER}|{DIGIT}|_|[$@#!?`\\|&])*

%x INDENT_STATE

%%

    /* Manejo de indentación al inicio de línea */
^[ \t]*\n       { at_line_start = 1; /* línea vacía, ignorar */ }

^[ \t]+         {
    if (at_line_start) {
        at_line_start = 0;
        int spaces = 0;
        for (int i = 0; i < yyleng; i++) {
            if (yytext[i] == '\t') spaces += 4;  // tab = 4 espacios
            else spaces++;
        }
        
        if (spaces > peek_indent()) {
            // Incremento de indentación: INDENT
            push_indent(spaces);
            return INDENT;
        } else if (spaces < peek_indent()) {
            // Decremento de indentación: generar DEDENTs
            while (spaces < peek_indent() && indent_stack_ptr > 0) {
                pop_indent();
                pending_dedents++;
            }
            if (pending_dedents > 0) {
                pending_dedents--;
                unput('\n');  // Devolver el newline para procesarlo después
                for (int i = yyleng - 1; i >= 0; i--) {
                    unput(yytext[i]);  // Devolver la indentación
                }
                return DEDENT;
            }
        }
        // Si spaces == peek_indent(), continuar normalmente
    }
}

^[^ \t\n]       { 
    at_line_start = 0;
    unput(yytext[0]);
    // Sin indentación al inicio de línea
    if (peek_indent() > 0) {
        // Necesitamos generar DEDENTs hasta llegar a nivel 0
        while (indent_stack_ptr > 0) {
            pop_indent();
            pending_dedents++;
        }
        if (pending_dedents > 0) {
            pending_dedents--;
            return DEDENT;
        }
    }
}

#.*             { /* comentarios */ }

"and"           { at_line_start = 0; yylval.str = strdup(yytext); return AND; }
"break"         { at_line_start = 0; yylval.str = strdup(yytext); return BREAK; }
"continue"      { at_line_start = 0; yylval.str = strdup(yytext); return CONTINUE; }
"def"           { at_line_start = 0; yylval.str = strdup(yytext); return DEF; }
"elif"          { at_line_start = 0; yylval.str = strdup(yytext); return ELIF; }
"else"          { at_line_start = 0; yylval.str = strdup(yytext); return ELSE; }
"for"           { at_line_start = 0; yylval.str = strdup(yytext); return FOR; }
"if"            { at_line_start = 0; yylval.str = strdup(yytext); return IF; }
"import"        { at_line_start = 0; yylval.str = strdup(yytext); return IMPORT; }
"in"            { at_line_start = 0; yylval.str = strdup(yytext); return IN; }
"is"            { at_line_start = 0; yylval.str = strdup(yytext); return IS; }
"not"           { at_line_start = 0; yylval.str = strdup(yytext); return NOT; }
"or"            { at_line_start = 0; yylval.str = strdup(yytext); return OR; }
"pass"          { at_line_start = 0; yylval.str = strdup(yytext); return PASS; }
"return"        { at_line_start = 0; yylval.str = strdup(yytext); return RETURN; }
"while"         { at_line_start = 0; yylval.str = strdup(yytext); return WHILE; }
"print"         { at_line_start = 0; yylval.str = strdup(yytext); return PRINT; }
"range"         { at_line_start = 0; yylval.str = strdup(yytext); return RANGE; }
"len"           { at_line_start = 0; yylval.str = strdup(yytext); return LEN; }

"True"          { at_line_start = 0; yylval.str = strdup(yytext); return TRUE; }
"False"         { at_line_start = 0; yylval.str = strdup(yytext); return FALSE; }

{STRING}        { at_line_start = 0; yylval.str = strdup(yytext); return STRING; }
{IMAGINARY}     { at_line_start = 0; yylval.str = strdup(yytext); return IMAGINARY; }
{LONG}          { at_line_start = 0; yylval.str = strdup(yytext); return LONG; }
{REAL}          { at_line_start = 0; yylval.str = strdup(yytext); return REAL; }
{INTEGER}       { at_line_start = 0; yylval.str = strdup(yytext); return INTEGER; }
{INVALID_NUM}   { at_line_start = 0; yylval.str = strdup(yytext); return ERROR_TOKEN; }
{INVALID_ID}    { at_line_start = 0; yylval.str = strdup(yytext); return ERROR_TOKEN; }

"**"            { at_line_start = 0; return POW; }
"//"            { at_line_start = 0; return FLOORDIV; }
"<<"            { at_line_start = 0; return LSHIFT; }
">>"            { at_line_start = 0; return RSHIFT; }
"<>"            { at_line_start = 0; return NOTEQUAL2; }
"=="            { at_line_start = 0; return EQUAL; }
"!="            { at_line_start = 0; return NOTEQUAL; }
">="            { at_line_start = 0; return GREATEREQUAL; }
"<="            { at_line_start = 0; return LESSEQUAL; }
"=?"            { at_line_start = 0; return ERROR_TOKEN; }
"%"             { at_line_start = 0; return MOD; }
"&"             { at_line_start = 0; return BITAND; }
"|"             { at_line_start = 0; return BITOR; }
"^"             { at_line_start = 0; return BITXOR; }
"~"             { at_line_start = 0; return BITNOT; }
"+"             { at_line_start = 0; return PLUS; }
"-"             { at_line_start = 0; return MINUS; }
"*"             { at_line_start = 0; return TIMES; }
"/"             { at_line_start = 0; return DIVIDE; }
"="             { at_line_start = 0; return ASSIGN; }
"<"             { at_line_start = 0; return LESS; }
">"             { at_line_start = 0; return GREATER; }

"//="           { at_line_start = 0; return FLOORDIVASSIGN; }
"+="            { at_line_start = 0; return PLUSASSIGN; }
"-="            { at_line_start = 0; return MINUSASSIGN; }
"*="            { at_line_start = 0; return TIMESASSIGN; }
"/="            { at_line_start = 0; return DIVIDEASSIGN; }

"("             { at_line_start = 0; return LPAREN; }
")"             { at_line_start = 0; return RPAREN; }
"["             { at_line_start = 0; return LBRACKET; }
"]"             { at_line_start = 0; return RBRACKET; }
"{"             { at_line_start = 0; return LBRACE; }
"}"             { at_line_start = 0; return RBRACE; }
":"             { at_line_start = 0; return COLON; }
";"             { at_line_start = 0; return SEMICOLON; }
","             { at_line_start = 0; return COMMA; }
"."             { at_line_start = 0; return DOT; }

{ID}            { at_line_start = 0; yylval.str = strdup(yytext); return ID; }

[ \t]+          { /* espacios en medio de línea */ }

\n              { 
    at_line_start = 1;
    if (pending_dedents > 0) {
        pending_dedents--;
        unput('\n');
        return DEDENT;
    }
    return NEWLINE; 
}

\r              { /* ignorar retorno de carro */ }

.               { at_line_start = 0; return ERROR_TOKEN; }

%%

int yywrap(void) {
    return 1;
}
