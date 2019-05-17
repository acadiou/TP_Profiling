program heat3d
  use heat3d_mpi
  implicit none

  integer, parameter :: nx_glo = 512, ny_glo = 512, nz_glo = 512
  integer, parameter :: step_max = 200
  integer, parameter :: fres=92
  character*80 :: fnam
  character(len=3) :: str

  integer :: nx, ny, nz
  integer :: i, j, k, step

  logical :: notConverged

  double precision, parameter :: dimx = 1.0d0, dimy = 1.0d0, dimz = 1.0d0
  double precision, parameter :: kappa = 1.0d0, conv_stop = 1.0d-1

  double precision, dimension(:,:,:), pointer :: u
  double precision, dimension(:,:,:), pointer :: uold
  double precision, dimension(:,:,:), pointer :: tmp
  double precision :: t, dt, conv, e, hx, hy, hz, cx, cy, cz
  double precision :: start, end

  hx = dimx / dble(nx_glo + 4)
  hy = dimy / dble(ny_glo + 4)
  hz = dimz / dble(nz_glo + 4)

  step = 0
  t = 0.0d0
  dt = 0.125d0 * ((min(min(hx, hy), hz)) ** 3) / kappa

  cx = kappa * dt / (12 * hx * hx)
  cy = kappa * dt / (12 * hy * hy)
  cz = kappa * dt / (12 * hz * hz)

  call init_mpi()

  nx = nx_glo / dims(1)
  if (coords(1) < mod(nx_glo, dims(1))) nx = nx + 1
  ny = ny_glo / dims(2)
  if (coords(2) < mod(ny_glo, dims(2))) ny = ny + 1
  nz = nz_glo / dims(3)
  if (coords(3) < mod(nz_glo, dims(3))) nz = nz + 1

  if (nx == 0 .or. (nx == 1 .and. neighbor(WEST) /= MPI_PROC_NULL .and. neighbor(EAST) /= MPI_PROC_NULL) &
        .or. ny == 0 .or. (ny == 1 .and. neighbor(SOUTH) /= MPI_PROC_NULL .and. neighbor(NORTH) /= MPI_PROC_NULL) &
        .or. nz == 0 .or. (nz == 1 .and. neighbor(DOWN) /= MPI_PROC_NULL .and. neighbor(UP) /= MPI_PROC_NULL)) then
    print *, "Decomposition invalide : la taille du domaine local du processus", rank &
      , "est insuffisante (", nx, "x", ny, "x", nz, ")"
    call MPI_Abort(comm3d, 2, ierr)
  endif

  call create_types(nx, ny, nz)

  allocate(u(-1:nx+2,-1:ny+2,-1:nz+2), uold(-1:nx+2,-1:ny+2,-1:nz+2))

  if (rank == 0) then
    print *, "Taille du domaine global =", nx_glo, "x", ny_glo, "x", nz_glo
    print *, "dt =", dt
  endif

  ! Conditions limites
  if (neighbor(WEST) == MPI_PROC_NULL) then
    u(-1:0, :, :) = -10.0d0
    uold(-1:0, :, :) = -10.0d0
  endif
  if (neighbor(EAST) == MPI_PROC_NULL) then
    u(nx+1:nx+2, :, :) = -10.0d0
    uold(nx+1:nx+2, :, :) = -10.0d0
  endif
  if (neighbor(SOUTH) == MPI_PROC_NULL) then
    u(:, -1:0, :) = -10.0d0
    uold(:, -1:0, :) = -10.0d0
  endif
  if (neighbor(NORTH) == MPI_PROC_NULL) then
    u(:, ny+1:ny+2, :) = -10.0d0
    uold(:, ny+1:ny+2, :) = -10.0d0
  endif
  if (neighbor(DOWN) == MPI_PROC_NULL) then
    u(:, :, -1:0) = -10.0d0
    uold(:, :, -1:0) = -10.0d0
  endif
  if (neighbor(UP) == MPI_PROC_NULL) then
    u(:, :, nz+1:nz+2) = -10.0d0
    uold(:, :, nz+1:nz+2) = -10.0d0
  endif

  ! Condition initiale
  uold(1:nx, 1:ny, 1:nz) = 20.0d0

  write(str,'(i3.3)') rank+1
  fnam='init_p'//trim(str)//'.bin'
  open(fres,file=trim(fnam), access='STREAM', form='UNFORMATTED', convert='LITTLE_ENDIAN')
  write(fres) (((uold(i,j,k),i=1,nx),j=1,ny),k=1,nz)
  close(fres)
  call MPI_Barrier(comm3d, ierr)

  notConverged = .true.
  start = MPI_Wtime()
  do while (notConverged)
    call update_overlap(uold(:,:,:))

    t = t + dt
    step = step + 1

    conv = 0.0d0

    do k=1,nz
    do j=1,ny
    do i=1,nx
      e = cx * (- uold(i-2,j,k) + 16.0d0 * uold(i-1,j,k) - 30.0d0 * uold(i,j,k) + 16.0d0 * uold(i+1,j,k) - uold(i+2,j,k)) &
            + cy * (- uold(i,j-2,k) + 16.0d0 * uold(i,j-1,k) - 30.0d0 * uold(i,j,k) + 16.0d0 * uold(i,j+1,k) - uold(i,j+2,k)) &
            + cz * (- uold(i,j,k-2) + 16.0d0 * uold(i,j,k-1) - 30.0d0 * uold(i,j,k) + 16.0d0 * uold(i,j,k+1) - uold(i,j,k+2))

      u(i,j,k) = uold(i,j,k) + e

      conv = conv + e * e
    end do
    end do
    end do

    call MPI_Allreduce(MPI_IN_PLACE, conv, 1, MPI_DOUBLE_PRECISION, MPI_SUM, comm3d, ierr)

    write(str,'(i3.3)') rank+1
    fnam='res_p'//trim(str)//'.bin'
    open(fres,file=trim(fnam), access='STREAM', form='UNFORMATTED', convert='LITTLE_ENDIAN')
    write(fres) (((u(i,j,k),i=1,nx),j=1,ny),k=1,nz)
    close(fres)

    conv = sqrt(conv)
    notConverged = step < step_max .and. conv > conv_stop

    if (rank == 0) print *, "Step =", step, " --> conv =", conv

    ! Echange des tableaux nouveau et ancien
    tmp => uold
    uold => u
    u => tmp
  end do
  end = MPI_Wtime()

  if (rank == 0) then
    print *, "Step =", step, " --> conv =", conv
    print *, "Elapse time =", end - start
  endif

  deallocate(u, uold)

  call finalize_mpi()

end program heat3d
