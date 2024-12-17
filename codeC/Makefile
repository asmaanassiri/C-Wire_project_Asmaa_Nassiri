# Définition du compilateur à utiliser (ici, GCC)
CC = gcc

# Options de compilation :
# -Wall : Active tous les avertissements courants.
# -Wextra : Active des avertissements supplémentaires.
# -pedantic : Force la conformité stricte avec les normes C.
# -g : Génère des informations de débogage.
CFLAGS = -Wall -Wextra -pedantic -g

# Liste des fichiers objets nécessaires à la compilation de l'exécutable principal (main)
# main.o : Fichier objet de main.c
# avl_tree.o : Fichier objet de avl_tree.c (doit être listé ici pour que Makefile sache qu'il est requis)
# utils.o : Fichier objet de utils.c
OBJECTS = main.o avl_tree.o utils.o  # <-- Ensure avl_tree.o is listed

# Cible par défaut appelée lors de l'exécution de "make" 
all: main

# Cible pour générer l'exécutable principal "main"
# Elle dépend de tous les fichiers objets listés dans la variable $(OBJECTS)
# La commande utilise le compilateur (défini par $(CC)) et les options de compilation (définies par $(CFLAGS))
# Elle produit l'exécutable "main" à partir des fichiers objets $(OBJECTS)
main: $(OBJECTS)
	$(CC) $(CFLAGS) -o main $(OBJECTS)

# Règle générique pour compiler tout fichier .c en fichier .o
# Cette règle signifie que tout fichier .o dépend d'un fichier .c et de son fichier d'en-tête correspondant (.h)
# $< fait référence au premier prérequis (par exemple, le fichier .c correspondant)
%.o: %.c %.h
	$(CC) $(CFLAGS) -c $<

# Cible "clean" utilisée pour nettoyer le répertoire
# Elle supprime tous les fichiers objets (*.o) et l'exécutable "main"
# La commande "rm -f" supprime les fichiers sans afficher d'erreur si les fichiers n'existent pas
clean:
	rm -f *.o main
