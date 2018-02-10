#!/bin/bash

function alsvinn_cmake () {
    module unload python; 
    module load python/2.7.6; 
    $HOME/local_cmake/bin/cmake .. -DCMAKE_BUILD_TYPE=Release -DBOOST_ROOT=$HOME/local_boost165 -DALSVINN_USE_CUDA=OFF -DALSVINN_BUILD_TESTS=OFF -DALSVINN_BUILD_DOXYGEN=OFF -DPYTHON_INCLUDE_DIR=$(dirname $(dirname $(which python)))/include/python2.7 -DPYTHON_LIBRARY=$(dirname $(dirname $(which python)))/lib64/libpython2.7.so  -DBOOST_LIBRARYDIR=$HOME/local_boost165/lib -DCMAKE_PREFIX_PATH=$HOME/boost_local165; 
    $HOME/local_cmake/bin/cmake .. -DCMAKE_PREFIX_PATH=$HOME/pnetcdf; PYTHONLIB=$(dirname $(dirname $(which python)))/lib64/libpython2.7.so; PYTHONLIB=${PYTHONLIB//"/"/"\/"}; 
    sed -i "s/HDF5_sz_LIBRARY_RELEASE-NOTFOUND/$PYTHONLIB/g" CMakeCache.txt; 
    $HOME/local_cmake/bin/cmake ..; 
    MPI_LIB=$(dirname $(dirname $(which mpicc)))/lib/libmpi.so; 
    MPI_LIB=${MPI_LIB//"/"/"\/"};
    MPI_INC=$(dirname $(dirname $(which mpicc)))/include; 
    MPI_INC=${MPI_INC//"/"/"\/"}; 
    sed -i "s/MPI_C_LIBRARIES:STRING=/MPI_C_LIBRARIES:STRING=${MPI_LIB}/g" CMakeCache.txt;  
    sed -i "s/MPI_C_INCLUDE_PATH:STRING=/MPI_C_INCLUDE_PATH:STRING=${MPI_INC}/g" CMakeCache.txt; 
    $HOME/local_cmake/bin/cmake ..; 
    sed -i "s/MPI_CXX_LIBRARIES:STRING=/MPI_CXX_LIBRARIES:STRING=${MPI_LIB}/g" CMakeCache.txt; 
    sed -i "s/MPI_CXX_INCLUDE_PATH:STRING=/MPI_CXX_INCLUDE_PATH:STRING=${MPI_INC}/g" CMakeCache.txt; 
    $HOME/local_cmake/bin/cmake ..; 
    sed -i "s/OpenMP_gomp_LIBRARY:FILEPATH=OpenMP_gomp_LIBRARY-NOTFOUND/OpenMP_gomp_LIBRARY:FILEPATH=-lgomp/g" CMakeCache.txt; 

    $HOME/local_cmake/bin/cmake ..
}
cwd=`pwd`
export OMP_NUM_THREADS=1
# First we download and compile alsvinn
git clone --recursive git@github.com:kjetil-lye/alsvinn.git
cd alsvinn
mkdir build
cd build
alsvinn_cmake
set -e
make
cd $cwd

echo $cwd
BASE_N=256
cp -r configs/* runs/multiy/
cp -r configs/* runs/multix/
cp -r configs/* runs/multixmultiy/


for N in 256 512 1024 2048 4096 8192;
do
    cd $cwd;
    cpus=$((($N*$N)/($BASE_N*$BASE_N)))
    # first we do multiy
    cd runs/multiy/2d/weak_scaling/kelvinhelmholtz_${N}/
    bsub -N -B -R beta -n ${cpus} -J weak_chain_beta -W 24:00 mpirun -np ${cpus} ${cwd}/alsvinn/build/alsuqcli --multi-y ${cpus} kelvinhelmholtz/kelvinhelmholtz.xml

    cd $cwd
    cd runs/multix/2d/weak_scaling/kelvinhelmholtz_${N}/
    bsub -N -B -R beta -n ${cpus} -J weak_chain_beta -W 24:00 mpirun -np ${cpus} ${cwd}/alsvinn/build/alsuqcli --multi-x ${cpus} kelvinhelmholtz/kelvinhelmholtz.xml

    cd $cwd
    cd runs/multixmultiy/2d/weak_scaling/kelvinhelmholtz_${N}/
    x_cpus=$(($N/${BASE_N}))
    bsub -N -B -R beta -n ${cpus} -J weak_chain_beta -W 24:00 mpirun -np ${cpus} ${cwd}/alsvinn/build/alsuqcli --multi-x ${x_cpus} --multi-y ${x_cpus} kelvinhelmholtz/kelvinhelmholtz.xml
done;

cd $cwd;
cd notebooks; 
bsub -J weak_chain -w "done(weak_chain_beta)"  -N -B $HOME/.local/bin/jupyter nbconvert --ExecutePreprocessor.timeout=-1 --to notebook --execute WeakScalingReport.ipynb --output ../reports/WeakScalingReport_euler_beta_$(date +%Y%m%d).ipynb
    
    



    
