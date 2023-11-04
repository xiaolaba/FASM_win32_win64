@echo off
 
REM Readme first
REM 2017-MAR-25, xioalaba
REM Uses FASMW or FASM, goto C:\fasmw17160\TOOLS\WIN32
REM to build 3-EXE one time first, listing.exe, prepsrc.exe, symbols.exe
 

SET FASM=E:\FASM


SET TOOLS=%FASM%\TOOLS\WIN32
SET INCLUDE=%FASM%\INCLUDE
 
set path=%FASM%;%INCLUDE%;%TOOLS%;%path%
path

 
if exist %TOOLS%\listing.exe goto skip
@echo ---- Uses FASMW or FASM, goto %TOOLS%
@echo ---- To build 3 EXE first at one time deal, listing.exe, prepsrc.exe, symbols.exe
cd %TOOLS%
fasm.exe listing.asm listing.exe
fasm.exe prepsrc.asm prepsrc.exe
fasm.exe symbols.asm symbols.exe
:skip


REM change to current dir
cd /D "%~dp0"
@echo.
@echo working folder = %1

 
@echo FASM build.bat, by xiaolaba, MAR/26/2017
@echo.
@echo ---- Drag .asm file to this build.bat, produce .exe and .fas
fasm.exe %1 %1.exe -s %1.fas

::goto end
 
@echo.
@echo ---- Uses .fas, produce .lst
listing -a %1.fas %1.lst
 
@echo.
@echo ---- Uses .fas, produce .src
prepsrc %1.fas %1.src
 
@echo.
@echo ---- Uses .fas, produce .fas
symbols %1.fas %1.sym

:end

del *.fas
 
@echo DONE !!
pause 