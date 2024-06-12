%{
#include <stdio.h>              
#include "parser-bison.tab.h"
int num_linha = 1;
%}

%option noyywrap

LETRA [a-zA-Z]
LETRA_COMPLEXA [çẃéŕýúíóṕáśǵj́ḱĺḉźćǘńḿẁèỳùìòàǜǹm̀ẽỹũĩõãṽñŵêŷûîôâŝĝĥĵẑĉÇẂÉŔÝÚÍÓṔÁŚǴJ́ḰĹḈŹĆǗŃḾẀÈỲÙÌÒÀǛǸM̀ẼỸŨĨÕÃṼÑŴÊŶÛÎÔÂŜĜĤĴẐĈ]
DIGITO [0-9]
SIMBOLO [!@#$%¨&*()_+-=/?°®ŧ←↓→øþ´ªºæßðđŋħˀĸł´~«»©“”nµ─·.;.,<>:]

%%
"the one piece is real"[ |"\n"]  { return INICIO;  }
"kaizoku-o ni ore wa naru"[ |"\n"] { return RETURN; }
"mugiwara" { return MUGIWARA; }			// tipo inteiro
"going merry"[ ] { return GOING_MERRY; }		// going_merru ( kara ___ mukau ___ made ___ ) -> for
[ ]"kara"[ ] { return KARA; }
[ ]"mukau"[ ]  { return MUKAU; }
[ ]"made"[ ]   { return MADE; }
"logpose" { return LOGPOSE; }			// logpose ( ni todomaru ___ ) -> while
[ ]"ni todomaru"[ ] { return NI_TODOMARU; }
"kaizoku" { return KAIZOKU; }			// kaizoku ( ___ ) -> if
"matawa neibi" { return MATAWA_NEIBI; }		// matawa neibi ( ___ ) -> else
"puroko" { return PUROKO; }
"tanishi" { return TANISHI; }
"shinu" { return SHINU;  }
"->" { return ATRIB; }
"|D" { return PEV; }
"=D".* { }
"<<" { return IMPRIMA; }
">>" { return RECEBA; }
"+" { return SOMA; }
"-" { return SUBTR; }
"*" { return MULT; }
"/" { return DIV; }
"%" { return REST; }
"<" { return MENOR; }
">" { return MAIOR; }
"<=" { return MEN_IGUAL; }
">=" { return MAI_IGUAL; }
"==" { return IGUAL; }
"!=" { return DIFER; }
"!" { return NEGACAO; }
"&&" { return E; }
"||" { return OU; }
"(" { return E_PARENTES; }
")" { return D_PARENTES; }
"[" { return E_COLCHETE; }
"]" { return D_COLCHETE; }
"{" { return E_CHAVES; }
"}" { return D_CHAVES; }
["].*["] { return TEXTO; }
[-+]?{DIGITO}+ { return NUM; }			
[ ]{LETRA}({LETRA}|{DIGITO}|_)*[ ] { return ID; }
"\n" { num_linha++; }
" " { }
({LETRA}|{LETRA_COMPLEXA}|{DIGITO}|{SIMBOLO})+  { printf("\nERRO: erro lexico, \"%s\" (linha %d) nao reconhecido.\n", yytext, num_linha); yy_fatal_error("");  }

%%

