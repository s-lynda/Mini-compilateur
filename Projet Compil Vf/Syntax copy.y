%{
#include<stdio.h>
#include <string.h>
#include<math.h>

#include "Routine.h"
extern int nb_lignes;
extern int col;
int yyparse();
int yylex();
int yyerror(char *s);
char typeidf[20];
char Temp[100][200];
char Exp[100][200];
int cpt=0;
int cptexp=0;
char Operateur[2];
char Ex[100][200];
int cptex=0;
char T[100][200];
int cpte=0;
char O[100][200];
char TypeD[20];
int cptn=0;
int Sauvint;
float sauvfloat;
%}
%union {
int entier;
char* str;
float numvrg;
}  
%start S   
%token mc_program mc_pdec mc_pinst begin mc_end mc_cst 
       mc_dfType mc_for mc_while mc_do endfor mc_if mc_else DP 
       OU pvg egal Degal aff plus moins mul  sup mc_endif
       inf supOuEg InfOuEg diff ET  non '(' ')'
%token <str>idf 
%token <str> mc_entier mc_reel
%token <entier> integer 
%token <numvrg> reel
%token <str> divis
/* ------------------------------------------ Les types --------------------------------------*/
/*---------------------------Les Priorites -----------------------------------------------*/
%left OU
%left ET
%left non 
%left sup inf supOuEg Degal diff InfOuEg
%left plus moins 
%left mul divis  
%%
S:entete mc_pdec decpart mc_pinst begin instrpart mc_end
  { printf("\nLe programme est  syntaxiquement correcte\n"); afficherTS();} 
;
entete: mc_program idf
;

decpart: decpart variables DP type pvg
        { int i;
         for(i=0;i<cpt;i++)
        { insert(Temp[i],typeidf,"Var");
        }
        cpt=0;
        }
       | variables DP type pvg 
         {int i;
            for(i=0;i<cpt;i++)
            {
              insert(Temp[i],typeidf,"Var");
            }
            cpt=0;
         }
       | decpart Constante
       | Constante
;
variables:variables OU idf 
          { strcpy(Temp[cpt],$3);
            cpt++;
          }
         |idf 
         {
          strcpy(Temp[cpt],$1);
             cpt++;
          }
;
Constante:mc_cst type idf egal types pvg 
          { insert($3,typeidf,"Cst");}
;        
type:mc_entier {strcpy(typeidf,$1);}
     |mc_reel {strcpy(typeidf,$1);}
;
instrpart:insts instrpart
         |insts
;
insts:instaff pvg      
      |instFor 
      |instCondt 
;
instaff:idf aff exparth
   {if(NonDeclaree($1)==1)
    printf("\nErreur a la ligne %d, cet entite %s est non declaree\n",nb_lignes,$1);
    //Verification de la Non declaration de la partie Exparth
    int i;
     for(i=0;i<cpte;i++)
     {if(strcmp($1,T[i])!=0 && NonDeclaree(T[i])==1)
        printf("\nErreur a la ligne %d, cet entite %s est non declaree\n",nb_lignes,T[i]);
     }
     cpte=0;
     //traitement de la routine de Modification d'une constante 
     //Floor arrondit à l’entier inférieur le plus proche
     if(NonDeclaree($1)==-1 && modif_cste($1)==1)
      printf("\nErreur a la ligne %d ,impossible de modifier la constante %s",nb_lignes,$1);
   }
   
;
exparth:exparth divis exparth
       {strcmp(Operateur,divis);}
       |exparth moins exparth     
       |exparth mul exparth    
       |exparth plus exparth 
       |'('exparth ')' 
       |idf
       {strcpy(T[cpte],$1);
            cpte++;
       }
       |typeInt
       |Typefloat
;
instFor:mc_for cdtfor mc_while integer mc_do instrpart endfor
;
cdtfor:idf aff integer
 {if(NonDeclaree($1)==1)
          printf("Erreur a la ligne %d, cet entite %s est non declaree\n",nb_lignes,$1); }
;

instCondt:mc_do instrpart mc_if DP '(' condition ')' mc_endif      
         |mc_do instrpart mc_if DP '(' condition ')' mc_else instrpart mc_endif
;
condition:exprlog
; 
exprlog:'(' exprlog ')' OU '(' exprlog ')'
       |'(' exprlog ')' ET '(' exprlog ')'
       |non '(' exprlog ')'
       |expcompar 
       {int i;
         for(i=0;i<cpte;i++)
         {if(NonDeclaree(T[i])==1)
          printf("Erreur a la ligne %d, cet entite %s est non declaree\n",nb_lignes,T[i]);
         }
       cpte=0; 
     }  
;
expcompar:expcompar sup expcompar
	   |expcompar inf expcompar
	   |expcompar Degal expcompar
	   |expcompar diff expcompar
	   |expcompar InfOuEg expcompar 
	   |expcompar supOuEg expcompar
       |idf
        {strcpy(T[cpte],$1);
         cpte++;
        }
       |types  
       ;
typeInt: '(' moins integer ')'
       |'(' plus integer ')' 
       |integer  
;
Typefloat: '(' moins reel ')' 
       |'('plus reel')' 
       |reel  

;
types:typeInt 
      |Typefloat
;
%%
int yyerror(char* msg)
{printf("L'erreur Syntaxique %s a la ligne %d et la colonne %d",msg,nb_lignes,col);
  return 0;
}
extern FILE* yyin;
int main()  {  
yyin = fopen("Myprgrm.txt","r");
yyparse();
return 0;  
} 


