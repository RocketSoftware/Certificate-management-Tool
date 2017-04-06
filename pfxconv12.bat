@ECHO OFF
:cls
set /p INPUT=Enter name and path of the certificate file : 
IF  NOT (%INPUT%)==() (
set pfxfile=%INPUT%
) ELSE (
echo "bad input"
)
echo.
openssl x509 -startdate -noout -in %pfxfile%
openssl x509 -enddate -noout -in %pfxfile%
rem openssl x509 -checkend 86400 -in %pfxfile%
:EOF
echo.
set /p DUMMY=Hit ENTER to exit...
EXIT
