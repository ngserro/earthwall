#!/bin/bash

# * Name: earthwall.sh
# * Description: Downloads random image from earthview.withgoogle.com and sets as wallpaper on OSX
# * Author: Nuno Serro
# * Date: 09/07/2015 22:24:11 WEST
# * License: This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# * Copyright (c) 2015, Nuno Serro

# Test if OSX
if [ "$(uname -s)" != "Darwin" ] ; then
	echo "This script only works on OSX"
	exit 1
fi

mkdir -p $HOME/Pictures/earthwall
osversion=$(sw_vers -productVersion | sed 's/10.//1')

# Get page index
/usr/local/bin/wget -q http://earthview.withgoogle.com -O $HOME/Pictures/earthwall/.index.html 2> /dev/null
if [ $? -ne 0 ]; then
	echo "Failed to get index from earthview.withgoogle.com"
	exit 1
fi

# Set image url, name and location
image_url=`cat $HOME/Pictures/earthwall/.index.html | grep prettyearth | grep 'https://www.gstatic.com/prettyearth/assets/full/[0-9]\{0,6\}.jpg' -m 1 -o | head -1`
image_name=`echo $image_url | grep '[0-9]\{0,6\}.jpg' -m 1 -o`

#TODO: Find a way to retrieve image location. Possibly from title html tags?
#cat $HOME/Pictures/earthwall/.index.html | awk -vRS="</title>" '/<title>/{gsub(/.*<title>|\n+/,"");print;exit}' > $HOME/Pictures/earthwall/.image_location
#image_location=`cat $HOME/Pictures/earthwall/.image_location | sed 's/, /,/g' | sed 's/ /_/g'`
#image_location=test

# Get image
/usr/local/bin/wget -q $image_url -O $HOME/Pictures/earthwall/$image_location-$image_name 2> /dev/null
if [ $? -ne 0 ]; then
	echo "Failed to get image from www.gstatic.com"
	exit 1
fi

# Apple script tested in El Capitan
osa_capitan="set theFile to POSIX file \"$HOME/Pictures/earthwall/$image_location-$image_name\"\n
set theDesktops to {}\n
\n
tell application \"System Events\"\n
    set theDesktops to a reference to every desktop\n
    repeat with aDesktop in theDesktops\n
        set picture of aDesktop to theFile\n
    end repeat\n
end tell"

# Change wallpaper
sleep 1
if [ $(bc <<< "$osversion<10.0") -eq "1" ] ; then
	var=$(echo "osascript -e 'tell application \"Finder\" to set desktop picture to POSIX file \"$HOME/Pictures/earthwall/$image_location-$image_name\"'")
	eval $var
else
	sqlite3 ~/Library/Application\ Support/Dock/desktoppicture.db "update data set value = '$HOME/Pictures/earthwall/$image_location-$image_name'"
	echo -e $osa_capitan | /usr/bin/osascript
fi
killall Dock

echo "Wallpaper changed to $image_location-$image_name"
exit 0
