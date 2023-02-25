%{	
	#include <stdio.h>
	#include <stdlib.h>
	
	int err = 0;
	int h = 0;
	int Fin_if=0,Fin_while=0, Deb_while=0,OP = 0,and_b=0,and_f=0,or_b=0,or_f=0,debu=0,deb_for=0;
	char L[25],Q[25];
	char temp1[25] = "TEMP";
	char opera[5]; 
	char saveType[25];
	char saveOP[25];
	char saveOpLo[25];
	char tmp[25];
	char med[25];
	char med2[25];
	char op1[25];
	char op2[25];
	char medOp[25];
	char tempMul[25];
	char resultL[25];
	char s[25];
	char medType[25];
    int fin_if[10];
	int i_if=0;
    int deb_else[10];
	int i_else=0;	
	int lol = 0;
	int Cond = 0;
	int medL=0;
	int indentation = 0;
	int mustBe = 0;
	int mul=0;
	int x=0;
	int AND_or_OR = 0;
	int only_one = 0;
	int first =0;
	int teemp = 0;
	int p = 0;
	int o = 0;
	int a = 0;	
	char saveCst[25];
	char sauvIdf1[25];
	char sauvIdf[2][10] = {};	
    int yylineo=1; 
    int Col=1; //declaraction du cpt de nombre de colonne
	int qc =0;
%}
%union{
int integer;
 float reel;
 char character;
 char* str;
}
%token <str>INT <str>FLOAT <str>CHAR <str>BOOL <str>IDF COMMENT IF ELSE WHILE FOR RANGE PLUS MINUS MUL DIVIDE  <str>EQUAL SPECIAL_START SPECIAL_END SQUAREBRACKET_START WHITE_SPACE IN Empty 
SQUAREBRACKET_END COLON SINGLEQUOTE COMMA OR AND NOT LESSTHAN LESSTHANEQUAL GREATERTHAN GREATERTHANEQUAL DOUBLEEQUAL NOTEQUAL <str>CHARACTER  <integer>TRUE <integer>FALSE <integer>INTEGER <reel>REAL
%start S
%left PLUS MINUS
%left MUL DIVIDE 
%left AND
%left OR
%left GREATERTHAN GREATERTHANEQUAL LESSTHAN LESSTHANEQUAL EQUAL NOTEQUAL
%%
S : DEC  S| LIST_INST  S|COMMENT S| { printf("Le programme est correcte syntaxiquement\n"); YYACCEPT; } ;

DEC: DEC_VAR |
	DEC_ARR |
	DEC_CONST;

TYPE: INT {strcpy(saveType,"integer");}|
	FLOAT {strcpy(saveType,"reel");}|
	CHAR {strcpy(saveType,"char");}| 
	BOOL{strcpy(saveType,"boolean");};

DEC_VAR : TYPE IDF{ if(doubleDeclaration($2)==-1) 
			  printf("error at %d %d, %s is already declared\n",yylineo-1,Col,$2);   
			  else
			   {strcpy(sauvIdf1,$2);
			      }} CHO      LIST_IDF;
CHO:EQUAL INTEGER{SaveType(saveType,sauvIdf1);sprintf(saveCst,"%d",$2);quadr("=",saveCst,"",sauvIdf1);}
  |EQUAL REAL {SaveType(saveType,sauvIdf1);sprintf(saveCst,"%f",$2);quadr("=",saveCst,"",sauvIdf1);}
  |EQUAL CHARACTER {SaveType(saveType,sauvIdf1);sprintf(saveCst,"%s",$2);quadr("=",saveCst,"",sauvIdf1);}
  |EQUAL TRUE {{SaveType(saveType,sauvIdf1);sprintf(saveCst,"%d",1);quadr("=",saveCst,"",sauvIdf1);}}
  |EQUAL FALSE {{SaveType(saveType,sauvIdf1);sprintf(saveCst,"%d",0);quadr("=",saveCst,"",sauvIdf1);}}
  |{SaveType(saveType,sauvIdf1);};				  

LIST_IDF : COMMA IDF { if(doubleDeclaration($2)==-1) 
			 printf("error at %d %d, %s is already declared\n",yylineo-1,Col,$2);  

			  else
			   {strcpy(sauvIdf1,$2); }   }CHO LIST_IDF   | ;	

DEC_ARR: TYPE IDF SQUAREBRACKET_START INTEGER SQUAREBRACKET_END { if(doubleDeclaration($2)==-1) {
			 printf("error at %d %d, %s is already declared\n",yylineo-1,Col,$2);  err=1;}
			  else {if($4<=0){printf("error at %d %d,array size must be positive\n",yylineo,Col);}else{
			  SaveType(saveType,$2);
			  }}}

