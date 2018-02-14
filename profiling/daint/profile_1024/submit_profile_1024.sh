#!/bin/bash -l
#SBATCH --job-name=profile
#SBATCH --mail-type=ALL
#SBATCH --mail-user=kjetil.lye@sam.math.ethz.ch
#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --ntasks-per-node=12
#SBATCH --cpus-per-task=1
#SBATCH --partition=normal
#SBATCH --constraint=gpu

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export CRAY_CUDA_MPS=1

srun nvprof --analyze-metrics -m all -a global_access,shared_access,branch,instruction_execution -o nvprof.output.%h.%p ../alsvinn/build/alsuqcli/alsuqcli ../kelvinhelmholtz_1024/kelvinhelmholtz/kelvinhelmholtz.xml
