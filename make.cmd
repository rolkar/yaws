@echo off

rem ------------------------------------------------------------
rem Command file for building Yaws for CallGuide
rem
rem Andreas Hellström, Telia, 2013-03-27
rem Anders Hjelm, Consoden AB, 2008-02-25
rem
rem ------------------------------------------------------------

set do_exit=0

set MODE=%1
if "%MODE%"=="compile" goto compile
if "%MODE%"=="clean" goto clean
if "%MODE%"=="release" goto release
goto usage

rem -------------------------------------------------------------------------------------------

:usage

echo "Usage: make compile|clean|release"
goto end

rem -------------------------------------------------------------------------------------------

:compile
echo.
echo Make file for building Yaws for CallGuide
echo -----------------------------------------
echo.
echo This option (make -compile) will:
echo.
echo 1. Cleanup (delete release folder, temp files, etc).
echo 2. Compile and install files in ebin folder.
echo 3. Create release folder (release\yaws).
echo.
pause
echo.
rem
cd src
call :do_set_vsn
if %do_exit%==1 goto exit
call :do_clean
if %do_exit%==1 goto exit
call :do_compile
if %do_exit%==1 goto exit
call :do_install
if %do_exit%==1 goto exit
call :do_release
if %do_exit%==1 goto exit
cd ..
goto end

:clean
echo.
echo Make file for building Yaws for CallGuide
echo -----------------------------------------
echo.
echo This option (make -clean) will:
echo.
echo 1. Cleanup (delete release folder, temp files, etc).
echo.
pause
echo.
rem
cd src
call :do_set_vsn
if %do_exit%==1 goto exit
call :do_clean
if %do_exit%==1 goto exit
cd ..
goto end

:install
echo.
echo Make file for building Yaws for CallGuide
echo -----------------------------------------
echo.
echo This option (make -install) will:
echo.
echo 1. Install files in ebin folder.
echo.
pause
echo.
rem
cd src
call :do_set_vsn
if %do_exit%==1 goto exit
call :do_install
if %do_exit%==1 goto exit
cd ..
goto end

:release
echo.
echo Make file for building Yaws for CallGuide
echo -----------------------------------------
echo.
echo This option (make -release) will:
echo.
echo 1. Create release folder.
echo.
pause
echo.
rem
cd src
call :do_set_vsn
if %do_exit%==1 goto exit
call :do_release
if %do_exit%==1 goto exit
cd ..
goto end

rem -------------------------------------------------------------------------------------------

:do_set_vsn

if exist ..\templateFiles\vsn.config (goto vsn_ok) else (goto vsn_error)

:vsn_ok:
set VSN=
for /F "delims=" %%i in (..\templateFiles\vsn.config) do set VSN=%%i
if errorlevel 1 goto error_exit
:: End of subroutine
goto :EOF

:vsn_error:
echo ERROR: File does not exist: ..\templateFiles\vsn.config
goto error_exit

rem -------------------------------------------------------------------------------------------

:do_compile

echo ### Compile files...
echo.
@echo off

echo Compiling sed.erl
del sed.erl 2>NUL
copy ..\templateFiles\sed.erl .\sed.erl
if errorlevel 1 goto error_exit
erlc sed.erl
if errorlevel 1 goto error_exit

del yaws_vsn.erl 2>NUL
erl -run sed s ..\templateFiles\yaws_vsn.template yaws_vsn.erl %%VSN%% "%VSN%"
if errorlevel 1 goto error_exit
echo Compiling yaws_vsn.erl
erlc yaws_vsn.erl
if errorlevel 1 goto error_exit

del yaws_generated.erl 2>NUL
erl -run sed s ..\templateFiles\yaws_generated.template yaws_generated.erl %%localinstall%% "false" %%VSN%% "%VSN%" %%VARDIR%% "unknown" %%ETCDIR%% "unknown" 

if errorlevel 1 goto error_exit
echo Compiling yaws_generated.erl
erlc yaws_generated.erl
if errorlevel 1 goto error_exit

