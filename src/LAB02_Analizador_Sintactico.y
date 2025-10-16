%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/stat.h>

extern int yylex();
extern int yylineno;
extern char* yytext;
extern FILE* yyin;

void yyerror(const char *s);

// Variables para manejo de errores
int syntax_errors[1000];
int error_count = 0;
int current_line = 1;
char* input_filename = NULL;

void add_syntax_error(int line) {
    // Evitar duplicados en la misma línea
    for(int i = 0; i < error_count; i++) {
        if(syntax_errors[i] == line) {
            return;
        }
    }
    syntax_errors[error_count++] = line;
}

void create_output_directory() {
    struct stat st = {0};
    if (stat("salidas", &st) == -1) {
        system("mkdir -p salidas");
    }
}

void save_syntax_output(const char* input_filename) {
    create_output_directory();
    
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
        fprintf(output_file, "Prueba con el archivo de entrada\n");
        
        if (error_count == 0) {
            fprintf(output_file, "0 errores\n");
        } else {
            // Ordenar errores por línea
            for(int i = 0; i < error_count - 1; i++) {
                for(int j = i + 1; j < error_count; j++) {
                    if(syntax_errors[i] > syntax_errors[j]) {
                        int temp = syntax_errors[i];
                        syntax_errors[i] = syntax_errors[j];
                        syntax_errors[j] = temp;
                    }
                }
            }
            
            for(int i = 0; i < error_count; i++) {
                fprintf(output_file, "línea %d error\n", syntax_errors[i]);
            }
        }
        
        fclose(output_file);
        printf("\n✅ Análisis sintáctico completado. Salida guardada en: %s\n", output_filename);
    } else {
        printf("Error: No se pudo crear el archivo de salida\n");
    }
}

%}

%union {
    int intval;
    double floatval;
    char* strval;
}

/* Tokens de palabras reservadas */
%token AND BREAK CONTINUE DEF ELIF ELSE FOR IF IMPORT IN IS NOT OR PASS RETURN WHILE PRINT RANGE LEN
%token TRUE FALSE

/* Tokens de operadores */
%token POTENCIA DIV_ENTERA DESP_IZQ DESP_DER DIF_ALT COMP DIF MAYOR_IG MENOR_IG
%token MODULO AND_BIT OR_BIT XOR_BIT NOT_BIT
%token SUMA MENOS MULT DIV ASIGN MENOR MAYOR
%token ASIGN_DIV_ENTERA ASIGN_SUMA ASIGN_MENOS ASIGN_MULT ASIGN_DIV

/* Tokens de delimitadores */
%token PARABRE PARCIERR CORABRE CORCIERR LLAVEABRE LLAVECIERR
%token DOSPUNT PUNTOCOMA COMA PUNTO

/* Tokens de valores */
%token <strval> ID CADENA
%token <intval> ENTERO LONG
%token <floatval> REAL IMAGINARIO

/* Tokens especiales */
%token NEWLINE INDENT ERROR

/* Precedencia de operadores (de menor a mayor) */
%left OR
%left AND
%left NOT
%left COMP DIF MENOR MAYOR MENOR_IG MAYOR_IG IS
%left OR_BIT
%left XOR_BIT
%left AND_BIT
%left DESP_IZQ DESP_DER
%left SUMA MENOS
%left MULT DIV DIV_ENTERA MODULO
%right NOT_BIT
%right POTENCIA
%left PUNTO

%start programa

%%

programa:
    /* vacío */
    | sentencias
    ;

sentencias:
    sentencia
    | sentencias sentencia
    ;

sentencia:
    asignacion
    | definicion_funcion
    | condicional
    | ciclo_for
    | ciclo_while
    | PASS
    | BREAK
    | CONTINUE
    | print_stmt
    | import_stmt
    | expresion
    | error { add_syntax_error(current_line); yyerrok; }
    ;

/* Asignación */
asignacion:
    ID ASIGN expresion
    | lista_ids ASIGN lista_expresiones
    | ID operador_asignacion expresion
    ;

operador_asignacion:
    ASIGN_SUMA
    | ASIGN_MENOS
    | ASIGN_MULT
    | ASIGN_DIV
    | ASIGN_DIV_ENTERA
    ;

lista_ids:
    ID COMA ID
    | lista_ids COMA ID
    ;

lista_expresiones:
    expresion COMA expresion
    | lista_expresiones COMA expresion
    ;

/* Definición de función */
definicion_funcion:
    DEF ID PARABRE PARCIERR DOSPUNT bloque_funcion
    | DEF ID PARABRE lista_parametros PARCIERR DOSPUNT bloque_funcion
    | DEF ID error DOSPUNT bloque_funcion { add_syntax_error(current_line); yyerrok; }
    | DEF ID PARABRE lista_parametros error bloque_funcion { add_syntax_error(current_line); yyerrok; }
    ;

