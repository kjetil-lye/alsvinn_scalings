#!/bin/bash
function switch_to_intel() {
    module purge
    alias cmake=$HOME/local_cmake_intel/bin/cmake
    module load new
    module load intel/2018.0;
    module load impi
    module load hdf5;
    module load netcdf
    module load python/3.6.1
}
function alsvinn_cmake {
    switch_to_intel
    set +x
    $HOME/local_cmake_intel/bin/cmake .. -DCMAKE_BUILD_TYPE=Release -DALSVINN_USE_CUDA=OFF -DALSVINN_BUILD_TESTS=OFF -DALSVINN_BUILD_DOXYGEN=OFF -DCMAKE_C_COMPILER=${CC} -DCMAKE_CXX_COMPILER=${CXX} -DCMAKE_PREF\
IX_PATH=$HOME/pnetcdf_intel -DBOOST_ROOT=$HOME/boost_intel/ -DPYTHON_LIBRARY=$(dirname $(dirname $(which python)))/lib64/libpython3.6m.so

    sed -i 's/NETCDF_LIBRARY-NOTFOUND/\/cluster\/apps\/netcdf\/4.3.1\/x86_64\/intel_16.0.2.181\/impi_5.1.3\/lib\/libnetcdf.so/g' CMakeCache.txt

    sed -i "s/Boost_PYTHON_LIBRARY_DEBUG-NOTFOUND/\/cluster\/home\/klye\/boost_intel\/lib\/libboost_python3d.so/g" CMakeCache.txt
    sed -i "s/Boost_PYTHON_LIBRARY_RELEASE-NOTFOUND/\/cluster\/home\/klye\/boost_intel\/lib\/libboost_python3.so/g" CMakeCache.txt

    sed -i "s/Boost_NUMPY_LIBRARY_DEBUG-NOTFOUND/\/cluster\/home\/klye\/boost_intel\/lib\/libboost_numpy3-d.so/g" CMakeCache.txt
    sed -i "s/Boost_NUMPY_LIBRARY_RELEASE-NOTFOUND/\/cluster\/home\/klye\/boost_intel\/lib\/libboost_numpy3.so/g" CMakeCache.txt
    sed -i 's/libpython3.6.so/libpython3.6m.so/g' CMakeCache.txt
    $HOME/local_cmake_intel/bin/cmake .. -DCMAKE_PREFIX_PATH=$HOME/pnetcdf_intel -DBOOST_ROOT=$HOME/boost_intel/ -DPYTHON_LIBRARY=$(dirname $(dirname $(which python)))/lib64/libpython3.6m.so

    sed -i 's/NETCDF_LIBRARY-NOTFOUND/\/cluster\/apps\/netcdf\/4.3.1\/x86_64\/intel_16.0.2.181\/impi_5.1.3\/lib\/libnetcdf.so/g' CMakeCache.txt



    sed -i "s/Boost_PYTHON_LIBRARY_DEBUG-NOTFOUND/\/cluster\/home\/klye\/boost_intel\/lib\/libboost_python3d.so/g" CMakeCache.txt
    sed -i "s/Boost_PYTHON_LIBRARY_RELEASE-NOTFOUND/\/cluster\/home\/klye\/boost_intel\/lib\/libboost_python3.so/g" CMakeCache.txt

    sed -i "s/Boost_NUMPY_LIBRARY_DEBUG-NOTFOUND/\/cluster\/home\/klye\/boost_intel\/lib\/libboost_numpy3-d.so/g" CMakeCache.txt
    sed -i "s/Boost_NUMPY_LIBRARY_RELEASE-NOTFOUND/\/cluster\/home\/klye\/boost_intel\/lib\/libboost_numpy3.so/g" CMakeCache.txt
    sed -i 's/libpython3.6.so/libpython3.6m.so/g' CMakeCache.txt
    $HOME/local_cmake_intel/bin/cmake .. -DCMAKE_PREFIX_PATH=$HOME/pnetcdf_intel -DBOOST_ROOT=$HOME/boost_intel/ -DPYTHON_LIBRARY=$(dirname $(dirname $(which python)))/lib64/libpython3.6m.so
    sed -i 's/libpython3.6.so/libpython3.6m.so/g' CMakeCache.txt
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
    # here we only do mulit-y
    cd runs/multiy/2d/weak_scaling_without_write/kelvinhelmholtz_${N}/
    bsub -N -B -R beta -n ${cpus} -J weak_chain_without_write_intel -W 24:00 mpirun -np ${cpus} ${cwd}/alsvinn/build/alsuqcli/alsuqcli --multi-y ${cpus} kelvinhelmholtz/kelvinhelmholtz.xml

done;

cd $cwd;
cd notebooks; 
bsub -J weak_chain_without_write_intel_without_write -w "done(weak_chain_without_write_intel)"  -N -B $HOME/.local/bin/jupyter nbconvert --ExecutePreprocessor.timeout=-1 --to notebook --execute WeakScalingReport.ipynb --output ../reports/WeakScalingReport_euler_beta_without_write$(date +%Y%m%d).ipynb
    
    



    
