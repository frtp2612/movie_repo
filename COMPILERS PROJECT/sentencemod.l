%option noyywrap
%{
#include <stdlib.h>
#include <string.h>

int state =0;

void add_word(char *type, char *word);
char *lookup_word(char *word);

%}

%%

VERB	{state = 1; return VERB;}
NOUN	{state = 1; return NOUN;}
ADJ	{state = 1; return ADJ;}
ADV	{state = 1; return ADV;}
DET	{state = 1; return DET;}
PREP	{state = 1; return PREP;}
CONJ	{state = 1; return CONJ;}


[a-zA-Z]+ 	{yylval.lexeme = strdup(yytext);
		char *s = lookup_word(yytext);
		return numOfTok(s);
		}

;		{if(state == 1){state = 0;return ';';}else{yylval.lexeme = strdup(yytext); return PUNC;}}
,		{if(state == 1){return ',';}else{yylval.lexeme = strdup(yytext); return punc;}}
[\.:!\?]	{if(state == 1){;}else{yylval.lexeme = strdup(yytext); return PUNC;}}
.		{;}
%%

int numOfTok(char *input)
{
	if(strcmp(input,"verb")==0)
	{
		return 600;
	}
	else if(strcmp(input,"noun")==0)
	{
		return 601;
	}
	else if(strcmp(input,"adj")==0)
	{
		return 602;
	}
	else if(strcmp(input,"adv")==0)
	{
		return 603;
	}
	else if(strcmp(input,"prep")==0)
	{
		return 604;
	}
	else if(strcmp(input,"det")==0)
	{
		return 605;
	}
	else if(strcmp(input,"conj")==0)
	{
		return 606;
	}
	return 500;
}

