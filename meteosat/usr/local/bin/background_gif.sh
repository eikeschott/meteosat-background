#!/bin/bash

#Hurricane glob: {*2019_10_??_10.jpg,*2019_09_{26..30}_12.jpg}
#This script creates an animated gif from a user selected list of files.

#read globbing string
read -rp "Please enter a globbing string to select files eg. {*2019_10_??_10.jpg,*2019_09_{26..30}_12.jpg}:"$'\n' glob

#read output filename and append ".gif"
read -rp "How should the animated gif be named?"$'\n' filename

#read output format
read -rp "Please insert the resize format in order to keep filesize reasonable. Default:720x720"$'\n' resize
resize=${resize:-720x720}

#read delay between each frame
read -rp "Please insert the delay in milliseconds between each frame. Default: 50"$'\n' delay
delay=${delay:-50}


key=$(sed -n 1p ~/.local/bin/credentials.txt)
port=$(sed -n 2p ~/.local/bin/credentials.txt)
serv=$(sed -n 3p ~/.local/bin/credentials.txt)
ftpserv=$(sed -n 4p ~/.local/bin/credentials.txt)

#Double check the number of selected files and report to user in order to avoid errors in globbing string
count=$(ssh $key $port $serv <<EOF
	shopt -s extglob
	ls -la /mnt/drive1/backgrounds/earth/*/*/${glob} | wc -l
EOF
)
echo "The gif you are about to create contains $count images."
read -rp "Do you want to continue? [y|n]"$'\n' continue

#Create the actual gif
if [ "$continue" == "y" ]; then
ssh $key $port $serv <<-EOF
	shopt -s extglob
	cd /mnt/drive1/backgrounds/earth || exit
	/usr/bin/convert -resize "$resize" -delay "$delay" -loop 0 ./*/*/${glob} 01_gifs/"$filename"
	/bin/echo "Processing finished!. Do you want to open the created gif now? [y/n]"
EOF
read -r open

#Download the created gif to the Desktop and open it with xviewer
if [ "$open" == "y" ]; then
  cd ~/Desktop || exit
  /usr/bin/lftp ftp://$ftpserv/01_gifs/ <<-EOF
    mget -P 10 $filename
EOF
/usr/bin/xviewer ~/Desktop/"$filename"
fi
else
	echo "Exiting..."
fi
