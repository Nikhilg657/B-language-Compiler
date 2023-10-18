NAME: NIKHIL GARG AND ANISHA PRAKASH
ENTRY NO. 2021CSB1114 , 2021CSB1067
There are 7 files in the folder those are:

    1. BMM_Parser.y - It will parse the given code 
    2. BMM_Scanner.l - It will scan the given code
    3. CorrectSample.bmm - It contains a sample of code without any error
    4. IncorrectSample.bmm - It contans code with error
    5. input.txt - The code to be compiled should be written here
    6. output.txt - It will show error with line no. ,if any.
    7. README.md  

***HOW TO RUN***
The Following Instructions Should Be Followed While Running The Program :
     Open the terminal in the directory B-- language compiler and Enter the following commands to run the program :

If you are running it in windows:

      1. flex BMM_scanner.l ; bison -d  BMM_parser.y ; gcc lex.yy.c BMM_parser.tab.c -o a.exe
      2. ./a.exe

If you are running it in linux then:

    1.  lex BMM_scanner.l 
    2. yacc -d  BMM_parser.y 
    3. cc lex.yy.c y.tab.c -o BMM_Parser.exe
    4.  ./BMM_Parser.exe


    And change line number 6 in BMM_Scanner.l from #include "BMM_parser.tab.h"  to #include "y.tab.h"

To compile a piece of code just put it to input.txt and it should run good.

Any error output should come in output.txt.

***ASSUMPTIONS***
    1. The line number mentioned in GOTO, GOSUB and THEN always exist in the code.
    2. Any condition mentioned in IF and FOR statement always contains the variable
       which is declared in the previous statements.
    3. All the FOR loops ends with a NEXT statement
    4. In REM we cannot have words whose tokens are defined in lex and all possible value of them AND SPACE.
    5. In REM and PRINT we cannot use integers, it was giving some error.

*******************************THANK YOU !*******************************
