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
: rem name pfxconv6
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
echo. ++++++++++++++++++++++++
echo.  View PFX File Contents
echo. ++++++++++++++++++++++++
echo.      
:
:pfxconv6
set /p pfxfile=Enter name of the PFX file : %pfxfile%
IF "%pfxfile%"=="" goto Errorpfxconv6
goto nnext
:Errorpfxconv6
echo Bad Input!!
goto pfxconv6
:
:nnext
openssl pkcs12 -info -in %pfxfile% 
:
echo.
SET /P M= Any key to exit : 
IF %M%== GOTO EOF
:EOF
exit