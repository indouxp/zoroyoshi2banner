#!/bin/sh
RESULT=/tmp/`echo ${0##*/} | sed 's%\.sh%.result%'`
echo "ibase=10; obase=16; $1" | bc > ${RESULT:?}
