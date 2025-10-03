%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

char* identifiers[100];
int id_counter = 0;
int error_count = 0;
char output_buffer[50000] = ""; // Buffer para acumular toda la salida

void append_to_buffer(const char* text) {
    strcat(output_buffer, text);
}

void create_output_directory() {
    struct stat st = {0};
    if (stat("salidas", &st) == -1) {
        system("mkdir -p salidas");
    }
}

void save_output_to_file(const char* input_filename) {
    create_output_directory();
    
    char output_filename[256];
    if (input_filename) {
        // Extraer solo el nombre del archivo sin la extensión
        const char* base_name = strrchr(input_filename, '/');
        if (base_name) {
            base_name++; // Saltar el '/'
        } else {
            base_name = input_filename;
        }
        
        // Crear nombre del archivo de salida
        char name_copy[256];
        strcpy(name_copy, base_name);
        char* dot = strrchr(name_copy, '.');
        if (dot) *dot = '\0'; // Remover extensión
        
        snprintf(output_filename, sizeof(output_filename), "salidas/%s_tokens.txt", name_copy);
    } else {
        strcpy(output_filename, "salidas/output_tokens.txt");
    }
    
    FILE* output_file = fopen(output_filename, "w");
    if (output_file) {
        fprintf(output_file, "%s", output_buffer);
        fprintf(output_file, "\n\n%d Identificadores\n\n", id_counter);
        for(int i = 0; i < id_counter; i++) {
            fprintf(output_file, "Id%d=%s\n", i + 1, identifiers[i]);
        }
        fprintf(output_file, "\n%d Errores\n", error_count);
        fclose(output_file);
        printf("Salida guardada en: %s\n", output_filename);
    } else {
        printf("Error: No se pudo crear el archivo de salida\n");
    }
}

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
    printf("\n%d Errores\n", error_count);
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
INVALID_NUM {DIGIT}+[A-KM-Za-ik-z]+({LETTER}|{DIGIT})*

%%

#.*             { /* comentarios */ }

"and"           { append_to_buffer("AND "); }
"break"         { append_to_buffer("BREAK "); }
"continue"      { append_to_buffer("CONTINUE "); }
"def"           { append_to_buffer("DEF "); }
"elif"          { append_to_buffer("ELIF "); }
"else"          { append_to_buffer("ELSE "); }
"for"           { append_to_buffer("FOR "); }
"if"            { append_to_buffer("IF "); }
"in"            { append_to_buffer("IN "); }
"is"            { append_to_buffer("IS "); }
"not"           { append_to_buffer("NOT "); }
"or"            { append_to_buffer("OR "); }
"pass"          { append_to_buffer("PASS "); }
"return"        { append_to_buffer("RETURN "); }
"while"         { append_to_buffer("WHILE "); }
"print"         { append_to_buffer("PRINT "); }
"range"         { append_to_buffer("RANGE "); }

"True"          { append_to_buffer("TRUE "); }
"False"         { append_to_buffer("FALSE "); }

{INVALID_NUM}   { char temp[100]; sprintf(temp, "ERROR=%s ", yytext); append_to_buffer(temp); error_count++; }
{STRING}        { char temp[1000]; sprintf(temp, "cadena=%s ", yytext); append_to_buffer(temp); }
{IMAGINARY}     { char temp[100]; sprintf(temp, "imaginario=%s ", yytext); append_to_buffer(temp); }
{SCIENTIFIC}    { char temp[100]; sprintf(temp, "real=%s ", yytext); append_to_buffer(temp); }
{LONG}          { char temp[100]; sprintf(temp, "long=%s ", yytext); append_to_buffer(temp); }
{DECIMAL}       { char temp[100]; sprintf(temp, "real=%s ", yytext); append_to_buffer(temp); }
{INTEGER}       { char temp[100]; sprintf(temp, "entero=%s ", yytext); append_to_buffer(temp); }

"**"            { append_to_buffer("potencia= ** "); }
"//"            { append_to_buffer("div_entera= // "); }
"<<"            { append_to_buffer("desp_izq= << "); }
">>"            { append_to_buffer("desp_der= >> "); }
"<>"            { append_to_buffer("dif_alt= <> "); }
"=="            { append_to_buffer("comp= == "); }
"!="            { append_to_buffer("dif= != "); }
">="            { append_to_buffer("mayor_ig= >= "); }
"<="            { append_to_buffer("menor_ig= <= "); }
"=?"            { append_to_buffer("ERROR=? "); error_count++; }
"%"             { append_to_buffer("modulo= % "); }
"&"             { append_to_buffer("and_bit= & "); }
"|"             { append_to_buffer("or_bit= | "); }
"^"             { append_to_buffer("xor_bit= ^ "); }
"~"             { append_to_buffer("not_bit= ~ "); }
"+"             { append_to_buffer("suma= + "); }
"-"             { append_to_buffer("menos= - "); }
"*"             { append_to_buffer("mult= * "); }
"/"             { append_to_buffer("div= / "); }
"="             { append_to_buffer("asign= = "); }
"<"             { append_to_buffer("menor= < "); }
">"             { append_to_buffer("mayor= > "); }

"("             { append_to_buffer("parabre=( "); }
")"             { append_to_buffer("parcierr=) "); }
"["             { append_to_buffer("corabre=[ "); }
"]"             { append_to_buffer("corcierr=] "); }
":"             { append_to_buffer("dospunt=: "); }
","             { append_to_buffer("coma=, "); }

{ID}            { char temp[100]; sprintf(temp, "id%d=%s ", get_id_number(yytext), yytext); append_to_buffer(temp); }

^[ \t]+         { append_to_buffer(yytext); }
[ \t]+          { /* espacios dentro de línea */ }
\n              { append_to_buffer("\n"); }
.               { char temp[100]; sprintf(temp, "ERROR=%s ", yytext); append_to_buffer(temp); error_count++; }

%%

int main(int argc, char** argv) {
    char* input_filename = NULL;
    
    if (argc > 1) {
        input_filename = argv[1];
        FILE* file = fopen(input_filename, "r");
        if (!file) {
            fprintf(stderr, "Error: No se pudo abrir el archivo %s\n", input_filename);
            return 1;
        }
        yyin = file;
    }
    
    printf("Procesando archivo...\n");
    yylex();
    
    // Guardar resultado en archivo
    save_output_to_file(input_filename);
    
    // Mostrar estadísticas en consola también
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