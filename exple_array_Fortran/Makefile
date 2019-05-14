.SUFFIXES:
.SUFFIXES:.o .f90 .mod

SHELL=/bin/bash

F90=f95

PREP=
ifdef DEBUG
PREP=-g
endif
ifdef PROF
PREP=-pg
endif
F90FLAGS = -fdefault-real-8 -fdefault-double-8 -O2 $(PREP)
LDFLAGS=$(PREP)

EXE=a.out

all: $(EXE)

SRC=main.f90

OBJ=$(SRC:.f90=.o)

$(EXE): $(OBJ)
	$(F90) -o $@ $^ $(LDFLAGS)

%.o : %.f90
	$(F90) -o $@ -c $< $(F90FLAGS)

.PHONY: clean

clean:
	rm -f *.o *.mod a.out
	rm -f *.log *.out
	rm -f *.pdf *.dot

