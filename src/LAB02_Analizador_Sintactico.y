%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>

extern FILE *yyin;
extern int yylineno;
int yylex(void);
void yyerror(const char *s);
extern void print_lexical_stats(void);  // Declarar función del léxico

char output_buffer[50000] = "";
int error_count = 0;
int last_error_line = 0;
int error_line_stack[100];
int error_line_count = 0;

void append_output(const char* text) {
    strcat(output_buffer, text);
}

void mark_error_line(int line) {
    // Marcar la línea como teniendo un error para reporte posterior
    for (int i = 0; i < error_line_count; i++) {
        if (error_line_stack[i] == line) {
            return; // Ya marcada
        }
    }
    if (error_line_count < 100) {
        error_line_stack[error_line_count++] = line;
    }
}

void report_error_at_line(int line) {
    // Solo reportar el error si es en una línea diferente a la anterior
    if (line != last_error_line && line > 0) {
        char temp[200];
        sprintf(temp, "línea %d error\n", line);
        append_output(temp);
        
        // NO imprimir en consola durante el parsing
        // Se imprimirá después con las estadísticas sintácticas
        
        error_count++;
        last_error_line = line;
    }
}

void print_syntax_errors() {
    // Imprimir todos los errores sintácticos que se capturaron
    // Buscar el primer salto de línea para omitir el encabezado
    char* error_start = strchr(output_buffer, '\n');
    if (error_start && strlen(error_start) > 1) {
        printf("%s", error_start + 1);
    }
}

void save_syntax_output(const char* input_filename) {
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
        
        snprintf(output_filename, sizeof(output_filename), "salidas/%s_sintactico.txt", name_copy);
    } else {
        strcpy(output_filename, "salidas/output_sintactico.txt");
    }
    
    FILE* output_file = fopen(output_filename, "w");
    if (output_file) {
        fprintf(output_file, "%s", output_buffer);
        fclose(output_file);
        printf("Análisis sintáctico guardado en: %s\n", output_filename);
    } else {
        printf("Error: No se pudo crear el archivo de salida %s\n", output_filename);
    }
}
%}

