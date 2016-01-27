%{
#include <stdio.h>
#include <string>
using namespace std;

//define token names
#define T_AND "T_AND"
#define T_ASSIGN "T_ASSIGN"
#define T_BOOLTYPE "T_BOOLTYPE"
#define T_BREAK "T_BREAK"
#define T_CHARCONSTANT "T_CHARCONSTANT"
#define T_CLASS "T_CLASS"
#define T_COMMENT "T_COMMENT"
#define T_COMMA "T_COMMA"
#define T_CONTINUE "T_CONTINUE"
#define T_DIV "T_DIV"
#define T_DOT "T_DOT"
#define T_ELSE "T_ELSE"
#define T_EQ "T_EQ"
#define T_EXTENDS "T_EXTENDS"
#define T_EXTERN "T_EXTERN"
#define T_FALSE "T_FALSE"
#define T_FOR "T_FOR"
#define T_GEQ "T_GEQ"
#define T_GT "T_GT"
#define T_IF "T_IF"
#define T_INTCONSTANT "T_INTCONSTANT"
#define T_INTTYPE "T_INTTYPE"
#define T_LCB "T_LCB"
#define T_LEFTSHIFT "T_LEFTSHIFT"
#define T_LEQ "T_LEQ"
#define T_LPAREN "T_LPAREN"
#define T_LSB "T_LSB"
#define T_LT "T_LT"
#define T_MINUS "T_MINUS"
#define T_MOD "T_MOD"
#define T_MULT "T_MULT"
#define T_NEQ "T_NEQ"
#define T_NEW "T_NEW"
#define T_NOT "T_NOT"
#define T_NULL "T_NULL"
#define T_OR "T_OR"
#define T_PLUS "T_PLUS"
#define T_RCB "T_RCB"
#define T_RETURN "T_RETURN"
#define T_RIGHTSHIFT "T_RIGHTSHIFT"
#define T_RPAREN "T_RPAREN"
#define T_RSB "T_RSB"
#define T_SEMICOLON "T_SEMICOLON"
#define T_STRINGTYPE "T_STRINGTYPE"
#define T_STRINGCONSTANT "T_STRINGCONSTANT"
#define T_TRUE "T_TRUE"
#define T_VOID "T_VOID"
#define T_WHILE "T_WHILE"
#define T_ID "T_ID"
#define T_WHITESPACE "T_WHITESPACE"

//define error strings
#define E_STRING_UNKNOWN_ESCAPE "Error: unknown escape sequence in string constant"
#define E_STRING_NEWLINE "Error: newline in string constant"
#define E_STRING_NO_CLOSING "Error: string constant is missing closing delimiter"
#define E_CHAR_LENGTH "Error: char constant length is greater than one"
#define E_CHAR_UNTERMINATED "Error: unterminated char constant"
#define E_CHAR_ZERO_WIDTH "Error: char constant has zero width"
#define E_CHARACTER_UNEXPECTED "Error: unexpected character in input"

  //special characters \a, etc.... do they correspond to any tokens?
%}

all_char [\x7-\xD\x20-\x7E]
char [\x7-\xD\x20-\x5B\x5D-\x7E]
stringchar [\x7-\xD\x20-\x21\x23-\x5B\x5D-\x7E]

letter [a-zA-Z_]
decimal_digit [0-9]
hex_digit [0-9A-Fa-f]
digit [0-9]

T_COMMENT "//".*\xA

newline \n
carriage_return \r
horizontal_tab \t
vertical_tab \v
form_feed \f
space \x20
T_WHITESPACE ({space}|{newline}|{carriage_return}|{horizontal_tab}|{vertical_tab}|{form_feed})+

bell \a
backspace \b

T_ID {letter}({letter}|{digit})*

%{
  //Keywords!
%}
T_BOOLTYPE bool
T_BREAK break
T_CONTINUE continue
T_CLASS class
T_ELSE else
T_EXTENDS extends
T_EXTERN extern
T_FALSE false
T_FOR for
T_IF if
T_INTTYPE int
T_NEW new
T_NULL null
T_RETURN return
T_STRINGTYPE string
T_TRUE true
T_VOID void
T_WHILE while

