::::::::::::::::::::::::::::::::::
:
: Rocket Software Confidential
: OCO Source Materials
: Copyright (C) Rocket Software. 2017
: 
:
: @(:) $0 : script for converting pkcs#8 cert and pvtkey to pfx file
:           for a U2 DB system
:	by : Nik Kesic
:	   : U2 Support Denver - USA
: Synopsis:
:
: rem name pfxconv3
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
echo. +++++++++++++++++++++++++++++++++++++++++++++++
echo.  PEM Server Certificate and Private Key to PFX
echo. +++++++++++++++++++++++++++++++++++++++++++++++
echo.      
:
:pfxconv3
set /p pemfile=Enter name of the PEM Certificate file : %pemfile%
IF "%pemfile%"=="" goto ErrorpemFile
goto pvtfile
:ErrorpemFile
echo Bad Input!!
goto pfxconv3
:
:pvtfile
set /p pvtfile=Enter name of the Private Key file : %pvtfile%
IF "%pvtfile%"=="" goto ErrorpvtFile
goto cafile
:ErrorpvtFile
echo Bad Input!!
goto pvtfile
:
:cafile
set /p cafile=Enter name of the CAfile file :  
IF "%cafile%"=="" goto ErrorcaFile
goto pfxfile
:ErrorcaFile
set cafile=%pemfile%
:
:pfxfile
set /p pfxfile=Enter name for the PFX file :  
IF "%pfxfile%"=="" goto ErrorpfxFile
goto nnext
:ErrorpfxFile
echo Bad Input!!
goto pfxfile
:
:nnext
openssl pkcs12 -export -out %pfxfile% -inkey %pvtfile% -in %pemfile% -cacerts -in %cafile% 
echo.
dir /B %pfxfile%*
SET /P M= Any key to exit : 
IF %M%== GOTO EOF
EOF
exit