include ../../Arch/make_inc

.SUFFIXES:
.PRECIOUS: %.o

%.o : %.f90
	$(CF90) -c $< $(CFLAGS)

heat3d : heat3d_mpi.o heat3d.o
	$(CF90) -o $@_$(ARCH).exe $(LDFLAGS) $^
	cp $@_$(ARCH).exe ../../Bin/

all : heat3d
	@echo 'Compilation de Heat3D'

clean :
	rm -f *.o *.mod core

cleanall :
	rm -f *.o *.mod *.exe core