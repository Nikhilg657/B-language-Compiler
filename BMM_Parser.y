%{
    #include <stdio.h>
    #include<math.h>
    #include <stdlib.h>
    #include <stdbool.h>
    #include<string.h>
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
    |INTEGER|FLOAT|DOUBLE
    |MSS 
    |NORVAR
    |DOUBLEVAR 
    |SINGLEVAR 
    ;

dim: DIM dimm;
dimm: dimm ',' MSS '(' intt ')'
    | MSS '(' intt ')'
    ;
intt: INTEGER ',' INTEGER
    | INTEGER
    ;

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
        | FLOAT
        | DOUBLE
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
    | varname
    | FLOAT
    | DOUBLE
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
    FILE *fp;
    char line[100];
    int line_number = 0;
    int prev_line_number = 0;
    bool line_numbers[10000] = { false }; 
    int found=0;

    fp = fopen("input.txt", "r");
    if (fp == NULL) {
        printf("Error: Unable to open file\n");
        return 1;
    }
    while (fgets(line, sizeof(line), fp)) {
        int num = atoi(line);

        if (num < 1 || num > 9999 || line_numbers[num]) {
            printf("Error: Invalid line number or duplicate line number\n");
            return 1;
        }

        line_numbers[num] = true; 
        if (num <= prev_line_number) {
            printf("Error: not in ascending order\n");
            return 1;
        }
        prev_line_number = num;
    }
    fclose(fp);
    FILE *f;
    int curr=0;
    f = fopen("input.txt", "r");
    while (fgets(line, sizeof(line), f)) {
                curr++;
                if (strstr(line, "GOTO") != NULL) {
                char *pos = strstr(line, "GOTO");
                if (pos != NULL) {
                    pos += strlen("GOTO");
                    pos++;
                    int number = atoi(pos); 
                    if(!line_numbers[number])
                    {
                        printf("Error: number corresponding to GOTO doesn't exist in line no. %d\n",curr);
                    }
                }
        }
    }
    fclose(f);
    curr=0;
    f = fopen("input.txt", "r");
    if (f == NULL) {
        printf("Error: Unable to open file\n");
        return 1;
    }
    while (fgets(line, sizeof(line), f)) {
                    curr++;
                if (strstr(line, "THEN") != NULL) {
                char *pos = strstr(line, "THEN");
                if (pos != NULL) {
                    found = 1;
                    pos += strlen("THEN");
                    pos++;
                    int number = atoi(pos); 
                    if(!line_numbers[number])
                    {
                        printf("Error: number corresponding to THEN doesn't exist in line number: %d\n",curr);
                    }
                }
        }
    }
    fclose(f);
    curr=0;
    f = fopen("input.txt", "r");
    if (f == NULL) {
        printf("Error: Unable to open file\n");
        return 1;
    }
    while (fgets(line, sizeof(line), f)) {
                    curr++;
                if (strstr(line, "GOTOSUB") != NULL) {
                char *pos = strstr(line, "GOTOSUB");
                if (pos != NULL) {
                    found = 1;
                    pos += strlen("GOTOSUB");
                    pos++;
                    int number = atoi(pos); 
                    if(!line_numbers[number])
                    {
                        printf("Error: number corresponding to GOTOSUB doesn't existin line number: %d\n",curr);
                    }
                     }
                }
    fclose(f);
    yyin=fopen("input.txt","r");
    yyout=fopen("output.txt","w");
    yyparse();
    fclose(yyin);
    fclose(yyout);
    return 0;
    }
}