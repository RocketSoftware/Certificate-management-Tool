@ECHO OFF
:cls
::::::::::::::::::::::::::::::::::
:
: Rocket Software Confidential
: OCO Source Materials
: Copyright (C) Rocket Software. 2017
: 
:
: @(:) $0 : script for creating a ertificate request with an option to create 
:           a self-signed pkcs#8 certificate (.cer) and a pkcs#12 certificate (.pfx) 
:           for a U2 DB system
:	by : Nik Kesic
:	   : U2 Support Denver - USA
: Synopsis:
:
:     pfxconv05
:
:         for Windows 2008, 7, - 64 bit
:           
:
:
::::::::::::::::::::::::::::::::::
:
cls
:
set OPENSSL_CONF=.\openssl.cnf
:
echo. ++++++++++++++++++++++++++++++++++++++++
echo.  Create CSR and Self-Signed Certificate
echo. ++++++++++++++++++++++++++++++++++++++++
echo.      
:
rem set pfxfile=mytest
::
:pfxstart
set /p INPUT=Enter name and path of the CSR file : 
IF  NOT (%INPUT%)==() (
set pfxfile=%INPUT%
) ELSE (
echo "bad input"
goto pfxstart
)
openssl genrsa -out %pfxfile%.rsa 2048 
openssl rsa -in %pfxfile%.rsa -pubout > %pfxfile%.pub
:country
set country=US
set /p INP3=Country Name (2 letter code) [US]:  
IF  NOT (%INP3%)==() (
set country=%INP3%
) ELSE (
echo. " bad input"
goto country
)
:state
rem set state=Some-State
set /p INP4=State or Province Name (full name) []: 
IF  NOT (%INP4%)==() (
set state=%INP4%
) ELSE (
echo. " bad input"
goto state
)
:city
rem set city=Denver
set /p INP5=Locality Name (eg, city) []:  
IF  NOT (%INP5%)==() (
set city=%INP5%
) ELSE (
echo. " bad input"
goto city
)
:orgname
rem set orgname=Rocket Software
set orgname=
SET /P orgname=Organization Name (eg, company) []: 
IF "%orgname%"=="" goto ErrorOrgname
goto unit
:ErrorOrgname
echo Bad Input!!
goto orgname
:unit
rem set unit=U2 Lab
set /p unit=Organizational Unit Name (eg, section) []: 
IF  "%unit%"=="" goto ErrorUnit
goto domname
:ErrorUnit
echo " bad input"
goto unit
)
:domname
rem set domname=den-l-nk01.rocketsoftware.com
set /p INP8=Common Name (e.g. server Fully Qualified Domain Name) []:  
IF  NOT (%INP8%)==() (
set domname=%INP8%
) ELSE (
echo. " bad input"
goto domname
)
:email
rem set email=nkesic@rs.com
set /p INP9=Email Address []:
IF  NOT (%INP9%)==() (
set email=%INP9%
) ELSE (
echo. " bad input"
goto email
)
:algoIN
rem set algo=sha256
set /p INP12=Sha1 or sha2 type certificate (sha1/sha2):
IF  NOT (%INP12%)==() (
set algoIN=%INP12%
) ELSE (
echo. " bad input"
goto algoIN
)
IF %algoIN%==sha2 (
set algo=sha256
) ELSE (
set algo=%INP12%
)
:age
set age=365
set /p INP10=Certificate Age limit [365]:
IF  NOT %INP10%==() (
set age=%inp10%
) ELSE (
echo. " bad input"
goto age
)
echo.
pause
echo. 
echo Country = %country%
echo State = %state%
echo Locality = %city%
echo Organization = %orgname%
echo Organization Name = %unit%
echo Common Name = %domname%
echo Email Adress = %email%
echo Algorithm = %algo%
echo Certificate Age = %age%
echo.
:
echo                 If list above is ok, hit (y) or (n) to go back!
set INPUT=
set /P INPUT=Type input: %=%
If /I "%INPUT%"=="y" goto pfxcont 
If /I "%INPUT%"=="n" goto pfxstart
:
:pfxcont
echo 1
echo.
echo 2
   openssl.exe pkcs8 -v1 PBE-SHA1-3DES -topk8 -in %pfxfile%.rsa -out %pfxfile%.pvt
echo 3 
:
::  openssl req -new -%algo% -digest sha1 -subj "/C=%country%/ST=%state%/L=%city%/O=%orgname%/CN=%domname%/emailAddress=%email%/OU=%unit%" -key %pfxfile%.pvt -out %pfxfile%.req
:: echo  openssl req -new -%algo% -subj "/C=%country%/ST=%state%/L=%city%/O=%orgname%/CN=%domname%/emailAddress=%email%/OU=%unit%" -key %pfxfile%.pvt -out %pfxfile%.req -passin pass:password
  openssl req -new -%algo% -subj "/C=%country%/ST=%state%/L=%city%/O=%orgname%/CN=%domname%/emailAddress=%email%/OU=%unit%" -key %pfxfile%.pvt -out %pfxfile%.req -passin pass:password
   openssl req -text -noout -verify -in %pfxfile%.req
:
set /p INP11=Do you want to create a self-signed certificate [y/n]:
IF  %INP11%==y (
openssl x509 -%algo% -signkey %pfxfile%.pvt -in %pfxfile%.req -req -days %age% -out %pfxfile%.cer 
:
echo "Private Key and CSR and self-signed certificate created!"
openssl pkcs12 -passin pass:password -export -out %pfxfile%.pfx -inkey %pfxfile%.pvt -in %pfxfile%.cer
echo "Self-signed PFX certificate created!" 
) ELSE (
echo.The following files were created:
echo.================================================================
echo.
dir /B %pfxfile%*
goto END
)
:
echo.
:
echo.The following files were created:
echo.================================================================
echo.
dir /B %pfxfile%*
set INP1=
set INP2=
set INP3=
set INP4=
set INP5=
set INP6=
set INP7=
set INP8=
set INP9=
set INP10=
set INP11=
set country=
set state=
set city=
:END
:echo.
echo "Task Completed"
pause
exit