#include <mpi.h>

enum {
  WEST = 0,
  EAST = 1,
  SOUTH = 2,
  NORTH = 3,
  DOWN = 4,
  UP = 5
};

enum { ndims = 3 };

typedef struct {
  int nbProcs, rank;
  MPI_Comm comm3d;
  MPI_Datatype type_overlap_x, type_overlap_y, type_overlap_z;
  int dims[ndims], coords[ndims];
  int neighbor[2 * ndims];
} mpi_context_t ;

void init_mpi(mpi_context_t* c);
void create_types(mpi_context_t* c, int nx, int ny, int nz);
void update_overlap(mpi_context_t* c, double* u, int nx, int ny, int nz);
void finalize_mpi(mpi_context_t* c);