%union {
    char* str;
    int lineno;
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

/* Indentación con TABs */
%token TAB

%type <lineno> identificadores expresiones expresion

%start programa

%%

programa:
    /* vacío */
    | programa statement
    ;

statement:
    simple_stmt
    | compound_stmt
    ;

simple_stmt:
    asignacion NEWLINE {
        /* Asignación válida, no mostrar nada */
    }
    | PASS NEWLINE {
        /* pass statement */
    }
    | BREAK NEWLINE {
        /* break statement */
    }
    | CONTINUE NEWLINE {
        /* continue statement */
    }
    | RETURN NEWLINE {
        /* return sin valor */
    }
    | RETURN expresion_booleana NEWLINE {
        /* return con valor */
    }
    | print_stmt NEWLINE {
        /* print statement */
    }
    | call_function NEWLINE {
        /* llamada a función como statement */
    }
    | IMPORT ID NEWLINE {
        /* import statement */
    }
    | NEWLINE {
        /* línea vacía */
    }
    | error NEWLINE {
        // El error ocurrió en la línea actual - 1
        int err_line = yylineno - 1;
        if (err_line < 1) err_line = 1;
        
        report_error_at_line(err_line);
        yyclearin; // Limpiar el token lookahead
        yyerrok;   // Recuperarse del error
    }
    ;

print_stmt:
    PRINT LPAREN RPAREN
    | PRINT LPAREN argumentos RPAREN
    ;

compound_stmt:
    funcdef
    | ifstmt
    | forstmt
    | whilestmt
    ;

funcdef:
    DEF ID LPAREN RPAREN COLON NEWLINE suite {
        /* función sin parámetros */
    }
    | DEF ID LPAREN parameters RPAREN COLON NEWLINE suite {
        /* función con parámetros */
    }
    | DEF ID LPAREN RPAREN NEWLINE {
        /* Error: falta ':' después de función sin parámetros */
        report_error_at_line(yylineno - 1);
    } suite {
        yyerrok;
    }
    | DEF ID LPAREN parameters RPAREN NEWLINE {
        /* Error: falta ':' después de función con parámetros */
        report_error_at_line(yylineno - 1);
    } suite {
        yyerrok;
    }
    ;

/* if-elif-else unificado (maneja nivel 0 y niveles anidados) */
ifstmt:
    if_clause elif_clauses else_clause
    ;

if_clause:
    IF expresion_booleana COLON NEWLINE suite {
        /* if básico */
    }
    | IF expresion_booleana NEWLINE {
        /* Error: falta ':' después de condición if */
        report_error_at_line(yylineno - 1);
    } suite {
        yyerrok;
    }
    ;

/* elif/else unificados (sin tabs - nivel 0) */
elif_clauses:
    /* vacío - sin elif */
    | elif_clauses elif_clause
    ;

elif_clause:
    ELIF expresion_booleana COLON NEWLINE suite {
        /* elif válido */
    }
    | ELIF expresion_booleana NEWLINE {
        /* Error: falta ':' después de condición elif */
        report_error_at_line(yylineno - 1);
    } suite {
        yyerrok;
    }
    ;

else_clause:
    /* vacío - sin else */
    | ELSE COLON NEWLINE suite {
        /* else válido */
    }
    | ELSE NEWLINE {
        /* Error: falta ':' después de else */
        report_error_at_line(yylineno - 1);
    } suite {
        yyerrok;
    }
    ;

opt_newlines:
    /* vacío - sin newlines */
    | opt_newlines NEWLINE
    ;

forstmt:
    FOR ID IN secuencia COLON NEWLINE suite {
        /* ciclo for: for id in secuencia: */
    }
    | FOR ID IN RANGE ID {
        /* Error: falta '(' después de range */
        report_error_at_line(yylineno);
    } LPAREN expresion_booleana RPAREN RPAREN COLON NEWLINE suite {
        yyerrok;
    }
    | FOR ID call_range COLON NEWLINE {
        /* Error: falta 'in' antes de range */
        report_error_at_line(yylineno - 1);
    } suite {
        yyerrok;
    }
    | FOR ID IN secuencia NEWLINE {
        /* Error: falta ':' después de secuencia */
        report_error_at_line(yylineno - 1);
    } suite {
        yyerrok;
    }
    ;

secuencia:
    ID
    | call_range
    | lista
    | STRING
    | RANGE call_function RPAREN {
        /* Error: falta '(' después de range */
        report_error_at_line(yylineno);
        yyerrok;
    }
    | RANGE ID LPAREN {
        /* Error: falta '(' después de range */
        report_error_at_line(yylineno);
        yyerrok;
    } expresion_booleana RPAREN
    ;

call_range:
    RANGE LPAREN expresion_booleana RPAREN
    | RANGE LPAREN expresion_booleana COMMA expresion_booleana RPAREN
    | RANGE LPAREN expresion_booleana COMMA expresion_booleana COMMA expresion_booleana RPAREN
    ;

lista:
    LBRACKET RBRACKET
    | LBRACKET lista_elementos RBRACKET
    ;

lista_elementos:
    expresion_booleana
    | lista_elementos COMMA expresion_booleana
    ;

whilestmt:
    WHILE expresion_booleana COLON NEWLINE suite {
        /* ciclo while: while expresion: */
    }
    | WHILE expresion_booleana NEWLINE {
        /* Error: falta ':' después de condición while */
        report_error_at_line(yylineno - 1);
    } suite {
        yyerrok;
    }
    | WHILE COLON NEWLINE {
        /* Error: falta expresión en while */
        report_error_at_line(yylineno - 1);
    } suite {
        yyerrok;
    }
    ;

expresion_booleana:
    expresion_or
    ;

expresion_or:
    expresion_and
    | expresion_or OR expresion_and
    ;

expresion_and:
    expresion_not
    | expresion_and AND expresion_not
    ;

expresion_not:
    expresion_comparacion
    | NOT expresion_not
    ;

expresion_comparacion:
    expresion_aritmetica
    | expresion_aritmetica EQUAL expresion_aritmetica
    | expresion_aritmetica NOTEQUAL expresion_aritmetica
    | expresion_aritmetica NOTEQUAL2 expresion_aritmetica
    | expresion_aritmetica LESS expresion_aritmetica
    | expresion_aritmetica GREATER expresion_aritmetica
    | expresion_aritmetica LESSEQUAL expresion_aritmetica
    | expresion_aritmetica GREATEREQUAL expresion_aritmetica
    | expresion_aritmetica IS expresion_aritmetica
    | expresion_aritmetica IS NOT expresion_aritmetica
    | expresion_aritmetica IN expresion_aritmetica
    | expresion_aritmetica NOT IN expresion_aritmetica
    ;

expresion_aritmetica:
    expresion_termino
    | expresion_aritmetica PLUS expresion_termino
    | expresion_aritmetica MINUS expresion_termino
    | expresion_aritmetica BITOR expresion_termino
    | expresion_aritmetica BITXOR expresion_termino
    ;

expresion_termino:
    expresion_factor
    | expresion_termino TIMES expresion_factor
    | expresion_termino DIVIDE expresion_factor
    | expresion_termino FLOORDIV expresion_factor
    | expresion_termino MOD expresion_factor
    | expresion_termino BITAND expresion_factor
    ;

expresion_factor:
    expresion_potencia
    | PLUS expresion_factor
    | MINUS expresion_factor
    | BITNOT expresion_factor
    ;

expresion_potencia:
    expresion_primaria
    | expresion_primaria POW expresion_factor
    ;

expresion_primaria:
    ID
    | INTEGER
    | REAL
    | LONG
    | IMAGINARY
    | STRING
    | TRUE
    | FALSE
    | LPAREN expresion_booleana RPAREN
    | call_function
    | call_range
    | call_len
    | lista
    | expresion_primaria LBRACKET expresion_booleana RBRACKET
    ;

call_function:
    ID LPAREN RPAREN
    | ID LPAREN argumentos RPAREN
    ;

call_len:
    LEN LPAREN expresion_booleana RPAREN
    ;

argumentos:
    expresion_booleana
    | argumentos COMMA expresion_booleana
    ;

parameters:
    ID
    | parameters COMMA ID
    ;

suite:
    suite_statements opt_newlines
    ;

suite_statements:
    indented_statement
    | suite_statements indented_statement
    ;

indented_statement:
    tabs statement
    | tabs compound_stmt
    | tabs ELIF expresion_booleana COLON NEWLINE suite {
        /* elif anidado como statement independiente */
    }
    | tabs ELIF expresion_booleana NEWLINE {
        /* Error: falta ':' en elif anidado */
        report_error_at_line(yylineno - 1);
    } suite {
        yyerrok;
    }
    | tabs ELSE COLON NEWLINE suite {
        /* else anidado como statement independiente */
    }
    | tabs ELSE NEWLINE {
        /* Error: falta ':' en else anidado */
        report_error_at_line(yylineno - 1);
    } suite {
        yyerrok;
    }
    ;

tabs:
    TAB
    | tabs TAB
    ;

asignacion:
    identificadores ASSIGN expresiones {
        if ($1 > 1 && $1 != $3) {
            report_error_at_line(yylineno - 1);
        }
    }
    ;

identificadores:
    ID {
        $$ = 1;
    }
    | expresion_primaria {
        $$ = 1;
    }
    | identificadores COMMA ID {
        $$ = $1 + 1;
    }
    | identificadores COMMA expresion_primaria {
        $$ = $1 + 1;
    }
    ;

expresiones:
    expresion {
        $$ = $1;
    }
    | expresiones COMMA expresion {
        $$ = $1 + $3;
    }
    ;

expresion:
    expresion_booleana {
        $$ = 1;
    }
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
    
    // Imprimir encabezado
    char header[500];
    if (input_filename) {
        sprintf(header, "Prueba con el archivo de \"%s\"\n", input_filename);
    } else {
        sprintf(header, "Prueba con el archivo de \"entrada\"\n");
    }
    append_output(header);
    
    int result = yyparse();
    
    // Mostrar estadísticas léxicas PRIMERO
    print_lexical_stats();
    
    // Luego mostrar estadísticas sintácticas
    printf("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n");
    printf("ANÁLISIS SINTÁCTICO\n");
    printf("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n");
    
    // Imprimir errores de línea si existen
    if (error_count > 0) {
        print_syntax_errors();
    }
    
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
    
    return 0;
}
