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
%token VERB
%token DET
%token ADJ
%token ADV
%token PREP
%token CONJ
%type <lexeme> notSN
%type <lexeme> right
%type <lexeme> true2
%type <lexeme> declaration
%type <lexeme> sentence
%type <lexeme> princ
%type <lexeme> categ
%type <lexeme> SN
%type <lexeme> SA
%type <lexeme> SV
%type <lexeme> SP
%token <lexeme> verb 600
%token <lexeme> noun 601
%token <lexeme> adj  602
%token <lexeme> adv  603
%token <lexeme> prep 604
%token <lexeme> det  605
%token <lexeme> conj 606
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
		| VERB {$$="verb";}| NOUN {$$="noun";}| DET {$$="det";}| PREP {$$="prep";}| ADJ {$$="adj";}| ADV{$$="adv";}| CONJ{$$="conj";}
		;

punct	: PUNC | punc subor;

subor	: conj princ;

sentence: princ 			{$$=$1;}
	| PUNC				{$$="";}
	;

right	: true2 right
	| PUNC
	;

true2:	det | noun | adv | adj | verb | conj | prep | punc | WORD {printf("unknown string: %s\n",$1);};

princ	: SN SV	punct			{char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)));
					 strcpy(s,$1); strcat(s," "); strcat(s,$2);
					 $$=s;if(strlen($1)==0){$$="";}else{printf("SN SV: %s %s\n", $1, $2);}}
	| notSN right			{$$="";}
	| SN notSV right		{printf("missing verb for subject: \"%s\"\n", $1);$$="";}
	| SN punct			{printf("missing verb for subject: \"%s\"\n", $1);$$="";}
	| det SA punct			{printf("missing noun and verb for determiner: \"%s\"\n", $1);$$="";}
	| det punct			{printf("missing noun and verb for determiner: \"%s\"\n", $1);$$="";}
	;

SN	: det SA noun			{printf("det SA noun: %s %s %s\n", $1, $2, $3);
					 char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+2));
					 strcpy(s,$1); strcat(s," "); strcat(s,$2); strcat(s," "); strcat(s,$3); 
					 $$=s;}
	| SN SP				{printf("SN SP: %s %s\n", $1, $2);char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
					 strcpy(s,$1); strcat(s," "); strcat(s,$2);
					 $$=s;}
	| noun				{printf("noun: %s\n", $1);$$ = $1;}
	| det noun			{printf("det noun: %s %s\n", $1, $2);char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
					 strcpy(s,$1); strcat(s," "); strcat(s,$2); 
					 $$=s;}
	| det SA notnoun right		{printf("missing noun for determiner: \"%s\"\n", $1);$$="";}
	| det notSAnoun right		{printf("missing noun for determiner: \"%s\"\n", $1);$$="";}
	;

notnoun	: conj | verb | adj | adv | prep | det | WORD;

notSAnoun	: conj | det | verb | prep | WORD;

notSN	: conj | adj | adv | verb | prep | WORD;

SA	: adj				{printf("SA: %s\n", $1);$$ = $1;}
	| adv adj			{printf("SA: %s %s\n", $1, $2);char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
					 strcpy(s,$1); strcat(s," "); strcat(s,$2); 
					 $$=s;}
	| adv punct			{printf("missing adjective for \"%s\"\n", $1);$$="";}
	;

SV	: verb				{printf("verb: %s\n",$1);$$ = $1;}
	| verb SN				{char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
					 strcpy(s,$1); strcat(s," "); strcat(s,$2); 
					 $$=s;if(strlen($2)==0){$$="";}else{printf("SV O: %s %s\n", $1, $2);}}
	| SV SP				{printf("SV SP: %s %s\n", $1, $2);char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
					 strcpy(s,$1); strcat(s," "); strcat(s,$2); 
					 $$=s;}
	| SV SA				{printf("SV SA: %s %s\n", $1, $2);char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
					 strcpy(s,$1); strcat(s," "); strcat(s,$2); 
					 $$=s;}
	| SV notSPSA right		{printf("wrong word after SV: \"%s\"\n", $1);$$="";}
	;

notSPSA	: conj | verb | det | noun | WORD;

notSV	: conj | det | noun | adj | adv | WORD;

SP	: prep SN			{printf("SP: %s %s\n", $1, $2);char* s=malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
					 strcpy(s,$1); strcat(s," "); strcat(s,$2); 
					 $$=s;}
	| prep notSN right		{printf("\n");$$="";}
	| prep PUNC			{printf("\n");$$="";}
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

