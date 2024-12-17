#include <stdio.h>
#include <stdlib.h>
#include "avl_tree.h"
#include "utils.h"

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <data_file>\n", argv[0]);
        return 1;
    }

    AVLTree *tree = NULL;
    load_data_into_avl_tree(tree, argv[1]);

    avl_tree_print(tree);
    avl_tree_destroy(tree);

    return 0;
}
