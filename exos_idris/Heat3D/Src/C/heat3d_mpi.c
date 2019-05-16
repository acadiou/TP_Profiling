#include "heat3d.h"
#include "heat3d_mpi.h"

void init_mpi(mpi_context_t* c)
{
  int provided;
  int periods[ndims], reorder;

  MPI_Init(NULL, NULL);
  MPI_Comm_size(MPI_COMM_WORLD, &c->nbProcs);
  MPI_Comm_rank(MPI_COMM_WORLD, &c->rank);

  c->dims[0] = c->dims[1] = c->dims[2] = 0;
  MPI_Dims_create(c->nbProcs, ndims, c->dims);

  periods[0] = periods[1] = periods[2] = false;
  reorder = false;
  MPI_Cart_create(MPI_COMM_WORLD, ndims, c->dims, periods, reorder, &c->comm3d);
  if (c->rank == 0) {
    printf("Nombre de processus MPI = %d\n", c->nbProcs);
    printf("Topologie 3D = %d x %d x %d\n", c->dims[0], c->dims[1], c->dims[2]);
  }

  MPI_Cart_coords(c->comm3d, c->rank, ndims, c->coords);

  for (int i = 0; i < 2 * ndims; i++) {
    c->neighbor[i] = MPI_PROC_NULL;
  }
  MPI_Cart_shift(c->comm3d, 0, 1, &c->neighbor[WEST], &c->neighbor[EAST]);
  MPI_Cart_shift(c->comm3d, 1, 1, &c->neighbor[SOUTH], &c->neighbor[NORTH]);
  MPI_Cart_shift(c->comm3d, 2, 1, &c->neighbor[DOWN], &c->neighbor[UP]);
}

void create_types(mpi_context_t* c, int nx, int ny, int nz)
{
  int sizes[ndims], subsizes[ndims], starts[ndims];

  sizes[0] = nx + 4;
  sizes[1] = ny + 4;
  sizes[2] = nz + 4;

  starts[0] = starts[1] = starts[2] = 0;

  subsizes[0] = 2;
  subsizes[1] = ny;
  subsizes[2] = nz;
  MPI_Type_create_subarray(ndims, sizes, subsizes, starts,
                           MPI_ORDER_C, MPI_DOUBLE_PRECISION,
                           &c->type_overlap_x);
  MPI_Type_commit(&c->type_overlap_x);

  subsizes[0] = nx;
  subsizes[1] = 2;
  subsizes[2] = nz;
  MPI_Type_create_subarray(ndims, sizes, subsizes, starts,
                           MPI_ORDER_C, MPI_DOUBLE_PRECISION,
                           &c->type_overlap_y);
  MPI_Type_commit(&c->type_overlap_y);

  subsizes[0] = nx;
  subsizes[1] = ny;
  subsizes[2] = 2;
  MPI_Type_create_subarray(ndims, sizes, subsizes, starts,
                           MPI_ORDER_C, MPI_DOUBLE_PRECISION,
                           &c->type_overlap_z);
  MPI_Type_commit(&c->type_overlap_z);
}

void update_overlap(mpi_context_t* c, double* u, int nx, int ny, int nz)
{
  int tag;

  tag = 1;
  MPI_Sendrecv(&u[IDX(nx-2,0,0)], 1, c->type_overlap_x, c->neighbor[EAST], tag,
               &u[IDX(-2,0,0)], 1, c->type_overlap_x, c->neighbor[WEST], tag, c->comm3d, MPI_STATUS_IGNORE);
  MPI_Sendrecv(&u[IDX(0,0,0)], 1, c->type_overlap_x, c->neighbor[WEST], tag,
               &u[IDX(nx,0,0)], 1, c->type_overlap_x, c->neighbor[EAST], tag, c->comm3d, MPI_STATUS_IGNORE);

  tag = 2;
  MPI_Sendrecv(&u[IDX(0,ny-2,0)], 1, c->type_overlap_y, c->neighbor[NORTH], tag,
               &u[IDX(0,-2,0)], 1, c->type_overlap_y, c->neighbor[SOUTH], tag, c->comm3d, MPI_STATUS_IGNORE);
  MPI_Sendrecv(&u[IDX(0,0,0)], 1, c->type_overlap_y, c->neighbor[SOUTH], tag,
               &u[IDX(0,ny,0)], 1, c->type_overlap_y, c->neighbor[NORTH], tag, c->comm3d, MPI_STATUS_IGNORE);

  tag = 3;
  MPI_Sendrecv(&u[IDX(0,0,nz-2)], 1, c->type_overlap_z, c->neighbor[UP], tag,
               &u[IDX(0,0,-2)], 1, c->type_overlap_z, c->neighbor[DOWN], tag, c->comm3d, MPI_STATUS_IGNORE);
  MPI_Sendrecv(&u[IDX(0,0,0)], 1, c->type_overlap_z, c->neighbor[DOWN], tag,
               &u[IDX(0,0,nz)], 1, c->type_overlap_z, c->neighbor[UP], tag, c->comm3d, MPI_STATUS_IGNORE);
}

void finalize_mpi(mpi_context_t* c)
{
  MPI_Type_free(&c->type_overlap_x);
  MPI_Type_free(&c->type_overlap_y);
  MPI_Type_free(&c->type_overlap_z);

  MPI_Comm_free(&c->comm3d);

  MPI_Finalize();
}
