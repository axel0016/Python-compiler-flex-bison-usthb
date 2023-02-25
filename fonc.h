#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct
{
	int state;
	char name[20];
	char code[20];
	char type[20];
	float val;
	char valChar[20];
} element;

typedef struct
{
	int state;
	char name[20];
	char type[20];
} elt;

typedef struct
{
	char value[20];
} tabT;

typedef struct qdr
{

	char oper[100];
	char op1[100];
	char op2[100];
	char res[100];

} qdr;
qdr quad[1000];
extern int qc;

tabT tabt[1000];
int l = 0;
int b = 0;

element tab[1000];		
elt tabs[100], tabm[50]; 
int cpt, cpts, cptm;
char TEMP[50], TEMP2[50];


void initialisation()
{
	
	int i;
	for (i = 0; i < 1000; i++)
		tab[i].state = 0;
	for (i = 0; i < 40; i++)
	{
		tabs[i].state = 0;
		tabm[i].state = 0;
	}

	cpt = 0;
	cpts = 0;
	cptm = 0;
}



void inserer(char entite[], char code[], char type[], float val, int i, int y, char c[])
{
	switch (y)
	{
	case 0: 
		tab[i].state = 1;
		strcpy(tab[i].name, entite);
		strcpy(tab[i].code, code);
		strcpy(tab[i].valChar, c);
		if (strcmp(tab[i].type, "") == 0)
		{
			strcpy(tab[i].type, type);
		}
		if (tab[i].val == 0)
		{
			tab[i].val = val;
		}
		cpt++;
		break;

	case 1: 
		tabm[i].state = 1;
		strcpy(tabm[i].name, entite);
		strcpy(tabm[i].type, code);
		cptm++;
		break;

	case 2: 
		tabs[i].state = 1;
		strcpy(tabs[i].name, entite);
		strcpy(tabs[i].type, code);
		cpts++;
		break;
	}
}


void rechercher(char entite[], char code[], char type[], float val, int y, char c[])
{

	int j, i;

	switch (y)
	{
	case 0:
		
		if (cpt == 0)
			inserer(entite, code, type, val, 0, 0, c);
		else
		{
			for (i = 0; ((i < 1000) && (tab[i].state == 1)) && (strcmp(entite, tab[i].name) != 0); i++)
				;
			if (i < 1000)
			{
				inserer(entite, code, type, val, i, 0, c);
			}
			else
				printf("Entite %s existe deja\n", entite);
		}
		break;

	case 1:

		
		if (cptm == 0)
			inserer(entite, code, type, val, 0, 1, c);
		else
		{
			for (i = 0; ((i < 40) && (tabm[i].state == 1)) && (strcmp(entite, tabm[i].name) != 0); i++)
				;

			
			if (i < 40)
			{
				inserer(entite, code, type, val, i, 1, c);
			}
			else
				printf("Entite %s existe deja\n", entite);
		}
		break;

	case 2:
		
		if (cpts == 0)
			inserer(entite, code, type, val, 0, 2, c);
		else
		{
			for (i = 0; ((i < 40) && (tabs[i].state == 1)) && (strcmp(entite, tabs[i].name) != 0); i++)
				;
			if (i < 40)
			{
				inserer(entite, code, type, val, i, 2, c);
			}
			else
				printf("Entite %s existe deja\n", entite);
		}
		break;
	}
}

int doubleDeclaration(char entite[])
{
	int i;
	i = findIndex(entite);
	if (strcmp(tab[i].type, "") == 0)
	{
		return 0;
	}
	return -1;
}


void SaveType(char type[25], char entite[25])
{
	int i;
	i = findIndex(entite);
	if (i != -1)
	{
		strcpy(tab[i].type, type);
	}
}

int checkType(char entite[25], char Type[25])
{
	int i;
	i = findIndex(entite);
	if (strcmp(tab[i].type, Type) == 0)
	{
		return 0;
	}
	return -1;
}

void GetType(char entite[25], char Type[25])
{
	int i;
	i = findIndex(entite);
	strcpy(Type, tab[i].type);
}


