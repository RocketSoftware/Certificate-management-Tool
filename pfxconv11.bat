::::::::::::::::::::::::::::::::::
:
: Rocket Software Confidential
: OCO Source Materials
: Copyright (C) Rocket Software. 2017
: 
:
: @(:) $0 : script for importing a microsoft pfx file to a JKS store
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
echo. +++++++++++++++++++++++++++++
echo.  Extract entry from Java Keystore 
echo. +++++++++++++++++++++++++++++
echo.      
:
:jksName
set /p jksname=Enter name for the Java Key Store : %jksname%
IF "%jksname%"=="" goto ErrorjksName
goto pfxfile
:ErrorjksName
echo Bad Input!!
goto jksName
:pfxfile
set /p pfxfile=Enter name for the PFX file :  
IF "%pfxfile%"=="" goto ErrorpfxFile
goto nnext
:ErrorpfxFile
echo Bad Input!!
goto pfxfile
:
:nnext
keytool -destkeystore %pfxfile%.pfx -v -importkeystore -srckeystore %jksname% -srcstoretype JKS  -deststoretype PKCS12
echo.
dir /B %pfxfile%*
SET /P M= Any key to exit : 
IF %M%== GOTO EOF
:EOF
exit