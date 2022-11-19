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
char Operateur[20];
char Ex[100][200];
int cptex=0;
char T[100][200];
int cpte=0;
char O[100][200];
char TypeD[20];
int cptn=0;
char sauvIdf[20];
float sauvfloat;
char sauvType[20];
char sauvT[20];
char sauvval[20];
char sauvTE[100];
char sauvG[20];
char sauvD[20];
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
  { printf("\nLe programme est  syntaxiquement correcte\n");afficherTS();} 
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
          { insert($3,typeidf,"Cst");
          }
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
     strcpy(sauvT,getType($1));
     if(compatible_type(sauvT,sauvTE)==1 || NonDeclaree($1)==1)
         printf("\nErreur a la ligne %d ,incompatible de type ",nb_lignes);
    if(compatible_type(sauvT,sauvType)==1 || NonDeclaree($1)==1)
         printf("\nErreur a la ligne %d ,incompatible de type ",nb_lignes);
   }
   
;
exparth:exparth divis exparth
       {strcpy(Operateur,$2);
       if(sauvfloat==0  && atoi(sauvIdf)==0)
        printf("\n Erreur a la ligne %d division sur zero ",nb_lignes);
       }
       |exparth moins exparth     
       |exparth mul exparth    
       |exparth plus exparth 
       |'('exparth')' 
       |idf
       {strcpy(T[cpte],$1);
            cpte++;
        strcpy(sauvIdf,$1);
        strcpy(sauvTE,getType($1));
       }
       |typeInt
       |Typefloat
;
instFor:mc_for cdtfor mc_while integer mc_do instrpart endfor
;
cdtfor:idf aff integer
 {if(NonDeclaree($1)==1)
          printf("\n Erreur a la ligne %d, cet entite %s est non declaree\n",nb_lignes,$1); }
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
;
expcompar:idf sup idf
      {  strcpy(sauvD,getType($1));
       strcpy(sauvG,getType($3));
         
        if(compatible_type(sauvD,sauvG)==1 || NonDeclaree($1)==1)
        {printf("\nErreur a la ligne %d ,incompatible de type ",nb_lignes);
        }
      }
	   |idf inf idf 
    {strcpy(sauvD,getType($1));
       strcpy(sauvG,getType($3));
         
        if(compatible_type(sauvD,sauvG)==1 || NonDeclaree($1)==1)
        {printf("\nErreur a la ligne %d ,incompatible de type ",nb_lignes);
        }
    }
	   |idf Degal idf
      {  strcpy(sauvD,getType($1));
       strcpy(sauvG,getType($3));
         
        if(compatible_type(sauvD,sauvG)==1 || NonDeclaree($1)==1)
        {printf("\nErreur a la ligne %d ,incompatible de type ",nb_lignes);
        }
      }
	   |idf diff idf
      {  strcpy(sauvD,getType($1));
       strcpy(sauvG,getType($3));
         
        if(compatible_type(sauvD,sauvG)==1 || NonDeclaree($1)==1)
        {printf("\nErreur a la ligne %d ,incompatible de type ",nb_lignes);
        }
      }
	   |idf InfOuEg idf 
      {  strcpy(sauvD,getType($1));
       strcpy(sauvG,getType($3));
         
        if(compatible_type(sauvD,sauvG)==1 || NonDeclaree($1)==1)
        {printf("\nErreur a la ligne %d ,incompatible de type ",nb_lignes);
        }
      }
	   |idf supOuEg idf
      {  strcpy(sauvD,getType($1));
       strcpy(sauvG,getType($3));
         
        if(compatible_type(sauvD,sauvG)==1 || NonDeclaree($1)==1)
        {printf("\nErreur a la ligne %d ,incompatible de type ",nb_lignes);
        }
      }
     |idf sup types
      {  strcpy(sauvD,getType($1));
       strcpy(sauvG,sauvType);
         
        if(compatible_type(sauvD,sauvG)==1 || NonDeclaree($1)==1 )
        {printf("\nErreur a la ligne %d ,incompatible de type ",nb_lignes);
        }
      }
	   |idf inf types
      {  strcpy(sauvD,getType($1));
       strcpy(sauvG,sauvType);
         
        if(compatible_type(sauvD,sauvG)==1 || NonDeclaree($1)==1)
        {printf("\nErreur a la ligne %d ,incompatible de type ",nb_lignes);
        }
      }
	   |idf Degal types
      {  strcpy(sauvD,getType($1));
       strcpy(sauvG,sauvType);
         
        if(compatible_type(sauvD,sauvG)==1 || NonDeclaree($1)==1)
        {printf("\nErreur a la ligne %d ,incompatible de type ",nb_lignes);
        }
      }
	   |idf diff types
      {  strcpy(sauvD,getType($1));
       strcpy(sauvG,sauvType);
         
        if(compatible_type(sauvD,sauvG)==1 || NonDeclaree($1)==1)
        {printf("\nErreur a la ligne %d ,incompatible de type ",nb_lignes);
        }
      }
	   |idf InfOuEg types
      {  strcpy(sauvD,getType($1));
       strcpy(sauvG,sauvType);
         
        if(compatible_type(sauvD,sauvG)==1 || NonDeclaree($1)==1)
        {printf("\nErreur a la ligne %d ,incompatible de type ",nb_lignes);
        }
      }
	   |idf supOuEg types
      {  strcpy(sauvD,getType($1));
       strcpy(sauvG,sauvType);
         
        if(compatible_type(sauvD,sauvG)==1 || NonDeclaree($1)==1)
        {printf("\nErreur a la ligne %d ,incompatible de type ",nb_lignes);
        }
      }
;
typeInt: '(' moins integer ')'{strcpy(sauvType,"Pint");}
       |'(' plus integer ')' {strcpy(sauvType,"Pint");}
       |integer   {strcpy(sauvType,"Pint");sauvfloat=$1;}
;
Typefloat: '(' moins reel ')' {strcpy(sauvType,"Pfloat");}
       |'('plus reel')' {strcpy(sauvType,"Pfloat");}
       |reel  {strcpy(sauvType,"Pfloat");sauvfloat=$1;}

;
types:typeInt 
      |Typefloat
;
%%
int yyerror(char* msg)
{printf("\nL'erreur Syntaxique %s a la ligne %d et la colonne %d",msg,nb_lignes,col);
  return 0;
}
extern FILE* yyin;
int main()  {  
yyin = fopen("Myprgrm.txt","r");
yyparse();
return 0;  
} 


