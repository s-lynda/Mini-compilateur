%{
#include <stdio.h>
#include<string.h>
#include "Syntax.tab.h"
int nb_lignes=1;    
int col=0;
extern YYSTYPE yylval;
%}
lettre [a-z]
chiffre [0-9]
chiffre1 [1-9]
IDF {lettre}|{lettre}({lettre}|{chiffre}|"_"|{chiffre}|{lettre})*({chiffre}|{lettre})
integer {chiffre1}{chiffre}*|0
reel  ({chiffre1}|0)*"."{chiffre}*
Commentaire "//".*
Commentaire1  [/][*][^*]*[*]+([^*/][^*]*[*]+)*[/] 
cmtr {Commentaire}|{Commentaire1}
%%
Program {return mc_program;col=col+yyleng;}
PDEC {return mc_pdec; col=col+yyleng;}
PINST {return mc_pinst; col=col+yyleng;}
Begin {return begin;col=col+yyleng;}
End {return mc_end;col=col+yyleng;}
@define {return mc_cst;col=col+yyleng;}
FOR {return mc_for; col=col+yyleng;}
WHILE {return mc_while;col=col+yyleng;}
DO {return mc_do;col=col+yyleng;}
ENDFOR {return endfor;col=col+yyleng;}
IF {return mc_if;col=col+yyleng;}
ELSE {return mc_else;col=col+yyleng;}
ENDIF {return mc_endif;col=col+yyleng;}
Pint {yylval.str=strdup(yytext);return mc_entier;col=col+yyleng;}
Pfloat {yylval.str=strdup(yytext); return mc_reel;col=col+yyleng;}
{IDF} {if (yyleng<=12) {yylval.str=strdup(yytext);
    return idf;}
    else printf("\nerreur lexical : IDF trop long");col=col+yyleng;}
: {return DP;};
{integer} {yylval.entier=atoi(yytext); 
    if((-32768<yylval.entier)&&(yylval.entier<32767))
    {return integer;}
    else printf("\n erreur lexical : entier trop long");
    col=col+yyleng;};
{reel} {yylval.numvrg=atof(yytext);return reel;col=col+yyleng;};
"|" {return OU;col++;}
";" {return pvg;col=col+yyleng;}
"=" {return egal;col=col+yyleng;};
"==" {return Degal;col=col+yyleng;};
"<--" {return aff;col=col+yyleng;};
"+" {return plus;col=col+yyleng;};
"-" {return moins;col=col+yyleng;};
"*" {return mul;col=col+yyleng;}
"/" {yylval.str=strdup(yytext);return divis;col=col+yyleng;};
">" {return sup;col=col+yyleng;};
"<" {return inf;col=col+yyleng;};
">=" {return supOuEg;col=col+yyleng;};
"<=" {return InfOuEg;col=col+yyleng;};
"!=" {return diff;col=col+yyleng;};
"&" {return ET;col=col+yyleng;};
"!" {return non;col=col+yyleng;};
[()]  {return yytext[0];col++;}
[ \t] {col++;}
{cmtr} {col++;}
\n {nb_lignes++;}
. printf("L'erreur lexical a la ligne %d \n",nb_lignes);

%%
int yywrap(){
    return 0;
}