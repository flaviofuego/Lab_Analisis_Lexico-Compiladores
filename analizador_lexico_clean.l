%{
/* 
 * Analizador Lexico para subconjunto de Python
 * Este programa implementa la primera fase de un compilador
 * Identifica y clasifica tokens segun la gramatica especificada
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

/* Variables globales para el manejo de identificadores y errores */
char* identifiers[1000];  // Array para almacenar identificadores unicos
int id_counter = 0;       // Contador de identificadores unicos
int error_count = 0;      // Contador de errores lexicos

/* 
 * Funcion para obtener el numero de un identificador
 * Si el identificador ya existe, retorna su numero asignado
 * Si es nuevo, lo agrega al array y le asigna un numero
 */
int get_id_number(char* identifier) {
    // Buscar si el identificador ya existe
    for(int i = 0; i < id_counter; i++) {
        if(strcmp(identifiers[i], identifier) == 0) {
            return i + 1;  // Los numeros empiezan en 1
        }
    }
    
    // Si no existe, agregarlo
    identifiers[id_counter] = malloc(strlen(identifier) + 1);
    strcpy(identifiers[id_counter], identifier);
    id_counter++;
    return id_counter;
}

/* Funcion para imprimir la lista final de identificadores */
void print_identifiers() {
    printf("\n%d Identificadores\n", id_counter);
    for(int i = 0; i < id_counter; i++) {
        printf("Id%d=%s\n", i + 1, identifiers[i]);
    }
}

/* Funcion para imprimir el total de errores */
void print_errors() {
    printf("%d Errores\n", error_count);
}

%}

/* 
 * Definiciones de patrones reutilizables
 * Estas son como "variables" que podemos usar en nuestras reglas
 */
DIGIT    [0-9]
LETTER   [a-zA-Z]
ID       ({LETTER}|_)({LETTER}|{DIGIT}|_)*
INTEGER  [+-]?{DIGIT}+
DECIMAL  {DIGIT}+\.{DIGIT}*|{DIGIT}*\.{DIGIT}+|{DIGIT}+(e|E)[+-]?{DIGIT}+|({DIGIT}+\.{DIGIT}*|{DIGIT}*\.{DIGIT}+)(e|E)[+-]?{DIGIT}+

%%

/* 
 * SECCION DE REGLAS LEXICAS
 * Cada regla tiene el formato: patron { accion }
 * IMPORTANTE: El orden importa! Las reglas mas especificas van primero
 */

/* ========== COMENTARIOS ========== */
/* Los comentarios se ignoran completamente */
#.*$            { /* Ignorar comentarios que empiezan con # */ }

/* ========== PALABRAS RESERVADAS ========== */
/* Estas deben ir ANTES que la regla de identificadores */
/* Todas se muestran en MAYUSCULA segun la especificacion */
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

/* Valores especiales de Python */
"True"          { printf("TRUE "); }
"False"         { printf("FALSE "); }

/* ========== NUMEROS ========== */
/* El orden es importante: mas especificos primero */

/* Numeros imaginarios (terminan en j o J) */
({INTEGER}|{DECIMAL})(j|J)    { printf("imaginario=%s ", yytext); }

/* Numeros largos (terminan en L o l) */
{INTEGER}(L|l)                { printf("long=%s ", yytext); }

/* Numeros decimales */
{DECIMAL}                     { printf("real=%s ", yytext); }

/* Numeros enteros */
{INTEGER}                     { printf("entero=%s ", yytext); }

/* ========== OPERADORES ========== */
/* Operadores de asignacion compuesta (deben ir antes que los operadores simples) */
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

/* Operadores de comparacion */
"<="            { printf("menor_ig= "); }
">="            { printf("mayor_ig= "); }
"=="            { printf("comp= "); }
"!="            { printf("dif= "); }
"<>"            { printf("dif_alt= "); }

/* Operadores de desplazamiento */
"<<"            { printf("desp_izq= "); }
">>"            { printf("desp_der= "); }

/* Operadores aritmeticos */
"**"            { printf("pot= "); }
"//"            { printf("div_ent= "); }
"+"             { printf("suma= "); }
"-"             { printf("menos= "); }
"*"             { printf("mult= "); }
"/"             { printf("div= "); }
"%"             { printf("mod= "); }

/* Operadores logicos bitwise */
"&"             { printf("and_bit= "); }
"|"             { printf("or_bit= "); }
"^"             { printf("xor= "); }
"~"             { printf("not_bit= "); }

/* Operadores de comparacion simples */
"<"             { printf("menor= "); }
">"             { printf("mayor= "); }

/* ========== DELIMITADORES ========== */
"("             { printf("parabre= "); }
")"             { printf("parcierr= "); }
"["             { printf("corabre= "); }
"]"             { printf("corcierr= "); }
"="             { printf("asign= "); }
";"             { printf("puntocoma= "); }
","             { printf("coma= "); }
":"             { printf("dospunt= "); }
"."             { printf("punto= "); }

/* ========== STRINGS ========== */
/* Strings con comillas simples */
'([^'\n\\]|\\.)*'    { printf("cadena=%s ", yytext); }

/* Strings con comillas dobles */
\"([^\"\n\\]|\\.)*\"  { printf("cadena=%s ", yytext); }

/* ========== IDENTIFICADORES ========== */
/* Esta regla debe ir DESPUES de las palabras reservadas */
{ID}            { printf("id%d=%s ", get_id_number(yytext), yytext); }

/* ========== ESPACIOS EN BLANCO ========== */
/* Los espacios, tabs y nuevas lineas se ignoran */
[ \t\n]+        { /* Ignorar espacios en blanco */ }

/* ========== MANEJO DE ERRORES ========== */
/* Cualquier caracter que no coincida con las reglas anteriores es un error */
.               { printf("ERROR=%s ", yytext); error_count++; }

%%

/*
 * SECCION DE CODIGO C ADICIONAL
 * Aqui va el codigo que se ejecuta despues del analisis
 */

int main(int argc, char** argv) {
    /* Mensaje de bienvenida */
    printf("=== Analizador Lexico para Python ===\n");
    printf("Procesando archivo de entrada...\n\n");
    
    /* Si se proporciona un archivo como argumento, usarlo como entrada */
    if (argc > 1) {
        FILE* file = fopen(argv[1], "r");
        if (!file) {
            fprintf(stderr, "Error: No se pudo abrir el archivo %s\n", argv[1]);
            return 1;
        }
        yyin = file;
    }
    
    /* Ejecutar el analisis lexico */
    yylex();
    
    /* Imprimir estadisticas finales */
    printf("\n\n=== ESTADISTICAS FINALES ===\n");
    print_identifiers();
    print_errors();
    
    /* Liberar memoria asignada para identificadores */
    for(int i = 0; i < id_counter; i++) {
        free(identifiers[i]);
    }
    
    return 0;
}

/*
 * Funcion requerida por Lex para el manejo del final de archivo
 * Retorna 1 para indicar que el analisis ha terminado
 */
int yywrap() {
    return 1;
}