%{
    #include <stdio.h>
    #include<math.h>
    int yylex(void);
    void yyerror(char *);
    extern FILE * yyin;
    extern FILE * yyout;
%}

%token DEF FN DIM MSS END GOSUB GOTO IF THEN LET INPUT PRINT NEXT TO REM RETURN STOP STEP
%token  INTEGER
%token DATA
%token FLOAT AND OR NOT XOR
%token REMSTR STRING
%token NORVAR SINGLEVAR DOUBLEVAR STRVAR RELOP DOUBLE NE FOR
%left '+' '-'
%left '*' '/'
%start program

%%
program : line 
        | program line
        ;

line    : number statement
number  : INTEGER;
statement: data|def|dim|end|forr|next|gosub|got|iff|let|input|print|stop|rem|returnn 

data: DATA data_list 
data_list:
    data_item 
    | data_list ',' data_item 
    ;

data_item:
    INTEGER 
    |FLOAT
    | DOUBLE
    |STRING
    ;

def: DEF FN '=' expr
      |DEF FN '('varname')''=' expr 
;
expr: expr '+' term
    | expr '-' term 
    | term 
    ;
term: term '*' factor 
    | term '/' factor 
    | factor 
    ;
factor:'~' factor 
        | '~' exp 
        | exp
        ;
exp: exp2 '^' exp 
    | exp2
    ;
exp2: '(' expr ')' 
    |numbertype
    |MSS 
    |NORVAR
    |DOUBLEVAR 
    |SINGLEVAR 
    ;
numbertype: INTEGER|FLOAT|DOUBLE;

dim: DIM dimm;
dimm: dimm ',' MSS '(' intt ')'
    | MSS '(' intt ')'
    ;
intt: INTEGER ',' INTEGER
    | INTEGER;

varname: NORVAR|SINGLEVAR|DOUBLEVAR|MSS;
forr: FOR varname '=' expr TO expr step

step: STEP expr 
    |
    ;

next: NEXT varname; //should come after for, and its varname should be similar to varname of for

para: para ',' vari
    | vari
    ;

vari: varname|INTEGER|FLOAT|DOUBLE
    ;

iff: IF condn THEN number
   ;

iffvari: varname 
        | varname '(' para ')' 
        ;

condn: condn OR condn
    | condn AND condn
    | condn XOR condn
    | NOT condn
    | iffvari RELOP expr
    | iffvari NE expr
    | iffvari '=' expr
    |iffvari RELOP iffvari
    |iffvari NE iffvari
    | iffvari '=' iffvari
    |expr RELOP expr
    |expr NE expr
    | expr '=' expr
    |STRVAR NE STRVAR
    | STRVAR '=' STRVAR
    |STRVAR NE STRING
    | STRVAR '=' STRING
    |STRING NE STRING
    | STRING '=' STRING
    ;

let: LET letcondn ;
letcondn: NORVAR '=' INTEGER
        | SINGLEVAR '=' FLOAT
        | DOUBLEVAR '=' DOUBLE
        | DOUBLEVAR '=' FLOAT
        | MSS '=' INTEGER
        | NORVAR '=' NORVAR
        | SINGLEVAR '=' SINGLEVAR
        | DOUBLEVAR '=' DOUBLEVAR
        | STRVAR '=' STRING
        | STRVAR '=' STRVAR
        | varname '(' para ')' '=' expr;

input: INPUT inputvar;

inputvar: inputvar ',' inputvari
        | inputvari
        ;

inputvari: iffvari 
        | STRVAR
        ;

print: PRINT printrec
        | PRINT
        ;

printrec: printrec delimiter printexpr
        | printrec delimiter
        | printexpr
        ;

printexpr: STRVAR
        |varname
        |STRING
        ;

delimiter: ','
        | ';'
        |
        ;

rem: REM remm
    |REM
    ;

remm: remm REMSTR
    | REMSTR
    ;
got: GOTO number;

gosub: GOSUB number;

returnn: RETURN ; 

stop: STOP;

end: END; 

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void)
{
    yyin=fopen("input.txt","r");
    yyout=fopen("output.txt","w");
    yyparse();
    fclose(yyin);
    fclose(yyout);
    return 0;
}