::::::::::::::::::::::::::::::::::
:
: Rocket Software Confidential
: OCO Source Materials
: Copyright (C) Rocket Software. 2009, 2010, 2011, 2012, 2013
: 
:
: @(:) $0 : script for converting pkcs#8 cert and pvtkey to pfx file
:           for a U2 DB system
:	by : Nik Kesic
:	   : U2 Support Denver - USA
: Synopsis:
:
:  rem name pfxconv8
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
echo. +++++++++++++++++
echo.  SSL Test Client
echo. +++++++++++++++++
echo.      
:
:secServ
set /p secServ=Enter name of secure server [%secServ%]:
IF  "%secServ%"=="" goto ErrorsecServ
goto secPort
:ErrorsecServ
echo Bad input!!
goto secServ
:
:secPort
set /p secPort=Enter port of secure server [%secPort%]:
IF  "%secPort%"=="" goto ErrorsecPort
goto secPath
:ErrorsecPort
echo Bad input!!
goto secPort
:
:SecPath
set /p SecPath=Enter path of CA and intermediate certificates [%SecPath%]:
IF  "%SecPath%"=="" goto ErrorsecPath
goto secPath
:ErrorsecPath
echo Bad input!!
goto SecPath
:
:secOption
set /p INP4=Enter any other openssl options or "<cr>" :  
rem IF  (%INP4%)==() (
rem set INP4=%INPUT%
rem ) ELSE (
rem echo " bad input"
rem )
:
:nnext
echo openssl s_client -connect %secServ%:%secPort% -showcerts -CApath %secPath% %secOption%
openssl s_client -connect %secServ%:%secPort% -showcerts -CApath %secPath% %secOption%
:
echo.
SET /P M= Any key to exit : 
:EOF
exit