void GetValue(char entite[25], char value[25])
{
	int i;
	i = findIndex(entite);
	sprintf(value, "%f", tab[i].val);
}

void SaveValue(char entite[25], char Value[25])
{
	int i;
	
	i = findIndex(entite);
	if (strcmp(tab[i].type, "char") != 0)
		tab[i].val = atof(Value);

	else
		strcpy(tab[i].valChar, Value);
	if (strcmp(tab[i].type, "boolean") == 0)
	{
		if (tab[i].val == 1)
		{
			strcpy(tab[i].valChar, "true");
		}
		else
			strcpy(tab[i].valChar, "false");
	}
}


int findIndex(char entite[])
{
	int i = 0;
	while (i < 1000)
	{

		if (strcmp(entite, tab[i].name) == 0)
			return i;
		i++;
	}

	return -1;
}
void Doop(char result[25], char Op[25], char med[25])
{
	if (strcmp(Op, "+") == 0)
	{
		sprintf(result, "%f", (atof(med) + atof(result)));
	}
	if (strcmp(Op, "-") == 0)
	{
		sprintf(result, "%f", (atof(result) - atof(med)));
	}
	if (strcmp(Op, "*") == 0)
	{
		sprintf(result, "%f", (atof(med) * atof(result)));
	}
	if (strcmp(Op, "/") == 0)
	{
		if (atof(result) == 0)
		{
			/*printf("error at %d %d, cant divide by 0", yylineo, Col);*/
		}
		else
		{
			sprintf(result, "%f", (atof(med) / atof(result)));
		}
	}
}



