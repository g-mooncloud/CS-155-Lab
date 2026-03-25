/* PURISIMA, Ann Gabrielle C.*/

%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>                                       /* Addition for Exponents */

void yyerror(const char *msg);
int yylex(void);
%}

%union {
    int ival;
    double fval;
}

%token <ival> NUM
%token <fval> FNUM                                      /* Addition for Floating Numbers */
%token PLUS MINUS TIMES DIVIDE LPAREN RPAREN EXPO       /* Addition for Exponents */

%left PLUS MINUS
%left TIMES DIVIDE
%right UMINUS
%right EXPO                                             /* Addition for Exponents */

%type <ival> expr term factor

%%

program:                                    /* Allows multiple test lines; Recursive */
    program input
    | input
    ;
    
input:                                      /* Allows multiple test lines; Recursive */
      expr '\n'                             { printf("Result: %d\n", $1); }
    | '\n' 
    ;

expr:
    expr PLUS term                          { $$ = $1 + $3; }
    | expr MINUS term                       { $$ = $1 - $3; }
    | term                                  { $$ = $1; }
    ;

term:
    term TIMES factor                       { $$ = $1 * $3; }
    | term DIVIDE factor                    { $$ = $1 / $3; }
    | factor                                { $$ = $1; }
    ;

factor:
    NUM                                     { $$ = $1; }
    | LPAREN expr RPAREN                    { $$ = $2; }
    | MINUS factor %prec UMINUS             { $$ = -$2; }
    | factor EXPO factor                    { $$ = (int)pow((double)$1, (double)$3); }     /* Additional Rule for Exponents */
    ;

%%

void yyerror(const char *msg) {
    fprintf(stderr, "Parse error: %s\n", msg);
}

int main(void) {
    if (freopen("test.txt", "r", stdin) == NULL) {      /* For Opening Test File */
        perror("Error opening file");
        return 1;
    }

    return yyparse();
}