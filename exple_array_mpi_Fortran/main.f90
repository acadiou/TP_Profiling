!> @file    main.f90
!> @author  anne cadiou
!> @brief   example of CPU_TIME usage

program main
  use mpi
  implicit none

  integer :: n,nglob
  ! 10^9
  integer, parameter :: ndim=1000000000
  integer :: ierr,i,rang,nprocs
  integer :: nstart, nstop, npart, ncount, nrem
  real, allocatable :: x(:)

  ! timer 
  real :: beg_cpu_time,end_cpu_time
  real :: beg_mpi_time,end_mpi_time

  call CPU_TIME(beg_cpu_time)

  CALL MPI_INIT(ierr)
  CALL MPI_COMM_RANK(MPI_COMM_WORLD, rang, ierr)
  CALL MPI_Comm_size(MPI_COMM_WORLD, nprocs, ierr)

  ncount = ndim/nprocs
  nrem = MOD(ndim,nprocs)
  IF (rang < nrem) THEN
    nstart = rang * (ncount + 1)
    nstop = nstart + ncount
  ELSE 
    nstart = rang * ncount + nrem
    nstop = nstart + (ncount - 1)
  END IF
  npart = nstop-nstart+1

  allocate(x(npart))

  n = 1
  beg_mpi_time = MPI_WTIME()
  do n=1,npart
    nglob=n+nstart-1
    x(n) = EXP(1.0*n)
    !print*, "Rank: ",rang, x(n)
  end do
  end_mpi_time = MPI_WTIME()
  print*, 'MPI Time: ',end_mpi_time-beg_mpi_time

  deallocate(x)

  call mpi_finalize(ierr)

  call CPU_TIME(end_cpu_time)
  print*, end_cpu_time-beg_cpu_time

end program main

