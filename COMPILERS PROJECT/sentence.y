%{
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
void yyerror (char *s);
void add_word(char *type, char *word);
char *lookup_word(char *word);
int yydebug=0;
%}


%union {
       char* lexeme;			//identifier
       }
%start line
%left <lexeme> WORD 500
%token NOUN
%token AUX
%token TRANS
%token INTRANS
%token DET
%token ADJ
%token ADV
%token PREP
%token CONJ
%type <lexeme> declaration
%type <lexeme> sentence
%type <lexeme> subor
%type <lexeme> princ
%type <lexeme> categ
%type <lexeme> SN
%type <lexeme> SA
%type <lexeme> SV
%type <lexeme> SP
%type <lexeme> verbs
%token <lexeme> noun 601
%token <lexeme> adj  602
%token <lexeme> adv  603
%token <lexeme> prep 604
%token <lexeme> det  605
%token <lexeme> conj 606
%token <lexeme> trans 607
%token <lexeme> intrans 608
%token <lexeme> aux 609
%token <lexeme> PUNC
%token <lexeme> punc
%token ',' ';'
%%

line	: declaration
	| line declaration
	| sentence			{if(strcmp($1,"")!=0){printf("%s\n", $1);}}
	| line sentence			{if(strcmp($2,"")!=0){printf("%s\n", $2);}}
    	;

declaration	: categ WORD ';'	{add_word($1,$2);}
		;

categ		: categ WORD ','	{add_word($1,$2);}
		| AUX {$$="aux";}| INTRANS {$$="intrans";}| TRANS {$$="trans";}| NOUN {$$="noun";}| DET {$$="det";}| PREP {$$="prep";}| ADJ {$$="adj";}| ADV{$$="adv";}| CONJ{$$="conj";}
		;


subor	: subor punc conj princ		{char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+strlen($4)));
					 strcpy(s,$1); strcat(s,$2); strcat(s," "); strcat(s,$3); strcat(s," "); strcat(s,$4);
					 $$=s;}
	| subor conj princ		{char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)));
					 strcpy(s,$1); strcat(s," "); strcat(s,$2); strcat(s," "); strcat(s,$3);
					 $$=s;}
	| conj princ			{char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)));
					 strcpy(s,$1); strcat(s," "); strcat(s,$2);
					 $$=s;}
	| punc conj princ		{char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)));
					 strcpy(s,$1); strcat(s," "); strcat(s,$2); strcat(s," "); strcat(s,$3);
					 $$=s;}
	;

sentence: princ PUNC			{char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)));
					 strcpy(s,$1); strcat(s,$2);
					 $$=s;}
	| princ subor PUNC		{char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)));
					 strcpy(s,$1); strcat(s," "); strcat(s,$2); strcat(s,$3);
					 $$=s;}
	| error PUNC			{printf("Wrong syntax. \n");$$="";}
	;

princ	: SN SV				{char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)));
					 strcpy(s,$1); strcat(s," "); strcat(s,$2);
					 $$=s;if(strlen($1)==0){$$="";}else{printf("SN SV: %s %s\n", $1, $2);}}
	| SN error			{printf("No verb for subject: \"%s\"\n", $1);$$="";}
	;

SN	: det SA noun			{char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+2));
					 strcpy(s,$1); strcat(s," "); strcat(s,$2); strcat(s," "); strcat(s,$3); 
					 $$=s;if(strlen($2)==0){$$="";}else{printf("det SA noun: %s %s %s\n", $1, $2, $3);}}
	| SN SP				{char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
					 strcpy(s,$1); strcat(s," "); strcat(s,$2);
					 $$=s;if(strlen($2)==0){$$="";}else{printf("SN SP: %s %s\n", $1, $2);}}
	| noun				{printf("noun: %s\n", $1);$$ = $1;}
	| det noun			{printf("det noun: %s %s\n", $1, $2);char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
					 strcpy(s,$1); strcat(s," "); strcat(s,$2); 
					 $$=s;}
	| det error			{printf("no noun for determiner: \"%s\"\n", $1);$$="";}
	| det SA error			{printf("no noun for determiner: \"%s\"\n", $1);$$="";}
	;

SA	: adj				{printf("SA: %s\n", $1);$$ = $1;}
	| adv adj			{printf("SA: %s %s\n", $1, $2);char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
					 strcpy(s,$1); strcat(s," "); strcat(s,$2); 
					 $$=s;}
	| adv error			{printf("Missing adjective for: \"%s\"\n", $1);$$="";}
	;

SV	: aux verbs			{char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
					 strcpy(s,$1); strcat(s," "); strcat(s,$2); 
					 $$=s;printf("verb: %s %s\n",$1, $2);}
	| verbs				{printf("verb: %s\n",$1);$$ = $1;}
	| trans SN			{char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
					 strcpy(s,$1); strcat(s," "); strcat(s,$2); 
					 $$=s;if(strlen($2)==0){$$="";}else{printf("SV O: %s %s\n", $1, $2);}}
	| aux trans SN			{char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+2));
					 strcpy(s,$1); strcat(s," "); strcat(s,$2); strcat(s," "); strcat(s,$3); 
					 $$=s;if(strlen($3)==0){$$="";}else{printf("SV SP: %s %s %s\n", $1, $2, $3);}}
	| SV SP				{char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
					 strcpy(s,$1); strcat(s," "); strcat(s,$2); 
					 $$=s;if(strlen($2)==0){$$="";}else{printf("SV SP: %s %s\n", $1, $2);}}
	| intrans SA			{char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
					 strcpy(s,$1); strcat(s," "); strcat(s,$2); 
					 $$=s;if(strlen($2)==0){$$="";}else{printf("SV SA: %s %s\n", $1, $2);}}
	| SV error			{printf("Wrong word after verb: \"%s\"\n", $1);$$="";}
	| aux error			{printf("MIssing verb after auxiliary verb: \"%s\"\n", $1);$$="";}
	;

verbs	: trans | intrans;

SP	: prep SN			{printf("SP: %s %s\n", $1, $2);char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
					 strcpy(s,$1); strcat(s," "); strcat(s,$2); 
					 $$=s;}
	| prep error			{printf("Missing noun after preposition: \"%s\"\n", $1);$$="";}
	;


%%

#include "lex.yy.c"

struct word{
	char *word_name;
	char *word_type;
	struct word *next;
};

struct word *word_list;

extern void *malloc();

void add_word(char *type, char *word)
{
	struct word *wp;
	
	if(0 != strcmp(lookup_word(word), "")){
		printf("%s already defined \n", word);
		return;
	}
	
	wp = (struct word *) malloc(sizeof(struct word));
	
	wp->next = word_list;
	
	wp->word_name = (char *) malloc(strlen(word)+1);
	strcpy(wp->word_name, word);
	wp->word_type = type;
	word_list = wp;
}

char *lookup_word(char *word)
{
	struct word *wp = word_list;
	
	for(; wp; wp=wp->next){
	if(strcmp(wp->word_name, word) == 0 )
		{
			return wp->word_type;
		}
	}
	
	return "";
}

