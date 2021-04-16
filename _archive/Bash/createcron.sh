#!/bin/bash
cd /home/
mkdir /home/root/
mkdir /home/root/Documents
mkdir /home/root/Downloads
mkdir /home/root/Music
mkdir /home/root/Videos
mkdir /home/root/Pictures
cd /home/root/Documents
chown -R root /home/root/
touch autoupdate.sh
touch autoreboot.sh
echo $"#!/bin/bash\napt-get update && apt-get upgrade -y" >> autoupdate.sh
echo $"#!/bin/bash\nreboot" >> autoreboot.sh
chown root auto*
chmod u+x auto*
crontab -l | { cat; echo -e "29 0 * * 0-6 root /home/root/autoupdate.sh\n29 0 * * 0,2,4,6 root /home/root/autoreboot.sh"; } | crontab -