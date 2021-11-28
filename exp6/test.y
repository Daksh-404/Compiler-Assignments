%{
    
    #include <stdio.h>
    #include <stdlib.h>

    int yylex();
    void yyerror(char* s);

    char* symbols[1000];
    int symbolValues[1000];
    int symbolCounter = 0;
    int labelCounter = 0;
    char* numToString;
    char* labels;
    char* Temp();
    char* Label();
    FILE* yyout; 
    FILE* yyin;
   
%}

%union {
    struct quadruple
    {
        int num;
        int isnum;
        char *arg1;
        char *arg2;
        char * result;
    } tuple;
}

%start line
%token <tuple> number
%token TYPE
%token IF
%token ELSE
%token <tuple> incDec
%token <tuple> FOR
%token <tuple> WHILE
%token <tuple> identifier
%token <tuple> RELOP
%type <tuple> line exp factor assignment term C
%left '+' '-'
%left '*' '/'

%%

line :  assignment ';' {;}
     | line assignment ';'{;}
     | line exp ';' {;}
     | line WHILE {labels = Label(); $2.arg1 = labels; fprintf(yyout,"%s:\n",$2.arg1);} '(' C { labels = Label(); $5.arg2 = labels; fprintf(yyout,"if %s Goto %s\n",$5.result,$5.arg2);} ')' '{' line '}' { fprintf(yyout,"Goto %s\n %s:\n",$2.arg1,$2.arg2);}
     | WHILE {labels = Label(); $1.arg1 = labels; fprintf(yyout,"%s:\n",$1.arg1);} '(' C { labels = Label(); $1.arg2 = labels; fprintf(yyout,"if %s Goto %s\n",$4.result,$1.arg2);} ')' '{' line '}' { fprintf(yyout,"Goto %s\n %s:\n",$1.arg1,$1.arg2);}
     | line IF '(' C { labels = Label(); $4.arg2 = labels; fprintf(yyout,"IfZ %s Goto %s \n",$4.result,labels);    }   ')' '{' line '}' { fprintf(yyout,"%s :\n",$4.arg2);}
     | IF '(' C { labels = Label(); $3.arg2 = labels; fprintf(yyout,"IfZ %s Goto %s \n",$3.result,labels);    }   ')' '{' line '}' { fprintf(yyout,"%s :\n",$3.arg2);}
     ;

assignment : TYPE identifier '=' exp { fprintf(yyout,"%s = %s\n",$2.result,$4.result);}
           | identifier '=' exp { fprintf(yyout,"%s = %s\n",$1.result,$3.result);}          
        ;

exp : term {;}
    | '-' '-' exp   { fprintf(yyout,"--%s\n",$3.result); }       
    | '+' '+' exp {fprintf(yyout,"++%s\n",$3.result);}
    | exp '-' '-'    { fprintf(yyout,"%s--\n",$1.result); }       
    | exp '+' '+'  {fprintf(yyout,"%s++\n",$1.result);}
    | exp '+' term { $$.arg1 = $1.result; $$.arg2 = $3.result; $$.result = Temp(); $$.isnum = 0;  if($1.isnum == 1){  fprintf(yyout,"%s = %d + %s\n",$$.result,$1.num,$3.result);}else { fprintf(yyout,"%s = %s + %s\n",$$.result,$$.arg1,$$.arg2);}}
    | exp '-' term { $$.arg1 = $1.result; $$.arg2 = $3.result; $$.result = Temp(); $$.isnum = 0;  if($1.isnum == 1){  fprintf(yyout,"%s = %d - %s\n",$$.result,$1.num,$3.result);}else { fprintf(yyout,"%s = %s - %s\n",$$.result,$$.arg1,$$.arg2);}}
    ;

C : exp RELOP exp {  if($3.isnum == 1){ $$.arg1 = Temp(); $$.result = Temp(); fprintf(yyout,"%s = %d\n",$$.arg1,$3.num);  fprintf(yyout,"%s = %s %s %s\n",$$.result,$1.result,$2.arg1,$$.arg1);}else {  $$.result = Temp(); fprintf(yyout,"%s = %s %s %s\n",$$.result,$1.result,$2.arg1,$3.result);}}
  ;

term : factor {;}
     | term '*' factor {  $$.arg1 = $1.result; $$.arg2 = $3.result; $$.result = Temp(); $$.isnum = 0;  if($1.isnum == 1){  fprintf(yyout,"%s = %d * %s\n",$$.result,$1.num,$3.result);}else { fprintf(yyout,"%s = %s * %s\n",$$.result,$$.arg1,$$.arg2);}}
     | term '/' factor { $$.arg1 = $1.result; $$.arg2 = $3.result; $$.result = Temp(); $$.isnum = 0;  if($1.isnum == 1){  fprintf(yyout,"%s = %d / %s\n",$$.result,$1.num,$3.result);}else { fprintf(yyout,"%s = %s / %s\n",$$.result,$$.arg1,$$.arg2);}}
     ;

factor : number { sprintf(numToString,"%d",$1.num); $1.isnum = 1; $1.arg1 = numToString; $1.result = numToString; $$ =$1;}
       | '(' exp ')' { $2.isnum=0;  $$ = $2; } 
       | identifier {  $$.result = $1.result; }
       ;

%%

char * Temp(){
    
    symbolCounter++;
    char *temp=(char *)malloc(sizeof(5*sizeof(char)));
    sprintf(temp,"t%d",symbolCounter);
    return temp;
}

char * Label(){
    
    labelCounter++;
    char *temp=(char *)malloc(sizeof(5*sizeof(char)));
    sprintf(temp,"L%d",labelCounter);
    return temp; 
}

int main() {
  
    labels = malloc(10 * sizeof(char));
    numToString = malloc(11 * sizeof(char));
    yyout = fopen("out.txt","w+");
    yyin = fopen("input.txt", "r");
    fprintf(yyout,"--INTERMEDIATE THREE ADDRESS CODE--\n\n");
    yyparse();
    printf("---Code Generation Complete---\n");
    fclose(yyin);
    fclose(yyout);
}

void yyerror (char *s) {
    fprintf (stderr, "%s\n", s);
}