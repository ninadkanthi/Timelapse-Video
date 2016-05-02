#!/bin/bash
DATE=$(date +"%Y-%m-%d_%H%M")
ls *.jpg > stills.txt
mencoder -nosound -ovc lavc -lavcopts vcodec=mpeg4:aspect=16/9:vbitrate=8000000 -vf scale=1920:1080 -o $DATE-timelapse.avi -mf type=jpeg:fps=24 mf://@stills.txt
#mv -f *.jpg ../backup
