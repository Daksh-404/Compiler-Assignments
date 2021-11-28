%{
#include <stdio.h>
#include <string.h>
void yyerror(char *);
int yylex();
int n=1;
char tmp[20];
%}


%union{
  char* str;
}


%left '+' '-'
%left '*' '/'
%right UMINUS
%start St
%token <str> DIGIT 
%token <str> ID
%token <str> IF
%token <str> rel_const
%type <str> E

%%

<<<<<<< HEAD
St							:  St ID '=' E    { printf("%s = %s\n", $2, $4); }
							|  St E
							|  
							;

E							: DIGIT { $$ = yylval.str; }
							| ID { $$ = yylval.str; }
							| E '+' E { printf("t%d = %s + %s\n", n, $1, $3); sprintf(tmp, "t%d", n++); $$=strdup(tmp); }
							| E '-' E { printf("t%d = %s - %s\n", n, $1, $3); sprintf(tmp, "t%d", n++); $$=strdup(tmp); }
							| E '*' E { printf("t%d = %s * %s\n", n, $1, $3); sprintf(tmp, "t%d", n++); $$=strdup(tmp); }
							| E '/' E { printf("t%d = %s / %s\n", n, $1, $3); sprintf(tmp, "t%d", n++); $$=strdup(tmp); }
							| '-' E %prec UMINUS { printf("t%d = minus %s\n", n, $2); sprintf(tmp, "t%d", n++); $$=strdup(tmp);}
							| '(' E ')'{ $$ = $2; }
							;
=======
S	: S ID '=' E  { printf("%s = %s\n", $2, $4); }
	| S E  
	| S  
	| 
	;
E	: DIGIT { $$ = yylval.str; }
	| ID { $$ = yylval.str; }
	| E '+' E { printf("t%d = %s + %s\n", n, $1, $3); sprintf(tmp, "t%d", n++); $$=strdup(tmp); }
	| E '-' E { printf("t%d = %s - %s\n", n, $1, $3); sprintf(tmp, "t%d", n++); $$=strdup(tmp); }
	| E '*' E { printf("t%d = %s * %s\n", n, $1, $3); sprintf(tmp, "t%d", n++); $$=strdup(tmp); }
	| E '/' E { printf("t%d = %s / %s\n", n, $1, $3); sprintf(tmp, "t%d", n++); $$=strdup(tmp); }
	| '-' E %prec UMINUS { printf("t%d = minus %s\n", n, $2); sprintf(tmp, "t%d", n++); $$=strdup(tmp);}
	| '(' E ')'{ $$ = $2; }
	;
>>>>>>> 15facb320fbf1d8950f802bdffb55165fee84a4e

%%


void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void) {
    yyparse();
    return 0;
}
