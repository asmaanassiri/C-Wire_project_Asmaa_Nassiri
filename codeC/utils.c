#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "utils.h"
#include "avl_tree.h" // <-- Make sure this is included!

int load_data_into_avl_tree(AVLTree *tree, const char *file_path) {
    FILE *file = fopen(file_path, "r");
    if (!file) {
        perror("Error opening file");
        return 1;
    }

    char line[256];
    while (fgets(line, sizeof(line), file)) {
        int id, capacity, consumption;
        
        // Example parsing logic for a line like "ID:Capacity:Consumption"
        if (sscanf(line, "%d:%d:%d", &id, &capacity, &consumption) == 3) {
            tree = avl_tree_insert(tree, id, capacity, consumption); // <-- Correct function call
        } else {
            printf("Warning: Failed to parse line: %s\n", line);
        }
    }

    fclose(file);
    return 0;
}
