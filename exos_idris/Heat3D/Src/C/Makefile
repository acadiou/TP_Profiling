include ../../Arch/make_inc

.SUFFIXES:
.PRECIOUS: %.o

%.o : %.c
	$(CC) -c $< $(CFLAGS)

heat3d : heat3d_mpi.o heat3d.o
	$(CC) -o $@_$(ARCH).exe $^ $(LDFLAGS)
	cp $@_$(ARCH).exe ../../Bin/

all : heat3d
	@echo 'Compilation de Heat3D'

clean :
	rm -f *.o core

cleanall :
	rm -f *.o *.exe core
