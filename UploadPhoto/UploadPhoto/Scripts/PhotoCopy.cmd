@echo off
set puttydir=C:\Downloads\Linux\
set prjdir=C:\raspberrypi2\UploadPhoto\photos\
rem set rpi_ip=raspberrypi
set rpi_ip=192.168.0.11
set rpi_usr=pi
set rpi_pw=raspberry

Echo Copying the pictures locally
%puttydir%pscp -pw %rpi_pw% %rpi_usr%@%rpi_ip%:pictures/*.jpg %prjdir% 

echo rm -f  ~/pictures/*.jpg > %temp%\removephotos.tmp
%puttydir%putty %rpi_usr%@%rpi_ip% -pw %rpi_pw% -m %temp%\removephotos.tmp
