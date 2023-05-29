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
    -DCMAKE_FIND_FRAMEWORK:STRING=NEVER \
    -DCMAKE_FIND_APPBUNDLE:STRING=NEVER \
    -DENABLE_OPENMP:BOOL=ON \
    -DENABLE_ARCH_FLAGS:BOOL=OFF \
    -DPython_EXECUTABLE:STRING="${PYTHON}" \
    -DPYMOD_INSTALL_FULLDIR:PATH="${SP_DIR#$PREFIX/}/cppe" \
    -DENABLE_PYTHON_INTERFACE:BOOL=ON

# build
cmake --build build --parallel "${CPU_COUNT}" -- -v -d stats

# install
cmake --build build --target install
