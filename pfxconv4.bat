:
: Rocket Software Confidential
: OCO Source Materials
: Copyright (C) Rocket Software. 2017
: 
: @(:) $0 : script for checking A PEM certificate expiration data
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
:cls
:pfxconv4
set /p pemfile=Enter name and path of the PEM Certificate file : %pemfile%
IF "%pemfile%"=="" goto ErrorpemFile
goto :nnext
:ErrorpemFile
echo Bad Input!!
goto pfxconv4
:
:nnext
echo.
openssl x509 -startdate -noout -in %pemfile%
openssl x509 -enddate -noout -in %pemfile%
:EOF
echo.
set /p DUMMY=Hit ENTER to exit...
EXIT
