#include <stdio.h>
#include <stdlib.h>
#include <time.h>

/**
 * \brief produit de matrices carrees de dimension NxN
 *        loop i,k,j
 */
void mul_ikj(double **a, double **b, double **c, int N){
  int i,j,k;
  for (j = 0; j < N; j++){
    for (k = 0; k < N; k++){
      for (i = 0; i < N; i++){
        c[i][j] = c[i][j] + a[i][k]*b[k][j];
      }
    }
  }
}

/**
 * \brief produit de matrices carrees de dimension NxN
 *        loop i,j,k
 */
void mul_ijk(double **a, double **b, double **c, int N){
  int i,j,k;
  for (k = 0; k < N; k++){
    for (j = 0; j < N; j++){
      for (i = 0; i < N; i++){
        c[i][j] = c[i][j] + a[i][k]*b[k][j];
      }
    }
  }
}


/**
 * \brief produit de matrices carrees de dimension NxN
 *        loop j,k,i
 */
void mul_jki(double **a, double **b, double **c, int N){
  int i,j,k;
  for (i = 0; i < N; i++){
    for (k = 0; k < N; k++){
      for (j = 0; j < N; j++){
        c[i][j] = c[i][j] + a[i][k]*b[k][j];
      }
    }
  }
}


/**
 * \brief programme principal
 *
 */
int main(void){

  int i,j;
  int const N=1024;
  double **a = (double**)malloc(N*sizeof(double*));
  double **b = (double**)malloc(N*sizeof(double*));
  double **c = (double**)malloc(N*sizeof(double*));
  clock_t c_start,c_stop;
  double time_elapsed_s;

  /* allocate arrays */
  for (i=0; i<N; i++){
    a[i] = (double*)malloc(N*sizeof(double));
    b[i] = (double*)malloc(N*sizeof(double));
    c[i] = (double*)malloc(N*sizeof(double));
  }

  /* initialize */
  for (i = 0; i < N; i++){
    for (j = 0; j < N; j++){
      c[i][j] = 0.0;
      a[i][j] = (double)rand()/((double)RAND_MAX + 1); 
      b[i][j] = (double)rand()/((double)RAND_MAX + 1); 
    }
  }

  /* product c = a x b */
  c_start = clock();

  mul_ikj(a, b, c, N);

  c_stop = clock();
  time_elapsed_s = (c_stop-c_start)/(double) CLOCKS_PER_SEC;
  printf("CPU time (s): %f \n", time_elapsed_s);

  /* product c = a x b */
  c_start = clock();

  mul_jki(a, b, c, N);

  c_stop = clock();
  time_elapsed_s = (c_stop-c_start)/(double) CLOCKS_PER_SEC;
  printf("CPU time (s): %f \n", time_elapsed_s);

  /* product c = a x b */
  c_start = clock();

  mul_ijk(a, b, c, N);

  c_stop = clock();
  time_elapsed_s = (c_stop-c_start)/(double) CLOCKS_PER_SEC;
  printf("CPU time (s): %f \n", time_elapsed_s);


  return 0;
}
 
