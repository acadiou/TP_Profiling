SHELL=/bin/bash

CC=gcc

PREP=
ifdef DEBUG
PREP=-g
endif
ifdef PROF
PREP=-pg
endif
ifdef PERF
PREP=-fno-omit-frame-pointer
endif
CFLAGS=-W -Wall -ansi -pedantic -std=c11 $(PREP)
LDFLAGS=$(PREP)

EXE=a.out

all: $(EXE)

SRC=io_bound.c

OBJ=$(SRC:.c=.o)

$(EXE): $(OBJ)
	$(CC) -o $@ $^ $(LDFLAGS)

%.o : %.c
	$(CC) -o $@ -c $< $(CFLAGS)

.PHONY: clean

clean:
	rm -f *.o a.out
	rm -f *.log *.out
	rm -f *.pdf *.dot

