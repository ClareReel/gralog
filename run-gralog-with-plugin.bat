@echo off
REM Run GrALoG with Ford-Fulkerson Plugin (Windows Batch Version)

echo === GrALoG Ford-Fulkerson Plugin Launcher ===
echo.

REM Navigate to plugin directory and build
echo Building plugin...
cd gralog-fordfulkerson-plugin
call gradlew.bat build -x test
if errorlevel 1 (
    echo ERROR: Plugin build failed!
    exit /b 1
)
echo [OK] Plugin built successfully
echo.

REM Navigate back to gralog directory
cd ..\gralog

REM Check if gralog dist is built
if not exist "build\dist\gralog-fx.jar" (
    echo GrALoG distribution not built. Building now...
    call gradlew.bat assemble
    if errorlevel 1 (
        echo ERROR: GrALoG build failed!
        exit /b 1
    )
    echo [OK] GrALoG built successfully
)
echo.

REM Copy plugin to libs directory
echo Copying plugin to GrALoG libs directory...
copy /Y "..\gralog-fordfulkerson-plugin\build\libs\gralog-fordfulkerson-plugin-1.0.0.jar" "build\dist\libs\" >nul
if errorlevel 1 (
    echo ERROR: Failed to copy plugin JAR!
    exit /b 1
)
echo [OK] Plugin copied successfully
echo.

REM Add plugin to config.xml if not already there
findstr /C:"gralog-fordfulkerson-plugin" "build\dist\config.xml" >nul
if errorlevel 1 (
    echo Adding plugin to config.xml...
    powershell -Command "(Get-Content 'build\dist\config.xml') -replace '</gralog>', '  <plugin location=\"libs/gralog-fordfulkerson-plugin-1.0.0.jar\" />`n</gralog>' | Set-Content 'build\dist\config.xml'"
    echo [OK] Plugin added to config
) else (
    echo [OK] Plugin already in config
)
echo.

echo Launching GrALoG with Ford-Fulkerson plugin...
echo Working directory: build\dist
echo.
echo Once GrALoG opens:
echo   1. Go to File - New
echo   2. Select 'Flow Network' from the structure dropdown
echo   3. Start creating your flow network!
echo.

REM Navigate to dist directory and run
cd build\dist
java -jar gralog-fx.jar

echo.
echo GrALoG closed.
cd ..\..
pause
