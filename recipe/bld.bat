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

:: Copy the [de]activate scripts to %PREFIX%\etc\conda\[de]activate.d.
:: This will allow them to be run on environment activation.
for %%F in (activate deactivate) DO (
    if not exist %PREFIX%\etc\conda\%%F.d mkdir %PREFIX%\etc\conda\%%F.d
    copy %RECIPE_DIR%\%%F.bat %PREFIX%\etc\conda\%%F.d\%PKG_NAME%_%%F.bat
)
