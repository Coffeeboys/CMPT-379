%{
#include <stdio.h>
#define T_A 1
#define T_B 2
#define T_C 3
%}

%%
a return T_A;
abb return T_B;
a*b+ return T_C;
. return -1;
%%

int main (int argc, char* argv[]) {
  int token;
  while (token = yylex()) {
    switch (token) {
      case T_A:
        printf("T_A %s", yytext);
        break;
      case T_B:
        printf("T_B %s\n", yytext);
        break;
      case T_C:
        printf("T_C %s\n", yytext);
        break;
      case -1:
        printf("ERROR %s\n", yytext);
        break;
    }
  }
  exit(0);
}
