@echo off

:: Configure build variables.
set BUILD_CONFIGURATION=Debug
set BUILD_ARCH=x64
set BUILD_DIR=..\build\vc14-%BUILD_ARCH%-%BUILD_CONFIGURATION%
set ENABLE_TESTING=FALSE
set ENABLE_COVERAGE=FALSE

set VS_VERSION=14
set VS_YEAR=2015
set VS_ARCH=Win64

echo Creating a build directory...
if not exist %BUILD_DIR% mkdir %BUILD_DIR%

pushd %BUILD_DIR%

echo [Conan] Downloading packages...
conan install ^
	--build missing ^
	-s build_type=%BUILD_CONFIGURATION% ^
	-s compiler="Visual Studio" ^
	-s compiler.version=%VS_VERSION% ^
	-s compiler.runtime="MTd" ^
	../..

echo [CMake] Generating the project...
cmake ^
	-G "Visual Studio %VS_VERSION% %VS_YEAR% %VS_ARCH%" ^
	-DCMAKE_BUILD_TYPE:STRING=%BUILD_CONFIGURATION% ^
	-DENABLE_TESTING:BOOL=${ENABLE_TESTING} ^
	-DENABLE_COVERAGE:BOOL=${ENABLE_COVERAGE} ^
	../..

echo Project has been generated successfully!
popd
goto :eof

:error
echo [ERROR] Failed to generate project.
popd
exit /b 1
