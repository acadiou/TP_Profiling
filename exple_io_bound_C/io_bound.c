#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

/**
 * \brief Open many files and perform intensive seek inside them
 *
 */
int main(int argc, char **argv) {

    if (argc != 2) {
        fprintf(stderr, "specify a file to read!\n");
        return EXIT_FAILURE;
    }

    int fd = open(argv[1], O_DIRECT);
    if (fd < 0) {
        fprintf(stdout, " %s is not a file \n",argv[1]);
        perror("open error");
        return EXIT_FAILURE;
    }

    off_t size = lseek(fd, 0, SEEK_END);
    fprintf(stdout, "File %s size %ld \n",argv[1],size);

    for (int i = 0; i < 1000000; i++)                                                                                
        lseek(fd, rand() % size, SEEK_SET);

    close(fd);

    return EXIT_SUCCESS;
}
