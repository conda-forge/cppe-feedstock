#!/usr/bin/env bash
set -ex

export CXX=$(basename ${CXX})

# configure
cmake ${CMAKE_ARGS} \
    -S"${SRC_DIR}" \
    -Bbuild \
    -GNinja \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH="${PREFIX}" \
    -DCMAKE_CXX_COMPILER:STRING="${CXX}" \
    -DCMAKE_CXX_FLAGS:STRING="${CXXFLAGS}" \
    -DBUILD_SHARED_LIBS:BOOL=ON \
    -DCMAKE_FIND_FRAMEWORK:STRING=NEVER \
    -DCMAKE_FIND_APPBUNDLE:STRING=NEVER \
    -DINSTALL_DEVEL_HEADERS:BOOL=OFF \
    -DENABLE_OPENMP:BOOL=ON \
    -DENABLE_XHOST:BOOL=OFF \
    -DPython_EXECUTABLE:STRING="${PYTHON}" \
    -DPYMOD_INSTALL_LIBDIR:PATH="${SP_DIR#$PREFIX/lib}" \
    -DENABLE_PYTHON_INTERFACE:BOOL=ON

# build
cmake --build build --parallel "${CPU_COUNT}" -- -v -d stats

# install
cmake --build build --target install
