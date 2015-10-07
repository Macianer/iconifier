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
appExists pngcrush "
# # On Mac
# brew install pngcrush
#
# # On Linux
# sudo apt-get install pngcrush"

#check if inkscape is installed
appExists inkscape "
# # On Mac
# brew cask install inkscape
#
# # On Linux
# sudo apt-get install imagemagick"

#check if ImageMagick is installed
appExists convert "
# # On Mac
# brew install imagemagick
#
# # On Linux
# sudo apt-get install imagemagick"

#check if fontcustom is installed
appExists fontcustom "
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

function Handle {
if [ -z "$1" ];then
	echo $1
fi
}

EXPORT="EXPORT"
IMPORT="IMPORT"

#clear
try rm -rf ${EXPORT}

fontcustom compile ${IMPORT} -o -n "${EXPORT}"

Handle `find ${IMPORT} -iname '*.svg' `
# define target
ANDROID_TARGET="TestProjectAndroid/app/src/main/res/"

if [ -e "${EXPORT}" ]; then
 rsync -arcuP "EXPORT/" "${ANDROID_TARGET}"
fi

cp $EXPORT/Font/custom_font.ttf $ANDROID_TARGET_FONT/icon_fonts.ttf
