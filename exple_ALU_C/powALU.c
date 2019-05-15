#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

int main(void) {

    double x = 1.0;
    double y = 2.0;
    int ndim = 100000000;
    int i;
    clock_t c_start,c_stop;
    double time_elapsed_s;

    c_start = clock();
    for (i = 0; i < ndim; ++i) {
        x += pow(y,4);
    }   
    c_stop = clock();
    time_elapsed_s = (c_stop-c_start)/(double) CLOCKS_PER_SEC;
    printf("CPU time (s): %f \n", time_elapsed_s);

    return EXIT_SUCCESS;
}
