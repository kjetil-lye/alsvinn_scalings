#!/bin/bash
function alsvinn_cmake {
    cmake .. -DCMAKE_BUILD_TYPE=Release -DALSVINN_BUILD_TESTS=OFF -DALSVINN_BUILD_DOXYGEN=OFF -DCMAKE_CXX_COMPILER=`which CC` -DCMAKE_PREFIX_PATH=$HOME/pnetcdf_new/ -DPYTHON_LIBRARY=$(dirname $(dirname $(which python)))/lib/libpython2.7.so -DPYTHON_INCLUDE_DIR=$(dirname $(dirname $(which python)))/include/python2.7
    safeNETCDF_DIR=${NETCDF_DIR//\//\\\/};
    sed -i "s/NETCDF_INCLUDE_DIR-NOTFOUND/${safeNETCDF_DIR}\/include/g" CMakeCache.txt
    sed -i "s/NETCDF_LIBRARY-NOTFOUND/${safeNETCDF_DIR}\/lib\/libnetcdf.so/g" CMakeCache.txt
    cmake ..
}

cwd=`pwd`
export OMP_NUM_THREADS=1
# First we download and compile alsvinn
git clone --recursive git@github.com:kjetil-lye/alsvinn.git
cd alsvinn
sed -i 's/sm_50/sm_60/g' CMakeLists.txt
sed -i 's/compute_50/compute_60/g' CMakeLists.txt

mkdir build
cd build
alsvinn_cmake
set -e
make
cd $cwd

echo $cwd
for x in profile*;
do
    cd $x
    sbatch submit*;
    cd ..
done

for x in timeline*;
do
    cd $x;
    sbatch submit*;
    cd ..
done
    
    



    
