setlocal EnableDelayedExpansion

set "SETUPTOOLS_SCM_PRETEND_VERSION=%PKG_VERSION%"
set "CMAKE_GENERATOR=Ninja"
set "CMAKE_GENERATOR_PLATFORM="
set "CMAKE_GENERATOR_TOOLSET="
set "CMAKE_ARGS=-DCMAKE_CXX_COMPILER:STRING=clang-cl -DCMAKE_WINDOWS_EXPORT_ALL_SYMBOLS:BOOL=ON -DENABLE_OPENMP:BOOL=ON -DENABLE_ARCH_FLAGS:BOOL=OFF -DFETCHCONTENT_FULLY_DISCONNECTED:BOOL=ON -DEigen3_ROOT:PATH=%PREFIX%"

%PYTHON% -m pip install . -vv --no-deps --no-build-isolation
if errorlevel 1 exit 1

:: Copy the [de]activate scripts to %PREFIX%\etc\conda\[de]activate.d.
:: This will allow them to be run on environment activation.
for %%F in (activate deactivate) DO (
    if not exist %PREFIX%\etc\conda\%%F.d mkdir %PREFIX%\etc\conda\%%F.d
    copy %RECIPE_DIR%\%%F.bat %PREFIX%\etc\conda\%%F.d\%PKG_NAME%_%%F.bat
)
