#!/usr/bin/bash

SRC_DIR=`pwd`/bin/
DEST_DIR=/usr/local/bin/

for filename in `ls ${SRC_DIR}`
do
	binary=${SRC_DIR}${filename}
	sym_link=${DEST_DIR}${filename}
	echo "Create symlink: ${binary} -> ${sym_link}"
	ln -s ${binary} ${sym_link}
done
