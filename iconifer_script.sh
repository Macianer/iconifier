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
try rm -rf ${EXPORT}/draw*

#recreate
createDir ${EXPORT}


find "${IMPORT}" -type f -iname "*.svg"  | while read file ; do
	Test $file
done

doConvertAndroid "$IMPORT/ic_nav_alert_50.svg" "$EXPORT" "1024" "50"
doConvertAndroid "$IMPORT/ic_nav_lightalert_50.svg" "$EXPORT" "1024" "50"

# define target
ANDROID_TARGET="TestProjectAndroid/app/src/main/res"

# copy
if [ -e "${EXPORT}" -o -e ${ANDROID_TARGET}  ]; then
	print_green "copy image files"
	rsync -arcuP "$EXPORT/" --include="*.png" --include="*.PNG" --exclude="*.*"  "${ANDROID_TARGET}"
fi

FONTNAME="icon_font"
fontcustom compile -h "${IMPORT}" -n "${FONTNAME}" -o "${EXPORT}"

if [ -e "${EXPORT}/${FONTNAME}.ttf" ]; then
	print_green "copy font files"
	createDir "${ANDROID_TARGET}/asset/"
	rsync -arcuP "$EXPORT/"  --include="*.ttf" --include="*.TTF" --exclude="*" "${ANDROID_TARGET}/asset/"
fi
