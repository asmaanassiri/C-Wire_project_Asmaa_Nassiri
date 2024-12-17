#include <stdio.h>
#include <stdlib.h>
#include "avl_tree.h"

AVLTree *avl_tree_insert(AVLTree *tree, int id, int capacity, int consumption) {
    if (tree == NULL) {
        return create_node(id, capacity, consumption);
    }

    if (id < tree->id) {
        tree->left = avl_tree_insert(tree->left, id, capacity, consumption);
    } else if (id > tree->id) {
        tree->right = avl_tree_insert(tree->right, id, capacity, consumption);
    } else {
        tree->capacity += capacity;
        tree->consumption += consumption; 
    }

    return tree; 
}

AVLTree *create_node(int id, int capacity, int consumption) {
    AVLTree *node = malloc(sizeof(AVLTree));
    if (node == NULL) {                                        
        perror("Error allocating memory");
        exit(1);
    }
    node->id = id;
    node->capacity = capacity;
    node->consumption = consumption;
    node->left = NULL;
    node->right = NULL;
    return node;
}

void avl_tree_destroy(AVLTree *tree) {
    if (tree) {
        avl_tree_destroy(tree->left);
        avl_tree_destroy(tree->right);
        free(tree);
    }
}

void avl_tree_print(AVLTree *tree) {
    if (tree) {
        avl_tree_print(tree->left);
        printf("ID: %d, Capacity: %d, Consumption: %d\n", tree->id, tree->capacity, tree->consumption);
        avl_tree_print(tree->right);
    }
}
