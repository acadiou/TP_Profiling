# @ job_name = Heat3d
# @ output   = $(job_name).$(jobid)
# @ error    = $(job_name).$(jobid)
# @ job_type = mpich
# @ total_tasks = 64
# @ nb_threads = 1
# @ resources = ConsumableCpus($(nb_threads))
# @ environment = OMP_NUM_THREADS=$(nb_threads); NB_TASKS=$(total_tasks)
# @ wall_clock_limit = 00:10:00
# # @ class = cours
# @ queue

module load intel/2018.2

mpirun -np $NB_TASKS ./heat3d_X86_64.exe
