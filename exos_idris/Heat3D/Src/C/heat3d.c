#include "heat3d.h"
#include "heat3d_mpi.h"

#include <math.h>

int main(int argc, char* argv)
{
  const int nx_glo = 512, ny_glo = 512, nz_glo = 512, step_max = 200;

  int nx, ny, nz;
  int step;

  bool notConverged;

  const double dimx = 1.0, dimy = 1.0, dimz = 1.0;
  const double kappa = 1.0, conv_stop = 0.1;

  double *u, *uold, *tmp;
  double t, dt, conv, hx, hy, hz, hmin, cx, cy, cz;
  double start, end;

  mpi_context_t mpi_context;

  hx = dimx / (nx_glo + 4.0);
  hy = dimy / (ny_glo + 4.0);
  hz = dimz / (nz_glo + 4.0);

  hmin = hx;
  if (hmin > hy) hmin = hy;
  if (hmin > hz) hmin = hz;

  step = 0;
  t = 0.0;
  dt = 0.125 * pow(hmin, 3.0) / kappa;

  cx = kappa * dt / (12 * hx * hx);
  cy = kappa * dt / (12 * hy * hy);
  cz = kappa * dt / (12 * hz * hz);

  init_mpi(&mpi_context);

  nx = nx_glo / mpi_context.dims[0];
  if (mpi_context.coords[0] < (nx_glo % mpi_context.dims[0])) {
    nx = nx + 1;
  }
  ny = ny_glo / mpi_context.dims[1];
  if (mpi_context.coords[1] < (ny_glo % mpi_context.dims[1])) {
    ny = ny + 1;
  }
  nz = nz_glo / mpi_context.dims[2];
  if (mpi_context.coords[2] < (nz_glo % mpi_context.dims[2])) {
    nz = nz + 1;
  }

  if (nx == 0 || (nx == 1 && mpi_context.neighbor[WEST] != MPI_PROC_NULL && mpi_context.neighbor[EAST] != MPI_PROC_NULL)
        || ny == 0 || (ny == 1 && mpi_context.neighbor[SOUTH] != MPI_PROC_NULL && mpi_context.neighbor[NORTH] != MPI_PROC_NULL)
        || nz == 0 || (nz == 1 && mpi_context.neighbor[DOWN] != MPI_PROC_NULL && mpi_context.neighbor[UP] != MPI_PROC_NULL)) {
    printf("Decomposition invalide : la taille du domaine local du processus %d est insuffisante (%d x %d x %d)\n", mpi_context.rank, nx, ny, nz);
    MPI_Abort(mpi_context.comm3d, 2);
  }

  create_types(&mpi_context, nx, ny, nz);

  u = (double*)malloc((nx + 4) * (ny + 4) * (nz + 4) * sizeof(double));
  uold = (double*)malloc((nx + 4) * (ny + 4) * (nz + 4) * sizeof(double));

  if (mpi_context.rank == 0) {
    printf("Taille du domaine global = %d x %d x %d\n", nx_glo, ny_glo, nz_glo);
    printf("dt = %.15g\n", dt);
  }

  // Conditions limites
  if (mpi_context.neighbor[WEST] == MPI_PROC_NULL) {
    for (int i = -2; i < 0; i++) {
      for (int j = 0; j < ny; j++) {
        for (int k = 0; k < nz; k++) {
          u[IDX(i, j, k)] = uold[IDX(i, j, k)] = -10.0;
        }
      }
    }
  }
  if (mpi_context.neighbor[EAST] == MPI_PROC_NULL) {
    for (int i = nx; i <= nx + 1; i++) {
      for (int j = 0; j < ny; j++) {
        for (int k = 0; k < nz; k++) {
          u[IDX(i, j, k)] = uold[IDX(i, j, k)] = -10.0;
        }
      }
    }
  }
  if (mpi_context.neighbor[SOUTH] == MPI_PROC_NULL) {
    for (int i = 0; i < nx; i++) {
      for (int j = -2; j < 0; j++) {
        for (int k = 0; k < nz; k++) {
          u[IDX(i, j, k)] = uold[IDX(i, j, k)] = -10.0;
        }
      }
    }
  }
  if (mpi_context.neighbor[NORTH] == MPI_PROC_NULL) {
    for (int i = 0; i < nx; i++) {
      for (int j = ny; j <= ny + 1; j++) {
        for (int k = 0; k < nz; k++) {
          u[IDX(i, j, k)] = uold[IDX(i, j, k)] = -10.0;
        }
      }
    }
  }
  if (mpi_context.neighbor[DOWN] == MPI_PROC_NULL) {
    for (int i = 0; i < nx; i++) {
      for (int j = 0; j < ny; j++) {
        for (int k = -2; k < 0; k++) {
          u[IDX(i, j, k)] = uold[IDX(i, j, k)] = -10.0;
        }
      }
    }
  }
  if (mpi_context.neighbor[UP] == MPI_PROC_NULL) {
    for (int i = 0; i < nx; i++) {
      for (int j = 0; j < ny; j++) {
        for (int k = nz; k <= nz + 1; k++) {
          u[IDX(i, j, k)] = uold[IDX(i, j, k)] = -10.0;
        }
      }
    }
  }

  // Condition initiale
  for (int i = 0; i < nx; i++) {
    for (int j = 0; j < ny; j++) {
      for (int k = 0; k < nz; k++) {
        uold[IDX(i, j, k)] = 20.0;
      }
    }
  }

  notConverged = true;
  start = MPI_Wtime();

  while (notConverged) {
    update_overlap(&mpi_context, uold, nx, ny, nz);

    t = t + dt;
    step = step + 1;

    conv = 0.0;

    for (int i = 0; i < nx; i++) {
      for (int j = 0; j < ny; j++) {
        for (int k = 0; k < nz; k++) {
          double e = cx * (- uold[IDX(i-2,j,k)] + 16.0 * uold[IDX(i-1,j,k)] - 30.0 * uold[IDX(i,j,k)] + 16.0 * uold[IDX(i+1,j,k)] - uold[IDX(i+2,j,k)]) \
                      + cy * (- uold[IDX(i,j-2,k)] + 16.0 * uold[IDX(i,j-1,k)] - 30.0 * uold[IDX(i,j,k)] + 16.0 * uold[IDX(i,j+1,k)] - uold[IDX(i,j+2,k)]) \
                      + cz * (- uold[IDX(i,j,k-2)] + 16.0 * uold[IDX(i,j,k-1)] - 30.0 * uold[IDX(i,j,k)] + 16.0 * uold[IDX(i,j,k+1)] - uold[IDX(i,j,k+2)]);

          u[IDX(i,j,k)] = uold[IDX(i,j,k)] + e;

          conv = conv + e * e;
        }
      }
    }

    MPI_Allreduce(MPI_IN_PLACE, &conv, 1, MPI_DOUBLE_PRECISION, MPI_SUM, mpi_context.comm3d);

    conv = sqrt(conv);
    notConverged = step < step_max && conv > conv_stop;

    //if (mpi_context.rank == 0) printf("Step = %d --> conv = %lf\n", step, conv);

    // Echange des tableaux nouveau et ancien
    tmp = uold;
    uold = u;
    u = tmp;
  }

  end = MPI_Wtime();

  if (mpi_context.rank == 0) {
    printf("Step = %d --> conv = %.15lf\n", step, conv);
    printf("Elapse time = %lf\n", end - start);
  }

  free(u);
  free(uold);

  finalize_mpi(&mpi_context);

  return 0;
}
