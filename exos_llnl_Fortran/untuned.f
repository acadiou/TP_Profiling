C========================================================================
C FILE: untuned.f
C DESCRIPTION: This is a simple example used to demonstrate a few
C   compiler optimizations. Each subroutine loops through a trivial 
C   calculation an arbitrary number of times so that it will run a 
C   reasonable length of time (for illustration purposes).
C SOURCE: Purdue University Research Computing and Visualization group
C LAST REVISED: 03/17/03 Blaise Barney
C========================================================================

      PROGRAM untuned

      print *,'Running pipe()...'
      call pipe()

      print *,'Running unroll()...'
      call unroll()

      print *,'Running strength()...'
      call strength()

      print *,'Running block()...'
      call block()

      END PROGRAM untuned




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
          s2 = s2+ w*a(i) + x*b(i) + y*c(i) + z*d(i)
        end do
          s = s2
      end do
      print *, 's= ',s

      END SUBROUTINE pipe


C=======================================================================

      SUBROUTINE unroll()

      PARAMETER ( N=80, REPEAT_MAX=100000 )
      DOUBLE PRECISION x(N),y(N),a(N,N)
      DOUBLE PRECISION s
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
        do j=1,N
          do i=1,N
            y(j) = y(j) + x(i)*a(i,j)
          end do
        end do
        s = y(N)
      end do
      s = s + s
      print *, 's= ',s


      END SUBROUTINE unroll


C=======================================================================


      SUBROUTINE strength()

      PARAMETER ( N=500, REPEAT_MAX=100 )
      DOUBLE PRECISION s,a(N),b(N),c(N)
      INTEGER i,j,repeat

      do j=1,N
        a(j)=1.0
        b(j)=1.0
        c(j)=0.0
      end do

      do repeat=1,REPEAT_MAX

        do j=1,N
          do i=1,N
            c(j) = c(j) + dsin(a(i))/b(j)
          end do
          s = c(N)
        end do
        s = s + s
      end do
      print *, 's= ',s

      END SUBROUTINE strength


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

      do i=1,N
        do j=1,N
          do k=1,N
            c(j,i)=c(j,i)+a(j,k)*b(k,i)
          end do
        end do
      end do
      print *, 'c(N,N) = ',c(N,N)

      END SUBROUTINE block