void afficher()
{
	int i;

	printf("\n/+++++++++++++++++++++++Table des symboles IDF++++++++++++++++++++++/\n");
	printf("____________________________________________________________________\n");
	printf("\t| Nom_Entite |  Code_Entite | Type_Entite | Val_Entite | valChar |\n");
	printf("____________________________________________________________________\n");

	for (i = 0; i < cpt; i++)
	{

		if (tab[i].state == 1)
		{
			printf("\t|%10s |%15s | %12s | %5.3f | %9s | \n", tab[i].name, tab[i].code, tab[i].type, tab[i].val, tab[i].valChar);
		}
	}

	printf("\n/***************Table des symboles mots cles*************/\n");

	printf("_____________________________________\n");
	printf("\t| NomEntite |  CodeEntite | \n");
	printf("_____________________________________\n");

	for (i = 0; i < cptm; i++)
		if (tabm[i].state == 1)
		{

			printf("\t|%10s |%12s | \n", tabm[i].name, tabm[i].type);
		}

	printf("\n/***************Table des symboles separateurs*************/\n");

	printf("_____________________________________\n");
	printf("\t| NomEntite |  CodeEntite    | \n");
	printf("_____________________________________\n");

	for (i = 0; i < cpts; i++)
		if (tabs[i].state == 1)
		{
			printf("\t|%10s |%15s | \n", tabs[i].name, tabs[i].type);
		}
}
void quadr(char opr[], char op1[], char op2[], char res[])
{

	strcpy(quad[qc].oper, opr);
	strcpy(quad[qc].op1, op1);
	strcpy(quad[qc].op2, op2);
	strcpy(quad[qc].res, res);

	qc++;
}
void ajour_quad(int num_quad, int colon_quad, char val[])
{
	if (colon_quad == 0)
		strcpy(quad[num_quad].oper, val);
	else if (colon_quad == 1)
		strcpy(quad[num_quad].op1, val);
	else if (colon_quad == 2)
		strcpy(quad[num_quad].op2, val);
	else if (colon_quad == 3)
		strcpy(quad[num_quad].res, val);
}
void afficher_qdr()
{
	printf("++++++++++++++Les Quadruplets++++++++++++\n");

	int i;

	for (i = 0; i < qc; i++)
	{

		printf("\n %d - ( %s  ,  %s  ,  %s  ,  %s )", i, quad[i].oper, quad[i].op1, quad[i].op2, quad[i].res);
		printf("\n-------------------------------------\n");
	}
}
int serach_temp(int l)
{
	int i = l;
	while (strcmp(quad[i].op1, "TEMP") == 0 || strcmp(quad[i].op2, "TEMP") == 0)
	{
		i--;
	}
	return i - 1;
}
void do_operation(char x[], char y[], char z[], char op[])
{
	b = 1;
	if (strcmp(x, "TEMP") == 0)
	{
		strcpy(x, tabt[l - 1].value);
		if (strcmp(y, "TEMP") == 0)
		{
			strcpy(x, tabt[serach_temp(l - 2)].value);
			strcpy(y, tabt[serach_temp(l - 1)].value);
		}
	}
	if (strcmp(y, "TEMP") == 0)
	{
		strcpy(y, tabt[l - 1].value);
	}
	char te1[25], te2[25];
	strcpy(te1, x);
	strcpy(te2, y);
	if (findIndex(x) != -1)
	{
		GetValue(x, x);
	}
	if (findIndex(y) != -1)
	{
		GetValue(y, y);
	}
	if (strcmp(op, "+") == 0)
	{
		sprintf(tabt[l].value, "%f", atof(y) + atof(x));
	}
	if (strcmp(op, "-") == 0)
	{
		sprintf(tabt[l].value, "%f", atof(x) - atof(y));
	}
	if (strcmp(op, "*") == 0)
	{
		sprintf(tabt[l].value, "%f", atof(y) * atof(x));
	}
	if (strcmp(op, "/") == 0)
	{
		if (atof(y) == 0)
		{
			printf("error");
			return;
		}
		sprintf(tabt[l].value, "%f", atof(x) / atof(y));
	}
	strcpy(x, te1);
	strcpy(y, te2);
	l++;
}
void do_comparation(char x[], char y[], char z[], char op[])
{
	b = 1;
	if (strcmp(x, "TEMP") == 0 || strcmp(x, "TEMP!") == 0 || strcmp(x, "TEMP2") == 0)
	{
		strcpy(x, tabt[l - 1].value);
	}
	if (strcmp(y, "TEMP") == 0 || strcmp(y, "TEMP!") == 0 || strcmp(y, "TEMP2") == 0)
	{
		strcpy(y, tabt[l - 1].value);
	}
	char te1[25], te2[25];
	strcpy(te1, x);
	strcpy(te2, y);
	if (findIndex(x) != -1)
	{
		GetValue(x, x);
	}
	if (findIndex(y) != -1)
	{
		GetValue(y, y);
	}
	if (strcmp(op, ">") == 0)
	{
		if (atof(x) - atof(y) > 0)
		{
			sprintf(tabt[l].value, "%f", 1.0);
		}
		else
		{
			sprintf(tabt[l].value, "%f", 0.0);
		}
	}
	if (strcmp(op, ">=") == 0)
	{
		if (atof(x) - atof(y) >= 0)
		{
			sprintf(tabt[l].value, "%f", 1.0);
		}
		else
		{
			sprintf(tabt[l].value, "%f", 0.0);
		}
	}
	if (strcmp(op, "<") == 0)
	{
		if (atof(x) - atof(y) < 0)
		{
			sprintf(tabt[l].value, "%f", 1.0);
		}
		else
		{
			sprintf(tabt[l].value, "%f", 0.0);
		}
	}
	if (strcmp(op, "<=") == 0)
	{
		if (atof(x) - atof(y) <= 0)
		{
			sprintf(tabt[l].value, "%f", 1.0);
		}
		else
		{
			sprintf(tabt[l].value, "%f", 0.0);
		}
	}
	if (strcmp(op, "==") == 0)
	{
		if (atof(x) - atof(y) == 0)
		{
			sprintf(tabt[l].value, "%f", 1.0);
		}
		else
		{
			sprintf(tabt[l].value, "%f", 0.0);
		}
	}
	if (strcmp(op, "!=") == 0)
	{
		if (atof(x) - atof(y) != 0)
		{
			sprintf(tabt[l].value, "%f", 1.0);
		}
		else
		{
			sprintf(tabt[l].value, "%f", 0.0);
		}
	}
	strcpy(x, te1);
	strcpy(y, te2);
	l++;
}


