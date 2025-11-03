%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

// Pila para manejar niveles de indentación
int indent_stack[100];
int stack_top = 0;
int current_indent = 0;
int at_line_start = 1;
int pending_dedents = 0;
int line_number = 1;

// Colores ANSI
#define COLOR_RESET   "\033[0m"
#define COLOR_KEYWORD "\033[1;35m"  // Magenta bold
#define COLOR_ID      "\033[0;36m"  // Cyan
#define COLOR_NUMBER  "\033[0;33m"  // Yellow
#define COLOR_STRING  "\033[0;32m"  // Green
#define COLOR_OPERATOR "\033[1;34m" // Blue bold
#define COLOR_INDENT  "\033[1;31m"  // Red bold
#define COLOR_TAB     "\033[1;33m"  // Yellow bold
#define COLOR_ERROR   "\033[1;41m"  // Red background

int token_count = 0;
int tab_count = 0;
int error_count = 0;

void print_token(const char* color, const char* token_name, const char* value) {
    token_count++;
    if (value) {
        printf("%s%-15s%s : %s\n", color, token_name, COLOR_RESET, value);
    } else {
        printf("%s%-15s%s\n", color, token_name, COLOR_RESET);
    }
}

void init_indent_stack() {
    indent_stack[0] = 0;
    stack_top = 0;
}

int calculate_indent(char* text, int* tabs) {
    int spaces = 0;
    *tabs = 0;
    
    for(int i = 0; text[i] != '\0'; i++) {
        if(text[i] == ' ') {
            spaces++;
        } else if(text[i] == '\t') {
            (*tabs)++;
            spaces += 8;
        }
    }
    return spaces;
}

int process_indent(int new_indent) {
    if(new_indent > indent_stack[stack_top]) {
        stack_top++;
        indent_stack[stack_top] = new_indent;
        return 1;  // INDENT
    } else if(new_indent < indent_stack[stack_top]) {
        while(stack_top > 0 && new_indent < indent_stack[stack_top]) {
            stack_top--;
            pending_dedents++;
        }
        return 2;  // DEDENT
    }
    return 0;
}

int check_pending_dedents() {
    if(pending_dedents > 0) {
        pending_dedents--;
        return 1;
    }
    return 0;
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
INDENT_CHARS [ \t]+

%%

^{INDENT_CHARS}  {
    if(at_line_start) {
        int tabs = 0;
        current_indent = calculate_indent(yytext, &tabs);
        
        // Mostrar cada TAB encontrado
        for(int i = 0; i < tabs; i++) {
            print_token(COLOR_TAB, "TAB", "\\t");
            tab_count++;
        }
        
        at_line_start = 0;
        int token = process_indent(current_indent);
        if(token == 1) {
            char indent_info[50];
            sprintf(indent_info, "nivel %d (%d espacios)", stack_top, current_indent);
            print_token(COLOR_INDENT, "INDENT", indent_info);
        } else if(token == 2) {
            print_token(COLOR_INDENT, "DEDENT", NULL);
        }
    }
}

^[^ \t\n\r#]  {
    if(at_line_start) {
        current_indent = 0;
        int token = process_indent(current_indent);
        at_line_start = 0;
        yyless(0);
        if(token == 2) {
            print_token(COLOR_INDENT, "DEDENT", NULL);
        }
    }
}

<<EOF>> {
    if(check_pending_dedents()) {
        print_token(COLOR_INDENT, "DEDENT", NULL);
        return 0;
    }
    
    if(stack_top > 0) {
        stack_top--;
        print_token(COLOR_INDENT, "DEDENT", NULL);
        return 0;
    }
    yyterminate();
}

#.*             { 
    print_token(COLOR_OPERATOR, "COMENTARIO", yytext); 
}

