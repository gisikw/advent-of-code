#include <stdio.h>

int main(int argc, char *argv[]) {
    FILE *file = fopen(argv[1], "r");
    int lines = 0;
    char ch;

    while(!feof(file)) {
        ch = fgetc(file);
        if(ch == '\n') {
            lines++;
        }
    }
    fclose(file);

    printf("Received %d lines of input for part %s\n", lines, argv[2]);
    return 0;
}
