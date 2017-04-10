@ECHO OFF
:cls
::::::::::::::::::::::::::::::::::
:
: Rocket Software Confidential
: OCO Source Materials
: Copyright (C) Rocket Software. 2017
: 
:
: @(:) $0 : script for converting a microsoft pfx file to pkcs#8 
:           for a U2 DB system
:	by : Nik Kesic
:	   : U2 Lab Denver - USA
: Synopsis:
:
: rem name pfxconv1 
:
:         for Windows 2008, 7, - 64 bit
:           
:
:
::::::::::::::::::::::::::::::::::
:
cls
:
echo. +++++++++++++++++++++++++++++++++++++++
echo.  PFX (PKCS#12) to PEM PKCS#8 Converter
echo. +++++++++++++++++++++++++++++++++++++++
echo.      
:
rem set pfxfile=mytest
::
:pfxconv1
set /p pfxfile=Enter name of the PFX file : %pfxfile%
IF "%pfxfile%"=="" goto Errorpfxconv1
goto rootName
:Errorpfxconv1
echo Bad Input!!
goto pfxconv1
:rootName
set /p rootName=Enter new name for the server root certificate : %rootName%
IF "%rootName%"=="" goto ErrorrootName
goto pvtPass
:ErrorrootName
echo Bad Input!!
goto rootName
:pvtPass
set "psCommand=powershell -Command "$pword = read-host 'Enter Password' -AsSecureString ; ^
    $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword); ^
        [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)""
for /f "usebackq delims=" %%p in (`%psCommand%`) do set pvtPass=%%p
IF "%pvtPass%"=="" goto ErrorpvtPass
goto nnext
:ErrorpvtPass
echo Bad Input!!
goto pvtPass
:nnext
echo.
pause
:      
openssl pkcs12 -in %pfxfile% -clcerts -nokeys -out %rootName%.cer -passin pass:%pvtPass%
openssl pkcs12 -in %pfxfile% -nocerts -nodes -out %rootName%-pkcs7wh.pvt -passin pass:%pvtPass%
openssl rsa -in %rootName%-pkcs7wh.pvt -out %rootName%-pkcs7.pvt
openssl pkcs12 -in %pfxfile% -out %rootName%CA.cer -nodes -nokeys -cacerts -passin pass:%pvtPass%

echo.

    openssl.exe pkcs8 -v1 PBE-SHA1-3DES -topk8 -in %rootName%-pkcs7.pvt -out %rootName%.pvt -passout pass:%pvtPass%
	openssl x509 -in %rootName%.cer > %rootName%conv.cer
:
:
call :deleteIfEmpty %rootName%CA.cer
exit /b
:
:deleteIfEmpty
if %~z1 == 0 (echo CA certificate cannot be found.
echo.
del %1
)else (openssl x509 -in %rootName%CA.cer > %rootName%CAconv.cer
)
:
:        
del %rootName%-pkcs7wh.pvt %rootName%-pkcs7.pvt %rootName%.cer %rootName%CA.cer
ren %rootName%conv.cer %rootName%.cer
if exist %rootName%CAconv.cer (
ren %rootName%CAconv.cer %rootName%CA.cer
)
set pvtPass=
:
echo.The following files were extracted:
echo.================================================================
echo.
dir /B %rootName%*
set pfxfile=
set rootName=
set pvtPass=
echo.
SET /P M= Any key to exit : 
IF %M%== GOTO EOF
:EOF
exit
