%{
    #include <stdio.h>
    int yylex(void);
    void yyerror(char *);
    extern FILE * yyin;
    extern FILE * yyout;
%}

%token INTEGER DATA

%%
program: program ' ' expr ';' {printf("%s\n",$3);}
        | expr {printf("%d",$1);};
expr: INTEGER {$$=$1;}
    |DATA {$$=$1;};
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
