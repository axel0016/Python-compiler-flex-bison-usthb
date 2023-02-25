%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
extern yylineo; 
extern Col; 
#include "syntaxique.tab.h"
#include "fonc.h"
extern YYSTYPE yylval;
%}


digits  [0-9]
special_start \(
special_end   \)
integer  ({special_start}[+-]{digits}+{special_end})|({digits}+)
real ({special_start}[+-]({digits}*[.])?{digits}+{special_end})|(({digits}*[.])?{digits}+)
equal  =
plus	\+
minus	\-
divide	\/
mul	\*
char [a-zA-Z]
cChar [A-Z]
IDF {cChar}({char}|{digits})*
single_quote \'
character   '{char}' 


%%

int   	  {yylval.str=strdup(yytext);printf ("int dans la ligne %d\n",yylineo); rechercher(yytext,"Mot cle","",0, 1,"vide"); Col= Col + strlen(yytext); return INT; }
float     { yylval.str=strdup(yytext);printf ("float dans la ligne %d\n",yylineo); rechercher(yytext,"Mot cle","",0, 1,"vide"); Col= Col + strlen(yytext); return FLOAT; }
char      {yylval.str=strdup(yytext);printf ("char dans la ligne %d\n",yylineo);rechercher(yytext,"Mot cle","",0, 1,"vide");  Col= Col + strlen(yytext);return CHAR; }
bool      {yylval.str=strdup(yytext); printf ("bool dans la ligne %d\n",yylineo); rechercher(yytext,"Mot cle","",0, 1,"vide");  Col= Col + strlen(yytext);return BOOL; }
for       {printf("for dans la ligne %d\n",yylineo); rechercher(yytext,"Mot cle","",0, 1,"vide");  Col= Col + strlen(yytext);return FOR;}
while     {printf("while dans la ligne %d\n",yylineo); rechercher(yytext,"Mot cle","",0, 1,"vide");  Col= Col + strlen(yytext);return WHILE;}
range     {printf("range dans la ligne %d\n",yylineo); rechercher(yytext,"Mot cle","",0, 1,"vide");  Col= Col + strlen(yytext);return RANGE;}
if        {printf("if dans la ligne %d\n",yylineo); rechercher(yytext,"Mot cle","",0, 1,"vide");  Col= Col + strlen(yytext);return IF;}
else      {printf("else dans la ligne %d\n",yylineo); rechercher(yytext,"Mot cle","",0, 1,"vide");  Col= Col + strlen(yytext);return ELSE;}
in		  {printf("in dans la ligne %d\n",yylineo); rechercher(yytext,"Mot cle","",0, 1,"vide"); Col= Col + strlen(yytext); return IN;}

{IDF}     { yylval.str=strdup(yytext);
			  if (yyleng>8) printf ("Erreur lexical: IDF trop long %s \n", yytext);
              else {printf ("idf dans la ligne%d\n",yylineo); rechercher(yytext,"idf","",0, 0,"vide");   Col= Col + strlen(yytext);return IDF;}
		  }