"and"           { print_token(COLOR_KEYWORD, "AND", NULL); }
"break"         { print_token(COLOR_KEYWORD, "BREAK", NULL); }
"continue"      { print_token(COLOR_KEYWORD, "CONTINUE", NULL); }
"def"           { print_token(COLOR_KEYWORD, "DEF", NULL); }
"elif"          { print_token(COLOR_KEYWORD, "ELIF", NULL); }
"else"          { print_token(COLOR_KEYWORD, "ELSE", NULL); }
"for"           { print_token(COLOR_KEYWORD, "FOR", NULL); }
"if"            { print_token(COLOR_KEYWORD, "IF", NULL); }
"import"        { print_token(COLOR_KEYWORD, "IMPORT", NULL); }
"in"            { print_token(COLOR_KEYWORD, "IN", NULL); }
"is"            { print_token(COLOR_KEYWORD, "IS", NULL); }
"not"           { print_token(COLOR_KEYWORD, "NOT", NULL); }
"or"            { print_token(COLOR_KEYWORD, "OR", NULL); }
"pass"          { print_token(COLOR_KEYWORD, "PASS", NULL); }
"return"        { print_token(COLOR_KEYWORD, "RETURN", NULL); }
"while"         { print_token(COLOR_KEYWORD, "WHILE", NULL); }
"print"         { print_token(COLOR_KEYWORD, "PRINT", NULL); }
"range"         { print_token(COLOR_KEYWORD, "RANGE", NULL); }
"len"           { print_token(COLOR_KEYWORD, "LEN", NULL); }

"True"          { print_token(COLOR_KEYWORD, "TRUE", NULL); }
"False"         { print_token(COLOR_KEYWORD, "FALSE", NULL); }

{STRING}        { print_token(COLOR_STRING, "STRING", yytext); }
{IMAGINARY}     { print_token(COLOR_NUMBER, "IMAGINARY", yytext); }
{REAL}          { print_token(COLOR_NUMBER, "REAL", yytext); }
{LONG}          { print_token(COLOR_NUMBER, "LONG", yytext); }
{INTEGER}       { print_token(COLOR_NUMBER, "INTEGER", yytext); }
{INVALID_NUM}   { 
    print_token(COLOR_ERROR, "ERROR_NUM", yytext); 
    error_count++;
}
{INVALID_ID}    { 
    print_token(COLOR_ERROR, "ERROR_ID", yytext); 
    error_count++;
}

"**"            { print_token(COLOR_OPERATOR, "POW", "**"); }
"//"            { print_token(COLOR_OPERATOR, "FLOORDIV", "//"); }
"<<"            { print_token(COLOR_OPERATOR, "LSHIFT", "<<"); }
">>"            { print_token(COLOR_OPERATOR, "RSHIFT", ">>"); }
"<>"            { print_token(COLOR_OPERATOR, "NOTEQUAL2", "<>"); }
"=="            { print_token(COLOR_OPERATOR, "EQUAL", "=="); }
"!="            { print_token(COLOR_OPERATOR, "NOTEQUAL", "!="); }
">="            { print_token(COLOR_OPERATOR, "GREATEREQUAL", ">="); }
"<="            { print_token(COLOR_OPERATOR, "LESSEQUAL", "<="); }
"=?"            { 
    print_token(COLOR_ERROR, "ERROR_OP", "=?"); 
    error_count++;
}
"%"             { print_token(COLOR_OPERATOR, "MOD", "%"); }
"&"             { print_token(COLOR_OPERATOR, "BITAND", "&"); }
"|"             { print_token(COLOR_OPERATOR, "BITOR", "|"); }
"^"             { print_token(COLOR_OPERATOR, "BITXOR", "^"); }
"~"             { print_token(COLOR_OPERATOR, "BITNOT", "~"); }
"+"             { print_token(COLOR_OPERATOR, "PLUS", "+"); }
"-"             { print_token(COLOR_OPERATOR, "MINUS", "-"); }
"*"             { print_token(COLOR_OPERATOR, "TIMES", "*"); }
"/"             { print_token(COLOR_OPERATOR, "DIVIDE", "/"); }
"="             { print_token(COLOR_OPERATOR, "ASSIGN", "="); }
"<"             { print_token(COLOR_OPERATOR, "LESS", "<"); }
">"             { print_token(COLOR_OPERATOR, "GREATER", ">"); }

