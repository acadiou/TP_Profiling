module mSolve

contains
  
  subroutine solve(T,f,nx,ny)

    implicit none
    
    integer :: nx, ny
    real(kind=8), dimension(nx,ny) :: T,f
    real(kind=8) :: err, maxerr = 1.0e-7
    integer :: iter, maxiter=200
    
    do iter=1,maxiter
      call jacobi(T, f, nx, ny, err)
      print*, 'Iterations= ',iter,' err= ',err
      if(err.le.maxerr) then
        print*, 'Converged after ', iter, ' iterations'
        return
      endif
    enddo
  end subroutine solve

  subroutine jacobi(T, f, nx, ny, norm)

    implicit none

    integer :: nx, ny
    real(kind=8), dimension(nx,ny), intent(in) :: f
    real(kind=8), dimension(nx,ny), intent(inout) :: T
    real(kind=8), dimension(nx,ny) :: U
    real(kind=8) :: norm
    integer :: i, j
    real(kind=8) :: tmp
    norm = 0.0

    U = T

    do j=2, nx - 1
      do i=2, ny - 1
          tmp = 0.25 * (U(i-1,j) + U(i+1,j) + U(i,j-1) + U(i,j+1) + F(i,j))
          norm = norm + (U(i,j) - tmp)**2
          T(i,j) = tmp
       enddo
    enddo
    norm = sqrt(norm/(nx-2)/(ny-2))
  end subroutine jacobi

  subroutine initialisation(T, f, nx, ny, dx, dy)
    implicit none
    
    integer :: nx, ny
    real(kind=8), dimension(ny, nx) :: T, f
    real(kind=8) :: dx, dy

    real(kind=8) :: Tb = 20.0
    real(kind=8) :: hotspot
    integer :: i, j
    integer :: xmin, xmax, ymin, ymax

    T = 0.0
    T(1,:) = Tb
    T(:,1) = Tb 
    T(ny,:) = Tb 
    T(:,nx) = 0.0

    f = 0.0
    
    xmin = 1 + nx / 2 
    xmax = 1 + nx * 2 / 3
    ymin = 1 + ny / 6
    ymax = 1 + ny / 3

    hotspot = Tb * 10.0 * dx * dy
    do j=ymin, ymax
      do i=xmin, xmax
          f(i,j) = hotspot
       enddo
    enddo
    
  end subroutine initialisation

  subroutine save_sol(T, nx, ny, dx, dy, ires)

    implicit none
    
    integer, intent(in) :: ires
    integer, intent(in) :: nx, ny
    real(kind=8), intent(in) :: dx, dy
    real(kind=8), dimension(ny, nx), intent(in) :: T

    integer :: i,j

    do j=1, nx
       do i=1, ny
          write(ires, '(3E12.4)') real(i - 1) * dx, &
               real(j - 1) * dy, T(i,j)
       enddo
    enddo
  end subroutine save_sol
  

end module mSolve
