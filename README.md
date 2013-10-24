# imgoptim.sh

A simple shell script for optimizing JPEG and PNG images losslessly.

## Requirements & Compatibility

* [libjpeg-turbo](http://libjpeg-turbo.virtualgl.org/)
* [optipng](http://optipng.sourceforge.net/)
* standard UNIX tools: awk, cut, du, file and of course, sh.

Tested on OpenBSD, FreeBSD, Linux and OS X.

## Installation

Just copy the script somewhere in your `PATH` and make it executable.

## Usage

To optimize one or more images add them as a space-separated list of arguments to the script, eg:

    imgoptim.sh image1.jpg image2.png image3.JPG

Optimize all images in the currect directory:

    imgoptim.sh *

The combination of this script with other tools offers great flexibility. You can optimize all images in the `$HOME/app/assets` directory and its sub dirs in a single line, with the help of `find`:

    find $HOME/app/assets -type f -exec imgoptim.sh {} \;

Logging the script's output to an external file can be helpful when optimizing lots of images in bulk. To log to a file and get a list of errors try:

    imgoptim.sh * 2>&1 > $HOME/imgoptim.out
    grep skipped $HOME/imgoptim.out

## License

This script is licensed under the [ISC license](http://opensource.org/licenses/ISC).
