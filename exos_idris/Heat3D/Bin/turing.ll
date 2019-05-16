# @ job_name = Heat3d
# @ output   = $(job_name).$(jobid)
# @ error    = $(job_name).$(jobid)
# @ job_type = BLUEGENE
# @ wall_clock_limit = 00:10:00
# @ bg_size = 256
# @ queue

runjob --ranks-per-node 16 --np 4096 --envs OMP_NUM_THREADS=1 : ./heat3d_BGQ.exe
