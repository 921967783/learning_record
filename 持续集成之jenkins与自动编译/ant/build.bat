setlocal
set appdir=%~dp0
set disk=%~d0
%disk%

::@echo %appdir%
cd  %appdir%
cd compile
compole-to-bin.bat

endlocal
::调试完请注释掉pause=
pause