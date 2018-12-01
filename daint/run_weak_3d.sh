#!/bin/bash

cwd=`pwd`
export OMP_NUM_THREADS=1
set -e
alias sbatch=echo;
for BASE_N in 64 128 256;
do
    cd $cwd;
    mkdir runs/base_${BASE_N}_3d_multiz
    mkdir runs/base_${BASE_N}_3d_multiy
    mkdir runs/base_${BASE_N}_3d_multixmultiymultiz

    cp -r configs/3d/ runs/base_${BASE_N}_3d_multiz/
    cp -r configs/3d/ runs/base_${BASE_N}_3d_multiy/
    cp -r configs/3d/ runs/base_${BASE_N}_3d_multixmultiymultiz/

    N=${BASE_N}
    for k in `seq 0 3`
    do
	cd $cwd;
	cpus=$((($N*$N*$N)/($BASE_N*$BASE_N*$BASE_N)))

	if [ "$cpus" -lt "2048" ];
	then
	    # first we do multiy
	    cd runs/base_${BASE_N}_3d_multiz/3d/weak_scaling/kelvinhelmholtz_${N}/
	    sed -i "s/TOTAL_NODES_TO_USE/${cpus}/g" submit.sh
	    sed -i "s/01:00:00/24:00:00/g" submit.sh
	    sed -i "s/X_NODES_TO_USE/1/g" submit.sh
	    sed -i "s/Y_NODES_TO_USE/1/g" submit.sh
	    sed -i "s/Z_NODES_TO_USE/${cpus}/g" submit.sh
	    sed -i "s/NX/${N}/g" submit.sh
	    sed -i 's/cpu/cuda/g' kelvinhelmholtz/kelvinhelmholtz.xml
	    sbatch submit.sh
	    
	    cd $cwd
	    cd runs/base_${BASE_N}_3d_multiy/3d/weak_scaling/kelvinhelmholtz_${N}/
	    sed -i "s/TOTAL_NODES_TO_USE/${cpus}/g" submit.sh
	    sed -i "s/Y_NODES_TO_USE/${cpus}/g" submit.sh
	    sed -i "s/X_NODES_TO_USE/1/g" submit.sh
	    sed -i "s/Z_NODES_TO_USE/1/g" submit.sh
	    sed -i "s/01:00:00/24:00:00/g" submit.sh
	    sed -i "s/NX/${N}/g" submit.sh
	    sed -i 's/cpu/cuda/g' kelvinhelmholtz/kelvinhelmholtz.xml
	    sbatch submit.sh

	    cd $cwd
	    cd runs/base_${BASE_N}_3d_multixmultiymultiz/3d/weak_scaling/kelvinhelmholtz_${N}/
	    x_cpus=$(($N/${BASE_N}))
	    sed -i "s/TOTAL_NODES_TO_USE/${cpus}/g" submit.sh
	    sed -i "s/X_NODES_TO_USE/${x_cpus}/g" submit.sh
	    sed -i "s/Y_NODES_TO_USE/${x_cpus}/g" submit.sh
	    sed -i "s/Z_NODES_TO_USE/${x_cpus}/g" submit.sh
	    sed -i "s/01:00:00/24:00:00/g" submit.sh
	    sed -i 's/cpu/cuda/g' kelvinhelmholtz/kelvinhelmholtz.xml
	    sed -i "s/NX/${N}/g" submit.sh
	    sbatch submit.sh
	    N=$((2*$N))
	fi;
    done;
done

    
    



    
