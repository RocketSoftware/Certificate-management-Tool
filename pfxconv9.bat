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
: rem name pfxconv9
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
:jksName
echo.Import DER/PEM or PFX Certificate into new of existing Java Key Store
set /p jksname=Enter name for the Java Key Store (.jks will be added) : %jksname%
IF "%jksname%"=="" goto ErrorjksName
goto jksAlias
:ErrorjksName
echo Bad Input!!
goto jksName
:
:jksAlias
set /p jksalias=Java Key Store record alias name : %jksalias%
IF "%jksalias%"=="" goto ErrorjksAlias
goto certfile
:ErrorjksAlias
echo Bad Input!!
goto jksAlias
:
:certfile
set /p certfile=Enter name of the Certicate file : %certfile%
IF "%certfile%"=="" goto Errorcerttype
goto certtype
:Errorcerttype
echo Bad Input!!
goto certfile
:
:certtype
set /p certType="Certificate type? DER/PEM = 1 | PFX = 2 : "%certType%
IF "%certType%"=="" goto Errorcerttype
IF "%certType%"=="1" goto derpem
IF "%certType%"=="2" goto pfx
:Errorcerttype
echo Bad Input!!
goto certtype
:
:derpem
keytool -import -alias %jksalias% -keystore %jksname%.jks -file %certfile%
echo.
goto nnext
:pfx
keytool -v -importkeystore -srckeystore %certfile% -srcstoretype PKCS12 -destkeystore %jksname%.jks -deststoretype JKS
keytool -changealias -keystore %jksname%.jks -alias 1 -destalias %jksalias%
echo.
:nnext
dir /B %jksname%*
SET /P M= Any key to exit : 
IF %M%== GOTO EOF
:EOF
exit