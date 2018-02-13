#!/bin/bash
function alsvinn_cmake {
    cmake .. -DCMAKE_BUILD_TYPE=Release -DALSVINN_BUILD_TESTS=OFF -DALSVINN_BUILD_DOXYGEN=OFF -DCMAKE_CXX_COMPILER=`which CC` -DCMAKE_PREFIX_PATH=$HOME/pnetcdf/ -DPYTHON_LIBRARY=$(dirname $(dirname $(which python)))/lib/libpython2.7.so -DPYTHON_INCLUDE_DIR=$(dirname $(dirname $(which python)))/include/python2.7

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
sbatch submit_cpu_1024.sh
sbatch submit_cpu_2048.sh

sbatch submit_cuda_1024.sh
sbatch submit_cuda_2048.sh

    
    



    
