%{
  //IMPORTANT: to actually run this, remove the comments that are not within the %{Blocks%}. Otherwise, these comments will be interpreted as part of the token definition
  //so far, I have only defined the definitions for each token.
  //These definitions are somewhat incomplete, so they will definitely need some revising
  //the definitions are more or less in the order that they appear in in the decaf language specification
#include <stdio.h>
#define T_AND 1
#define T_ASSIGN 2
#define T_BOOLTYPE 3
#define T_BREAK 4
#define T_CHARCONSTANT 5
#define T_CLASS 6
#define T_COMMENT 7
#define T_COMMA 8
#define T_CONTINUE 9
#define T_DIV 10
#define T_DOT 11
#define T_ELSE 12
#define T_EQ 13
#define T_EXTENDS 14
#define T_EXTERN 15
#define T_FALSE 16
#define T_FOR 17
#define T_GEQ 18
#define T_GT 19
#define T_IF 20
#define T_INTCONSTANT 21
#define T_INTTYPE 22
#define T_LCB 23
#define T_LEFTSHIFT 24
#define T_LEQ 25
#define T_LPAREN 26
#define T_LSB 27
#define T_LT 28
#define T_MINUS 29
#define T_MOD 30
#define T_MULT 31
#define T_NEQ 32
#define T_NEW 33
#define T_NOT 34
#define T_NULL 35
#define T_OR 36
#define T_PLUS 37
#define T_RCB 38
#define T_RETURN 39
#define T_RIGHTSHIFT 40
#define T_RPAREN 41
#define T_RSB 42
#define T_SEMICOLON 43
#define T_STRINGTYPE 44
#define T_STRINGCONSTANT 45
#define T_TRUE 46
#define T_VOID 47
#define T_WHILE 48
#define T_ID 49
#define T_WHITESPACE 50
  //special characters \a, etc.... do they correspond to any tokens?
%}
all_char //how does one define ascii chars??????????/
char insertCharDefinitionHere!

letter [a-zA-z_]
decimal_digit [0-9]
hex_digit [0-9A-Fa-f]
digit [0-9]

T_COMMENT "//"{char}\n

newline \n
carriage_return \r
horizontal_tab \t
vertical_tab \v
form_feed \f
space " "
T_WHITESPACE [{newline}{carriage_return}{horizontal_tab}{vertical_tab}{form_feed}{space}]

bell \a
backspace \b

%{
  //Tokens!
  //see operators/delimiters for semicolon
%}
T_ID {letter}[{letter}|{digit}]

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
T_DIV \/ //does this need an escape?
T_DOT \.
T_EQ =
T_PLUS +
T_AND &&
T_OR ||
T_MOD %
T_MULT \*
T_NEQ !=
T_MINUS -
T_LEQ <=
T_GEQ >=
T_GT >
T_LT <
T_LPAREN (
T_RPAREN )
T_RCB }
T_LCB {
T_RSB ]
T_LSB [
T_COMMA ,
T_ASSIGN =
T_NOT !
T_LEFTSHIFT <<
T_RIGHTSHIFT >> //there are two << instead of a << and >>... wtf!
T_SEMICOLON ;

%{
  //literals!
%}
T_INTCONSTANT [{decimal_lit} {hex_lit}]
decimal_lit {decimal_digit}*
hex_lit "0"[xX]{hex_digit}{hex_digit}*

%{
  //char literals!
%}
T_CHARCONSTANT "'"[{char}{escaped_char}]"'"
escaped_char \\[nrtvfab\'""] //this is 100 percent incorrect

%{
//string literals!
%}
T_STRINGCONSTANT \"[{char}{escaped_char}]\"

%{
//type/bool literals
//see keywords
%}

%%{
{T_COMMENT} return T_COMMENT;
{T_WHITESPACE} return T_WHITESPACE;
{T_ID} return T_ID;
{T_SEMICOLON} return T_SEMICOLON;
%%

int main(int argv, char* argc[]) {
  int token;
  while (token = yylex()) {
    switch (token) {
    case T_COMMENT:
      printf("T_COMMENT %s\n", yytext);
      break;
    case T_WHITESPACE:
      printf("T_WHITESPACE %s\n", yytext);
      break;
    }
  }
  exit(0);
}
