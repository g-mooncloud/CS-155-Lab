/* PURISIMA, Ann Gabrielle C.*/

%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>                                       /* Addition for Exponents */

void yyerror(const char *msg);
int yylex(void);

int depth = 0;                                          /* Addition for Parse Tree */

void indent(int d){
    for(int i = 0; i < d; i++) printf("  ");
}

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

program:                                                /* Allows multiple test lines; Recursive */
    program input
    | { indent(depth); printf("expr\n"); depth++; 
      } input
    ;
    
input:                                                  /* Allows multiple test lines; Recursive */
    expr '\n'                                           /* { printf("Result: %d\n", $1); } */
    | '\n' 
    ;

expr:
    expr { indent(depth); printf("+\n"); 
        } PLUS { indent(depth); printf("term\n"); depth++; 
        } term { depth--; }                                             /* PLUS  { $$ = $1 + $3; } */                         
    | expr { indent(depth); printf("-\n"); 
        } MINUS { indent(depth); printf("term\n"); depth++; 
        } term { depth--; }                                             /* MINUS { $$ = $1 - $3; } */
    | { indent(depth); printf("expr\n"); depth++; 
        } term { depth--; }                                             /* TERM { $$ = $1; } */
    ;

term:
    term { indent(depth); printf("*\n"); 
        } TIMES { indent(depth); printf("factor\n"); depth++; 
        } factor { depth--; }                                           /* TIMES { $$ = $1 * $3; } */
    | term { indent(depth); printf("/\n"); 
        } DIVIDE { indent(depth); printf("factor\n"); depth++; 
        } factor { depth--; }                                           /* DIVIDE { $$ = $1 / $3; } */
    | { indent(depth); printf("term\n"); depth++; 
        indent(depth); printf("factor\n"); depth++; 
        } factor { depth--; }                                           /* FACTOR { $$ = $1; } */
    ;

factor:
    NUM { indent(depth); printf("%d\n", $1); depth--; }                 /* NUM { $$ = $1; } */
    | { indent(depth); printf("(\n"); 
        } LPAREN { indent(depth); printf("expr\n"); depth++; 
        } expr { depth--; indent(depth); printf(")\n");  
        } RPAREN { depth--; }                                           /* PAREN { $$ = $2; } */
    | MINUS { indent(depth); printf("-\n"); 
        indent(depth); printf("factor\n"); depth++; 
        } factor { depth--; } %prec UMINUS                              /* UMINUS { $$ = -$2; } */
    | factor EXPO { indent(depth); printf("^\n");                       /* Additional Rule for Exponents */
        indent(depth); printf("factor\n"); depth++;  
        } factor { depth--; }                                           /* EXPO { $$ = (int)pow((double)$1, (double)$3); } */ 
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