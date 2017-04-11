::::::::::::::::::::::::::::::::::
:
: Rocket Software Confidential
: OCO Source Materials
: Copyright (C) Rocket Software. 2009, 2010, 2011, 2012, 2013
: 
:
: @(:) $0 : script for importing a microsoft pfx file to a JKS store
:           for a U2 DB system
:	by : Nik Kesic
:	   : U2 Support Denver - USA
: Synopsis:
:
: rem name pfxconv4
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
echo. ++++++++++++++++++++++++++++++++++++++++
echo.  PFX Import into NEW/OLD Java Key Store
echo. ++++++++++++++++++++++++++++++++++++++++
echo.      
:
::
:pfxconv4
set /p pfxfile=Enter name of the PFX file : %pfxfile%
IF "%pfxfile%"=="" goto Errorpfxconv4
goto jksName
:Errorpfxconv4
echo Bad Input!!
goto pfxconv4
:
:jksName
set /p jksname=Enter name for the Java Key Store : %jksname%
IF "%jksname%"=="" goto Errorpfxconv4
goto nnext
:Errorpfxconv4
echo Bad Input!!
goto jksName
:nnext
keytool -v -importkeystore -srckeystore %pfxfile% -srcstoretype PKCS12 -destkeystore %jksname%.jks -deststoretype JKS
echo.
dir /B %jksname%*
SET /P M= Any key to exit : 
IF %M%== GOTO EOF
:EOF
exit