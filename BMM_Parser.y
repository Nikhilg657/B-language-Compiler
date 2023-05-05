%{
    #include <stdio.h>
    int yylex(void);
    void yyerror(char *);
    extern FILE * yyin;
    extern FILE * yyout;
%}

%token DEF DIM END FOR GOSUB GOTO IF THEN LET INPUT PRINT NEXT TO STEP REM RETURN STOP
%token  INTEGER
%token DATA
%token COMMA
%token FLOAT
%token  STRING
%start program

%%
program : line {printf("in program\n");}
        ;

line    : number statement {printf("in line\n");};
number  : INTEGER;
statement: data {printf("in statement\n");};
data: DATA data_list {printf("in DATA\n");};
data_list:
    data_item {printf("in SINGLE DATA\n");}
    | data_list COMMA data_item {printf("in DATA LIST MULTIPLE\n");}
    ;

data_item:
    INTEGER {printf("in INTEGER\n");}
    |STRING{printf("in STRING\n");}
    ;
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