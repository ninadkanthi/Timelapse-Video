@echo off
set puttydir=C:\Downloads\Linux\
set prjdir=C:\raspberrypi2\UploadPhoto\ConsoleApplication1\
rem set rpi_ip=raspberrypi
set rpi_ip=192.168.0.8
set rpi_usr=pi
set rpi_pw=raspberry

rem echo Creating UploadPhoto directory
echo mkdir UploadPhoto > %temp%\uploadphototmp
%puttydir%putty %rpi_usr%@%rpi_ip% -pw %rpi_pw% -m %temp%\uploadphototmp

echo Copying Gateway and logging files
%puttydir%pscp -pw %rpi_pw% %prjdir%bin\Release\UploadPhotoApp.exe %rpi_usr%@%rpi_ip%:UploadPhoto/
%puttydir%pscp -pw %rpi_pw% %prjdir%bin\Release\NLog.config %rpi_usr%@%rpi_ip%:UploadPhoto/
%puttydir%pscp -pw %rpi_pw% %prjdir%bin\Release\UploadPhotoApp.exe.config %rpi_usr%@%rpi_ip%:UploadPhoto/

%puttydir%pscp -pw %rpi_pw% %prjdir%bin\Release\Microsoft.Azure.KeyVault.Core.dll %rpi_usr%@%rpi_ip%:UploadPhoto/
%puttydir%pscp -pw %rpi_pw% %prjdir%bin\Release\Microsoft.Data.Edm.dll %rpi_usr%@%rpi_ip%:UploadPhoto/
%puttydir%pscp -pw %rpi_pw% %prjdir%bin\Release\Microsoft.Data.OData.dll %rpi_usr%@%rpi_ip%:UploadPhoto/
%puttydir%pscp -pw %rpi_pw% %prjdir%bin\Release\Microsoft.Data.Services.Client.dll %rpi_usr%@%rpi_ip%:UploadPhoto/
%puttydir%pscp -pw %rpi_pw% %prjdir%bin\Release\Microsoft.WindowsAzure.Storage.dll %rpi_usr%@%rpi_ip%:UploadPhoto/
%puttydir%pscp -pw %rpi_pw% %prjdir%bin\Release\Newtonsoft.Json.dll %rpi_usr%@%rpi_ip%:UploadPhoto/
%puttydir%pscp -pw %rpi_pw% %prjdir%bin\Release\NLog.dll %rpi_usr%@%rpi_ip%:UploadPhoto/
%puttydir%pscp -pw %rpi_pw% %prjdir%bin\Release\System.Spatial.dll %rpi_usr%@%rpi_ip%:UploadPhoto/
echo Uploading the batch file
%puttydir%pscp -pw %rpi_pw% C:\raspberrypi2\UploadPhoto\upload.sh %rpi_usr%@%rpi_ip%:UploadPhoto/


echo Marking upload.sh as executable
echo chmod +x %rpi_usr%@%rpi_ip%:UploadPhoto/upload.sh > %temp%\uploadphototmpautorunx.tmp
%puttydir%putty %rpi_usr%@%rpi_ip% -pw %rpi_pw% -m %temp%\uploadphototmpautorunx.tmp