setlocal EnableDelayedExpansion

:: configure!
cmake ^
    -S"%SRC_DIR%" ^
    -Bbuild ^
    -GNinja ^
    -DCMAKE_BUILD_TYPE:STRING=Release ^
    -DCMAKE_INSTALL_PREFIX:PATH="%PREFIX%" ^
    -DCMAKE_CXX_COMPILER:STRING=clang-cl ^
    -DCMAKE_CXX_FLAGS="/wd4018 /wd4101 /wd4996 /EHsc" ^
    -DCMAKE_INSTALL_LIBDIR:PATH="Library\lib" ^
    -DCMAKE_INSTALL_INCLUDEDIR:PATH="Library\include" ^
    -DCMAKE_INSTALL_BINDIR:PATH="Library\bin" ^
    -DCMAKE_INSTALL_DATADIR:PATH="Library" ^
    -DCMAKE_WINDOWS_EXPORT_ALL_SYMBOLS:BOOL=ON ^
    -DBUILD_SHARED_LIBS:BOOL=ON ^
    -DPython_EXECUTABLE:STRING="%PYTHON%" ^
    -DPYMOD_INSTALL_LIBDIR:PATH="..\..\Lib\site-packages" ^
    -DINSTALL_DEVEL_HEADERS:BOOL=OFF ^
    -DENABLE_OPENMP:BOOL=ON ^
    -DENABLE_XHOST:BOOL=OFF ^
    -DENABLE_PYTHON_INTERFACE:BOOL=ON
if errorlevel 1 exit 1

:: build!
cmake --build build --config Release --parallel %CPU_COUNT% -- -v -d stats
if errorlevel 1 exit 1

:: install!
cmake --build build --config Release --target install
if errorlevel 1 exit 1

