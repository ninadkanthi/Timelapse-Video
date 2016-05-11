#!/bin/bash
#echo ---------- Creating Share  directory  -----------
#mkdir Share
echo ----------   Mounting Share  ---------
sudo mount.cifs //nkimages.file.core.windows.net/linuxshare/Share /home/linuxuser/Share -o vers=2.1,username=nkimages,password=[Insert your Key here]
#echo ---------- Creating backup directory  ---------
#mkdir backup
echo -----------  Mounting backup ---------
sudo mount.cifs //nkimages.file.core.windows.net/linuxshare/backup /home/linuxuser/backup -o vers=2.1,username=nkimages,password=[Insert your Key here]

echo ----------- chaging the folder to Home folder ------------
cd /home/linuxuser/Share
DATE=$(date +"%Y-%m-%d_%H%M")
echo ----------- copying the  jpg to stills.txt ------
ls /home/linuxuser/Share/*.jpg > /home/linuxuser/Share/stills.txt
mencoder -nosound -ovc lavc -lavcopts vcodec=mpeg4:aspect=16/9:vbitrate=8000000 -vf scale=1920:1080 -o /home/linuxuser/Share/$DATE-timelapse.avi -mf type=jpeg:fps=24 mf://@/home/linuxuser/Share/st$
echo -----------  moving the file  -----------
mv -f /home/linuxuser/Share/*.jpg /home/linuxuser/backup
