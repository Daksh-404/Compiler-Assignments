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
%token <str>DIGIT
%token <str>ID
%type <str>E

%%

S	: S ID '=' E '\n' { printf("%s = %s\n", $2, $4); }
	| S E '\n' { }
	| S '\n' { }
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

%%


void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void) {
    yyparse();
    return 0;
}
