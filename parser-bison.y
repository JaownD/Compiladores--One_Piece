%{
#include <stdio.h>

typedef struct Nodo{
	struct Nodo numeros[10], letras_maiusculas[26], letras_minusculas[26], underline[1];
	int endereco, fim;
}nodo;

typedef struct Trie{
	nodo *raiz;
	int num_simbolos, num_endereco;
}trie;


nodo *cria_nodo(){
	nodo *aux_nodo = (nodo*)malloc(sizeof(nodo));
	int i;

	aux_nodo->underline[0] = NULL;

	for(i = 0; i < 10; i++)
		aux_nodo->numero[i] = NULL;
	
	for(i = 0; i < 26; i++){
		aux_nodo->letras_maiusculas[i] = NULL;
		aux_nodo->letras_minusculas[i] = NULL;
	}	

	aux_nodo->endereco = aux_nodo->fim = 0;

	return aux_nodo;
}

trie *cria_arvore(){
	trie *aux_trie = (trie*)malloc(sizeof(trie));
	aux_trie->raiz = cria_nodo();
	aux_trie->num_simbolos = aux_trie->num_endereco = 0;

	return aux_trie;
}


//trie *arvore = cria_trie();

int verifica_caracter(char caracter){
	if(caracter == '_') return 3;

	if((id[i] - 'a') < 0){				//Caso nao seja uma letra minuscula
		if((id[i] - 'A') < 0) return 0;		//Caso seja um numero
		else return 1;				//Caso seja uma letra maiuscula
	}
	else return 2;					//Caso seja uma letra minuscula
}

void insere_na_trie(trie *arvore, char *id, int tamanho){
	int i = 0, caracter_analisado = 0;
	nodo *backup_raiz = NULL;
	nodo *aux_raiz = arvore->raiz;

//Loop enquanto ja existe o caminho necessario na trie
	while(aux_raiz != NULL && i < strlen(id)){
		caracter_analisado = verifica_caracter(id[i]);
		
		backup_raiz = aux_raiz;
		switch(caracter_analisado){
			case 0:
				aux_raiz = aux_raiz->numeros[id[i] - '0'];
				break;
			case 1:
				aux_raiz = aux_raiz->letras_maiusculas[id[i] - 'A'];
				break;
			case 2:
				aux_raiz = aux_raiz->letras_minusculas[id[i] - 'a'];
				break;
			case 3:
				aux_raiz = aux_raiz->underline[0];
				break;
		}
		i++;
	}

	if(aux_raiz == NULL)
		aux_raiz = backup_raiz;
	
	while(i < strlen(id)){
		caracter_analisado = verifica_caracter(id[i]);
		backup_raiz = aux_raiz;
	
		switch(caracter_analisado){
			case 0:
				aux_raiz->numeros[id[i] - '0'] = cria_nodo();
				aux_raiz = aux_raiz->numeros[id[i] - '0'];
				break;
			case 1:
				aux_raiz->letras_maiusculas[id[i] - 'A'] = cria_nodo();
				aux_raiz = aux_raiz->letras_maiusculas[id[i] - 'A'];
				break;
			case 2:
				aux_raiz->letras_minusculas[id[i] - 'a'] = cria_nodo();
				aux_raiz = aux_raiz->letras_minusculas[id[i] - 'a'];
				break;
			case 3:
				aux_raiz->underline[0] = cria_nodo();
				aux_raiz = aux_raiz->underline[0];
				break;
		}	
		i++;
	}
	
	if(aux_raiz == NULL)			//Voltar ao nodo que coincide com o final de id (stlen(id) - 1)
		aux_raiz = backup_raiz;
	
	if(aux_raiz->fim == 1){
		printf("ERRO: erro semantico.\n");
		exit(1);
	}
	
	aux_nodo->fim = 1;
	aux_nodo->endereco = arvore->num_endereco;

	arvore->num_endereco += tamanho;
	arvore->num_simbolos++;
}

int busca_id(trie *arvore, char *id){
	int i = 0, caracter_analisado = 0;
	nodo *aux_raiz = arvore->raiz;
	
	while(aux_raiz != NULL && i < strlen(id)){
		caracter_analisado = verifica_caracter(id[i]);
		switch(caracter_analisado){
			case 0:
				aux_raiz = aux_raiz->numeros[id[i] - '0'];
				break;
			case 1:
				aux_raiz = aux_raiz->letras_maiusculas[id[i] - 'A'];
				break;
			case 2:
				aux_raiz = aux_raiz->letras_minusculas[id[i] - 'a'];
				break;
			case 3:
				aux_raiz = aux_raiz->underline[0];
				break;
		}
		i++;
	}

	if(aux_raiz == NULL){
		printf("ERRO: erro semantico.\n");
		exit(1);
	}
	else if(i == strlen(id) && aux_raiz->fim == 0){
		printf("ERRO: erro semantico.\n");
		exit(1);
	}
	else return aux_raiz->endereco;
}

void libera_trie(trie *arvore){
	nodo *aux_raiz, *backup_raiz = NULL;
	int posicao_numero, posicao_letra_maiscula, posicao_letra_minuscula;
	int i;

	while(1){
		aux_raiz = arvore->raiz;
		
		while(1){
			backup_raiz = aux_raiz;


			if(aux_raiz->under_line[0] != NULL){
				aux_raiz = aux_raiz->under_line[0];
				continue;
			}	
		
			for(i = 0; i < 10; i++){
				if(aux_raiz->numeros[i] != NULL){
					aux_raiz = aux_raiz->numeros[i];
					posicao_numero = i;
					posicao_letra_maiuscula = posicao_letra_minuscula = -1;
					break;
				}		
			}
			
			if(i < 10) continue;

			for(i = 0; i < 26; i++){
				if(aux_raiz->letras_maisculas[i] != NULL){
					aux_raiz = aux_raiz->letras_maiusculas[i];
					posicao_letra_maiuscula = i;
					posicao_numero = posicao_letra_minuscula = -1;
					break;
				}
				else if(aux_raiz->letras_minusculas[i] != NULL){
					aux_raiz = aux_raiz->letras_minusculas[i];
					posicao_letra_minuscula = i;
					posicao_numero = posicao_letra_maiuscula = -1;
					break;
				}
			}
			
			if(aux_raiz == arvore->raiz) break;

			if(i == 26){
				free(aux_raiz);
		
				if(posicao_numero != -1)
					backup->numeros[posicao_numero] = NULL;
				else if(posicao_letra_maiuscula != -1)
					backup->letras_maiusculas[posicao_letra_maiuscula] = NULL;
				else
					backup->letras_minusculas[posicao_letra_minuscula] = NULL;
				break;
			}
		}

		if(aux_raiz == arvore->raiz) break;
	}
	

	free(aux_raiz);
	free(arvore);
}



%}

