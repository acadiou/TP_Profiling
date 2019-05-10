# Compile and execute

make PROF=True
time ./a.out > run.out
gprof ./a.out gmon.out > prof.log