DEC_CONST :TYPE IDF { if(doubleDeclaration($2)==-1) {
			 printf("error at %d %d, %s is already declared\n",yylineo-1,Col,$2);  err=1;}
			  else {SaveType(saveType,$2); }   } EQUAL EXPRESS ;

LIST_INST : IF_INST |
		WHILE_LOOP |
		FOR_LOOP |
		AFF;

SPACED_LIST_INST: SPACE {if(indentation!=mustBe){printf("error at %d %d, indentation error\n",yylineo,Col);}}LIST_INST ; 
SPACE : WHITE_SPACE {indentation+=1;} SPACE | 
		WHITE_SPACE{indentation+=1; printf("mustbe: %d indentation: %d\n",mustBe,indentation);};
IF_INST :  IF SPECIAL_START LOGICAL_EXPRESSION  {deb_else[i_else]=qc;i_else++;quadr("BZ","",saveCst,"");}SPECIAL_END COLON  {mustBe+=1;} SPACED_LIST_INST  {indentation=0;} CHOIX {mustBe-=1;sprintf(tmp,"%d",qc);printf("qc: %d eb else: %d",qc,deb_else[i_else-1]);ajour_quad(deb_else[i_else-1],1,tmp);}ELSE_INST;
ELSE_INST: {fin_if[i_if]=qc;i_if++;quadr("BR","","","");sprintf(tmp,"%d",qc);ajour_quad(deb_else[i_else-1],1,tmp);i_else--; }ELSE COLON  {mustBe+=1;} SPACED_LIST_INST {indentation=0;} CHOIX {sprintf(tmp,"%d",qc);  ajour_quad(fin_if[i_if-1],1,tmp);i_if--;}{mustBe-=1;}| ;
CHOIX: SPACED_LIST_INST  {indentation=0;} CHOIX| ;
WHILE_LOOP: WHILE SPECIAL_START  {Fin_while=qc;}LOGICAL_EXPRESSION {quadr("BZ","",saveCst,"");} SPECIAL_END COLON  {mustBe+=1;} SPACED_LIST_INST {indentation=0;} CHOIX {sprintf(tmp,"%d",Fin_while);quadr("BR",tmp,"","");sprintf(tmp,"%d",qc);ajour_quad(Fin_while+1,1,tmp);}{mustBe-=1;};
FOR_LOOP :  FOR IDF {deb_for=qc;strcpy(L,$2);} IN L COLON  {mustBe+=1;} SPACED_LIST_INST {indentation=0;}  CHOIX {sprintf(tmp,"%d",deb_for+1);quadr("+",L,"1","TEMP");quadr("=","TEMP","",L);quadr("BR",tmp,"","");sprintf(tmp,"%d",qc);ajour_quad(deb_for+2,1,tmp);}{mustBe=0;};
L : IDF | RANGE SPECIAL_START CONST_1 {quadr("=",Q,"",L);} COMMA CONST_1 {quadr("<=",L,Q,"TEMP");quadr("BZ","","TEMP","");} SPECIAL_END;
CONST_1 :INTEGER {sprintf(Q,"%d",$1);} | IDF {strcpy(Q,$1);};
LOGICAL_EXPRESSION:LOGICAL_COMPARE {
if(AND_or_OR!=0){
	if(AND_or_OR==1){
		and_b=qc;
		quadr("BZ","",s,"");
		quadr("BZ","",saveCst,"");
		quadr("=","1","","TEMP");
		and_f=qc;
		quadr("BR","","","");
		sprintf(tmp,"%d",qc);ajour_quad(and_b,1,tmp);ajour_quad(and_b+1,1,tmp);
		quadr("=","0","","TEMP");sprintf(tmp,"%d",qc);
		ajour_quad(and_f,1,tmp);
	}else{
		or_b=qc;
		quadr("BNZ","",s,"");
		quadr("BNZ","",saveCst,"");
		quadr("=","0","","TEMP");
		or_f=qc;
		quadr("BR","","","");
		sprintf(tmp,"%d",qc);ajour_quad(or_b,1,tmp);ajour_quad(or_b+1,1,tmp);
		quadr("=","1","","TEMP");sprintf(tmp,"%d",qc);
		ajour_quad(or_f,1,tmp);
	}
}if(o){strcpy(saveCst,"TEMP");ajour_quad(qc-3,3,"TEMP2");}
if(strcmp(saveCst,"TEMP")==0){ajour_quad(qc-1,3,"TEMP2");strcpy(s,"TEMP2");}else{strcpy(s,saveCst);}{o = 1;}
} SMTHN LOGICAL_EXPRESSION {strcpy(saveCst,"TEMP");o=0;} | 
LOGICAL_COMPARE {
	if(AND_or_OR!=0){
	if(AND_or_OR==1){
		and_b=qc;
		quadr("BZ","",s,"");
		quadr("BZ","",saveCst);
		quadr("=","1","","TEMP");
		and_f=qc;
		quadr("BR","","","");
		sprintf(tmp,"%d",qc);ajour_quad(and_b,1,tmp);ajour_quad(and_b+1,1,tmp);
		quadr("=","0","","TEMP");sprintf(tmp,"%d",qc);
		ajour_quad(and_f,1,tmp);
	}else{
		or_b=qc;
		quadr("BNZ","",s,"");
		quadr("BNZ","",saveCst);
		quadr("=","0","","TEMP");
		or_f=qc;
		quadr("BR","","","");
		sprintf(tmp,"%d",qc);ajour_quad(or_b,1,tmp);ajour_quad(or_b+1,1,tmp);
		quadr("=","1","","TEMP");sprintf(tmp,"%d",qc);
		ajour_quad(or_f,1,tmp);
	}
}
} ;
SMTHN : AND {AND_or_OR=1;} | OR {AND_or_OR=-1;};

