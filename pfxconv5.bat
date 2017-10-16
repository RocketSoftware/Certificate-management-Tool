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
:	   : U2 Lab Denver - USA
: Synopsis:
:
: rem name pfxconv5
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
:pfxconv5
set /p pfxfile=Enter name and path of the CSR file (.req will be added) : %pfxfile%
IF "%pfxfile%"=="" goto Errorpfxconv5
goto rsa
:Errorpfxconv5
echo Bad Input!!
goto pfxconv5
:rsa
openssl genrsa -out %pfxfile%.rsa 2048 
openssl rsa -in %pfxfile%.rsa -pubout > %pfxfile%.pub
:country
rem set country=US
set /p country=Country Name (2 letter code) [%country%]:  
IF "%country%"=="" goto ErrorCountry
goto state
:ErrorCountry
echo Bad Input!!
goto country
:state
rem set state=Some-State
set /p state=State or Province Name (full name) [%state%]: 
IF "%state%"=="" goto ErrorState
goto city
:ErrorState
echo Bad input!!
goto state
)
:city
rem set city=Denver
set /p city=Locality Name (eg, city) [%city%]:  
IF "%city%"=="" goto ErrorCity
goto orgname
:ErrorCity
echo Bad Input!!
goto city
)
:orgname
rem set orgname=Rocket Software
rem set orgname=
SET /P orgname=Organization Name (eg, company) [%orgname%]: 
IF "%orgname%"=="" goto ErrorOrgname
goto unit
:ErrorOrgname
echo Bad Input!!
goto orgname
:unit
rem set unit=U2 Lab
set /p unit=Organizational Unit Name (eg, section) [%unit%]: 
IF  "%unit%"=="" goto ErrorUnit
goto domname
:ErrorUnit
echo Bad input!!
goto unit
)
:domname
rem set domname=den-l-nk01.rocketsoftware.com
set /p domname=Common Name (e.g. server Fully Qualified Domain Name) [%domname%]:  
IF  "%domname%"=="" goto ErrorDomname
goto email
:ErrorDomname
echo Bad input!!
goto domname
:email
rem set email=nkesic@rs.com
set /p email=Email Address [%email%]:
IF  "%email%"=="" goto ErrorEmail
goto algoIN
:ErrorEmail
echo Bad input!!
goto email
:algoIN
rem set algo=sha256
set /p algoIN=Sha1 or sha2 type certificate (sha1/sha2): %algoIN%
IF  "%algoIN%"=="" goto ErrorAlgoIN
IF %algoIN%==sha2 (
set algo=sha256
) ELSE (
set algo=%algoIN%
)
goto age
:ErrorAlgoIN
echo Bad input!!
goto algoIN
:age
rem set age=365
set /p age=Certificate Age limit [%age%]:
IF  "%age%"=="" goto ErrorAge
goto pvtPass1
:ErrorAge
echo Bad input!!
goto age
:pvtPass1
set "psCommand=powershell -Command "$pword = read-host 'Enter Password' -AsSecureString ; ^
    $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword); ^
        [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)""
for /f "usebackq delims=" %%p in (`%psCommand%`) do set pvtPass1=%%p
IF "%pvtPass1%"=="" goto ErrorpvtPass1
goto pvtPass2
:ErrorpvtPass1
echo Bad Input!!
goto pvtPass1
:pvtPass2
set "psCommand=powershell -Command "$pword = read-host 'Re-Enter Password' -AsSecureString ; ^
    $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword); ^
        [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)""
for /f "usebackq delims=" %%p in (`%psCommand%`) do set pvtPass2=%%p
IF "%pvtPass2%"=="" goto ErrorpvtPass2
IF not "%pvtPass1%"=="%pvtPass2%" goto ErrorpvtPassm
goto nnext
:ErrorpvtPass2
echo Bad Input!!
goto pvtPass2
:ErrorpvtPassm
echo Passwords Don't match!!
goto pvtPass1
:nnext
echo.
echo Passwords match!!
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
rem echo Private Key password = %pvtPass1%
echo.
:
echo                 If list above is ok, hit (y) or (n) to go back!
set INPUT=
set /P INPUT=Enter (y) or (n): %=%
If /I "%INPUT%"=="y" goto pfxcont 
If /I "%INPUT%"=="n" goto pfxconv5
:
:pfxcont
echo.
:   openssl.exe pkcs8 -v1 PBE-SHA1-3DES -topk8 -in %pfxfile%.rsa -out %pfxfile%.pvt -passin pass:%pvtPass1%
   openssl.exe pkcs8 -topk8 -in %pfxfile%.rsa -out %pfxfile%.pvt -passin pass:%pvtPass1%
:
  openssl req -new -%algo% -subj "/C=%country%/ST=%state%/L=%city%/O=%orgname%/CN=%domname%/emailAddress=%email%/OU=%unit%" -key %pfxfile%.pvt -out %pfxfile%.req -passin pass:%pvtPass1%
  openssl req -text -noout -verify -in %pfxfile%.req
:
set /p INP11=Do you want to create a self-signed certificate [y/n]:
IF  %INP11%==y (
openssl x509 -%algo% -signkey %pfxfile%.pvt -in %pfxfile%.req -req -days %age% -out %pfxfile%.cer 
:
echo "Private Key and CSR and self-signed certificate created!"
openssl pkcs12 -passin pass:%pvtPass1% -export -out %pfxfile%.pfx -inkey %pfxfile%.pvt -in %pfxfile%.cer
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
REM set pfxfile=
REM set country=
REM set state=
REM set city=
REM set orgname=
REM set unit=
REM set domname=
REM set email=
REM set algoIN=
REM set age=
REM set pvtPass1=
REM set pvtPass2=
:END
:echo.
echo "Task Completed"
pause
exit