#(.*\n) 	 			{printf("comment dans la ligne %d\n",yylineo);yylineo++;return COMMENT;} 
{equal}					{yylval.str=strdup(yytext);printf("egale dans la ligne %d\n",yylineo);rechercher(yytext,"equal ","",0, 2,"vide"); Col= Col + strlen(yytext);return EQUAL;}
{plus}					{yylval.str=strdup(yytext);printf("plus dans la ligne %d\n",yylineo);rechercher(yytext,"plus","",0, 2,"vide"); Col= Col + strlen(yytext); return PLUS;}
{minus}					{yylval.str=strdup(yytext);printf("minus dans la ligne %d\n",yylineo);rechercher(yytext,"minus ","",0, 2,"vide"); Col= Col + strlen(yytext);return MINUS;}
{mul}					{yylval.str=strdup(yytext);printf("mul dans la ligne %d\n",yylineo);rechercher(yytext,"mul ","",0, 2,"vide"); Col= Col + strlen(yytext);return MUL;}
{divide}				{yylval.str=strdup(yytext);printf("divide dans la ligne %d\n",yylineo);rechercher(yytext,"divide ","",0, 2,"vide");Col= Col + strlen(yytext); return DIVIDE;}
{special_start}         {printf("par_start dans la ligne %d\n",yylineo);rechercher(yytext,"special_start","",0, 2,"vide"); Col= Col + strlen(yytext);return SPECIAL_START;}
{special_end}           {printf("par_end dans la ligne %d\n",yylineo);rechercher(yytext,"special_end","",0, 2,"vide");Col= Col + strlen(yytext); return SPECIAL_END;}
\[                      {printf("parenthese sq start dans la ligne %d\n",yylineo);rechercher(yytext,"sq bracket start","",0, 2,"vide");Col= Col + strlen(yytext); return SQUAREBRACKET_START;}
\]                      {printf("parenthese sq end dans la ligne %d\n",yylineo);rechercher(yytext,"sq bracket end","",0, 2,"vide"); Col= Col + strlen(yytext);return SQUAREBRACKET_END;}
:                       {printf("colonne dans la ligne %d\n",yylineo);rechercher(yytext,"colon","",0, 2,"vide"); Col= Col + strlen(yytext);return COLON;}
{single_quote}          {printf("single citation dans la ligne %d\n",yylineo);rechercher(yytext,"single quote","",0, 2,"vide");Col= Col + strlen(yytext); return SINGLEQUOTE;}
,                       {printf("virgule dans la ligne %d\n",yylineo);rechercher(yytext,"comma","",0, 2,"vide");Col= Col + strlen(yytext); return COMMA;}
or                      {yylval.str=strdup(yytext);printf("or dans la ligne %d\n",yylineo);rechercher(yytext,"or","",0, 2,"vide"); Col= Col + strlen(yytext);return OR;}
and                     {yylval.str=strdup(yytext);printf("and dans la ligne %d\n",yylineo);rechercher(yytext,"and","",0, 2,"vide"); Col= Col + strlen(yytext);return AND;}
not                     {yylval.str=strdup(yytext);printf("not dans la ligne %d\n",yylineo);rechercher(yytext,"not","",0, 2,"vide");Col= Col + strlen(yytext); return NOT;}
\>			            {yylval.str=strdup(yytext);printf("plusque dans la ligne %d\n",yylineo);rechercher(yytext,"greaterthan","",0, 2,"vide");Col= Col + strlen(yytext); return GREATERTHAN;}
\>=			            {yylval.str=strdup(yytext);printf("plusqueegale dans la ligne %d\n",yylineo);rechercher(yytext,"greaterthanequal","",0, 2,"vide");Col= Col + strlen(yytext); return GREATERTHANEQUAL;}
\<						{yylval.str=strdup(yytext);printf("moinsque dans la ligne %d\n",yylineo);rechercher(yytext,"lessthan","",0, 2,"vide");Col= Col + strlen(yytext); Col= Col + strlen(yytext);return LESSTHAN;}
\<=						{yylval.str=strdup(yytext);printf("moinsqueegale dans la ligne %d\n",yylineo);rechercher(yytext,"lessthanequal","",0, 2,"vide");Col= Col + strlen(yytext); return LESSTHANEQUAL;}
\==						{yylval.str=strdup(yytext);printf("double egale dans la ligne %d\n",yylineo);rechercher(yytext,"doubleequal","",0, 2,"vide");Col= Col + strlen(yytext); return DOUBLEEQUAL;}
\!=						{yylval.str=strdup(yytext);printf("notequal dans la ligne %d\n",yylineo);rechercher(yytext,"notequal","",0, 2,"vide"); Col= Col + strlen(yytext);return NOTEQUAL;}
true                    {printf("Vrai dans la ligne %d\n",yylineo);rechercher(yytext,"true","boolean",1, 0,"true"); Col= Col + strlen(yytext);yylval.integer=atoi(yytext);return TRUE;}
false                   {printf("Faux dans la ligne %d\n",yylineo);rechercher(yytext,"false","boolean",0, 0,"false"); Col= Col + strlen(yytext);yylval.integer=atoi(yytext);return FALSE;}
{integer} 	{if(yytext[0]=='('){char *result = yytext+1; // removes first character
								 result[strlen(result)-1] = '\0';
								 strcpy(yytext,result);printf("%s",yytext);}
  
			  if ((atoi(yytext)>-32768)&&(atoi(yytext)<32767)){
			  rechercher(yytext,"integer","integer",atof(yytext),0,"vide");
			  printf ("integer dans la ligne %d\n",yylineo);Col= Col + strlen(yytext); yylval.integer=atoi(yytext);
			  return INTEGER;
			  }else printf ("Erreur lexical: integer trop long dans la ligne %d dans la colonne %d",yylineo,Col);
		     }
{real} {	  if(yytext[0]=='('){char *result = yytext+1; // removes first character
								 result[strlen(result)-1] = '\0';
								 strcpy(yytext,result);printf("%s",yytext);}
			  if ((atoi(yytext)>-32768)&&(atoi(yytext)<32767)){	
			  {rechercher(yytext,"float","reel",atof(yytext),0,"vide");}
			  printf ("float dans la ligne %d\n",yylineo);Col= Col + strlen(yytext);yylval.reel=atof(yytext);
			  return REAL;
			  }else printf ("Erreur lexical: float too big dans la ligne %d colonne %d",yylineo,Col);
		}
{character} {
			  rechercher(yytext,"character","char",0, 0,strdup(yytext));
			  printf ("charactere dans la ligne %d\n",yylineo);Col= Col + strlen(yytext);strcpy(yylval.str,strdup(yytext));
			  return CHARACTER;
			}

\n 		{ yylineo++; printf("nouvelle ligne reconnue\n");Col=1;}
("	"|"    ")+ {printf("identation reconnue\n");Col= Col + 1;return WHITE_SPACE;}
" "+    {Col= Col + strlen(yytext);}
"" {return Empty;}
. {printf("Erreur lexical dans la ligne %d la colonne %d in %s\n",yylineo,Col,yytext);}




