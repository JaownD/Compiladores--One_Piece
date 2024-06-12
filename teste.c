#include "stdio.h"
#include "string.h"
#include "stdlib.h"

typedef struct Nodo{
	struct Nodo *numeros[10], *letras_maiusculas[26], *letras_minusculas[26], *underline[1];
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
		aux_nodo->numeros[i] = NULL;
	
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
//	if(caracter == '\0') return 4;
	if(caracter == '_') return 3;

	if((caracter - 'a') < 0){				//Caso nao seja uma letra minuscula
		if((caracter - 'A') < 0) return 0;		//Caso seja um numero
		else return 1;				//Caso seja uma letra maiuscula
	}
	else return 2;					//Caso seja uma letra minuscula
}

void insere_na_trie(trie *aux_trie, char *id, int tamanho){
	int i = 0, caracter_analisado = 0, aux_caracter_analisado = 0;
	nodo *backup_raiz = NULL;
	nodo *aux_raiz = aux_trie->raiz;
printf("Info: [%s,%d] [%d]\n", id, tamanho, strlen(id));
//Loop enquanto ja existe o caminho necessario na trie

	
printf("Existentes na arvore: ");
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

		if(aux_raiz != NULL)
			printf("[%c,%d] ", id[i], caracter_analisado);
		i++;
	}

	if(aux_raiz == NULL){
		printf("\n\nCriando novos: ");
		aux_raiz = backup_raiz;
		i--;
	}

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
		printf("[%c;%d] ", id[i], caracter_analisado);
		i++;
	}

	if(aux_raiz == NULL)
		aux_raiz = backup_raiz;

	if(aux_raiz->fim == 1){
		printf("ERRO: erro semantico.");
		exit(1);
	}

	aux_raiz->fim = 1;
	aux_raiz->endereco = aux_trie->num_endereco;

	aux_trie->num_endereco += tamanho;
	aux_trie->num_simbolos++;


printf("\nInserido!\n\n");
}

/*
int busca_id(trie *arvore, char *id){
	int i = 0, caracter_analisado = 0;
	nodo *aux_raiz = arvore->raiz;

printf("Percurso: ");
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
				aux_raiz = aux_raiz->under_line[0];
				break;
		}
		printf("[%c,%d] ", id[i], caracter_analisado);
		i++;
	}

	if(aux_raiz == NULL){
		printf("ERRO: erro semantico.\n");
		exit(1);
	}
	else if(i == strlen(id) && aux_raiz->fim == 1) return aux_raiz->endereco;
}
*/

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

nodo *encontra_folha(trie *arvore, nodo *anterior, int *informcoes){
	nodo *aux_raiz = arvore->raiz;
	int i;

	while(1){
		printf("[%c,%c,%c]", posicao_numero + '0', posicao_letra_maiuscula + 'A', posicao_letra_minuscula + 'a');
                anterior = aux_raiz;

                if(aux_raiz->underline[0] != NULL){
 	        	aux_raiz = aux_raiz->underline[0];
//			posicao_underline = 0;
//			posicao_numero = posicao_letra_maiuscula = posicao_letra_minuscula = -1;
                        continue;
              	}

                for(i = 0; i < 10; i++){
                	if(aux_raiz->numeros[i] != NULL){
                        	aux_raiz = aux_raiz->numeros[i];
//                                posicao_numero = i;
//                                posicao_letra_maiuscula = posicao_letra_minuscula = posicao_underline = -1;
                                break;
                        }
               	}

                if(i < 10) continue;

                for(i = 0; i < 26; i++){
                	if(aux_raiz->letras_maiusculas[i] != NULL){
                        	aux_raiz = aux_raiz->letras_maiusculas[i];
//                              posicao_letra_maiuscula = i;
//                                posicao_numero = posicao_letra_minuscula = posicao_underline = -1;
                                break;
                       	}
                        else if(aux_raiz->letras_minusculas[i] != NULL){
                        	aux_raiz = aux_raiz->letras_minusculas[i];
//                                posicao_letra_minuscula = i;
//                                posicao_numero = posicao_letra_maiuscula = posicao_underline = -1;
                                break;
                        }
              	}

                if(aux_raiz == arvore->raiz) break;

	}
}



void libera_trie(trie *arvore){
        nodo *aux_raiz = arvore->raiz, *backup_raiz = NULL;
        int posicao_numero = -1, posicao_letra_maiuscula = -1, posicao_letra_minuscula = -1, posicao_underline = -1;
        int i;

      while(1){
// for(int j = 0; j < 6; j++){
		aux_raiz = arvore->raiz;
		posicao_numero = posicao_letra_maiuscula = posicao_letra_minuscula = posicao_underline = -1;
                while(1){
			printf("[%c,%c,%c]", posicao_numero + '0', posicao_letra_maiuscula + 'A', posicao_letra_minuscula + 'a');
                        backup_raiz = aux_raiz;


                        if(aux_raiz->underline[0] != NULL){
                                aux_raiz = aux_raiz->underline[0];
				posicao_underline = 0;
				posicao_numero = posicao_letra_maiuscula = posicao_letra_minuscula = -1;
                                continue;
                        }

                        for(i = 0; i < 10; i++){
                                if(aux_raiz->numeros[i] != NULL){
                                        aux_raiz = aux_raiz->numeros[i];
                                        posicao_numero = i;
                                        posicao_letra_maiuscula = posicao_letra_minuscula = posicao_underline = -1;
                                        break;
                                }
                        }

                        if(i < 10) continue;

                        for(i = 0; i < 26; i++){
                                if(aux_raiz->letras_maiusculas[i] != NULL){
                                        aux_raiz = aux_raiz->letras_maiusculas[i];
                                        posicao_letra_maiuscula = i;
                                        posicao_numero = posicao_letra_minuscula = posicao_underline = -1;
                                        break;
                                }
                                else if(aux_raiz->letras_minusculas[i] != NULL){
                                        aux_raiz = aux_raiz->letras_minusculas[i];
                                        posicao_letra_minuscula = i;
                                        posicao_numero = posicao_letra_maiuscula = posicao_underline = -1;
                                        break;
                                }
                        }

                       if(aux_raiz == arvore->raiz) break;

                        if(i == 26){
                                free(aux_raiz);
				aux_raiz = NULL;
printf("\nliberou\n");
                                if(posicao_numero != -1)
                                        backup_raiz->numeros[posicao_numero] = NULL;
                                else if(posicao_letra_maiuscula != -1)
                                        backup_raiz->letras_maiusculas[posicao_letra_maiuscula] = NULL;
                                else if(posicao_letra_minuscula != -1)
                                        backup_raiz->letras_minusculas[posicao_letra_minuscula] = NULL;
				else
					backup_raiz->underline[0] = NULL;
                                break;
                        }
//	}
                }

                //if(aux_raiz == arvore->raiz) break;
        }


//        free(aux_raiz);
        free(arvore);
}


int main(){
	char variavel[1000];
	int endereco, busca;

	trie *arvore_trie = cria_arvore();

	printf("Inciando insercao:\n");
	while(1){
		scanf("%s %d", variavel, &endereco);
		if(endereco == -1)
			break;
		insere_na_trie(arvore_trie, variavel, endereco);
	}
	printf("\nInsercao encerada\n\nIniciando busca:\n");
	
	while(1){
		scanf("%s", variavel);
		if(strcmp(variavel, "parar") == 0) break;

		busca = busca_id(arvore_trie, variavel);
		printf("\n[%s,%d]\n", variavel, busca);
	}

	printf("Programa encerrado\n");

	libera_trie(arvore_trie);
	return 0;
}

