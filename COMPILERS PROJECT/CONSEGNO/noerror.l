%option noyywrap
%{
#include <stdlib.h>
#include <string.h>

int state =0;

void add_word(char *type, char *word);
char *lookup_word(char *word);

%}	
%%



NOUN	{state = 1; return NOUN;}
ADJ	{state = 1; return ADJ;}
ADV	{state = 1; return ADV;}
DET	{state = 1; return DET;}
PREP	{state = 1; return PREP;}
CONJ	{state = 1; return CONJ;}
TRANS	{state = 1; return TRANS;}
INTRANS	{state = 1; return INTRANS;}
AUX	{state = 1; return AUX;}

am		{yylval.lexeme = strdup(yytext);
		return BE;}
are		{yylval.lexeme = strdup(yytext);
		return BE;}
is		{yylval.lexeme = strdup(yytext);
		return BE;}
was		{yylval.lexeme = strdup(yytext);
		return BE;}
were		{yylval.lexeme = strdup(yytext);
		return BE;}






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
	if(strcmp(input,"noun")==0)
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
	else if(strcmp(input,"trans")==0)
	{
		return 607;
	}
	else if(strcmp(input,"intrans")==0)
	{
		return 608;
	}
	else if(strcmp(input,"aux")==0)
	{
		return 609;
	}
	return 500;
}
