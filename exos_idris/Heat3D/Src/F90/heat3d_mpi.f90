module heat3d_mpi
  use mpi
  implicit none

  integer, parameter :: ndims = 3
  integer, parameter :: WEST = 1, EAST = 2, SOUTH = 3, NORTH = 4, DOWN = 5, UP = 6

  integer :: nbProcs, rank, comm3d, ierr
  integer :: type_overlap_x, type_overlap_y, type_overlap_z
  integer, dimension(ndims) :: dims, coords
  integer, dimension(2 * ndims) :: neighbor

  logical, parameter :: reorder = .false.

  logical, dimension(ndims) :: periods

contains

  subroutine init_mpi()
    call MPI_Init(ierr)
    call MPI_Comm_size(MPI_COMM_WORLD, nbProcs, ierr)
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)

    dims(:) = 0
    CALL MPI_Dims_create(nbProcs, ndims, dims, ierr)

    periods(:) = .false.
    CALL MPI_Cart_create(MPI_COMM_WORLD, ndims, dims, &
                         periods, reorder, comm3d, ierr)
    if (rank == 0) then
      print *, "Nombre de processus MPI =", nbProcs
      print *, "Topologie 3D =", dims(1), "x", dims(2), "x", dims(3)
    endif

    call MPI_Cart_coords(comm3d, rank, ndims, coords, ierr)

    neighbor(:) = MPI_PROC_NULL
    call MPI_Cart_shift(comm3d, 0, 1, neighbor(WEST), neighbor(EAST), ierr)
    call MPI_Cart_shift(comm3d, 1, 1, neighbor(SOUTH), neighbor(NORTH), ierr)
    call MPI_Cart_shift(comm3d, 2, 1, neighbor(DOWN), neighbor(UP), ierr)
  end subroutine init_mpi

  subroutine create_types(nx, ny, nz)
    integer :: nx, ny, nz
    integer, dimension(ndims) :: sizes, subsizes, starts

    sizes(1) = nx + 4
    sizes(2) = ny + 4
    sizes(3) = nz + 4

    starts(:) = 0

    subsizes(1) = 2
    subsizes(2) = ny
    subsizes(3) = nz
    call MPI_Type_create_subarray(ndims, sizes, subsizes, starts, &
                                  MPI_ORDER_FORTRAN, MPI_DOUBLE_PRECISION, &
                                  type_overlap_x, ierr)
    call MPI_Type_commit(type_overlap_x, ierr)

    subsizes(1) = nx
    subsizes(2) = 2
    subsizes(3) = nz
    call MPI_Type_create_subarray(ndims, sizes, subsizes, starts, &
                                  MPI_ORDER_FORTRAN, MPI_DOUBLE_PRECISION, &
                                  type_overlap_y, ierr)
    call MPI_Type_commit(type_overlap_y, ierr)

    subsizes(1) = nx
    subsizes(2) = ny
    subsizes(3) = 2
    call MPI_Type_create_subarray(ndims, sizes, subsizes, starts, &
                                  MPI_ORDER_FORTRAN, MPI_DOUBLE_PRECISION, &
                                  type_overlap_z, ierr)
    call MPI_Type_commit(type_overlap_z, ierr)
  end subroutine create_types

  subroutine update_overlap(u)
    double precision, dimension(-1:,-1:,-1:) :: u !, contiguous
    integer :: tag
    integer, dimension(ndims) :: sizes

    sizes(:) = shape(u)-4

    tag = 1
    call MPI_Sendrecv(u(sizes(1)-1,1,1), 1, type_overlap_x, neighbor(EAST), tag, &
                      u(-1,1,1), 1, type_overlap_x, neighbor(WEST), tag, comm3d, MPI_STATUS_IGNORE, ierr)
    call MPI_Sendrecv(u(1,1,1), 1, type_overlap_x, neighbor(WEST), tag, &
                      u(sizes(1)+1,1,1), 1, type_overlap_x, neighbor(EAST), tag, comm3d, MPI_STATUS_IGNORE, ierr)

    tag = 2
    call MPI_Sendrecv(u(1,sizes(2)-1,1), 1, type_overlap_y, neighbor(NORTH), tag, &
                      u(1,-1,1), 1, type_overlap_y, neighbor(SOUTH), tag, comm3d, MPI_STATUS_IGNORE, ierr)
    call MPI_Sendrecv(u(1,1,1), 1, type_overlap_y, neighbor(SOUTH), tag, &
                      u(1,sizes(2)+1,1), 1, type_overlap_y, neighbor(NORTH), tag, comm3d, MPI_STATUS_IGNORE, ierr)

    tag = 3
    call MPI_Sendrecv(u(1,1,sizes(3)-1), 1, type_overlap_z, neighbor(UP), tag, &
                      u(1,1,-1), 1, type_overlap_z, neighbor(DOWN), tag, comm3d, MPI_STATUS_IGNORE, ierr)
    call MPI_Sendrecv(u(1,1,1), 1, type_overlap_z, neighbor(DOWN), tag, &
                      u(1,1,sizes(3)+1), 1, type_overlap_z, neighbor(UP), tag, comm3d, MPI_STATUS_IGNORE, ierr)
  end subroutine update_overlap

  subroutine finalize_mpi()
    call MPI_Type_free(type_overlap_x, ierr)
    call MPI_Type_free(type_overlap_y, ierr)
    call MPI_Type_free(type_overlap_z, ierr)

    call MPI_Comm_free(comm3d, ierr)

    call MPI_Finalize(ierr)
  end subroutine finalize_mpi

end module heat3d_mpi
