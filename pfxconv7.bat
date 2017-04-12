::::::::::::::::::::::::::::::::::
:
: Rocket Software Confidential
: OCO Source Materials
: Copyright (C) Rocket Software. 2017
: 
:
: @(:) $0 : script for converting pkcs#8 cert and pvtkey to pfx file
:           for a U2 DB system
:	by : Nik Kesic
:	   : U2 Support Denver - USA
: Synopsis:
:
: rem name    pfxconv7
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
echo. +++++++++++++++++++++++++++++++++++++++++++++++
echo.  PEM Chain Certificates and Private Key to PFX
echo. +++++++++++++++++++++++++++++++++++++++++++++++
echo.      
:
rem rem if exist certChain.cer (ren certchain.cer certChain.cer)
set INPUT="no entry"
:
:pfxconv7
set /p pemfile=Enter name of the PEM Certificate file : %pemfile%
IF "%pemfile%"=="" goto ErrorpemFile
goto pvtfile
:ErrorpemFile
echo Bad Input!!
goto pfxconv7
:
:pvtfile
set /p pvtfile=Enter name of the Private Key file : %pvtfile%
IF "%pvtfile%"=="" goto ErrorpvtFile
goto cafile
:ErrorpvtFile
rem echo Bad Input!!
rem goto pvtfile
:
set /p numc=How Many Intermediate Certificates : 
FOR /L %%G IN (1,1,%numc%) DO set /p neddy=Enter name of the intermediate file %%G : & type %neddy% >>certChain.cer & echo. >>certChain.cer 
:
:cafile
set /p cafile=Enter name of the CAfile file :  
IF "%cafile%"=="" goto ErrorcaFile
goto pfxfile
:ErrorcaFile
set cafile=%pemfile%
:
:pfxfile
set /p pfxfile=Enter name for the PFX file :  
IF "%pfxfile%"=="" goto ErrorpfxFile
goto nnext
:ErrorpfxFile
echo Bad Input!!
goto pfxfile
:
:nnext
type %INP5% >>certChain.cer
:
openssl pkcs12 -export -in %pemfile% -certfile certChain.cer -inkey %pvtfile% -out %pfxfile% 
:
echo.
dir /B %pfxfile%*
SET /P M= Any key to exit : 
IF %M%== GOTO EOF
:EOF
::::exit
