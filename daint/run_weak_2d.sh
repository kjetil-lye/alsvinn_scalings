#!/bin/bash

cwd=`pwd`
export OMP_NUM_THREADS=1
set -e

for BASE_N in 1024 2048 4096; do 
    cd $cwd;
    mkdir runs/base_${BASE_N}_multiy
    mkdir runs/base_${BASE_N}_multix
    mkdir runs/base_${BASE_N}_multixmultiy

    cp -r configs/* runs/base_${BASE_N}_multiy/
    cp -r configs/* runs/base_${BASE_N}_multix/
    cp -r configs/* runs/base_${BASE_N}_multixmultiy/

    N=${BASE_N}
    for k in `seq 0 3`
    do
	cd $cwd;
	cpus=$((($N*$N)/($BASE_N*$BASE_N)))
	
	# first we do multiy
	cd runs/base_${BASE_N}_multiy/2d/weak_scaling/kelvinhelmholtz_${N}/
	sed -i "s/TOTAL_NODES_TO_USE/${cpus}/g" submit.sh
	sed -i "s/01:00:00/24:00:00/g" submit.sh
	sed -i "s/X_NODES_TO_USE/1/g" submit.sh
	sed -i "s/Y_NODES_TO_USE/${cpus}/g" submit.sh
	sed -i 's/cpu/cuda/g' kelvinhelmholtz/kelvinhelmholtz.xml
	sbatch submit.sh
	cd $cwd
	cd runs/base_${BASE_N}_multix/2d/weak_scaling/kelvinhelmholtz_${N}/
	sed -i "s/TOTAL_NODES_TO_USE/${cpus}/g" submit.sh
	sed -i "s/Y_NODES_TO_USE/1/g" submit.sh
	sed -i "s/X_NODES_TO_USE/${cpus}/g" submit.sh
	sed -i "s/01:00:00/24:00:00/g" submit.sh
	sed -i 's/cpu/cuda/g' kelvinhelmholtz/kelvinhelmholtz.xml
	sbatch submit.sh

	cd $cwd
	cd runs/base_${BASE_N}_multixmultiy/2d/weak_scaling/kelvinhelmholtz_${N}/
	x_cpus=$(($N/${BASE_N}))
	sed -i "s/TOTAL_NODES_TO_USE/${cpus}/g" submit.sh
	sed -i "s/X_NODES_TO_USE/${x_cpus}/g" submit.sh
	sed -i "s/Y_NODES_TO_USE/${x_cpus}/g" submit.sh
	sed -i "s/01:00:00/24:00:00/g" submit.sh
	sed -i 's/cpu/cuda/g' kelvinhelmholtz/kelvinhelmholtz.xml
	sbatch submit.sh
	N=$((2*$N))
    done;
done

    
    



    
