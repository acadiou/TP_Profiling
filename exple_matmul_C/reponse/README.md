# Compile and execute

make PROF=True
time ./a.out > run.out

export GMON_OUT_PREFIX='gmon.out'
gprof ./a.out gmon.out > prof.log

# Generates .dot and .pdf files from flat profile

gprof ./a.out | ../Tools/gprof2dot.py > job.dot
dot -Tpdf job.dot -o output.pdf

# Get CPU time with perf

perf stat ./a.out 

perf stat -e cpu-clock ./a.out 

perf record --call-graph fp ./a.out

perf report

# Valgrind

valgrind --tool=callgrind --dump-instr=yes --simulate-cache=yes --collect-jumps=yes --instr-atstart=no  ./a.out > valgrind_prof.log 2>&1 &

gnome-terminal -e callgrind_control -i on

kcachgrind

