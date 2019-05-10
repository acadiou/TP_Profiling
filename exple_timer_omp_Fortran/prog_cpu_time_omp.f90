!> @file    prog_cpu_time_omp.f90
!> @author  anne cadiou
!> @brief   example of CPU_TIME usage

program prog_cpu_time_omp
  !$ use OMP_LIB
  implicit none

  integer :: n,ndim
  integer :: rang
  real, allocatable :: x(:)

  ! timer 
  real :: beg_cpu_time,end_cpu_time
  real :: beg_omp_time,end_omp_time

  ! 100 10^6
  ndim = 100000000
  allocate(x(ndim))

  n = 1
  call CPU_TIME(beg_cpu_time)
  beg_omp_time = OMP_GET_WTIME()
  !$OMP PARALLEL DO &
  !$OMP DEFAULT(NONE) PRIVATE(n) SHARED(x)
  do n=1,ndim
    x(n) = EXP(1.0*n)
    !print*, "Rank: ",rang, x(n)
  end do
  !$OMP END PARALLEL DO
  end_omp_time = OMP_GET_WTIME()
  print*, end_omp_time-beg_omp_time
  call CPU_TIME(end_cpu_time)
  print*, end_cpu_time-beg_cpu_time

  deallocate(x)

end program prog_cpu_time_omp