%{
  //operators/delimiters
%}
T_DIV \/
T_DOT \.
T_EQ ==
T_PLUS \+
T_AND &&
T_OR \|\|
T_MOD %
T_MULT \*
T_NEQ !=
T_MINUS -
T_LEQ <=
T_GEQ >=
T_GT >
T_LT <
T_LPAREN \(
T_RPAREN \)
T_RCB \}
T_LCB \{
T_RSB \x5D
T_LSB \x5B
T_COMMA ,
T_ASSIGN =
T_NOT !
T_LEFTSHIFT <<
T_RIGHTSHIFT >>
T_SEMICOLON ;

%{
  //literals!
%}
decimal_lit {decimal_digit}*
hex_lit 0[xX]{hex_digit}{hex_digit}*
T_INTCONSTANT ({hex_lit}|{decimal_lit})

%{
  //char literals!
%}
ch_const_body ({char}|{escaped_char})
T_CHARCONSTANT "'"{ch_const_body}"'"
escaped_char \\[\\nrtvfab\'"]
%{
//string literals!
%}
str_const_body ({stringchar}|{escaped_char})*
T_STRINGCONSTANT \"{str_const_body}\"

%{
//errors!
//TODO: make these work properly!
//Note: CHAR_UNTERMINATED and STRING_NO_CLOSING work because lex is greedy and will try to scan for all char/string literal matches first. If it can't match these, it'll match the errors instead.
%}
E_STRING_UNKNOWN_ESCAPE \"{str_const_body}\\[^{escaped_char}]
E_STRING_NEWLINE \"{str_const_body}\xA{str_const_body}\"
E_STRING_NO_CLOSING \"
E_CHAR_LENGTH "'"{ch_const_body}{ch_const_body}+"'"
E_CHAR_UNTERMINATED "'"
E_CHAR_ZERO_WIDTH "'""'"
E_CHARACTER_UNEXPECTED .

%{
// Define global variables
int lineCount = 1;
int charCount = 0;
// Define prototypes
void printToken(string tokenName, char * tokenValue);
void printError(string errorName);
%}

%%
{T_BOOLTYPE}        {printToken(T_BOOLTYPE, yytext);}
{T_BREAK}           {printToken(T_BREAK, yytext);}
{T_CONTINUE}        {printToken(T_CONTINUE, yytext);}
{T_CLASS}           {printToken(T_CLASS, yytext);}
{T_ELSE}            {printToken(T_ELSE, yytext);}
{T_EXTENDS}         {printToken(T_EXTENDS, yytext);}
{T_EXTERN}          {printToken(T_EXTERN, yytext);}
{T_FALSE}           {printToken(T_FALSE, yytext);}
{T_FOR}             {printToken(T_FOR, yytext);}
{T_IF}              {printToken(T_IF, yytext);}
{T_INTTYPE}         {printToken(T_INTTYPE, yytext);}
{T_NEW}             {printToken(T_NEW, yytext);}
{T_NULL}            {printToken(T_NULL, yytext);}
{T_RETURN}          {printToken(T_RETURN, yytext);}
{T_STRINGTYPE}      {printToken(T_STRINGTYPE, yytext);}
{T_TRUE}            {printToken(T_TRUE, yytext);}
{T_VOID}            {printToken(T_VOID, yytext);}
{T_WHILE}           {printToken(T_WHILE, yytext);}

{E_CHAR_ZERO_WIDTH} {printError(E_CHAR_ZERO_WIDTH);}

{T_CHARCONSTANT}    {printToken(T_CHARCONSTANT, yytext);}
{T_COMMENT}         {
                        if (yytext[yyleng - 1] == 10) {
                            int commentLength = yyleng + 1;
                            char * commentText = new char[commentLength];
                            for (int i = 0; i < yyleng; i++) {
                                commentText[i] = yytext[i];
                            }
                            commentText[commentLength - 2] = '\\';
                            commentText[commentLength - 1] = 'n';
                            printToken(T_COMMENT, commentText);
                        }
                        else {
                            printToken(T_COMMENT, yytext);
                        }
                    }
{T_INTCONSTANT}     {printToken(T_INTCONSTANT, yytext);}
{E_STRING_NEWLINE}  {printError(E_STRING_NEWLINE);}
{T_STRINGCONSTANT}  {printToken(T_STRINGCONSTANT, yytext);}
{T_ID}              {printToken(T_ID, yytext);}
{T_WHITESPACE}      {
                        printf("%s ", T_WHITESPACE);
                        for (int i = 0; i < yyleng; ++i) {
                            if (yytext[i] == '\n') {
                                printf("\\n");
                                lineCount++;
                                charCount = 0;
                            }
                            else {
                                charCount++;
                                printf("%c", yytext[i]);
                            }
                        }
                        printf("\n");
                    }

{T_RSB}             {printToken(T_RSB, yytext);}
{T_LSB}             {printToken(T_LSB, yytext);}
{T_DIV}             {printToken(T_DIV, yytext);}
{T_MINUS}           {printToken(T_MINUS, yytext);}
{T_MOD}             {printToken(T_MOD, yytext);}
{T_MULT}            {printToken(T_MULT, yytext);}
{T_PLUS}            {printToken(T_PLUS, yytext);}
{T_LPAREN}          {printToken(T_LPAREN, yytext);}
{T_RPAREN}          {printToken(T_RPAREN, yytext);}
{T_NOT}             {printToken(T_NOT, yytext);}
{T_COMMA}           {printToken(T_COMMA, yytext);}
{T_SEMICOLON}       {printToken(T_SEMICOLON, yytext);}
{T_LEFTSHIFT}       {printToken(T_LEFTSHIFT, yytext);}
{T_RIGHTSHIFT}      {printToken(T_RIGHTSHIFT, yytext);}
{T_LT}              {printToken(T_LT, yytext);}
{T_GT}              {printToken(T_GT, yytext);}
{T_LEQ}             {printToken(T_LEQ, yytext);}
{T_GEQ}             {printToken(T_GEQ, yytext);}
{T_NEQ}             {printToken(T_NEQ, yytext);}
{T_AND}             {printToken(T_AND, yytext);}
{T_OR}              {printToken(T_OR, yytext);}
{T_DOT}             {printToken(T_DOT, yytext);}
{T_ASSIGN}          {printToken(T_ASSIGN, yytext);}
{T_EQ}              {printToken(T_EQ, yytext);}
{T_LCB}             {printToken(T_LCB, yytext);}
{T_RCB}             {printToken(T_RCB, yytext);}

{E_STRING_NO_CLOSING} {printError(E_STRING_NO_CLOSING);}
{E_CHAR_UNTERMINATED} {printError(E_CHAR_UNTERMINATED);}
{E_STRING_UNKNOWN_ESCAPE} {printError(E_STRING_UNKNOWN_ESCAPE);}

{E_CHARACTER_UNEXPECTED} {printError(E_CHARACTER_UNEXPECTED);}
%%

//TODO: uncomment these as they start working
/*

{E_CHAR_LENGTH} {printError(E_CHAR_LENGTH);}
*/

int main(int argv, char* argc[]) {
    yylex();
    exit(0);
}

void printToken(string tokenName, char * tokenValue) {
    charCount += yyleng;
    printf("%s %s\n", tokenName.c_str(), tokenValue);
}

void printError(string errorName) {
    fprintf(stderr, "%s\n", errorName.c_str());
    //print charCount as the start of this token (previous token ending index + 1)
    fprintf(stderr, "Lexical error: line %d, position %d\n", lineCount, charCount + 1);
    charCount += yyleng;
    exit(1);
}
