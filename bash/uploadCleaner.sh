#!/bin/bash

DIRS="/var/ftp/energoeffect/upload/*"

for d in ${DIRS}
do
	rm -rf ${d}
done