%token  MUGIWARA GOING_MERRY KARA MUKAU MADE LOGPOSE NI_TODOMARU KAIZOKU MATAWA_NEIBI PUROKO TANISHI SHINU ATRIB PEV IMPRIMA RECEBA SOMA SUBTR MULT DIV REST MENOR MAIOR MEN_IGUAL MAI_IGUAL IGUAL DIFER NEGACAO E OU E_PARENTES D_PARENTES E_COLCHETE D_COLCHETE E_CHAVES D_CHAVES INICIO RETURN TEXTO NUM ID

%define parse.error verbose

%%

comeco : INICIO code RETURN;
code : for code | while code | if code | declaracao code | atribuicao code | print code | scan code | SHINU PEV | ;	// shinu finaliza a operacao da execucao (similar ao "exit" em C++)

alem : logica condicional | ;								// pode aumentar a quantidade de condicionais no going_merry (for), logpose (while), kaizoku (if) e matawa_neibi (else) 
atribuicao : identificador ATRIB expressao PEV ;                                        // uma expressao eh atribuida a uma variavel 
comparacao : MENOR | MAIOR | MEN_IGUAL | MAI_IGUAL | IGUAL | DIFER ;
condicional : NEGACAO E_PARENTES condicional D_PARENTES | expressao comparacao expressao alem ;				// analisa se eh uma negacao ou uma comparacao entre duas expressoes 
conteudo : TEXTO | expressao ;								// restringe que, no puroko (print), apenas exista ou um texto ou um identificador
declaracao : MUGIWARA identificador {}  iniciacao PEV ;                                    // declara variaveis com valor inicial e sem valor inicial
else : MATAWA_NEIBI E_CHAVES code D_CHAVES else | ;					// matawa neibi ( ___ ) { ...  }
equivalente : identificador ATRIB expressao ;						// atribuicao sem a existencia do PEV (';'), sendo utilizado no going_merry (for)
expressao : expressao SOMA termo | expressao SUBTR termo | termo ;			// analisa se uma expressao dada esta na forma infexa em relacao a soma e subtracao de termos
fator : identificador | NUM ;
for : GOING_MERRY E_PARENTES KARA equivalente MUKAU condicional MADE expressao D_PARENTES E_CHAVES code D_CHAVES ;	// goind_merry ( kara ___ mukau ___ made ___ ) { ...  }  
identificador : ID {} | ID  E_COLCHETE expressao D_COLCHETE {} ;				// uma variavel pode ser apenas um ID ou uma posicao de um vetor (ID[n], sendo n a representacao de uma expressao)
if : KAIZOKU E_PARENTES condicional D_PARENTES E_CHAVES code D_CHAVES else ;            // kaizoku ( ___ ) { ...  }
iniciacao : ATRIB expressao | ;								// determina se uma variavel tem ou nao um valor incial durante sua declaracao
lista : IMPRIMA conteudo lista | ;                                                      // permite adicionar mais informacoes que serao impressas para o usuario, como "<< i" e "<< "texto"" (utilizado no puroko)
logica : E | OU ;
print : PUROKO IMPRIMA conteudo lista PEV ;                                             // "puroko << "    "" ou "puroko << variavel"
scan : TANISHI RECEBA identificador sequencia PEV ;                                     // tanishi >> variavel
sequencia : RECEBA identificador sequencia | ;						// permite aciononar mais identificadores para receberem informacoes disponibilizadas pelo usuario	
termo : termo DIV fator | termo MULT fator | termo REST fator | fator;
while : LOGPOSE E_PARENTES NI_TODOMARU condicional D_PARENTES E_CHAVES code D_CHAVES ;                          // logpose ( ni todomaru  ___ ) { ...  }

 
%%

// extern FILE *yyin;

int main(int argc, char *argv[]) {

//    yyin = fopen(argv[1], "r");

    yyparse();

//    fclose(yyin);

    return 0;
}

void yyerror(char *s) { fprintf(stderr,"ERRO: %s \n\n", s); }
