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
%type <lexeme> speechpart
%type <lexeme> declaration
%type <lexeme> sentence
%type <lexeme> subor
%type <lexeme> princ
%type <lexeme> categ
%type <lexeme> SN
%type <lexeme> SV
%type <lexeme> SP
%token <lexeme> BE
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
		| categ speechpart ';'	{printf("Word \"%s\" already defined\n", $2);}
		;

categ		: categ WORD ','	{add_word($1,$2);}
		| AUX {$$="aux";}| INTRANS {$$="intrans";}| TRANS {$$="trans";}| NOUN {$$="noun";}| DET {$$="det";}| PREP {$$="prep";}| ADJ {$$="adj";}| ADV{$$="adv";}| CONJ{$$="conj";}
		| categ speechpart ','	{printf("Word \"%s\" already defined\n", $2);}
		;

speechpart	: verbs | noun | adj | adv | prep | conj | aux | det | BE;

subor	: subor punc conj princ		{char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+strlen($4)+3));
					 strcpy(s,$1); strcat(s,$2); strcat(s," "); strcat(s,$3); strcat(s," "); strcat(s,$4);
					 $$=s;if(strlen($1)==0||strlen($4)==0){$$="";}else{printf("subor: %s %s\n", $3, $4);}}
	| subor conj princ		{char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+3));
					 strcpy(s,$1); strcat(s," "); strcat(s,$2); strcat(s," "); strcat(s,$3);
					 $$=s;if(strlen($1)==0||strlen($3)==0){$$="";}else{printf("subor: %s %s\n", $2, $3);}}
	| conj princ			{char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+2));
					 strcpy(s,$1); strcat(s," "); strcat(s,$2);
					 $$=s;if(strlen($2)==0){$$="";}else{printf("subor: %s %s\n", $1, $2);}}
	| punc conj princ		{char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+3));
					 strcpy(s,$1); strcat(s," "); strcat(s,$2); strcat(s," "); strcat(s,$3);
					 $$=s;if(strlen($3)==0){$$="";}else{printf("subor: %s %s\n", $2, $3);}}
	;

sentence: princ PUNC			{char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
					 strcpy(s,$1); strcat(s,$2);
					 $$=s;}
	| princ subor PUNC		{char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+1));
					 strcpy(s,$1); strcat(s,$2); strcat(s,$3);
					 $$=s;}
	| error PUNC			{printf("Wrong syntax. \n");$$="";}
	;

princ	: SN SV				{char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+2));
					 strcpy(s,$1); strcat(s," "); strcat(s,$2);
					 $$=s;if(strlen($1)==0||strlen($2)==0){$$="";}else{printf("SN SV: %s %s\n", $1, $2);}}
	| SN error			{printf("No verb for subject: \"%s\"\n", $1);$$="";}
	;

SN	: det adj noun			{char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+3));
					 strcpy(s,$1); strcat(s," "); strcat(s,$2); strcat(s," "); strcat(s,$3); 
					 $$=s;if(strlen($1)==0||strlen($2)==0){$$="";}else{printf("det adj noun: %s %s %s\n", $1, $2, $3);}}
	| SN SP				{char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+2));
					 strcpy(s,$1); strcat(s," "); strcat(s,$2);
					 $$=s;if(strlen($1)==0||strlen($2)==0){$$="";}}
	| noun				{printf("noun: %s\n", $1);$$ = $1;}
	| det noun			{printf("det noun: %s %s\n", $1, $2);char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+2));
					 strcpy(s,$1); strcat(s," "); strcat(s,$2); 
					 $$=s;}
	| det error			{printf("no noun for determiner: \"%s\"\n", $1);$$="";}
	| det adj error			{printf("no noun for determiner: \"%s\"\n", $1);$$="";}
	;

SV	: aux verbs			{char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+2));
					 strcpy(s,$1); strcat(s," "); strcat(s,$2); 
					 $$=s;printf("verb: %s %s\n",$1, $2);}
	| verbs				{printf("verb: %s\n",$1);$$ = $1;}
	| adv verbs			{char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+2));
					 strcpy(s,$1); strcat(s," "); strcat(s,$2); 
					 $$=s;printf("adv + verb: %s %s\n",$1, $2);}
	| trans SN			{char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+2));
					 strcpy(s,$1); strcat(s," "); strcat(s,$2); 
					 $$=s;if(strlen($2)==0){$$="";}else{printf("SV O: %s %s\n", $1, $2);}}
	| aux trans SN			{char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+3));
					 strcpy(s,$1); strcat(s," "); strcat(s,$2); strcat(s," "); strcat(s,$3); 
					 $$=s;if(strlen($3)==0){$$="";}else{printf("SV O: %s %s %s\n", $1, $2, $3);}}
	| SV SP				{char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+2));
					 strcpy(s,$1); strcat(s," "); strcat(s,$2); 
					 $$=s;if(strlen($1)==0||strlen($2)==0){$$="";}}
	| SV adv			{char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+2));
					 strcpy(s,$1); strcat(s," "); strcat(s,$2); 
					 $$=s;if(strlen($1)==0){$$="";}else{printf("SV adv: %s %s\n", $1, $2);}}
	| BE adj			{char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+2));
					 strcpy(s,$1); strcat(s," "); strcat(s,$2); 
					 $$=s;printf("be + adj: %s %s\n", $1, $2);}
	| BE SN				{char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+2));
					 strcpy(s,$1); strcat(s," "); strcat(s,$2); 
					 $$=s;if(strlen($2)==0){$$="";}else{printf("be + noun: %s %s\n", $1, $2);}}
	| SV error			{printf("Wrong word after verb: \"%s\"\n", $1);$$="";}
	| aux error			{printf("Missing verb after auxiliary verb: \"%s\"\n", $1);$$="";}
	| BE error			{printf("Wrong word after verb: \"%s\"\n", $1);$$="";}
	;

verbs	: trans | intrans;

SP	: prep SN			{char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+2));
					 strcpy(s,$1); strcat(s," "); strcat(s,$2); 
					 $$=s;if(strlen($2)==0){$$="";}else{printf("SP: %s %s\n", $1, $2);}}
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
	
	wp = (struct word *) malloc(sizeof(struct word));
	
	wp->next = word_list;
	
	wp->word_name = (char *) malloc(strlen(word)+1);
	strcpy(wp->word_name, word);
	wp->word_type = (char *) malloc(strlen(type)+1);
	strcpy(wp->word_type, type);
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

