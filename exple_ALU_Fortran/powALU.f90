program ProgALU

  implicit none
  integer :: n,ndim
  real :: x,y,deb,fin

  ndim = 100000000
  x = 1.0
  y = 2.0
  deb=0.
  fin=0.

  call cpu_time(deb)
  n = 0
  do n = 1, ndim
    x = x + y**4
  end do
  call cpu_time(fin)

  print*, fin-deb

end program ProgALU
