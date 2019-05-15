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
PREP=
endif
CFLAGS=-W -Wall -ansi -pedantic $(PREP)
LDFLAGS=-lm $(PREP)

EXE=a.out

all: $(EXE)

SRC=powALU.c

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

