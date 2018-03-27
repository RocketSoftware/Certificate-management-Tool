::::::::::::::::::::::::::::::::::
:
: Rocket Software Confidential
: OCO Source Materials
: Copyright (C) Rocket Software. 2017
: 
:
: @(:) $0 : MS exported certificate store pfx file to pkcs#8 file 
:           for a U2 DB system
:	by : Nik Kesic
:	   : U2 Support Denver - USA
: Synopsis:
:
: rem name pfxconv10
:
:         for Windows 2008, 7, - 64 bit
:           
:
:
::::::::::::::::::::::::::::::::::
@ECHO OFF
:
cls
:
echo. ++++++++++++++++++++++++++++++++++
echo.  View PFX (PKCS#12) File Contents
echo. ++++++++++++++++++++++++++++++++++
echo. 
:
:
:pfxdir
set /p workdir=Enter path\name of the work directory : %workdir%
IF "%workdir%"=="" goto Errorpfxdir
IF EXIST %workdir% (
goto pfxconv10
) ELSE (
Echo Error opening file: %workdir%
set workdir=
goto pfxdir
)
:Errorpfxdir
echo Bad Input!!
goto pfxdir     
:
:pfxconv10
set /p pfxfile=Enter name of the PFX file : %pfxfile%
IF "%pfxfile%"=="" goto Errorpfxconv10
IF EXIST %workdir%\%pfxfile% (
goto nnext
) ELSE (
Echo Error opening file: %pfxfile%
set pfxfile=
goto pfxconv10
)
:Errorpfxconv1
echo Bad Input!!
goto pfxconv10
:
:nnext
openssl pkcs12 -info -in %workdir%\%pfxfile% 
:
echo.
SET /P M= Any key to exit : 
IF %M%== GOTO EOF
:EOF
exit