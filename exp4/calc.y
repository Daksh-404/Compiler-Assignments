%{
void yyerror (char *s);
int yylex();
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <ctype.h>
int symbols[52];
int symbolVal(char symbol);
void updateSymbolVal(char symbol, int val);
int success = 1;
%}

%union {int num; char id;}         /* Yacc definitions */
%start line
%token print
%token exit_command
%token <num> number
%token <id> identifier
%type <num> line exp term 
%type <id> assignment

%left '+' '-'
%left '*' '/' '%'
%left '(' ')'
%left UMINUS  /*supplies precedence for unary minus */

%%

/* descriptions of expected inputs     corresponding actions (in C) */

line    	: assignment ';'		{;}
			| exit_command ';'		{exit(EXIT_SUCCESS);}
			| print exp ';'			{printf("Printing %d\n", $2);}
			| line assignment ';'	{;}
			| line print exp ';'	{printf("Printing %d\n", $3);}
			| line exit_command ';'	{exit(EXIT_SUCCESS);}
			;

assignment 	: identifier '=' exp  	{ updateSymbolVal($1,$3); }
			;

exp    		: term                  {$$ = $1;}
			| '(' exp ')'			{$$ = $2;}
			| exp '*' exp			{$$ = $1 * $3;}
			| exp '/' exp			{$$ = $1 / $3;}
			| exp '%' exp			{$$  = $1 % $3;}
			| exp '+' exp			{$$ = $1 + $3;}
			| exp '-' exp			{$$ = $1 - $3;}
			| '-' exp %prec UMINUS	{$$ = - $2;}
			;

term   		: number                {$$ = $1;}
			| identifier			{$$ = symbolVal($1);} 
			;

%%                     /* C code */

int findIndex(char token)
{
	int idx = -1;
	if(islower(token)) {
		idx = token - 'a' + 26;
	} else if(isupper(token)) {
		idx = token - 'A';
	}
	return idx;
} 

/* returns the value of a given symbol */
int symbolVal(char symbol)
{
	int idx = findIndex(symbol);
	return symbols[idx];
}

/* updates the value of a given symbol */
void updateSymbolVal(char symbol, int val)
{
	int idx = findIndex(symbol);
	symbols[idx] = val;
}

int main (void) {
	/* init symbol table */
	int i;
	for(i=0; i<52; i++) 
	{
		symbols[i] = 0;
	}

	return yyparse();
}

void yyerror (char *s) 
{	
	fprintf (stderr, "%s\n", s);
} 