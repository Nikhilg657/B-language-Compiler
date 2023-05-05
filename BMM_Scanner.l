%{
    #include<stdio.h>
    #include<stdlib.h>
    void yyerror(char* s);
    #include "BMM_parser.tab.h"
%}

%%
[0-9]+ {
    yylval = atoi(yytext);
    return INTEGER;
    }
DATA {
    yylval=*yytext;
    return DATA;
}
;   {return yytext[0];}
. {return *yytext;}
%%
int yywrap(void)
{
    return 1;
}