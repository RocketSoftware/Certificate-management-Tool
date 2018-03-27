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
echo. +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo.  PFX (PKCS#12) to PEM PKCS#8 key and X509 Certs Converter
echo. +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo.      
:
:pfxdir
set /p workdir=Enter path\name of the work directory : %workdir%
IF "%workdir%"=="" goto Errorpfxdir
IF EXIST %workdir% (
goto pfxconv5
) ELSE (
Echo Error opening file: %workdir%
set workdir=
goto pfxdir
)
:Errorpfxdir
echo Bad Input!!
goto pfxdir
::
:pfxconv5
set /p pfxfile=Enter name of the PFX file : %pfxfile%
IF "%pfxfile%"=="" goto Errorpfxconv5
IF EXIST %workdir%\%pfxfile% (
goto rootName
) ELSE (
Echo Error opening file: %pfxfile%
set pfxfile=
goto pfxconv5
)
:Errorpfxconv5
echo Bad Input!!
goto pfxconv5
:
:rootName
set /p rootFile=Enter name for the PEM certificate (.cer will be added): %rootFile%
goto pvtPass
:
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
openssl pkcs12 -in %workdir%\%pfxfile% -clcerts -nokeys -out %workdir%\%rootFile%.cer -passin pass:"%pvtPass%"
openssl pkcs12 -in %workdir%\%pfxfile% -nocerts -nodes -out %workdir%\%rootFile%-pkcs7wh.pvt -passin pass:"%pvtPass%"
openssl rsa -in %workdir%\%rootFile%-pkcs7wh.pvt -out %workdir%\%rootFile%-pkcs7.pvt
openssl pkcs12 -in %workdir%\%pfxfile% -out %workdir%\%rootFile%CA.cer -nodes -nokeys -cacerts -passin pass:"%pvtPass%"

echo.

    openssl.exe pkcs8 -topk8 -in %workdir%\%rootFile%-pkcs7.pvt -out %workdir%\%rootFile%.pvt -passout pass:"%pvtPass%"
::    openssl.exe pkcs8 -v1 PBE-SHA1-3DES -topk8 -in %workdir%\%rootFile%-pkcs7.pvt -out %workdir%\%rootFile%.pvt -passout pass:"%pvtPass%"
	openssl x509 -in %workdir%\%rootFile%.cer > %workdir%\%rootFile%conv.cer
:
:
call :deleteIfEmpty %workdir%\%rootFile%CA.cer
exit /b
:
:deleteIfEmpty
if %~z1 == 0 (echo CA signing certificate cannot be found.
echo.
del %1
)else (openssl x509 -in %workdir%\%rootFile%CA.cer > %workdir%\%rootFile%CAconv.cer
)
:
:
cd /d %workdir%        
del %rootFile%-pkcs7wh.pvt %rootFile%-pkcs7.pvt %rootFile%.cer %rootFile%CA.cer
ren %rootFile%conv.cer %rootFile%.cer
if exist %rootFile%CAconv.cer (
ren %rootFile%CAconv.cer %rootFile%CA.cer
)
::set pvtPass=
:
echo.The following files were extracted:
echo.================================================================
echo.
dir /B %rootFile%*
set pfxfile=
set rootFile=
set pvtPass=
set workdir=
echo.
SET /P M= Any key to exit : 
IF %M%== GOTO EOF
:EOF
exit
