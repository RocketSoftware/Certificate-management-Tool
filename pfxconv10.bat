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
echo.  View Java Keystore Contents
echo. +++++++++++++++++++++++++++++
echo.      
:
:jksName
set /p jksname=Enter name for the Java Key Store : %jksname%
IF "%jksname%"=="" goto ErrorjksName
goto nnext
:ErrorjksName
echo Bad Input!!
goto jksName
:
:nnext
keytool -list -v -keystore %jksname%
echo.
dir /B %jksname%*
SET /P M= Any key to exit : 
IF %M%== GOTO EOF
:EOF
exit