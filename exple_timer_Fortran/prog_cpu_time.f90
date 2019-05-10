!> @file    prog_cpu_time.f90
!> @author  anne cadiou
!> @brief   example of CPU_TIME usage

program prog_cpu_time

  implicit none

  integer :: n,ndim
  real, allocatable :: x(:)

  ! timer 
  real :: beg_cpu_time,end_cpu_time

  ! 100 10^6
  ndim = 100000000
  allocate(x(ndim))

  call CPU_TIME(beg_cpu_time)
  do n=1,ndim
    x(n) = EXP(1.0*n)
  end do
  call CPU_TIME(end_cpu_time)
  print*, end_cpu_time-beg_cpu_time

  deallocate(x)

end program prog_cpu_time

