%{
#include <stdio.h>
%}

%s INPUT
%s OUTPUT

%%

[ \t\n]+                ;
inputfile       BEGIN INPUT;
outputfile	BEGIN OUTPUT; 
<INPUT>\".*\"   { BEGIN 0; ECHO; printf(" is the input file.\n"); }
<OUTPUT>\".*\"  { BEGIN 0; ECHO; printf(" is the output file.\n"); }
\".*\"          { ECHO; printf("\n"); }
.                ;

%%
