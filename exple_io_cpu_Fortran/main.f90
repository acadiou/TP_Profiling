!> @file    main.f90
!> @brief   solve 2D Poisson equation with Dirichelet boundary conditions
!>          not physically relevant
!>          just to have a loop with frequent output on disk

program main

  use mSolve

  implicit none

  integer :: nx = 5000, ny = 5000
  real(kind=8) :: lx, ly
  real(kind=8) :: dx, dy
  integer :: idat = 92, ires = 93
  
  real(kind=8), dimension(:,:), allocatable :: T,f

  real(kind=8) :: start_time,stop_time

  lx = 2.0
  ly = 2.0

  dx = lx / real(nx - 1)
  dy = ly / real(ny - 1)

  allocate(T(nx,ny))
  allocate(f(nx,ny))

  call initialisation(T,f,nx,ny,dx,dy)

  open(idat,file='init.dat')
  call save_sol(F,nx,ny,dx,dy,idat)
  close(idat)

  call CPU_TIME(start_time)
  call solve(T,f,nx,ny)
  call CPU_TIME(stop_time)

  open(ires,file='field.dat')
  call save_sol(T,nx,ny,dx,dy, ires)
  close(ires)
  print*, stop_time - start_time

  deallocate(T)
  deallocate(f)

end program main
