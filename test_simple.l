%{
#include <stdio.h>
int id_counter = 0;
int error_count = 0;
%}

%%

"if"            { printf("IF "); }
"else"          { printf("ELSE "); }
[a-zA-Z][a-zA-Z0-9_]*   { printf("ID=%s ", yytext); }
[0-9]+          { printf("NUM=%s ", yytext); }
[ \t\n]+        { /* ignore whitespace */ }
.               { printf("ERROR=%s ", yytext); error_count++; }

%%

int main() {
    printf("=== Analizador Lexico Simple ===\n");
    yylex();
    printf("\n%d Errores\n", error_count);
    return 0;
}

int yywrap() {
    return 1;
}