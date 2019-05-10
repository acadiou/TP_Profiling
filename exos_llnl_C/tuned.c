/*=======================================================================
* FILE: tuned.c
* DESCRIPTION: This is a simple example used to demonstrate a few
*   compiler optimizations. Each subroutine loops through a trivial
*   calculation an arbitrary number of times so that it will run a
*   reasonable length of time (for illustration purposes).
* SOURCE: Purdue University Research Computing and Visualization group
* LAST REVISED: 03/18/03 Blaise Barney
* Tuned version.
*======================================================================*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <essl.h>

#define N_PIPE 400
#define N_UNROLL 80
#define N_STRENGTH 500
#define N_BLOCK 512
#define BLOCK_SIZE 64
#define REPEAT_PIPE 100000
#define REPEAT_UNROLL 100000
#define REPEAT_STRENGTH 100

void pipe();
void unroll();
void strength();
void block();

int main(void)
{
   printf("Running pipe()...\n");
   pipe();

   printf("Running unroll()...\n");
   unroll();

   printf("Running strength()...\n");
   strength();

   printf("Running block()...\n");
   block();

   return 0;
}



/*======================================================================
* SUBROUTINE pipe()
*    This subroutine illustrates how code can be reorganized by the
*    compiler to take advantage of the processor pipelines.
*    Optimization: compiler 
*=====================================================================*/

void pipe()
{
   int i, j, k, repeat;
   double s, s2, w, x, y, z;
   double a[N_PIPE], b[N_PIPE], c[N_PIPE], d[N_PIPE];

   for (i=0; i<N_PIPE; i++)
   {
      a[i] = i * 1.0;
      b[i] = i * 1.0;
      c[i] = i * 1.0;
      d[i] = i * 1.0;
   }
   w = 1.0;
   x = 2.0;
   y = 3.0;
   z = 4.0;

   for (repeat=0; repeat<REPEAT_PIPE; repeat++)
   {
      for (i = 0; i < N_PIPE; i++)
         s2 = s2 + w * a[i] + x * b[i] + y * c[i] + z * d[i];
   }
   s = s2;
   printf("s = %e\n", s);
}

/*======================================================================
* SUBROUTINE unroll()
*    This subroutine illustrates the concept of loop unrolling
*    to reduce the dependence on the processor Load/Store unit.
*
*    Optimization: Compiler optimization with manual unrolling
*=====================================================================*/

void unroll()
{
   int i, j, repeat;
   double s, s0, s1, s2, s3, s4, s5, s6, s7;
   double x[N_UNROLL], y[N_UNROLL], a[N_UNROLL][N_UNROLL];

   for (i=0; i<N_UNROLL; i++)
   {
      x[i] = i * 1.0;
      y[i] = i * 1.0;
      for (j=0; j<N_UNROLL; j++)
         a[i][j] = j * 1.0;
   }
   s = 0.0;

   for (repeat=0; repeat<REPEAT_UNROLL; repeat++)
   {
      for (j=0; j<N_UNROLL; j=j+8) 
      {
         s0 = y[j  ];
         s1 = y[j+1];
         s2 = y[j+2];
         s3 = y[j+3];
         s4 = y[j+4];
         s5 = y[j+5];
         s6 = y[j+6];
         s7 = y[j+7];
         for (i=0; i<N_UNROLL; i++) 
         {
            s0 = s0 + x[i] * a[j  ][i];
            s1 = s1 + x[i] * a[j+1][i];
            s2 = s2 + x[i] * a[j+2][i];
            s3 = s3 + x[i] * a[j+3][i];
            s4 = s4 + x[i] * a[j+4][i];
            s5 = s5 + x[i] * a[j+5][i];
            s6 = s6 + x[i] * a[j+6][i];
            s7 = s7 + x[i] * a[j+7][i];
         }
         y[j  ] = s0;
         y[j+1] = s1;
         y[j+2] = s2;
         y[j+3] = s3;
         y[j+4] = s4;
         y[j+5] = s5;
         y[j+6] = s6;
         y[j+7] = s7;
      }
      s = y[N_UNROLL-1];
   }
   s = s + s;
   printf("s = %e\n",s);
}


/*======================================================================
* SUBROUTINE strength()
*    This subroutine illustrates the concept of "strength
*    reduction", which is a technique to reduce redundant operations
*    without altering the results.
*
*    Optimization: Compiler optimization with manual strength reduction
*=====================================================================*/

void strength()
{
   int i, j, repeat;
   double s, a[N_STRENGTH], b[N_STRENGTH], c[N_STRENGTH], 
          binv[N_STRENGTH], sina[N_STRENGTH];

   for (j=0; j<N_STRENGTH; j++)
   {
      a[j] = 1.0;
      b[j] = 1.0;
      c[j] = 0.0;
   }

   for (repeat=0; repeat<REPEAT_STRENGTH; repeat++)
   {
      for (j=0; j<N_STRENGTH; j++)
         binv[j] = 1.0 / b[j];

      for (i=0; i<N_STRENGTH; i++)
         sina[i] = sin(a[i]);

      for (j=0; j<N_STRENGTH; j++)
      {
         for (i = 0; i < N_STRENGTH; i++)
            c[j] = c[j] + sina[i] * binv[j];
         s = c[N_STRENGTH-1];
      }
   s = s + s;
   }
   printf("s = %e\n",s);
}


/*======================================================================
* SUBROUTINE block()
*    This subroutine illustrates the concept of "blocking",
*    which is a technique to optimize calculations with bad stride
*    for a particular cache size.  This is a standard matrix
*    multiplication algorithm.
*
*    Optimization: ESSL routine
*=====================================================================*/

void block()
{
   int i, j, k;
   double a[N_BLOCK][N_BLOCK], b[N_BLOCK][N_BLOCK], c[N_BLOCK][N_BLOCK];

   for (i=0; i<N_BLOCK; i++)
   {
     for (j=0; j<N_BLOCK; j++)
     {
        a[i][j] = i * 1.0;
        b[i][j] = i * 1.0;
        c[i][j] = 0.0;
     }
   }

   dgemm("n", "n", N_BLOCK, N_BLOCK, N_BLOCK, 1.0, a, N_BLOCK, b, N_BLOCK, 
        0.0, c, N_BLOCK);

   printf("c[%d][%d] = %e\n",N_BLOCK-1, N_BLOCK-1, c[N_BLOCK-1][N_BLOCK-1]);
}


