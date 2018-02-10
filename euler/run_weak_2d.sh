#!/bin/bash
set -e

export OMP_NUM_THREADS=1
# First we download and compile alsvinn
git clone git@github.com:kjetil-lye/alsvinn.git
cd alsvinn
mkdir build
cd build
alsvinn_cmake_release27
make

BASE_N=256
cp -r configs/* runs/multiy/
cp -r configs/* runs/multix/
cp -r configs/* runs/multixmultiy/

cwd=`pwd`
for N in 256 512 1024 2048 4096 8192;
do
    cpus=$((($N*$N)/($BASE_N*$BASE_N)))
    # first we do multiy
    cd runs/multiy/2d/weak_scaling/kelvinhelmholtz_${N}/
    bsub -n ${cpus} -J weak_chain -W 24:00 mpirun -np ${N} ${cwd}/alsvinn/build/alsuqcli --multi-y ${cpus} kelvinhelmholtz/kelvinhelmholtz.xml

    cd $cwd
    cd runs/multix/2d/weak_scaling/kelvinhelmholtz_${N}/
    bsub -n ${cpus} -J weak_chain -W 24:00 mpirun -np ${N} ${cwd}/alsvinn/build/alsuqcli --multi-x ${cpus} kelvinhelmholtz/kelvinhelmholtz.xml

    cd $cwd
    cd runs/multixmultiy/2d/weak_scaling/kelvinhelmholtz_${N}/
    x_cpus=$(($N/${BASE_N}))
    bsub -n ${cpus} -J weak_chain -W 24:00 mpirun -np ${N} ${cwd}/alsvinn/build/alsuqcli --multi-x ${x_cpus} --multi-y ${x_cpus} kelvinhelmholtz/kelvinhelmholtz.xml
done;
bsub -J weak_chain -w "done(weak_chain)"  -N -B $HOME/.local/bin/jupyter nbconvert --ExecutePreprocessor.timeout=-1 --to notebook --execute notebooks/WeakScalingReport.ipynb --output reports/WeakScalingReport_euler_$(date +%Y%m%d).ipynb
    
    



    
