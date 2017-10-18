#!/bin/sh
RESULT=/tmp/`echo ${0##*/} | sed 's%\.sh%.result%'`
echo "obase = 16; ibase = 16; $*" | bc > ${RESULT:?}
