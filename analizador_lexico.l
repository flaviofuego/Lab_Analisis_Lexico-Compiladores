%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char* identifiers[1000];
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
    printf("\n%d Identificadores\n", id_counter);
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
INTEGER  [+-]?{DIGIT}+
DECIMAL  {DIGIT}+\.{DIGIT}*|{DIGIT}*\.{DIGIT}+

%%

#.*$            { /* Ignorar comentarios */ }

"and"           { printf("AND "); }
"break"         { printf("BREAK "); }
"continue"      { printf("CONTINUE "); }
"def"           { printf("DEF "); }
"elif"          { printf("ELIF "); }
"else"          { printf("ELSE "); }
"for"           { printf("FOR "); }
"if"            { printf("IF "); }
"import"        { printf("IMPORT "); }
"in"            { printf("IN "); }
"is"            { printf("IS "); }
"not"           { printf("NOT "); }
"or"            { printf("OR "); }
"pass"          { printf("PASS "); }
"print"         { printf("PRINT "); }
"return"        { printf("RETURN "); }
"while"         { printf("WHILE "); }
"True"          { printf("TRUE "); }
"False"         { printf("FALSE "); }

({INTEGER}|{DECIMAL})(j|J)    { printf("imaginario=%s ", yytext); }
{INTEGER}(L|l)                { printf("long=%s ", yytext); }
{DECIMAL}                     { printf("real=%s ", yytext); }
{INTEGER}                     { printf("entero=%s ", yytext); }

">="            { printf("mayor_ig= "); }
"<="            { printf("menor_ig= "); }
"=="            { printf("comp= "); }
"!="            { printf("dif= "); }
"**"            { printf("pot= "); }
"+="            { printf("asig_sum= "); }
"-="            { printf("asig_rest= "); }
"*="            { printf("asig_mult= "); }

"+"             { printf("suma= "); }
"-"             { printf("menos= "); }
"*"             { printf("mult= "); }
"/"             { printf("div= "); }
"="             { printf("asign= "); }
"<"             { printf("menor= "); }
">"             { printf("mayor= "); }

"("             { printf("parabre= "); }
")"             { printf("parcierr= "); }
"["             { printf("corabre= "); }
"]"             { printf("corcierr= "); }
":"             { printf("dospunt= "); }
","             { printf("coma= "); }

{ID}            { printf("id%d=%s ", get_id_number(yytext), yytext); }

[ \t\n]+        { /* Ignorar espacios */ }
.               { printf("ERROR=%s ", yytext); error_count++; }

%%

int main(int argc, char** argv) {
    printf("=== Analizador Lexico para Python ===\n");
    printf("Procesando archivo de entrada...\n\n");
    
    if (argc > 1) {
        FILE* file = fopen(argv[1], "r");
        if (!file) {
            fprintf(stderr, "Error: No se pudo abrir el archivo %s\n", argv[1]);
            return 1;
        }
        yyin = file;
    }
    
    yylex();
    
    printf("\n\n=== ESTADISTICAS FINALES ===\n");
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