@echo off

taskkill /T /IM spall.exe 2>nul >nul

if EXIST "bin" (
    rmdir /s /q bin
)
md bin

set COMMON_FLAGS=-collection:formats=formats -out:bin\spall.exe -debug -error-pos-style:unix

if "%1"=="release" (
    odin build src %COMMON_FLAGS% -o:speed -no-bounds-check -subsystem:windows -define:GL_DEBUG=false -resource:resources\spall.rc
) else if "%1"=="opt" (
    odin build src %COMMON_FLAGS% -o:speed -resource:resources\spall.rc
) else (
    odin build src %COMMON_FLAGS% -keep-temp-files -resource:resources\spall.rc
)

copy resources\SDL2.dll bin\ 2>nul >nul
