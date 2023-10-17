@ECHO off
cls
:start
ECHO Bienvenue dans le script de cryptage / decryptage de fichier appServer.exe.config
findstr /m "CipherValue" appServer.exe.config >Nul
if %errorlevel%==0 (
echo Statut du fichier : crypte
)
if %errorlevel%==1 (
echo Statut du fichier : decrypte
)
ECHO -----------------------------------------------------------
ECHO.
ECHO 1. Crypter le fichier de configuration
ECHO 2. Decrypter le fichier de configuration
ECHO 3. Importer la clef publique de chiffrement
ECHO 4. Suprimer le fichier le fichier non crypte appServer.exe.config.bak
ECHO 5. Supprimer le conteneur de cle importee
ECHO 6. Supprimer le fichier keys.xml
ECHO 7. Quitter
ECHO.
ECHO -----------------------------------------------------------
ECHO Entrez votre choix :
ECHO.
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto crypt
if '%choice%'=='2' goto decrypt
if '%choice%'=='3' goto import
if '%choice%'=='4' goto deletebak
if '%choice%'=='5' goto deletekey
if '%choice%'=='6' goto deletexml
if '%choice%'=='7' exit

ECHO "%choice%" n'est pas valide, reessayez
ECHO.
goto start
:crypt
copy appServer.exe.config web.config
rename appServer.exe.config appServer.exe.config.bak
%windir%\Microsoft.NET\Framework64\v4.0.30319\aspnet_regiis.exe  -pc MyCustomKeys -exp
%windir%\Microsoft.NET\Framework64\v4.0.30319\aspnet_regiis.exe  -pef connectionStrings . -prov MyEncryptionProvider
%windir%\Microsoft.NET\Framework64\v4.0.30319\aspnet_regiis.exe  -px  MyCustomKeys keys.xml -pri
copy web.config appServer.exe.config
del web.config
goto end
:decrypt
copy appServer.exe.config web.config
%windir%\Microsoft.NET\Framework64\v4.0.30319\aspnet_regiis.exe  -pdf connectionStrings .
copy web.config appServer.exe.config
del web.config
goto end
:import
%windir%\Microsoft.NET\Framework64\v4.0.30319\aspnet_regiis.exe -pi MyCustomKeys keys.xml
goto end
:deletebak
del appServer.exe.config.bak
goto end
:deletekey
%windir%\Microsoft.NET\Framework64\v4.0.30319\aspnet_regiis.exe  -pz  MyCustomKeys
goto end
:deletexml
del keys.xml
goto end
:end
ECHO Fin du choix, retour au menu principal
ECHO.
ECHO.
goto start
pause