"//="           { print_token(COLOR_OPERATOR, "FLOORDIVASSIGN", "//="); }
"+="            { print_token(COLOR_OPERATOR, "PLUSASSIGN", "+="); }
"-="            { print_token(COLOR_OPERATOR, "MINUSASSIGN", "-="); }
"*="            { print_token(COLOR_OPERATOR, "TIMESASSIGN", "*="); }
"/="            { print_token(COLOR_OPERATOR, "DIVIDEASSIGN", "/="); }

"("             { print_token(COLOR_OPERATOR, "LPAREN", "("); }
")"             { print_token(COLOR_OPERATOR, "RPAREN", ")"); }
"["             { print_token(COLOR_OPERATOR, "LBRACKET", "["); }
"]"             { print_token(COLOR_OPERATOR, "RBRACKET", "]"); }
"{"             { print_token(COLOR_OPERATOR, "LBRACE", "{"); }
"}"             { print_token(COLOR_OPERATOR, "RBRACE", "}"); }
":"             { print_token(COLOR_OPERATOR, "COLON", ":"); }
";"             { print_token(COLOR_OPERATOR, "SEMICOLON", ";"); }
","             { print_token(COLOR_OPERATOR, "COMMA", ","); }
"."             { print_token(COLOR_OPERATOR, "DOT", "."); }

{ID}            { print_token(COLOR_ID, "ID", yytext); }

\n              { 
    if(check_pending_dedents()) {
        print_token(COLOR_INDENT, "DEDENT", NULL);
        return 0;
    }
    at_line_start = 1; 
    line_number++;
    print_token(COLOR_OPERATOR, "NEWLINE", NULL);
}

[ ]+            { /* espacios dentro de línea - ignorar */ }
\r              { /* ignorar retorno de carro */ }

.               { 
    char error_msg[100];
    sprintf(error_msg, "'%s' (ASCII: %d)", yytext, (int)yytext[0]);
    print_token(COLOR_ERROR, "ERROR_CHAR", error_msg); 
    error_count++;
}

%%

int main(int argc, char **argv) {
    char* input_filename = NULL;
    
    printf("\033[1;36m╔════════════════════════════════════════════════════════════╗\033[0m\n");
    printf("\033[1;36m║         VISUALIZADOR DE TOKENS - PYTHON SIMPLIFICADO      ║\033[0m\n");
    printf("\033[1;36m╚════════════════════════════════════════════════════════════╝\033[0m\n\n");
    
    if (argc > 1) {
        input_filename = argv[1];
        FILE* file = fopen(input_filename, "r");
        if (!file) {
            fprintf(stderr, "\033[1;31m❌ Error: No se pudo abrir el archivo %s\033[0m\n", input_filename);
            return 1;
        }
        yyin = file;
        printf("\033[1;33m📄 Archivo:\033[0m %s\n", input_filename);
    } else {
        printf("\033[1;33m📄 Entrada:\033[0m stdin (Ctrl+D para terminar)\n");
    }
    
    printf("\033[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m\n\n");
    
    init_indent_stack();
    
    while(yylex() != 0) {
        // Continuar procesando
    }
    
    printf("\n\033[1;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m\n");
    printf("\033[1;32m📊 ESTADÍSTICAS:\033[0m\n");
    printf("   Total de tokens: \033[1;37m%d\033[0m\n", token_count);
    printf("   Tabulaciones:    \033[1;33m%d\033[0m\n", tab_count);
    printf("   Líneas:          \033[1;37m%d\033[0m\n", line_number);
    
    if (error_count > 0) {
        printf("   \033[1;31m⚠️  Errores:        %d\033[0m\n", error_count);
    } else {
        printf("   \033[1;32m✅ Errores:        0\033[0m\n");
    }
    
    printf("\033[1;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m\n");
    
    if (argc > 1) {
        fclose(yyin);
    }
    
    return error_count > 0 ? 1 : 0;
}
