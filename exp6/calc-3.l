%{
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
void yyerror(char *);
%}
num [0-9]
letter [A-Za-z_]

%%

{num}+      { yylval.str = strdup(yytext); return DIGIT; }
{letter}[A-Za-z0-9_]*   { yylval.str = strdup(yytext); return ID; }
[+-/*\n]    { return *yytext; }
[ \t\n]	    { }
.           { return yytext[0]; }

%%

int yywrap(void) {
	return 1;
}