void lancer()
{
	printf("+++++++++++++++++++++ quadruplets +++++++++++++++++++++\n");
	int i = 0;
	int v = 0;
	char A[25];
	int anda = 0, ora = 0;
	while (i < 1000)
	{
		printf(" -> %d", i);
		if (strcmp(quad[i].oper, "=") == 0)
		{  
			if (strcmp(quad[i].op1, "TEMP") != 0)
			{
				GetValue(quad[i].op1, A);
				if (strcmp(quad[i].res, "TEMP") == 0)
				{

					strcpy(tabt[l].value, A);
					printf("%s", tabt[l].value);

					l++;
				}
				SaveValue(quad[i].res, quad[i].op1);
				
			}
			else
			{   
				SaveValue(quad[i].res, tabt[l - 1].value);
			}
			b = 0;
		}
		if (strcmp(quad[i].oper, "BZ") == 0)
		{
			if (strcmp(quad[i].op2, "TEMP") != 0)
			{
				if (atof(quad[i].op2) == 0)
				{
					i = atoi(quad[i].op1);
					v = 1;
				}
			}
			else
			{
				if (atof(tabt[l - 1].value) == 0)
				{
					i = atoi(quad[i].op1);
					v = 1;
				}
			}
			if (b)
				b = 0;
			strcpy(TEMP, "");
		}
		if (strcmp(quad[i].oper, "BR") == 0)
		{
			i = atoi(quad[i].op1);
			v = 1;
		}
		if (strcmp(quad[i].oper, "BNZ") == 0)
		{
			if (!b)
			{
				if (atof(quad[i].op2) == 1)
				{
					i = atoi(quad[i].op1);
					v = 1;
				}
			}
			else
			{
				if (atof(tabt[l - 1].value) == 1)
				{
					i = atoi(quad[i].op1);
					v = 1;
				}
			}
			b = 0;
			strcpy(TEMP, "");
			ora = 1;
		}
		if (strcmp(quad[i].oper, "==") == 0)
		{
			do_comparation(quad[i].op1, quad[i].op2, quad[i].res, "==");
		}
		if (strcmp(quad[i].oper, ">") == 0)
		{
			do_comparation(quad[i].op1, quad[i].op2, quad[i].res, ">");
		}
		if (strcmp(quad[i].oper, ">=") == 0)
		{
			do_comparation(quad[i].op1, quad[i].op2, quad[i].res, ">=");
		}
		if (strcmp(quad[i].oper, "<") == 0)
		{
			do_comparation(quad[i].op1, quad[i].op2, quad[i].res, "<");
		}
		if (strcmp(quad[i].oper, "<=") == 0)
		{
			do_comparation(quad[i].op1, quad[i].op2, quad[i].res, "<=");
		}
		if (strcmp(quad[i].oper, "!=") == 0)
		{
			do_comparation(quad[i].op1, quad[i].op2, quad[i].res, "!=");
		}
		if (strcmp(quad[i].oper, "+") == 0)
		{
			do_operation(quad[i].op1, quad[i].op2, quad[i].res, "+");
		}
		if (strcmp(quad[i].oper, "-") == 0)
		{
			do_operation(quad[i].op1, quad[i].op2, quad[i].res, "-");
		}
		if (strcmp(quad[i].oper, "*") == 0)
		{
			do_operation(quad[i].op1, quad[i].op2, quad[i].res, "*");
		}
		if (strcmp(quad[i].oper, "/") == 0)
		{
			do_operation(quad[i].op1, quad[i].op2, quad[i].res, "/");
		}
		if (strcmp(quad[i].oper, "") == 0)
		{
			return;
		}
		if (v)
		{
			v = 0;
		}
		else
		{
			i++;
		}
	}
}
