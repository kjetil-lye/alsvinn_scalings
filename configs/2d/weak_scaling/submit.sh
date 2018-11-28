#!/bin/bash -l
#SBATCH --job-name=profile
#SBATCH --mail-type=ALL
#SBATCH --mail-user=kjetil.lye@sam.math.ethz.ch
#SBATCH --time=01:00:00
#SBATCH --nodes=TOTAL_NODES_TO_USE
#SBATCH --ntasks-per-core=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --partition=normal
#SBATCH --constraint=gpu

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
srun  $HOME/alsvinn/build/alsuqcli/alsuqcli --multi-x X_NODES_TO_USE --multi-x Y_NODES_TO_USE kelvinhelmholtz/kelvinhelmholtz.xml