LOGICAL_COMPARE : SPECIAL_START LOGICAL SPECIAL_END | NOT LOGICAL | SPECIAL_START NOT LOGICAL SPECIAL_END |LOGICAL ;
LOGICAL : WX {if(strcmp(saveCst,"TEMP")==0){ajour_quad(qc-1,3,"TEMP2");strcpy(s,"TEMP2");}else{strcpy(s,saveCst);}}LOGICAL_OPERATIONS WX {
	if(strcmp(saveOpLo,">")==0){quadr(">",s,saveCst,"TEMP");}
	if(strcmp(saveOpLo,">=")==0){quadr(">=",s,saveCst,"TEMP");}
	if(strcmp(saveOpLo,"<")==0){quadr("<",s,saveCst,"TEMP");}
	if(strcmp(saveOpLo,"<=")==0){quadr("<=",s,saveCst,"TEMP");}
	if(strcmp(saveOpLo,"==")==0){quadr("==",s,saveCst,"TEMP");}
	if(strcmp(saveOpLo,"!=")==0){quadr("!=",s,saveCst,"TEMP");}
	strcpy(saveCst,"TEMP");
}|WX;

WX:	EXPRESSION ;			
LOGICAL_OPERATIONS : GREATERTHAN {strcpy(saveOpLo,$1);}| 
					GREATERTHANEQUAL {strcpy(saveOpLo,$1);}| 
					LESSTHAN {strcpy(saveOpLo,$1);}|
					LESSTHANEQUAL {strcpy(saveOpLo,$1);}| 
					DOUBLEEQUAL {strcpy(saveOpLo,$1);}|
					NOTEQUAL {strcpy(saveOpLo,$1);}

EXPRESS : SPECIAL_START EXPRESS  SPECIAL_END BS4  | 
			EXPRESSION
			;
BS4:ARITHMETIC_OPERATION{strcpy(opera,saveOP); } EXPRESS{quadr(opera,"TEMP","TEMP","TEMP");}|;			
			
EXPRESSION : CONST
{	
	if(only_one == 0 ){
		if(strcmp(op1,"")==0 && !h){
			strcpy(saveCst,op1);}else{if(h){h=0;}}
	}else{
		if(!mul){
			if(x==1){
				if(p){
				quadr(medOp,op1,"TEMP",temp1);
			}else{
				quadr(saveOP,temp1,op1,temp1);}
		}else{
			quadr(saveOP,med,op1,temp1);
		}
		}else{
			if (lol){
			quadr(medOp,temp1,tempMul,temp1);lol=0;}
			if(strcmp(tempMul,"")!=0){
				if(strcmp(med2,"")!=0){if(a){quadr(medOp,med2,tempMul,temp1);}}
			}
		}
	}
	} {strcpy(op1,"");}| 		
			CONST {strcpy(medType,saveType);strcpy(med,op1);} {only_one = 1} 
			ARITHMETIC_OPERATION {
					if(strcmp(saveOP,"+")==0 ||strcmp(saveOP,"-")==0){
						if(!mul){
						if(strcmp(med2,"")!=0){
							if(x){
								quadr(medOp,temp1,med,temp1);
							}else{
								quadr(medOp,med2,med,temp1);x=1;
							}
							strcpy(med2,"");lol = 1;
						}
						else{
							strcpy(med2,med);
						}}
						else{
							if(strcmp(med2,"")!=0){
									quadr(medOp,med2,"TEMP",temp1);
									strcpy(med2,"TEMP");
								}else{
									strcpy(med2,"TEMP");p=1;
									}mul=0;x=1;strcpy(tempMul,"");
						}strcpy(medOp,saveOP);a=0;
					}	

										
				if(strcmp(saveOP,"*")==0 || strcmp(saveOP,"/")==0){
						mul = 1;a=1;
					}
			}
			EXPRESS {strcpy(saveOP,"");strcpy(medOp,"");strcpy(med2,"");strcpy(med,"");strcpy(tempMul,"");strcpy(op1,"");lol=0;mul=0;x=0;a=0;p=0;}
				
				{strcpy(saveCst,temp1);only_one=0 ;};

