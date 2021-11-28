%{
#include "y.tab.h"
#include <string.h>
%}

relop >=|<=|>|<|==|!=
number [0-9]+

%%

<<<<<<< HEAD
[\n\t ]+	                   {;}
"if"                           {return IF;}
"while"                        {return WHILE;}
"for"                          {return FOR;}
"else"                         {return ELSE;}
"int"|"string"|"char"|"double" {return TYPE;}
[a-z]([a-z]|[0-9])* 		   {yylval.tuple.result = strdup(yytext); return identifier;}
[0-9]+                         {yylval.tuple.num= atoi(yytext); return number;}
{relop}                        {yylval.tuple.arg1 =strdup(yytext); return RELOP;}
[-+*=/;%(){}]                  {return yytext[0];}

=======
{num}+      { yylval.str = strdup(yytext); return DIGIT; }
{letter}[A-Za-z0-9_]*   { yylval.str = strdup(yytext); return ID; }
[+-/*\n]    { return *yytext; }
[ \t\n]	    { }
.           { return yytext[0]; }
>>>>>>> 15facb320fbf1d8950f802bdffb55165fee84a4e

%%

int yywrap(void)
{
	return 1;
}