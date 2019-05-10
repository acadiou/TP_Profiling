C========================================================================
C FILE: tuned.f
C DESCRIPTION: This is a simple example used to demonstrate a few
C   compiler optimizations. Each subroutine loops through a trivial
C   calculation an arbitrary number of times so that it will run a
C   reasonable length of time (for illustration purposes).
C SOURCE: Purdue University Research Computing and Visualization group
C LAST REVISED: 03/18/03 Blaise Barney
C Tuned version.
C========================================================================

      PROGRAM tuned

      print *,'Running pipe()...'
      call pipe()

      print *,'Running unroll()...'
      call unroll()

      print *,'Running strength()...'
      call strength()

      print *,'Running block()...'
      call block()

      END PROGRAM tuned



C=======================================================================
C SUBROUTINE pipe()
C    This subroutine illustrates how code can be reorganized by the
C    compiler to take advantage of the processor pipelines. 
C    Optimization: compile with compiler optimization 
C=======================================================================

      SUBROUTINE pipe()

      PARAMETER ( N=400, REPEAT_MAX=100000 )
      DOUBLE PRECISION a(N),b(N),c(N),d(N)
      DOUBLE PRECISION s,s2,w,x,y,z
      INTEGER i,repeat

      do i=1,N
        a(i) = i * 1.0
        b(i) = i * 1.0
        c(i) = i * 1.0
        d(i) = i * 1.0
      end do
        s2 = 0.0
        w = 1.0
        x = 2.0
        y = 3.0
        z = 4.0

      do repeat=1,REPEAT_MAX
        do i=1,N
          s2 = s2 + w*a(i) + x*b(i) + y*c(i) + z*d(i)
        end do
          s = s2
      end do
      print *, 's= ',s

      END SUBROUTINE pipe

C=======================================================================
C SUBROUTINE unroll()
C    This subroutine illustrates the concept of loop unrolling
C    to reduce the dependence on the processor Load/Store unit. 
C
C    Optimization: Compiler optimization with manual unrolling
C=======================================================================

      SUBROUTINE unroll()

      PARAMETER ( N=80, REPEAT_MAX=100000 )
      DOUBLE PRECISION x(N),y(N),a(N,N)
      DOUBLE PRECISION s,s0,s1,s2,s3,s4,s5,s6,s7
      INTEGER i,j,repeat

      do i=1,N
        x(i) = i * 1.0
        y(i) = i * 1.0
        do j=1,N
          a(i,j) = j * 1.0
        end do
      end do
      s = 0.0

      do repeat=1,REPEAT_MAX

        do j=1,N,8
          s0 = y(j  )
          s1 = y(j+1)
          s2 = y(j+2)
          s3 = y(j+3)
          s4 = y(j+4)
          s5 = y(j+5)
          s6 = y(j+6)
          s7 = y(j+7)
          do i=1,N
            s0 = s0 + x(i)*a(i,j  )
            s1 = s1 + x(i)*a(i,j+1)
            s2 = s2 + x(i)*a(i,j+2)
            s3 = s3 + x(i)*a(i,j+3)
            s4 = s4 + x(i)*a(i,j+4)
            s5 = s5 + x(i)*a(i,j+5)
            s6 = s6 + x(i)*a(i,j+6)
            s7 = s7 + x(i)*a(i,j+7)
          end do
          y(j  ) = s0
          y(j+1) = s1
          y(j+2) = s2
          y(j+3) = s3
          y(j+4) = s4
          y(j+5) = s5
          y(j+6) = s6
          y(j+7) = s7
        end do
        s = y(N)
      end do
      s = s + s
      print *, 's= ',s  
      

      END SUBROUTINE unroll



C=======================================================================
C SUBROUTINE strength()
C    This subroutine illustrates the concept of "strength 
C    reduction", which is a technique to reduce redundant operations
C    without altering the results.
C
C    Optimization: Compiler optimization with manual strength reduction
C=======================================================================

      SUBROUTINE strength()

      PARAMETER ( N=500, REPEAT_MAX=100 )
      DOUBLE PRECISION s,a(N),b(N),c(N),binv(N),sina(N)
      INTEGER i,j,repeat

      do j=1,N
        a(j)=1.0
        b(j)=1.0
        c(j)=0.0
      end do

      do repeat=1,REPEAT_MAX

        do j=1,N
          binv(j) = 1.0/b(j)
        end do

        do i=1,N
          sina(i) = dsin(a(i))
        end do

        do j=1,N
          do i=1,N
            c(j) = c(j) + sina(i)*binv(j)
          end do
          s = c(N)
        end do
        s = s + s
      end do
      print *, 's = ',s

      END SUBROUTINE strength



C=======================================================================
C SUBROUTINE block()
C    This subroutine illustrates the concept of "blocking",
C    which is a technique to optimize calculations with bad stride
C    for a particular cache size.  This is a standard matrix 
C    multiplication algorithm.
C
C    Optimization: ESSL routine
C=======================================================================

      SUBROUTINE block()

      PARAMETER ( N=512 )
      DOUBLE PRECISION a(N,N),b(N,N),c(N,N)
      INTEGER i,j,k

      do i=1,N
        do j=1,N
          a(i,j) = i * 1.0
          b(i,j) = i * 1.0
          c(i,j) = 0.0
        end do
      end do

      call DGEMM('n', 'n', N, N, N, 1.d0, a, N, b, N, 0.d0, c, N)

      print *, 'c(N,N) = ',c(N,N)

      END SUBROUTINE block

