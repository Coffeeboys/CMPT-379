%{
#include <stdio.h>
#define BLOCK_COMMENT 1
#define LINE_COMMENT 2
#define STRING_LITERAL 3
%}

%%
\"(\\.|[^"])*\" return STRING_LITERAL;
"/*"([^*]|\*+[^*/])*\*+"/" return BLOCK_COMMENT;
"//".* return LINE_COMMENT;
%%

void printSpaces(int count);

int main (int argc, char* argv[]) {
  int token;
  while (token = yylex()) {
    switch (token) {
    case BLOCK_COMMENT:
      printSpaces(strlen(yytext));
      break;
    case STRING_LITERAL:
      printf("%s", yytext);
      break;
    }
  }
  exit(0);
}

void printSpaces(int count) {
  for (int i = 0; i < count; i++) {
    printf(" ");
  }
}
