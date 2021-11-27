%option yylineno

%{
	#include<stdio.h>
	#include"y.tab.h"
	#include<math.h>
%}
%%
"#include"([ ]+)?((<(\\.|[^>])+>)|(\"(\\.|[^"])+\"))					                                    {return HEADER;}
"#define"[ ]+[a-zA-z_][a-zA-z_0-9]* 																	    {return DEFINE;}
"void"|"char"|"short"|"int"|"long"|"float"|"double"|"signed"|"unsigned"|"int*"|"char*"|"float*"				{return type_const;}	
"if"																										{return IF;}
"else"																										{return ELSE;}
"for"																										{return FOR;}
"do"																										{return DO;}
"while"																										{return WHILE;}
"continue"																									{return CONTINUE;}
"break"																										{return BREAK;}
"printf"																									{return PRINTF;}
"return"																									{return RETURN;}
"&&"|"||"																									{return logical_const;}
"<="|">="|"=="|"!="|"<"|">"																					{return rel_const;}
">>"|"<<"																									{return shift_const;}
"++"|"--"																									{return inc_const;}
";"|"="|","|"{"|"}"|"("|")"|"["|"]"|"?"|":"|"*"|"+"|"-"|"/"|"&"|"|"|"^"|"!"|"~"|"%"							{return yytext[0];}																						
[0-9]+																										{return int_const;}
[0-9]+"."[0-9]+																								{return float_const;}	
"'"."'"																										{return char_const;}
[a-zA-z_][a-zA-z_0-9]*			 																			{return id;}
\"(\\.|[^\"])*\"																							{return string;}																							
"//"(\\.|[^\n])*[\n]																						;
[/][*]([^*]|[*]*[^*/])*[*]+[/]                                                                              ;
[ \t\n]																										;
%%

int yywrap(void)
{
    return 1;
}