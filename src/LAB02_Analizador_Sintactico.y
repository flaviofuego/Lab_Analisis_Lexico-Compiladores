%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern FILE *yyin;
extern int yylineno;
int yylex(void);
void yyerror(const char *s);

char output_buffer[50000] = "";
int error_count = 0;

void append_output(const char* text) {
    strcat(output_buffer, text);
}

void save_syntax_output(const char* input_filename) {
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
        
        snprintf(output_filename, sizeof(output_filename), "salidas/%s_sintactico.txt", name_copy);
    } else {
        strcpy(output_filename, "salidas/output_sintactico.txt");
    }
    
    FILE* output_file = fopen(output_filename, "w");
    if (output_file) {
        fprintf(output_file, "%s", output_buffer);
        fclose(output_file);
        printf("Análisis sintáctico guardado en: %s\n", output_filename);
    }
}
%}

%union {
    char* str;
}

%token <str> ID
%token <str> INTEGER REAL LONG IMAGINARY STRING
%token <str> TRUE FALSE
%token <str> AND BREAK CONTINUE DEF ELIF ELSE FOR IF IMPORT IN IS NOT OR PASS RETURN WHILE PRINT RANGE LEN
%token <str> ERROR_TOKEN

/* Operadores aritméticos */
%token PLUS MINUS TIMES DIVIDE MOD POW FLOORDIV

/* Operadores de comparación */
%token EQUAL NOTEQUAL NOTEQUAL2 LESS GREATER LESSEQUAL GREATEREQUAL

/* Operadores bit a bit */
%token BITAND BITOR BITXOR BITNOT LSHIFT RSHIFT

/* Operadores de asignación */
%token ASSIGN PLUSASSIGN MINUSASSIGN TIMESASSIGN DIVIDEASSIGN FLOORDIVASSIGN

/* Delimitadores */
%token LPAREN RPAREN LBRACKET RBRACKET LBRACE RBRACE
%token COLON SEMICOLON COMMA DOT
%token NEWLINE

%start programa

%%

programa:
    /* vacío */
    | programa linea
    ;

linea:
    asignacion NEWLINE {
        /* Asignación válida, no mostrar nada */
    }
    | NEWLINE {
        /* línea vacía */
    }
    | error NEWLINE {
        char temp[100];
        // El error ocurrió en la línea anterior al NEWLINE actual
        int err_line = yylineno - 1;
        if (err_line < 1) err_line = 1;
        
        sprintf(temp, "línea %d error\n", err_line);
        append_output(temp);
        error_count++;
        yyerrok;
    }
    ;

asignacion:
    identificadores ASSIGN expresiones
    ;

identificadores:
    ID
    | identificadores COMMA ID
    ;

expresiones:
    expresion
    | expresiones COMMA expresion
    ;

expresion:
    ID
    | INTEGER
    | REAL
    | LONG
    | IMAGINARY
    | STRING
    | TRUE
    | FALSE
    ;

%%

void yyerror(const char *s) {
    // Silenciar errores en stderr para no duplicar la salida
}

int main(int argc, char **argv) {
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
    
    printf("Iniciando análisis sintáctico...\n");
    
    // Imprimir encabezado
    char header[500];
    if (input_filename) {
        sprintf(header, "Prueba con el archivo de \"%s\"\n", input_filename);
    } else {
        sprintf(header, "Prueba con el archivo de \"entrada\"\n");
    }
    append_output(header);
    
    int result = yyparse();
    
    save_syntax_output(input_filename);
    
    if (error_count == 0) {
        printf("Análisis sintáctico completado exitosamente.\n");
        printf("0 errores sintácticos\n");
    } else {
        printf("Análisis sintáctico completado con errores.\n");
        printf("%d errores sintácticos\n", error_count);
    }
    
    if (argc > 1) {
        fclose(yyin);
    }
    
    return result;
}
