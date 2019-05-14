!> @file    prog_cpu_time.f90
!> @author  anne cadiou
!> @brief   example of CPU_TIME usage

program main

  implicit none

  integer :: n,ndim
  real, allocatable :: x(:)

  ! timer 
  real :: beg_cpu_time,end_cpu_time

  ! 10^9
  ndim = 1000000000
  allocate(x(ndim))

  call CPU_TIME(beg_cpu_time)
  do n=1,ndim
    x(n) = EXP(1.0*n)
  end do
  call CPU_TIME(end_cpu_time)
  print*, end_cpu_time-beg_cpu_time

  deallocate(x)

end program main

