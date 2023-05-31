setlocal EnableDelayedExpansion

:: configure!
cmake ^
    -S"%SRC_DIR%" ^
    -Bbuild ^
    -GNinja ^
    -DCMAKE_BUILD_TYPE:STRING=Release ^
    -DCMAKE_INSTALL_PREFIX:PATH="%PREFIX%" ^
    -DCMAKE_CXX_COMPILER:STRING=clang-cl ^
    -DCMAKE_WINDOWS_EXPORT_ALL_SYMBOLS:BOOL=ON ^
    -DPython_EXECUTABLE:STRING="%PYTHON%" ^
    -DENABLE_OPENMP:BOOL=ON ^
    -DENABLE_ARCH_FLAGS:BOOL=OFF ^
    -DPYMOD_INSTALL_FULLDIR:PATH="Lib\site-packages\cppe"
if errorlevel 1 exit 1

:: build!
cmake --build build --config Release --parallel %CPU_COUNT% -- -v -d stats
if errorlevel 1 exit 1

:: install!
cmake --build build --config Release --target install
if errorlevel 1 exit 1

