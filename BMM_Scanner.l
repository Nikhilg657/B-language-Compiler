%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    void yyerror(char* s);
    #include "BMM_parser.tab.h"
    int nlines=0;
%}

%%
[0-9]+ {
    yylval = atoi(yytext);
    return INTEGER;
    }
\"([^\\\"]|\\.)*\"  {  return STRING; }
DATA {
     yylval=*yytext;
    return DATA;}
DEF {
    return DEF;
}
DIM {return DIM;}
END {
    return END;
}
FOR {
    return FOR;
}
LET {
    return LET;
}
NEXT {
    return NEXT;
}
STOP {
    return STOP;
}
STEP {
    return STEP;
}
TO {
    return TO;
}
GOSUB {
    return GOSUB;
}
GOTO {
    return GOTO;
}
IF {
    return IF;
}
THEN {
    return THEN;
}
INPUT {
    return INPUT;
}
PRINT {
    return PRINT;
}
REM {
    return REM;
}
RETURN {
    return RETURN;
}
[\n] {nlines++;}
[;] {return *yytext;}
[-+,*/()=]   {return *yytext;}
[\t] yyerror("tab not allowed");
%%
int yywrap(void)
{
    return 1;
}