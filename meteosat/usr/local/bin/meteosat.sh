#!/bin/bash
/bin/date #Print the current date and time - useful for logging

# Set the DBUS_SESSION_BUS_ADDRESS environment variable
euid=$(id --real --user)
pid=$(pgrep --euid $euid cinnamon-sess)
export DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$pid/environ|cut -d= -f2-)

#Create background dir
mkdir -p ~/.background_meteosat
cd ~/.background_meteosat || exit

#Download the image
/usr/bin/wget -O EUMETSAT_MSG_RGBNatColourEnhncd_FullResolution.jpg https://eumetview.eumetsat.int/static-images/latestImages/EUMETSAT_MSG_RGBNatColourEnhncd_FullResolution.jpg
/bin/sleep 3s

#Crop image at location where the year is displayed and set filename from there.
/usr/bin/convert EUMETSAT_MSG_RGBNatColourEnhncd_FullResolution.jpg -crop 90x40+3220+3650 year.pbm
year=$(/usr/bin/gocr -u 1 -C 0-9 year.pbm)
/bin/echo "Detected year is: $year"

#Crop image at location where the month is displayed and set filename from there.
/usr/bin/convert EUMETSAT_MSG_RGBNatColourEnhncd_FullResolution.jpg -crop 45x40+3328+3650 month.pbm
month=$(/usr/bin/gocr -u 1 -C 0-9 month.pbm)
/bin/echo "Detected month is: $month"

#Crop image at location where the day is displayed and set filename from there.
/usr/bin/convert EUMETSAT_MSG_RGBNatColourEnhncd_FullResolution.jpg -crop 50x40+3385+3650 day.pbm
day=$(/usr/bin/gocr -u 1 -C 0-9 day.pbm)
/bin/echo "Detected day is: $day"

#Crop image at location where the hour is displayed and set filename from there.
/usr/bin/convert EUMETSAT_MSG_RGBNatColourEnhncd_FullResolution.jpg -crop 50x40+3440+3650 hour.pbm
hour=$(/usr/bin/gocr -u 1 -C 0-9 hour.pbm)
/bin/echo "Detected hour is: $hour"

#Parse string to append to filename
app="$year"_"$month"_"$day"_"$hour"

filepath=~/.background_meteosat/EUMETSAT_MSG_RGBNatColourEnhncd_FullResolution_"$app".jpg

# 
if [ ! -s "${filepath}" ]; then
	#Renaming the image
	mv EUMETSAT_MSG_RGBNatColourEnhncd_FullResolution.jpg EUMETSAT_MSG_RGBNatColourEnhncd_FullResolution_"$app".jpg

	#Parsing an annotation
	annot="$day.$month.$year $hour:00 UTC"
	/bin/echo "The annotation is: ""$annot" #Output the annotation for logging purposes

	#Overwriting the original image with the annotated one
	/usr/bin/convert -pointsize 64 -font DejaVu-Sans -fill white -annotate +2900+200 "$annot" "$filepath" "$filepath"

	echo "I'm here"
	path="\"file://"$filepath"\""
	/bin/echo $filepath
	/usr/bin/gsettings set org.cinnamon.desktop.background picture-uri $path
	/usr/bin/gsettings set org.cinnamon.desktop.background picture-options scaled
fi

#Go to directory and delete every file except the current background
cd ~/.background_meteosat || exit
shopt -s extglob
/bin/echo "${filepath}"
rm !($(/usr/bin/basename "${filepath}"))

/bin/date
/bin/echo "================================================================================================================"
