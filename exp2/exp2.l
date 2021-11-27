%{
/*declarations*/
#include <stdio.h>

%}

/*lex substituition strings*/
num             [0-9]
exp             [a-zA-Z_][a-zA-Z0-9_]*
typeInt         int
typeFloat       float
typeChar        char
space           [ ]
open            [(]
close           [)]
open_2          [{]
close_2         [}]

%%      /*lexical analyser rules*/

#.* {printf("\n%s is a preprocesor directive\n",yytext);}

{typeInt}{space}{exp}[ ]?{open}.*{close}[ ]?{open_2}.*{close_2}  {printf("\n%s is a function\n",yytext);} 

{typeFloat}{space}{exp}[ ]?{open}.*{close}[ ]?{open_2}.*{close_2}  {printf("\n%s is a function\n",yytext);} 

{typeChar}{space}{exp}[ ]?{open}.*{close}[ ]?{open_2}.*{close_2}  {printf("\n%s is a function\n",yytext);} 


{typeInt}   {printf("\n%s is a keyword\n",yytext);}

{typeFloat}   {printf("\n%s is a keyword\n",yytext);}

{typeChar}   {printf("\n%s is a keyword\n",yytext);}


double      {printf("\n%s is a keyword\n",yytext);}

if          {printf("\n%s is a keyword\n",yytext);}

else        {printf("\n%s is a keyword\n",yytext);}

while       {printf("\n%s is a keyword\n",yytext);}

do          {printf("\n%s is a keyword\n",yytext);}

return      {printf("\n%s is a keyword\n",yytext);}

break       {printf("\n%s is a keyword\n",yytext);}

continue    {printf("\n%s is a keyword\n",yytext);}

void        {printf("\n%s is a keyword\n",yytext);}

switch      {printf("\n%s is keyword\n",yytext);}

for         {printf("\n%s is a keyword\n",yytext);}

typedef     {printf("\n%s is a keyword\n",yytext);}

struct      {printf("\n%s is a keyword\n",yytext);}

goto        {printf("\n%s is a keyword\n",yytext);}


{exp}       {printf("\n%s is an Identifier\n",yytext);}

{num}+      {printf("\n%s is a number\n",yytext);}

[\n\t ]     ;

.*          {printf("\nInvalid Input\n");}

%%

int main()

{
    yylex();

}