echo Create yaws_configure.hrl
del yaws_configure.hrl 2>NUL
echo off
echo. 2>yaws_configure.hrl
if errorlevel 1 goto error_exit

echo Create charset.def
del ..\priv\charset.def 2>NUL
echo off
echo. 2>..\priv\charset.def
if errorlevel 1 goto error_exit

echo Copy yaws.hrl from inlucde folder
del yaws.hrl 2>NUL
copy ..\include\yaws.hrl .\yaws.hrl
if errorlevel 1 goto error_exit

echo.
echo Run Makefile
echo.
erl -pa "../ebin" -make
if errorlevel 1 goto error_exit
echo.

echo Creating mime_types.erl
del mime_types.erl 2>NUL
erl -run mime_type_c generate
echo.
if errorlevel 1 goto error_exit
echo Compiling mime_types.erl
erlc mime_types.erl
if errorlevel 1 goto error_exit

setlocal ENABLEDELAYEDEXPANSION
for /f %%m in ('dir /b *.erl') do set MODULES=!MODULES! %%~nm
set MODULES=%MODULES:~1%
set MODULES=%MODULES: =, %
del yaws.app 2>NUL
erl -run sed s ..\templateFiles\yaws.app.src yaws.app %%VSN%% "%VSN%" %%MODULES%% "%MODULES%"
endlocal 
if errorlevel 1 goto error_exit
echo.

:: End of subroutine
goto :EOF

rem -------------------------------------------------------------------------------------------

:do_clean

echo ### Cleanup (delete release folder, temp files, etc)...
echo.
@echo off

del sed.erl 2>NUL
del yaws_vsn.erl 2>NUL
del yaws_generated.erl 2>NUL
del yaws_configure.hrl 2>NUL
del yaws.hrl 2>NUL
del mime_types.erl 2>NUL
del *.app 2>NUL
del *.beam 2>NUL
del *.dump 2>NUL
del ..\ebin\*.* /q 2>NUL
del ..\priv\charset.def /q 2>NUL
del ..\ebin\*~ 2>NUL
del ..\include\*~ 2>NUL
del ..\priv\*~ 2>NUL
del ..\src\*~ 2>NUL
del ..\templateFiles\*~ 2>NUL
del ..\templateFiles\src\*~ 2>NUL
if exist ..\release\yaws (rmdir ..\release\yaws /s /q)
if exist ..\release (rmdir ..\release /s /q)

:: End of subroutine
goto :EOF

rem -------------------------------------------------------------------------------------------

:do_install

echo ### Install files in ebin folder.
echo.
@echo off

del ..\ebin\*.* /q 2>NUL
xcopy *.beam ..\ebin\ /q
if errorlevel 1 goto error_exit
xcopy *.app ..\ebin\ /q
if errorlevel 1 goto error_exit
del *.beam 2>NUL
del *.app 2>NUL
echo.

:: End of subroutine
goto :EOF

rem -------------------------------------------------------------------------------------------

:do_release

echo ### Create release folder (release\yaws)...
echo.
@echo off

if exist ..\release\yaws (rmdir ..\release\yaws /s /q)
if exist ..\release (rmdir ..\release /s /q)
md ..\release\yaws

del ..\ebin\*~ 2>NUL
del ..\include\*~ 2>NUL
del ..\priv\*~ 2>NUL

xcopy ..\ebin ..\release\yaws\ebin\ /q
if errorlevel 1 goto error_exit
xcopy ..\include ..\release\yaws\include\ /q
if errorlevel 1 goto error_exit
xcopy ..\priv ..\release\yaws\priv\ /q
if errorlevel 1 goto error_exit
echo.

:: End of subroutine
goto :EOF

rem -------------------------------------------------------------------------------------------

:error_exit

echo.
echo ------- ERROR during %MODE%. See above for error description.
echo.
set do_exit=1
goto exit

rem -------------------------------------------------------------------------------------------

:end

echo ### Finished OK!
echo.
goto exit

rem -------------------------------------------------------------------------------------------

:exit
