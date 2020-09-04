#!/usr/bin/env bash

mkdir build
cd build

# Openmpi Specific environment setup - Cf. https://github.com/conda-forge/libnetcdf-feedstock/pull/80
export OMPI_MCA_btl=self,tcp
export OMPI_MCA_plm=isolated
export OMPI_MCA_rmaps_base_oversubscribe=yes
export OMPI_MCA_btl_vader_single_copy_mechanism=none
mpiexec="mpiexec --allow-run-as-root"

export CXXFLAGS="-nostdinc++ -I$PREFIX/include/c++/v1 -L$PREFIX/lib -Wno-unused-command-line-argument"
cmake \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DBLAS_LIBRARIES=$PREFIX/lib/libblas${SHLIB_EXT} \
    "-DLAPACK_LIBRARIES=$PREFIX/lib/liblapack${SHLIB_EXT};$PREFIX/lib/libblas${SHLIB_EXT}" \
    ..

make -j${CPU_COUNT} VERBOSE=1
CTEST_OUTPUT_ON_FAILURE=1 ctest
make install
