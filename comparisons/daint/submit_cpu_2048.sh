#!/bin/bash -l
#SBATCH --job-name=kh_2048_cpu
#SBATCH --mail-type=ALL
#SBATCH --mail-user=kjetil.lye@sam.math.ethz.ch
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --ntasks-per-node=8
#SBATCH --cpus-per-task=1
#SBATCH --partition=normal
#SBATCH --constraint=gpu
#SBATCH --account=s665
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export CRAY_CUDA_MPS=1

srun alsvinn/build/alsuqcli/alsuqcli --multi-x 8 ../kelvinhelmholtz_2048/kelvinhelmholtz/kelvinhelmholtz.xml
