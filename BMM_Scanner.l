%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    void yyerror(char* s);
    #include "BMM_parser.tab.h"
    int nlines=0;
%}

%%
[-;+,*/^()=~]   {return *yytext;}
[0-9]+ {
    // yylval = atoi(yytext);
    return INTEGER;
    }

\"([A-Z]+[\.]?[A-Z]*[!]?[ \t]?[*]?)*\"  {  return STRING; }
DATA {
     yylval=*yytext;
    return DATA;}

DEF {
    yylval=*yytext;
    return DEF;
}
FN[A-Z]?  {
    return FN;
}

DIM {return DIM;}

FOR {
    return FOR;
}

[A-Z] {yylval=*yytext;
    return MSS;}
[0-9]*[\.]?[0-9]{1,7} {
    // yylval= atof(*yytext);
    return FLOAT;
}
[0-9]*\.?[0-9]{1,15} {
    // yylval= atof(*yytext);
    return DOUBLE;
}
[A-Z][0-9]?[%]? {
    yylval=*yytext;
    return NORVAR; //normal variable
}
[A-Z][0-9]?[!] {
    yylval=*yytext;
    return SINGLEVAR;
}
[A-Z][0-9]?[#] {
    yylval=*yytext;
    return DOUBLEVAR;
}
[A-Z][0-9]?[$] {
    yylval=*yytext;
    return STRVAR;
}

END {
    return END;
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
[<][>] {return NE;}
[><][>=]? {return RELOP;}
[\n] {nlines++;}
[\s] {return *yytext;}
(([*]*[A-Z]*[*]*)?)([A-Z]*) {return REMSTR;}
%%
int yywrap(void)
{
    return 1;
}