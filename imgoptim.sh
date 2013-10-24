#!/bin/sh
#
# imgoptim.sh: optimize images losslessly
#
# Copyright (c) 2013 Manolis Tzanidakis <mtzanidakis@gmail.com>
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
# WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE
# AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL
# DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR
# PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
# TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.

# error message function
_error() {
	echo "error: ${@}."
	exit 1
}

# warning message function
_warn() {
	echo "${@}. skipped!"
	continue
}

# help message function
_help() {
	echo "usage: $(basename $0) some.jpg images.png"
	exit 0
}

# image file info function
_imginfo() {
	case "$1" in
		ft) file "${_img}" | cut -d ':' -f 2 | awk '{ print $1 }' ;;
		fs) du -k "${_img}" | awk '{ print $1 }'                  ;;
	esac
}

# results message function
_resmsg() {
	# get the new image file size
	_fs_n="$(_imginfo fs)"

	# calculate the percent decrease in file size
	_fs_perc="$((100 * (${_fs_o} - ${_fs_n}) / ${_fs_o}))"

	[ "${_fs_perc}" -eq 0 ] && echo 'no size reduction.' \
		|| echo "${_fs_perc}% (${_fs_o}K -> ${_fs_n}K)."
}

# check if all requirements are available
for _cmd in awk cut du file jpegtran optipng; do
	which ${_cmd} >/dev/null 2>&1 || \
		_error "${_cmd} is not installed or accessible"
done

# show help when run without arguments
test -n "$1" || _help

for _img in "$@"; do
	printf " * ${_img}: "

	# skip the current file if unavailable
	test -e "${_img}" || _warn 'not available'

	# switch based on file type
	case "$(_imginfo ft)" in
		# XXX: add more file types.
		JPEG)
			_cmd="jpegtran -copy none -optimize \
			      -progressive -outfile '${_img}' '${_img}'"
			;;
		PNG)
			_cmd="optipng -o5 -preserve -strip all \
			      -quiet '${_img}'"
			;;
		directory)
			_warn "is a directory"
			;;
		*)
			_warn "unkown filetype"
			;;
	esac

	# original image file size
	_fs_o="$(_imginfo fs)"

	# do the compression
	eval $_cmd && _resmsg || echo 'fail.'
done
