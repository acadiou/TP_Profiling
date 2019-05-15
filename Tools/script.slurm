#!/bin/bash
#SBATCH --job-name=get_memory
#SBATCH --output=job.%j.out
#SBATCH --error=job.%j.err
#SBATCH --partition=parallel
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=16
#SBATCH --cpus-per-task=1

echo $SLURM_JOB_NODELIST

nodeCode=`python get_first_node.py $SLURM_JOB_NODELIST`

echo $nodeCode

ssh -T $nodeCode < local.sh > logMem_Code.log &

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

# load modules
#module purge 
#module load MODULES_NEEDED

time mpirun -np $SLURM_NTASKS a.out

