!> @file    main.f90
!> @author  anne cadiou
!> @brief   example for profiling

program main

  use mFunc

  implicit none

  integer :: ni,nj,nk
  integer :: i,j,k
  real, allocatable, dimension(:,:,:) :: x,y,z
  real :: deb_cpu_time,end_cpu_time

  ! data 
  ni = 256
  nj = 256
  nk = 256

  ! allocate
  allocate(x(ni,nj,nk))
  allocate(y(ni,nj,nk))
  allocate(z(ni,nj,nk))

  call RANDOM_SEED()

  ! initialize
  call cpu_time(deb_cpu_time)
  call RANDOM_NUMBER(x)
  call RANDOM_NUMBER(y)
  call RANDOM_NUMBER(z)
  call cpu_time(end_cpu_time)
  write(*,*) "Init :: elapsed CPU time :",end_cpu_time-deb_cpu_time

  ! sum
  call cpu_time(deb_cpu_time)
  call sumMatijk(ni,nj,nk,x,y,z)
  call cpu_time(end_cpu_time)
  write(*,*) "ijk :: elapsed CPU time :",end_cpu_time-deb_cpu_time

  ! sum reverse line and column
  call cpu_time(deb_cpu_time)
  call sumMatjik(ni,nj,nk,x,y,z)
  call cpu_time(end_cpu_time)
  write(*,*) "jik :: elapsed CPU time :",end_cpu_time-deb_cpu_time

  ! sum shorter access left index
  call cpu_time(deb_cpu_time)
  call sumMatkji(ni,nj,nk,x,y,z)
  call cpu_time(end_cpu_time)
  write(*,*) "kji :: elapsed CPU time :",end_cpu_time-deb_cpu_time

  ! deallocate
  deallocate(x)
  deallocate(y)
  deallocate(z)

end program main