CONST:INTEGER {		
	strcpy(saveType,"integer");
	sprintf(saveCst,"%d",$1);strcpy(op1,saveCst);
	if(strcmp(saveOP,"")!=0){
		if(strcmp(saveType,medType)!=0){
		printf("error at %d %d,types error\n",yylineo-1,Col);err=1;
		}
	}
	if(mul==1){
		if(strcmp(tempMul,"")==0){
			quadr(saveOP,med,op1,"TEMP");
			strcpy(tempMul,"TEMP");
	}else{
			quadr(saveOP,tempMul,op1,"TEMP");
		}
	}
}|
		REAL {
			strcpy(saveType,"reel");
	sprintf(saveCst,"%f",$1);strcpy(op1,saveCst);
	if(strcmp(saveOP,"")!=0){
		if(strcmp(saveType,medType)!=0){
		printf("error at %d %d,types error\n",yylineo-1,Col);err=1;
		}
	}
	if(mul==1){
		if(strcmp(tempMul,"")==0){
			quadr(saveOP,med,op1,"TEMP");
			strcpy(tempMul,"TEMP");
	}else{
			quadr(saveOP,tempMul,op1,"TEMP");
		}
	}
		}|
		
		CHARACTER {strcpy(saveType,"character");sprintf(saveCst, "%c", $1);
		if(strcmp(saveOP,"")!=0){
		if(strcmp(saveType,medType)!=0){
		printf("error at %d %d,types error\n",yylineo-1,Col);err=1;
		}
	}
	if(mul==1){
		if(strcmp(tempMul,"")==0){
			quadr(saveOP,med,op1,"TEMP");
			strcpy(tempMul,"TEMP");
	}else{
			quadr(saveOP,tempMul,op1,"TEMP");
		}
	}
		}|
		
		TRUE {strcpy(saveType,"boolean");strcpy(saveCst,"1");h=1;}|
		
		FALSE {strcpy(saveType,"boolean");strcpy(saveCst,"0");h=1;}|
		
		IDF {char Type[25],value[25]; GetType($1,Type);if(doubleDeclaration($1)==0){ printf("error at %d %d, %s is not declared\n",yylineo,Col,$1);err=1;  } 
		strcpy(saveType,Type);if(strcmp(saveOP,"")!=0){if(strcmp(saveType,medType)!=0){printf("error at %d %d,types error\n",yylineo-1,Col);err=1;}}
		strcpy(saveType,"integer");
	strcpy(saveCst,$1);strcpy(op1,saveCst);
	if(strcmp(saveOP,"")!=0){
		if(strcmp(saveType,medType)!=0){
		printf("error at %d %d,types error\n",yylineo-1,Col);err=1;
		}
	}
	if(mul==1){
		if(strcmp(tempMul,"")==0){
			quadr(saveOP,med,op1,"TEMP");
			strcpy(tempMul,"TEMP");
	}else{
			quadr(saveOP,tempMul,op1,"TEMP");
		}
	}
		}|
		
		IDF SQUAREBRACKET_START INTEGER SQUAREBRACKET_END{if($4<=0){printf("error at %d %d,array index must be positive\n",yylineo-1,Col);err=1;}else{char Type[25]; GetType($1,Type);
		strcpy(saveType,Type);}};
ARITHMETIC_OPERATION : PLUS  {strcpy(saveOP,$1);}|
						MINUS  {strcpy(saveOP,$1);}| 
						MUL  {strcpy(saveOP,$1);}| 
						DIVIDE {strcpy(saveOP,$1);};

AFF : IDF{
	strcpy(saveCst,"0");
	} 
EQUAL {first=1;}
EXPRESS 
 {if(doubleDeclaration($1)==-1){
	 if(checkType($1,saveType)==-1){
		 printf("error at %d %d, types error\n",yylineo-1,Col);
		 }
		 }else{
			 SaveType(saveType,$1);
		 } 
		 quadr("=",saveCst,"",$1);
	};

           
%%
main ()
{	 
   initialisation();
   yyparse();
   if(!err){
   

	afficher_qdr();
	
	lancer();
	afficher();
   
  }else{
	   printf("error in the code\n");
   }
   
}
 yywrap ()
 {}
int yyerror (char *msg ) { 
        printf ("Erreur syntaxique, ligne %d, colonne %d \n",yylineo,Col); 
        return 1; }
 
 