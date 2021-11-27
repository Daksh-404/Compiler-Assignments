%{
	#include<stdio.h>
	int yylex(void);
	int yyerror(const char *s);
	extern FILE* yyin;
%}

%token int_const char_const float_const id string enumeration_const storage_const type_const qual_const struct_const enum_const DEFINE
%token IF FOR DO WHILE BREAK SWITCH CONTINUE RETURN CASE DEFAULT GOTO SIZEOF PUNC logical_const shift_const rel_const inc_const
%token point_const param_const ELSE HEADER PRINTF 

%left '*' '/' '%'
%left '+' '-'
%left '&' '|' '^'
%left '(' ')'

%nonassoc "then"
%nonassoc ELSE
%start program_unit_first

%%

program_unit_first			: HEADER program_unit_second    {printf("Parsed Successfully!\n");}       
							| HEADER program_unit_first		{printf("Parsed Successfully!\n");}
							;

program_unit_second			: DEFINE consts program_unit_second
							| program_unit_third
							;

program_unit_third			: exp program_unit_third
							| functions program_unit_third
							| /*epsilon*/
							;

functions 					: type_const id '(' arg_list ')' internal_block
							;

function_call				: id '(' arg_list_call ')' 
							;

internal_block				: '{' block '}'
							| '{' block RETURN exp4 ';' '}'
							| '{' block RETURN ';' '}'
							;

arg_list					: exp2
							| arg_list ',' exp2
							| /*epsilon*/
							;

arg_list_call				: exp4
							| arg_list_call ',' exp4
							| /*epsilon*/
							;							

block						: exp block
							| loops block
							| conditionals block
							| print block
							| BREAK ';'
							| CONTINUE ';'
							| /*epsilon*/
							;

conditionals				: IF '(' cond_exp ')' internal_block
							| IF '(' cond_exp ')' internal_block ELSE internal_block
							;

loops 						: FOR '(' exp3 ';' exp3 ';' exp3 ')' internal_block
							| WHILE '(' cond_exp ')' internal_block
							| DO internal_block WHILE '(' cond_exp ')' ';'
							;

exp 						: type_const id '=' exp4 ';'
							| type_const id '=' function_call ';'
							| id '=' exp4 ';'
							| id '=' function_call ';'
							| type_const id ';'
							;

exp2 						: type_const id '=' exp4 
							| type_const id
							;

exp3						: type_const id '=' exp4
							| cond_exp
							| id inc_const
							;

exp4						: exp4 '+' exp4 
							| exp4 '-' exp4 
							| exp4 '*' exp4
							| exp4 '/' exp4 
							| exp4 '%' exp4
							| exp4 '&' exp4
							| exp4 '|' exp4
							| exp4 '^' exp4
							| '(' exp4 ')' 
							| primary_exp


cond_exp					: exp4 rel_const exp4
							;

print						: PRINTF '(' id ')' ';'
							| PRINTF '(' consts ')' ';'
							| PRINTF '(' string ')' ';'
							| PRINTF '(' string ',' exp4 ')' ';'
 							;

primary_exp					: id 													
							| consts 
							| string												
							;

consts						: int_const
							| float_const
							| char_const						
							;


%%

int main()
{
    // open a file handle to a particular file:
	FILE *myfile = fopen("input.txt", "r");
	// make sure it's valid:
	if (!myfile) 
	{
		printf("I can't open input file!\n" );
		return -1;
	}
	// set flex to read from it instead of defaulting to STDIN:
	yyin = myfile;

	// parse through the input until there is no more:
	do 
	{
		yyparse();
	} while (!feof(yyin));
}

int yyerror(const char *msg)
{
	extern int yylineno;
	printf("Parsing Failed\nLine Number: %d %s\n",yylineno,msg);
	return 0;
}
