:
: Rocket Software Confidential
: OCO Source Materials
: Copyright (C) Rocket Software. 2017
: 
@ECHO OFF
:cls
:pfxconv12
set /p pemfile=Enter name and path of the PEM Certificate file : %pemfile%
IF "%pemfile%"=="" goto ErrorpemFile
goto :nnext
:ErrorpemFile
echo Bad Input!!
goto pfxconv12
:
:nnext
echo.
openssl x509 -startdate -noout -in %pemfile%
openssl x509 -enddate -noout -in %pemfile%
:EOF
echo.
set /p DUMMY=Hit ENTER to exit...
EXIT
