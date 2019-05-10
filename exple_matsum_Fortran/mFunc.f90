module mFunc
! Example of functions 

  ! Declarations
  implicit none

contains

subroutine sumMatijk(ni,nj,nk,x,y,z)
! sum of matrices

  ! Declarations
  implicit none
  integer, intent(in) :: ni,nj,nk
  real, dimension(:,:,:), intent(in) :: x,y
  real, dimension(:,:,:), intent(out) :: z

  ! Local variables
  integer :: i,j,k

  ! Loop 
  do i=1,ni
    do j=1,nj
      do k=1,nk
        z(i,j,k) = x(i,j,k)+y(i,j,k)
      end do
    end do
  end do

end subroutine sumMatijk

subroutine sumMatjik(ni,nj,nk,x,y,z)
! sum of matrices

  ! Declarations
  implicit none
  integer, intent(in) :: ni,nj,nk
  real, dimension(:,:,:), intent(in) :: x,y
  real, dimension(:,:,:), intent(out) :: z

  ! Local variables
  integer :: i,j,k

  ! Loop 
  do j=1,nj
    do i=1,ni
      do k=1,nk
        z(i,j,k) = x(i,j,k)+y(i,j,k)
      end do
    end do
  end do

end subroutine sumMatjik

subroutine sumMatkji(ni,nj,nk,x,y,z)
! sum of matrices

  ! Declarations
  implicit none
  integer, intent(in) :: ni,nj,nk
  real, dimension(:,:,:), intent(in) :: x,y
  real, dimension(:,:,:), intent(out) :: z

  ! Local variables
  integer :: i,j,k

  ! Loop 
  do k=1,nk
    do j=1,nj
      do i=1,ni
        z(i,j,k) = x(i,j,k)+y(i,j,k)
      end do
    end do
  end do

end subroutine sumMatkji



end module mFunc