bloque_funcion:
    sentencias_funcion
    | sentencias_funcion RETURN expresion
    ;

sentencias_funcion:
    sentencia_indentada
    | sentencias_funcion sentencia_indentada
    ;

sentencia_indentada:
    sentencia
    ;

lista_parametros:
    ID
    | lista_parametros COMA ID
    ;

/* Condicional */
condicional:
    IF expresion DOSPUNT bloque
    | IF expresion DOSPUNT bloque elif_bloques
    | IF expresion DOSPUNT bloque else_bloque
    | IF expresion DOSPUNT bloque elif_bloques else_bloque
    ;

elif_bloques:
    ELIF expresion DOSPUNT bloque
    | elif_bloques ELIF expresion DOSPUNT bloque
    ;

else_bloque:
    ELSE DOSPUNT bloque
    ;

bloque:
    sentencia
    | sentencias
    ;

/* Ciclo for */
ciclo_for:
    FOR ID IN secuencia DOSPUNT bloque
    | FOR ID error secuencia DOSPUNT bloque { add_syntax_error(current_line); yyerrok; }
    ;

secuencia:
    lista
    | range_call
    | ID
    ;

/* Ciclo while */
ciclo_while:
    WHILE expresion DOSPUNT bloque
    ;

/* Print */
print_stmt:
    PRINT PARABRE PARCIERR
    | PRINT PARABRE lista_expresiones PARCIERR
    ;

/* Import */
import_stmt:
    IMPORT ID
    ;

/* Range */
range_call:
    RANGE PARABRE expresion PARCIERR
    | RANGE PARABRE expresion COMA expresion PARCIERR
    | RANGE error PARCIERR { add_syntax_error(current_line); yyerrok; }
    ;

/* Expresiones */
expresion:
    expresion_aritmetica
    | expresion_booleana
    | CADENA
    | lista
    | ID CORABRE expresion CORCIERR  /* acceso a lista */
    | llamada_funcion
    | ID
    | TRUE
    | FALSE
    ;

expresion_aritmetica:
    ENTERO
    | LONG
    | REAL
    | IMAGINARIO
    | expresion SUMA expresion
    | expresion MENOS expresion
    | expresion MULT expresion
    | expresion DIV expresion
    | expresion DIV_ENTERA expresion
    | expresion MODULO expresion
    | expresion POTENCIA expresion
    | MENOS expresion %prec NOT_BIT
    | PARABRE expresion PARCIERR
    ;

expresion_booleana:
    expresion COMP expresion
    | expresion DIF expresion
    | expresion MENOR expresion
    | expresion MAYOR expresion
    | expresion MENOR_IG expresion
    | expresion MAYOR_IG expresion
    | expresion IS expresion
    | expresion AND expresion
    | expresion OR expresion
    | NOT expresion
    | expresion AND_BIT expresion
    | expresion OR_BIT expresion
    | expresion XOR_BIT expresion
    | NOT_BIT expresion
    | expresion DESP_IZQ expresion
    | expresion DESP_DER expresion
    ;

lista:
    CORABRE CORCIERR
    | CORABRE lista_expresiones CORCIERR
    ;

llamada_funcion:
    ID PARABRE PARCIERR
    | ID PARABRE lista_expresiones PARCIERR
    | LEN PARABRE expresion PARCIERR
    ;

%%

void yyerror(const char *s) {
    add_syntax_error(current_line);
}

int main(int argc, char** argv) {
    if (argc > 1) {
        input_filename = argv[1];
        FILE* file = fopen(input_filename, "r");
        if (!file) {
            fprintf(stderr, "❌ Error: No se pudo abrir el archivo %s\n", input_filename);
            return 1;
        }
        yyin = file;
    }
    
    printf("🔍 Iniciando análisis sintáctico...\n");
    
    int result = yyparse();
    
    save_syntax_output(input_filename);
    
    // Mostrar resumen en consola
    printf("\n📊 Resumen del análisis sintáctico:\n");
    printf("════════════════════════════════════\n");
    if (error_count == 0) {
        printf("✅ Programa sintácticamente correcto\n");
        printf("   0 errores encontrados\n");
    } else {
        printf("❌ Se encontraron %d errores sintácticos:\n", error_count);
        for(int i = 0; i < error_count; i++) {
            printf("   - Línea %d\n", syntax_errors[i]);
        }
    }
    printf("════════════════════════════════════\n");
    
    if (yyin != stdin) {
        fclose(yyin);
    }
    
    return error_count > 0 ? 1 : 0;
}
