/*=======================================================================
* FILE: untuned.c
* DESCRIPTION: This is a simple example used to demonstrate a few
*   compiler optimizations. Each subroutine loops through a trivial 
*   calculation an arbitrary number of times so that it will run a 
*   reasonable length of time (for illustration purposes).
* SOURCE: Purdue University Research Computing and Visualization group
* LAST REVISED: 03/17/03 Blaise Barney
*======================================================================*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define N_PIPE 400
#define N_UNROLL 80
#define N_STRENGTH 500
#define N_BLOCK 512
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



void pipe()
{
   int i, repeat;
   double s, s2, w, x, y, z;
   double a[N_PIPE], b[N_PIPE], c[N_PIPE], d[N_PIPE];

   for (i=0; i<N_PIPE; i++)
   {
      a[i] = i * 1.0;
      b[i] = i * 1.0;
      c[i] = i * 1.0;
      d[i] = i * 1.0;
   }
   s2 = 0.0;
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


void unroll()
{
   int i, j, repeat;
   double s, x[N_UNROLL], y[N_UNROLL], a[N_UNROLL][N_UNROLL];

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
      for (j=0; j<N_UNROLL; j++)
      {
         for (i=0; i<N_UNROLL; i++)
            y[j] = y[j] + x[i] * a[j][i];
         s = y[N_UNROLL-1];
      }
   }
   s = s + s;
   printf("s= %e\n",s);
   
}


void strength()
{
   int i, j, repeat;
   double s, a[N_STRENGTH], b[N_STRENGTH], c[N_STRENGTH];

   for (j=0; j<N_STRENGTH; j++)
   {
      a[j] = 1.0;
      b[j] = 1.0;
      c[j] = 0.0;
   }

   for (repeat=0; repeat<REPEAT_STRENGTH; repeat++)
   {
      for (j=0; j<N_STRENGTH; j++)
      {
         for (i=0; i<N_STRENGTH; i++)
            c[j] = c[j] + sin(a[i]) / b[j];
         s = c[N_STRENGTH-1];
      }
      s = s + s;
   }
   printf("s= %e\n",s);
}


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

   for (i=0; i<N_BLOCK; i++)
      for (j=0; j<N_BLOCK; j++)
         for (k=0; k<N_BLOCK; k++)
            c[i][j] = c[i][j] + a[i][k] * b[k][j];
   printf("c[%d][%d] = %e\n",N_BLOCK-1, N_BLOCK-1, c[N_BLOCK-1][N_BLOCK-1]);
}




