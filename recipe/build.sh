#!/usr/bin/env bash
set -ex

export CXX=$(basename ${CXX})

ARCH_ARGS=""
IS_PYPY=$(${PYTHON} -c "import platform; print(int(platform.python_implementation() == 'PyPy'))")

if [[ $IS_PYPY == 1 ]]; then
    ARCH_ARGS="-DPython_INCLUDE_DIR=${PREFIX}/include/pypy${PY_VER} ${ARCH_ARGS}"
fi

# configure
cmake ${CMAKE_ARGS} ${ARCH_ARGS} \
    -S"${SRC_DIR}" \
    -Bbuild \
    -GNinja \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH="${PREFIX}" \
    -DCMAKE_CXX_COMPILER:STRING="${CXX}" \
    -DCMAKE_FIND_FRAMEWORK:STRING=NEVER \
    -DCMAKE_FIND_APPBUNDLE:STRING=NEVER \
    -DPython_EXECUTABLE:STRING="${PYTHON}" \
    -DENABLE_OPENMP:BOOL=ON \
    -DENABLE_ARCH_FLAGS:BOOL=OFF \
    -DPYMOD_INSTALL_FULLDIR:PATH="${SP_DIR#$PREFIX/}/cppe"

# build
cmake --build build --parallel "${CPU_COUNT}" -- -v -d stats

# install
cmake --build build --target install
