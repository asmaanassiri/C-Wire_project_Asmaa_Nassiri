#ifndef AVL_TREE_H
#define AVL_TREE_H

typedef struct AVLTree {
    int id;
    int capacity;
    int consumption;
    struct AVLTree *left, *right;
} AVLTree;

AVLTree *avl_tree_insert(AVLTree *tree, int id, int capacity, int consumption);
AVLTree *create_node(int id, int capacity, int consumption);
void avl_tree_destroy(AVLTree *tree);
void avl_tree_print(AVLTree *tree);

#endif
