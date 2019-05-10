# Compile and execute

make PROF=True
time ./a.out > run.out
gprof ./a.out gmon.out > prof.log

# Generates .dot and .pdf files from flat profile

gprof ./a.out | ../Tools/gprof2dot.py > job.dot
dot -Tpdf job.dot -o output.pdf
