!> @file    main.f90
!> @author  anne cadiou
!> @brief   example for profiling

program main

  use mFunc

  implicit none

  integer :: ni,nj,nk
  integer :: i,j,k
  real, allocatable, dimension(:,:,:) :: x,y,z

  ! data 
  ni = 512
  nj = 512
  nk = 512

  ! allocate
  allocate(x(ni,nj,nk))
  allocate(y(ni,nj,nk))
  allocate(z(ni,nj,nk))

  call RANDOM_SEED()

  ! initialize
  call RANDOM_NUMBER(x)
  call RANDOM_NUMBER(y)
  call RANDOM_NUMBER(z)

  ! sum
  call sumMatijk(ni,nj,nk,x,y,z)

  ! sum reverse line and column
  call sumMatjik(ni,nj,nk,x,y,z)

  ! sum shorter access left index
  call sumMatkji(ni,nj,nk,x,y,z)

  ! deallocate
  deallocate(x)
  deallocate(y)
  deallocate(z)

end program main

