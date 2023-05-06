%{
    #include <stdio.h>
    #include<math.h>
    int yylex(void);
    void yyerror(char *);
    extern FILE * yyin;
    extern FILE * yyout;
    int sym[26];
%}
%token DEF FN DIM MSS END FOR GOSUB GOTO IF THEN LET INPUT PRINT NEXT TO REM RETURN STOP STEP
%token  INTEGER
%token DATA
%token FLOAT
%token  STRING
%token NORVAR SINGLEVAR DOUBLEVAR STRVAR RELOP DOUBLE NE 
%left '+' '-'
%left '*' '/'
%start program

%%
program : line {printf("in program\n");}
        | program line
        ;

line    : number statement {printf("in line\n");};
number  : INTEGER;
statement: data|def|dim|end|fo|next|gosub|got|iff|then|let|input|print|stop|rem|returnn {printf("in statement\n");};
data: DATA data_list {printf("in DATA\n");};
data_list:
    data_item {printf("in SINGLE DATA\n");}
    | data_list ',' data_item {printf("in DATA LIST MULTIPLE\n");}
    ;

data_item:
    INTEGER {printf("in INTEGER\n");}
    |FLOAT {printf("in float\n");}
    | DOUBLE {printf("in double\n");}
    |STRING {printf("in STRING\n");}
    ;

def: DEF FN '=' expr {printf("in def");}
      |DEF FN '('MSS')''=' expr {printf("in def_par\n");}
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
    |DOUBLEVAR 
    |SINGLEVAR 
    ;
numbertype: INTEGER|FLOAT|DOUBLE;
dim: DIM dimm;
dimm: dimm ',' MSS '(' intt ')'{printf("in dim");}
    | MSS '(' intt ')'{printf("in dim");}
    ;
intt: INTEGER ',' INTEGER
    | INTEGER;

fo: FOR varname '=' expr TO expr step
;
step: STEP expr
    |
    ;
next: NEXT varname; //should come after for, and its varname should be similar to varname of for

iff: IF condn THEN number;
condn: varname RELOP numbertype
    | varname '=' numbertype
    |varname RELOP varname
    | varname '=' varname
    |numbertype RELOP numbertype
    | numbertype '=' numbertype
    |STRVAR NE STRVAR
    | STRVAR '=' STRVAR
    |STRVAR NE STRING
    | STRVAR '=' STRING
    |STRING NE STRING
    | STRING '=' STRING;
varname: NORVAR|SINGLEVAR|DOUBLEVAR;


let: LET letcondn ;
letcondn: NORVAR '=' INTEGER
        | SINGLEVAR '=' FLOAT
        | NORVAR '=' NORVAR
        | SINGLEVAR '=' SINGLEVAR
        | DOUBLEVAR '=' DOUBLE
        | DOUBLEVAR '=' DOUBLEVAR
        | STRVAR '=' STRING
        | STRVAR '=' STRVAR
        | varname '(' para ')' '=' expr;
para: para ',' vari
    | vari;
vari: varname|INTEGER|FLOAT|DOUBLE;

input: INPUT inputvar;

inputvar: inputvar ',' inputvari
        | inputvari
inputvari: varname
        | varname '(' para ')' 
        | STRVAR;


print: PRINT printrec
        | PRINT
        ;

printrec: printrec delimiter printexpr
        | printexpr;

printexpr: expr|STRING|STRVAR|varname;

delimiter: ','
        | ';'
        |
        ;

rem: REM STRING
    |REM
    ;

got: GOTO number; // must check line number is present in line array

gosub: GOSUB number; // must check line number is present in line array

returnn: RETURN ; //return line no. should come after gosub and before any other gosub

stop: STOP;

end: END; //it's line number must be last
%%
void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void)
{
    // yyin=fopen("input.txt","r");
    // yyout=fopen("output.txt","w");
    yyparse();
    // fclose(yyin);
    // fclose(yyout);
    return 0;
}
