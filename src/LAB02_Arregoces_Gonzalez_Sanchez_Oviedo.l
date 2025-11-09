%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/types.h>
#include "LAB02_Arregoces_Gonzalez_Sanchez_Oviedo.tab.h"

// Para el análisis sintáctico
char* identifiers[100];
int id_counter = 0;
extern int error_count;  // Declarada en el analizador sintáctico
int lexical_error_count = 0;  // Contador de errores léxicos

// Buffer para guardar los tokens
char token_output_buffer[50000] = "";

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

// Función para agregar tokens al buffer
void append_token_to_buffer(const char* text) {
    strcat(token_output_buffer, text);
}

// Función para guardar la salida de tokens en un archivo
void save_lexical_output(const char* input_filename) {
    // Crear directorio salidas/ si no existe
    struct stat st = {0};
    if (stat("salidas", &st) == -1) {
        mkdir("salidas", 0700);
    }
    
    char output_filename[256];
    if (input_filename) {
        const char* base_name = strrchr(input_filename, '/');
        if (base_name) {
            base_name++;
        } else {
            base_name = input_filename;
        }
        
        char name_copy[256];
        strcpy(name_copy, base_name);
        char* dot = strrchr(name_copy, '.');
        if (dot) *dot = '\0';
        
        snprintf(output_filename, sizeof(output_filename), "salidas/%s_lexico_tokens.txt", name_copy);
    } else {
        strcpy(output_filename, "salidas/output_lexico_tokens.txt");
    }
    
    FILE* output_file = fopen(output_filename, "w");
    if (output_file) {
        fprintf(output_file, "%s", token_output_buffer);
        fprintf(output_file, "\n\n%d Identificadores\n\n", id_counter);
        for(int i = 0; i < id_counter; i++) {
            fprintf(output_file, "Id%d=%s\n", i + 1, identifiers[i]);
        }
        fprintf(output_file, "\n%d Errores léxicos\n", lexical_error_count);
        fclose(output_file);
        printf("Tokens léxicos guardados en: %s\n", output_filename);
    }
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

"and"           { append_token_to_buffer("AND "); return AND; }
"break"         { append_token_to_buffer("BREAK "); return BREAK; }
"continue"      { append_token_to_buffer("CONTINUE "); return CONTINUE; }
"def"           { append_token_to_buffer("DEF "); return DEF; }
"elif"          { append_token_to_buffer("ELIF "); return ELIF; }
"else"          { append_token_to_buffer("ELSE "); return ELSE; }
"for"           { append_token_to_buffer("FOR "); return FOR; }
"if"            { append_token_to_buffer("IF "); return IF; }
"import"        { append_token_to_buffer("IMPORT "); return IMPORT; }
"in"            { append_token_to_buffer("IN "); return IN; }
"is"            { append_token_to_buffer("IS "); return IS; }
"not"           { append_token_to_buffer("NOT "); return NOT; }
"or"            { append_token_to_buffer("OR "); return OR; }
"pass"          { append_token_to_buffer("PASS "); return PASS; }
"return"        { append_token_to_buffer("RETURN "); return RETURN; }
"while"         { append_token_to_buffer("WHILE "); return WHILE; }
"print"         { append_token_to_buffer("PRINT "); return PRINT; }
"range"         { append_token_to_buffer("RANGE "); return RANGE; }
"len"           { append_token_to_buffer("LEN "); return LEN; }

"True"          { append_token_to_buffer("TRUE "); return TRUE; }
"False"         { append_token_to_buffer("FALSE "); return FALSE; }

{STRING}        { char temp[1000]; sprintf(temp, "cadena=%s ", yytext); append_token_to_buffer(temp); yylval.str = strdup(yytext); return STRING; }
{IMAGINARY}     { char temp[100]; sprintf(temp, "imaginario=%s ", yytext); append_token_to_buffer(temp); yylval.str = strdup(yytext); return IMAGINARY; }
{REAL}          { char temp[100]; sprintf(temp, "real=%s ", yytext); append_token_to_buffer(temp); yylval.str = strdup(yytext); return REAL; }
{LONG}          { char temp[100]; sprintf(temp, "long=%s ", yytext); append_token_to_buffer(temp); yylval.str = strdup(yytext); return LONG; }
{INTEGER}       { char temp[100]; sprintf(temp, "entero=%s ", yytext); append_token_to_buffer(temp); yylval.str = strdup(yytext); return INTEGER; }
{INVALID_NUM}   { char temp[100]; sprintf(temp, "ERROR=%s ", yytext); append_token_to_buffer(temp); yylval.str = strdup(yytext); lexical_error_count++; return ERROR_TOKEN; }
{INVALID_ID}    { char temp[100]; sprintf(temp, "ERROR=%s ", yytext); append_token_to_buffer(temp); yylval.str = strdup(yytext); lexical_error_count++; return ERROR_TOKEN; }

"**"            { append_token_to_buffer("potencia= ** "); return POW; }
"//"            { append_token_to_buffer("div_entera= // "); return FLOORDIV; }
"<<"            { append_token_to_buffer("desp_izq= << "); return LSHIFT; }
">>"            { append_token_to_buffer("desp_der= >> "); return RSHIFT; }
"<>"            { append_token_to_buffer("dif_alt= <> "); return NOTEQUAL2; }
"=="            { append_token_to_buffer("comp= == "); return EQUAL; }
"!="            { append_token_to_buffer("dif= != "); return NOTEQUAL; }
">="            { append_token_to_buffer("mayor_ig= >= "); return GREATEREQUAL; }
"<="            { append_token_to_buffer("menor_ig= <= "); return LESSEQUAL; }
"%"             { append_token_to_buffer("modulo= % "); return MOD; }
"&"             { append_token_to_buffer("and_bit= & "); return BITAND; }
"|"             { append_token_to_buffer("or_bit= | "); return BITOR; }
"^"             { append_token_to_buffer("xor_bit= ^ "); return BITXOR; }
"~"             { append_token_to_buffer("not_bit= ~ "); return BITNOT; }
"+"             { append_token_to_buffer("suma= + "); return PLUS; }
"-"             { append_token_to_buffer("menos= - "); return MINUS; }
"*"             { append_token_to_buffer("mult= * "); return TIMES; }
"/"             { append_token_to_buffer("div= / "); return DIVIDE; }
"="             { append_token_to_buffer("asign= = "); return ASSIGN; }
"<"             { append_token_to_buffer("menor= < "); return LESS; }
">"             { append_token_to_buffer("mayor= > "); return GREATER; }

"//="           { append_token_to_buffer("asign_div_entera=//= "); return FLOORDIVASSIGN; }
"+="            { append_token_to_buffer("asign_suma=+= "); return PLUSASSIGN; }
"-="            { append_token_to_buffer("asign_menos=-= "); return MINUSASSIGN; }
"*="            { append_token_to_buffer("asign_mult=*= "); return TIMESASSIGN; }
"/="            { append_token_to_buffer("asign_div=/= "); return DIVIDEASSIGN; }

"("             { append_token_to_buffer("parabre=( "); return LPAREN; }
")"             { append_token_to_buffer("parcierr=) "); return RPAREN; }
"["             { append_token_to_buffer("corabre=[ "); return LBRACKET; }
"]"             { append_token_to_buffer("corcierr=] "); return RBRACKET; }
"{"             { append_token_to_buffer("llaveabre={ "); return LBRACE; }
"}"             { append_token_to_buffer("llavecierr=} "); return RBRACE; }
":"             { append_token_to_buffer("dospunt=: "); return COLON; }
";"             { append_token_to_buffer("puntocoma=; "); return SEMICOLON; }
","             { append_token_to_buffer("coma=, "); return COMMA; }
"."             { append_token_to_buffer("punto=. "); return DOT; }

{ID}            { 
                  char temp[100]; 
                  int id_num = get_id_number(yytext);
                  sprintf(temp, "id%d=%s ", id_num, yytext); 
                  append_token_to_buffer(temp);
                  yylval.str = strdup(yytext); 
                  return ID; 
                }

"    "          { append_token_to_buffer("    "); return TAB; }
\t              { append_token_to_buffer("\t"); return TAB; }
\n              { append_token_to_buffer("\n"); return NEWLINE; }
[ ]             { /* espacios individuales - ignorar */ }
\r              { /* ignorar retorno de carro */ }

.               { char temp[100]; sprintf(temp, "ERROR=%s ", yytext); append_token_to_buffer(temp); yylval.str = strdup(yytext); lexical_error_count++; return ERROR_TOKEN; }

%%
