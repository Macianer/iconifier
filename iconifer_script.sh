#!/bin/sh
# iconifier_script.sh
# Author: Ronny Meißner
#
# A bash script to render pngs files for Android or iOS.
# Require tools:
# 	- ImageMagick
#   - Inkscape
#   - pngcrush
#
# Usage: ldpi mdpi hdpi xhdpi xxhdpi xxxhdpi

source bashUtils/sub_script/text_helper.sh
source bashUtils/sub_script/dir_helper.sh
source bashUtils/sub_script/common_helper.sh
source bashUtils/sub_script/image_android.sh

#check if pngcrush is installed
checkApp pngcrush "
# # On Mac
# brew install pngcrush
#
# # On Linux
# sudo apt-get install pngcrush"

#check if inkscape is installed
checkApp inkscape "
# # On Mac
# brew cask install inkscape
#
# # On Linux
# sudo apt-get install imagemagick"

#check if ImageMagick is installed
checkApp convert "
# # On Mac
# brew install imagemagick
#
# # On Linux
# sudo apt-get install imagemagick"

#check if fontcustom is installed
checkApp fontcustom "
# see https://github.com/FontCustom/fontcustom
#
# # On Mac
# brew install fontforge --with-python
# brew install eot-utils
# sudo gem install fontcustom
#
# # On Linux
# sudo apt-get install fontforge
# wget http://people.mozilla.com/~jkew/woff/woff-code-latest.zip
# unzip woff-code-latest.zip -d sfnt2woff && cd sfnt2woff && make && sudo mv sfnt2woff /usr/local/bin/
# gem install fontcustom"
#


pwd=$(pwd)
EXPORT="$pwd/EXPORT"
IMPORT="$pwd/IMPORT"

#clear
try rm -rf ${EXPORT}

fontcustom compile -h ${IMPORT} -n "icon_font" -o "${EXPORT}"

find "${IMPORT}" -type f -iname "*.svg"  | while read file ; do
	Test $file
done

doConvertAndroid "$IMPORT/ic_nav_alert_50.svg" "$EXPORT" "1024" "50"
doConvertAndroid "$IMPORT/ic_nav_lightalert_50.svg" "$EXPORT" "1024" "50"

# define target
ANDROID_TARGET="TestProjectAndroid/app/src/main/res"

if [ -e "${EXPORT}" ]; then
	print_green "copy image files"
 	rsync -arcuP "$EXPORT/" --exclude="*.*" --include="*.png" --include="*.PNG" "${ANDROID_TARGET}"

	print_green "copy font files"
 	createDir "TestProjectAndroid/app/src/main/res/asset/"
 	rsync "$EXPORT/" --exclude="*.*" --exclude="." --include="*.ttf" --include="*.TTF" "${ANDROID_TARGET}/asset/"
fi
