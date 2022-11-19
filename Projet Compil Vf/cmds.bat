flex Lexical.l
bison -d Syntax.y
gcc lex.yy.c Syntax.tab.c -o Compilateur.exe