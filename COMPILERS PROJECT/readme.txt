flex -l sentencemod.l				//crea file lex.yy.c
yacc -vd sentencemod.y --debug --verbose	//crea file y.tab.c e y.output
gcc -g y.tab.c -ly -ll				//crea c program
./a.out						//compila c code



