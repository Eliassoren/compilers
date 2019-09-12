%{
#include <vslc.h>
%}
%option noyywrap
%option array
%option yylineno

%x LINE_COMMENT
DIGIT [0-9]
LETTER [a-zA-Z_]
WHITESPACE [\t\n\r\v ]
%%
"//"                    { BEGIN LINE_COMMENT; }
<LINE_COMMENT>.         { }
<LINE_COMMENT>"\n"      { BEGIN INITIAL; }
L?\"(\\.|[^\\"])*\"     { return STRING; }
"PRINT"                 { return PRINT; }
"DO"                    { return DO; }
"WHILE"                 { return WHILE; }
"IF"                    { return IF; }
"ELSE"                  { return ELSE; }
"CONTINUE"              { return CONTINUE; }

"THEN"                  { return THEN; }
"END"                   { return CLOSEBLOCK; }
{DIGIT}+                { return NUMBER; }
"BEGIN"                 { return OPENBLOCK; }
"RETURN"                { return RETURN; }
"VAR"                   { return VAR; }
{WHITESPACE}*           {       }
FUNC                  { return FUNC; }
{LETTER}({LETTER}|{DIGIT})* {return IDENTIFIER; }
[-()<>=+*/;{}.,]        { return *yytext; }
.                       { printf("Unrecognized token %s", yytext); }
%%
//":="                    { return ASSIGN; }
//"END"                   { return FINISH; }