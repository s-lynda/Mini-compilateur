///Les champs de la table de symbole 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern int nb_lignes;
typedef struct eltTS *listeTS;
typedef struct eltTS{
    char NomEntite[20];
    char  Type[20]; //Integer pour Entier et Float pour Reel 
    char  Nature[20];  //Cst pour les constantes et Var pour les variables 
    char  Val[40];
    listeTS suivant;
} eltTS;

//un tableau qui va contenir les infos sur une entite
listeTS TS;
int cptTS=0; //pour indiquer la position du dernier elt insérer dans la table de symbole
//Dans la table de symbole pas de doublons ie on va pas trouvé 2 entité avec le meme nom
//pour régler ce probleme faut déclarée la fct 'Trouve'
//Fonction trouve ( chercher si il existe donc retourne 1 si nn retourne 0)
int trouve(char Nomentite[])
{ 
    listeTS p = TS;
    while(p!=NULL){
        if(strcmp(p->NomEntite, Nomentite)==0) break;
        p=p->suivant; //avancer dans la liste
    }
    if(p!=NULL) return 1;
    else return 0;
}
//la fonction insert qui va inserer les entités dans la table de symbole
void insert(char Nomentite[],char type[],char Nature[])
{
  if(trouve(Nomentite)==0){
        listeTS p = (listeTS) malloc(sizeof(eltTS));
        strcpy(p->NomEntite,Nomentite);
        strcpy(p->Type,type);
        strcpy(p->Nature,Nature);
        strcpy(p->Val,"0");
        p->suivant = NULL;
        cptTS++;

        if(TS == NULL)
            TS = p;
        else{
            listeTS temp = TS;
            while(temp->suivant != NULL) temp = temp->suivant;
            temp->suivant = p;
        }
   }
  else{
      printf("\nErreur  a la ligne %d , Entite '%s' existe deja...",nb_lignes,Nomentite);
  }
}
void setValeur(char *idf, char val[]){
  listeTS p=TS;
   while(p!=NULL)
   {if(strcmp(p->NomEntite,idf)==0){
       strcpy(p->Val,val);
    }
     p=p->suivant;
   }
}

//Pour indiquer les non déclarée 
int NonDeclaree(char NomEntite[])
{listeTS p=TS;
   while(p!=NULL)
   {if(strcmp(p->NomEntite,NomEntite)==0)
    { return -1;
    }
     p=p->suivant;
   }
    return 1;
}
//modification d'une constante 
/* Cette fonction on la trouve sur les Affectation dans la partie syntaxique*/
int modif_cste(char idf[20]){
    
  listeTS p =TS;
    while(p!=NULL)
    {if(strcmp(p->NomEntite,idf)==0)
      {if(strcmp(p->Nature,"Cst")==0) return 1;
       else return 0;
      }
      p=p->suivant;
    }
    return 0;
}
char *getType(char Nom[])
{listeTS p=TS;
while(p!=NULL) 
{if(strcmp(p->NomEntite,Nom)==0)
 {
  return p->Type;
 }
 p=p->suivant;
}
return " ";

}
int compatible_type(char type1[],char type2[]){
if(strcmp(type1,type2)==0)
 {return 0;}
 else return 1;
}

//fonction pour l'affichage de la table de Symbole ====Display 
void afficherTS()
{int i=0;
    printf("\n -----------Table de Symbole-----------");
    printf("\n +-------------+----------+----------+--------");
    printf("\n |  Nom Entite |  Type    |  Nature  |");
    printf("\n ---------------------------------------------");
    listeTS p=TS;
    while(p!=NULL)
    {printf("\n | %10s  |%10s|%10s|\n",p->NomEntite,p->Type,p->Nature);
     p = p->suivant;
    }
}