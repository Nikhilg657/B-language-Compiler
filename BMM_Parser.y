%{
    #include <stdio.h>
    #include<math.h>
    int yylex(void);
    void yyerror(char *);
    extern FILE * yyin;
    extern FILE * yyout;
    int sym[26];
%}
%token DEF FN DIM MSS END GOSUB GOTO IF THEN LET INPUT PRINT NEXT TO REM RETURN STOP STEP
%token  INTEGER
%token DATA
%token FLOAT
%token REMSTR STRING
%token NORVAR SINGLEVAR DOUBLEVAR STRVAR RELOP DOUBLE NE FOR
%left '+' '-'
%left '*' '/'
%start program

%%
program : line {printf("in program\n");}
        | program line
        ;

line    : number statement {printf("in line\n");};
number  : INTEGER;
statement: data|def|dim|end|forr|next|gosub|got|iff|let|input|print|stop|rem|returnn {printf("in statement\n");};
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
    |numbertype {printf("in NUMBERTYPE");}
    |MSS 
    |NORVAR
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

varname: NORVAR|SINGLEVAR|DOUBLEVAR|MSS;
forr: FOR varname '=' expr TO expr step{printf("in for");};
// forexpr:  '=' INTEGER {printf("in forexpr");}
//     | ;
// FOREXP: NORVAR '=' INTEGER {printf("in forexp");}

step: STEP expr {printf("in step");}
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
iffvari: varname  {printf("in iffvari");}
        | varname '(' para ')' {printf("in iff vari para\n");}
        ;
condn: iffvari RELOP expr
    | iffvari NE expr
    | iffvari '=' expr {printf("int equal condn");}
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
inputvari: iffvari 
        | STRVAR;


print: PRINT printrec
        | PRINT
        ;

printrec: printrec delimiter printexpr
        |printrec delimiter
        | printexpr;

printexpr: STRVAR|varname|expr|STRING;

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
