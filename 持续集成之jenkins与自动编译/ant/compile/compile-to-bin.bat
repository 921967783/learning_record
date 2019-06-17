::设置初始参数
set ANT_HOME=C:\apache-ant-1.9.7
set JAVA_HOME=C:\Java\jdk1.5.0_20
set JAVA_VERSION=1.5
set path=%JAVA_HOME%\bin;%JAVA_HOME%\jre\bin;%ANT_HOME%\bin;%path%
set classpath=%JAVA_HOME%\lib;%JAVA_HOME%\jre\lib;...\jdtCompilerAdapter.ecif.jar;..\org.eclipse.jdt.core_3.9.2.v20140114-1555.jar;

setloacl
set appdir=%~dp0
set disk=%~d0
%disk%
cd %appdir%

set ant.xml.dir=%appdir%project\
set workspace.dir=%appdir%..\..\
ant -f compile-to-bin.xml -Dant.xml.dir=%ant.xml.dir% -Dworkspace.dir=%workspace.dir% -Dsource=%JAVA_VERSION% -Dtarget=%JAVA_VERSION%
::ant -f compile-to-bin.xml -Dant.xml.dir=%1-Dworkspace.dir=%2 -Dsource=%3 -Dtarget=%4
endlocal

::调试完请注释掉
pause