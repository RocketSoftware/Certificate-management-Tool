::::::::::::::::::::::::::::::::::
:
: Rocket Software Confidential
: OCO Source Materials
: Copyright (C) Rocket Software. 2017
: 
:
: @(:) $0 : certificate converter help
:           for a U2 DB system
:	by : Nik Kesic
:	   : U2 Support Denver - USA
: Synopsis:
:
: rem name pfxhelp
:
:         for Windows 2008, 7, - 64 bit
:           
:
:
::::::::::::::::::::::::::::::::::
@ECHO OFF
CLS
MODE CON: COLS=85 LINES=65
ECHO.
for %%X in (openssl.exe) do (set FOUND=%%~$PATH:X)
:if defined FOUND ...
:pfxhelp
   echo.
   echo. openssl must be locally installed and acccesible for this script to work!
   echo. openssl must be 1.0.2 or later. UDT 8.1.2 or UniVerse 11.2.5 or later
   echo.
   echo. Modify scertmgr.cmd file to reflect the correct location of PATH and JRE_HOME
   echo. and OPENSSL_PATH
   echo. 
   echo. Your CMD session must be started with 'run as administrator'
   echo.
   echo. Run scertmgr.cmd prior to running pfxmenu.bat
   echo.
set /p DUMMY=Hit ENTER to continue...
ECHO.      ..................................................................
ECHO.      .    Rocket Software Certificate Management Tool                 .
ECHO.      ..................................................................
ECHO.      .                                                                .
ECHO.      .  1 - Creating a CSR and self-signed certificate                .
ECHO.      .  2 - SSL Test Server                                           .
ECHO.      .  3 - SSL Test Client                                           .
ECHO.      .  4 - PEM Certificate Expiration Date                           .
ECHO.      .  5 - Using the Certificate format converter (PFX to PEM)       .
ECHO.      .  6 - Certificate format converter (PEM to PFX)                 .
ECHO.      .  7 - Certificate signing chain converter (PEM to PFX)          .
ECHO.      .  8 - Certificate store format converter (PFX to PEM)           .
ECHO.      .  9 - Certificate Import to Java KeyStore)                      .
ECHO.      . 10 - PFX file content viewer                                   .
ECHO.      . 11 - Java KeyStore content viewer                              .
ECHO.      . 12 - Java KeyStore file extraction                             .
ECHO.      .  V - This tools Version                                        .
ECHO.      .  ? - Help README                                               .
ECHO.      .  Q - EXIT                                                      .
ECHO.      ..................................................................
ECHO.
set /p DUMMY=Hit ENTER to continue...
   echo. Option (1) This option Will create a password protected private key and  
   echo.            A certificate signing request (CSR). And if required this option
   echo.            will create a self signed certificate.
   echo. Option (2) SSL Test Server. This option starts up a local stand-alone secure server 
   echo.            using the certificates of the local machine.
   echo. Option (3) SSL Test Client . This option is used to test connections to a 
   echo.            secure SSL server.
   echo. Option (4) This option will read a PEM certificate start and end dates.
   echo. Option (5) This option extracts and converts a pfx certificate 
   echo.            file with private key to pkcs#8 PEM format. 
   echo.            If a CA (signing) certificate is included in the pfx file, 
   echo.            it will also be extracted and converted to PEM format.
   echo.            This option requires the password for the private key.
   echo. Option (6) This option converts a PEM certificate 
   echo.            file and its private key to pkcs#12 pfx format. 
   echo.            If a CA (signing) certificate is included,  
   echo.            it will also be places inside the created pfx file.
   echo.            This option requires the password for the private key and pfx file.
set /p DUMMY=Hit ENTER to continue...
   echo. Option (7) PEM Chain Certificates and Private Key to PFX file conversion. 
   echo. Option (8) This option extracts all the certificates contained 
   echo.            within the pfx file and produces one PEM format file.
   echo.            This option should be used if you export all certificates
   echo.            from a microsoft certificate store such as the 
   echo.            "Trusted Root Certificate Store".  
   echo.            This option requires the password of the extracted pfx file.
   echo. Option (9) This option uses an existing Java Key Store or creates a new key  
   echo.            store and populates the store with the contents of the pfx file.
   echo.            Passwords are required for the new or old java key store and to 
   echo.            extract the pfx file.
   echo. Option (10) This option Will display the content of a pxf file. 
   echo. Option (11) This option will look into a Java KeyStore (JKS). password is required.
   echo. Option (12) This option will extract a certificate from Java KeyStore (JKS). 
   echo.            password is required.
   echo. Option (v) This tools Version
   echo. Option (?) Help
   echo. Option (Q) Exit the Menu
   echo.
SET /P M= Any key to exit : 
IF %M%== GOTO EOF
:EOF
exit
:    