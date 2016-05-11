#Edit the /etc/rc/local file and insert the following line at the end of the file. This will ensure that the photo processing happens once the machine boots up
/home/linuxuser/createavi.sh &
#The content of your /etc/rc.local should look like following
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.
/home/linuxuser/createavi.sh &

exit 0
