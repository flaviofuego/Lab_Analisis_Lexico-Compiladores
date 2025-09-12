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
SCIENTIFIC  ({INTEGER}|{DECIMAL})[eE][+-]?{DIGIT}+

%%

#.*$            { /* Ignorar comentarios */ }

"and"           { printf("AND "); }
"as"            { printf("AS "); }
"assert"        { printf("ASSERT "); }
"break"         { printf("BREAK "); }
"class"         { printf("CLASS "); }
"continue"      { printf("CONTINUE "); }
"def"           { printf("DEF "); }
"del"           { printf("DEL "); }
"elif"          { printf("ELIF "); }
"else"          { printf("ELSE "); }
"except"        { printf("EXCEPT "); }
"exec"          { printf("EXEC "); }
"finally"       { printf("FINALLY "); }
"for"           { printf("FOR "); }
"from"          { printf("FROM "); }
"global"        { printf("GLOBAL "); }
"if"            { printf("IF "); }
"import"        { printf("IMPORT "); }
"in"            { printf("IN "); }
"is"            { printf("IS "); }
"lambda"        { printf("LAMBDA "); }
"not"           { printf("NOT "); }
"or"            { printf("OR "); }
"pass"          { printf("PASS "); }
"print"         { printf("PRINT "); }
"raise"         { printf("RAISE "); }
"return"        { printf("RETURN "); }
"try"           { printf("TRY "); }
"while"         { printf("WHILE "); }
"with"          { printf("WITH "); }
"yield"         { printf("YIELD "); }

"True"          { printf("TRUE "); }
"False"         { printf("FALSE "); }
"None"          { printf("NONE "); }

({INTEGER}|{DECIMAL}|{SCIENTIFIC})(j|J)    { printf("imaginario=%s ", yytext); }
{INTEGER}(L|l)                             { printf("long=%s ", yytext); }
{SCIENTIFIC}                               { printf("cientifico=%s ", yytext); }
{DECIMAL}                                  { printf("real=%s ", yytext); }
{INTEGER}                                  { printf("entero=%s ", yytext); }

">="            { printf("mayor_ig= "); }
"<="            { printf("menor_ig= "); }
"=="            { printf("comp= "); }
"!="            { printf("dif= "); }
"<>"            { printf("dif_alt= "); }
"**"            { printf("pot= "); }
"//"            { printf("div_ent= "); }
"<<"            { printf("desp_izq= "); }
">>"            { printf("desp_der= "); }

">>="           { printf("asig_right= "); }
"<<="           { printf("asig_left= "); }
"+="            { printf("asig_sum= "); }
"-="            { printf("asig_rest= "); }
"*="            { printf("asig_mult= "); }
"/="            { printf("asig_div= "); }
"//="           { printf("asig_divint= "); }
"**="           { printf("asig_pot= "); }
"%="            { printf("asig_mod= "); }
"&="            { printf("asig_and= "); }
"|="            { printf("asig_or= "); }
"^="            { printf("asig_xor= "); }

"+"             { printf("suma= "); }
"-"             { printf("menos= "); }
"*"             { printf("mult= "); }
"/"             { printf("div= "); }
"%"             { printf("mod= "); }
"&"             { printf("and_bit= "); }
"|"             { printf("or_bit= "); }
"^"             { printf("xor= "); }
"~"             { printf("not_bit= "); }
"="             { printf("asign= "); }
"<"             { printf("menor= "); }
">"             { printf("mayor= "); }

"("             { printf("parabre= "); }
")"             { printf("parcierr= "); }
"["             { printf("corabre= "); }
"]"             { printf("corcierr= "); }
"{"             { printf("llavabre= "); }
"}"             { printf("llavcierr= "); }
":"             { printf("dospunt= "); }
";"             { printf("puntocoma= "); }
","             { printf("coma= "); }
"."             { printf("punto= "); }

'([^'\\n\\\\]|\\\\.)*'         { printf("cadena=%s ", yytext); }
\"([^\"\\n\\\\]|\\\\.)*\"      { printf("cadena=%s ", yytext); }

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