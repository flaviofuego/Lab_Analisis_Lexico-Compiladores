%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char* identifiers[100];
int id_counter = 0;
int error_count = 0;

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

void print_identifiers() {
    printf("%d Identificadores\n", id_counter);
    for(int i = 0; i < id_counter; i++) {
        printf("Id%d=%s\n", i + 1, identifiers[i]);
    }
}

void print_errors() {
    printf("%d Errores\n", error_count);
}
%}

DIGIT    [0-9]
LETTER   [a-zA-Z]
ID       ({LETTER}|_)({LETTER}|{DIGIT}|_)*
INTEGER  {DIGIT}+
LONG     {INTEGER}L
DECIMAL  {DIGIT}+\.{DIGIT}*|{DIGIT}*\.{DIGIT}+
SCIENTIFIC {DECIMAL}[eE][+-]?{DIGIT}+|{INTEGER}[eE][+-]?{DIGIT}+
IMAGINARY ({INTEGER}|{DECIMAL}|{SCIENTIFIC})j
STRING   \"[^\"]*\"|\'[^\']*\'

%%

#.*$            { /* comentarios */ }

"and"           { printf("AND "); }
"break"         { printf("BREAK "); }
"continue"      { printf("CONTINUE "); }
"def"           { printf("DEF "); }
"elif"          { printf("ELIF "); }
"else"          { printf("ELSE "); }
"for"           { printf("FOR "); }
"if"            { printf("IF "); }
"in"            { printf("IN "); }
"is"            { printf("IS "); }
"not"           { printf("NOT "); }
"or"            { printf("OR "); }
"pass"          { printf("PASS "); }
"return"        { printf("RETURN "); }
"while"         { printf("WHILE "); }
"print"         { printf("PRINT "); }
"range"         { printf("RANGE "); }
"len"           { printf("LEN "); }

"True"          { printf("TRUE "); }
"False"         { printf("FALSE "); }

{STRING}        { printf("cadena=%s ", yytext); }
{IMAGINARY}     { printf("imaginario=%s ", yytext); }
{SCIENTIFIC}    { printf("real=%s ", yytext); }
{LONG}          { printf("long=%s ", yytext); }
{DECIMAL}       { printf("real=%s ", yytext); }
{INTEGER}       { printf("entero=%s ", yytext); }

"=="            { printf("comp= "); }
"!="            { printf("dif= "); }
">="            { printf("mayor_ig= "); }
"<="            { printf("menor_ig= "); }
"=?"            { printf("ERROR=? "); error_count++; }
"+"             { printf("suma=+ "); }
"-"             { printf("menos=- "); }
"*"             { printf("mult=* "); }
"/"             { printf("div=/ "); }
"="             { printf("asig= "); }
"<"             { printf("menor= "); }
">"             { printf("mayor= "); }

"("             { printf("parabre=( "); }
")"             { printf("parcierr=) "); }
"["             { printf("corabre=[ "); }
"]"             { printf("corcierr=] "); }
":"             { printf("dospunt=: "); }
","             { printf("coma=, "); }

{ID}            { printf("id%d=%s ", get_id_number(yytext), yytext); }

[ \t]+          { /* espacios */ }
\n              { printf("\n"); }
.               { printf("ERROR=%s ", yytext); error_count++; }

%%

int main(int argc, char** argv) {
    if (argc > 1) {
        FILE* file = fopen(argv[1], "r");
        if (!file) {
            fprintf(stderr, "Error: No se pudo abrir el archivo %s\n", argv[1]);
            return 1;
        }
        yyin = file;
    }
    
    yylex();
    
    printf("\n");
    print_identifiers();
    print_errors();
    
    for(int i = 0; i < id_counter; i++) {
        free(identifiers[i]);
    }
    
    return 0;
}

int yywrap() {
    return 1;
}