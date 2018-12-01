#!/bin/bash -l
#SBATCH --job-name=profile_Z_NODES_TO_USE_Y_NODES_TO_USE_X_NODES_TO_USE_NX
#SBATCH --mail-type=ALL
#SBATCH --mail-user=kjetil.lye@sam.math.ethz.ch
#SBATCH --time=24:00:00
#SBATCH --nodes=TOTAL_NODES_TO_USE
#SBATCH --ntasks-per-core=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --partition=normal
#SBATCH --constraint=gpu

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
srun  $HOME/alsvinn/build/alsuqcli/alsuqcli --multi-z Z_NODES_TO_USE --multi-x X_NODES_TO_USE --multi-y Y_NODES_TO_USE kelvinhelmholtz/kelvinhelmholtz.xml
