::::::::::::::::::::::::::::::::::
:
: Rocket Software Confidential
: OCO Source Materials
: Copyright (C) Rocket Software. 2017
: 
:
: @(:) $0 : MS exported certificate store pfx file to pkcs#8 file 
:           for a U2 DB system
:	by : Nik Kesic
:	   : U2 Support Denver - USA
: Synopsis:
:
: rem name pfxconv2
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
echo. +++++++++++++++++++++++++++++++++
echo.  PFX Certificate Store Converter
echo. +++++++++++++++++++++++++++++++++
echo.      
:
:pfxconv2
set /p pfxfile=Enter name of the PFX file : %pfxfile%
IF "%pfxfile%"=="" goto Errorpfxconv1
goto rootName
:Errorpfxconv1
echo Bad Input!!
goto pfxconv2
:
:rootName
set /p rootName=Enter name for the server root certificate : %rootName%
IF "%rootName%"=="" goto ErrorrootName
goto pvtPass
:ErrorrootName
echo Bad Input!!
goto rootName
:
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
:
openssl pkcs12 -cacerts -in %pfxfile% -nodes -out %rootName% -passin pass:%pvtPass%
:END
echo.
SET /P M= Any key to exit : 
IF %M%== GOTO EOF
:EOF
exit