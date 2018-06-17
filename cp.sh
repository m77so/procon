#!/bin/bash
if [ -L $0 ]; then
  shdir="$(dirname $0)/$(dirname `readlink "$0"`)"
else
  shdir="$(dirname $0)"
fi
ext=${1#*.}
if [ ${ext} = "cpp" ]; then
  cp　-i ${shdir}/templates/cpp/a.cpp $1
elif [ ${ext} = "nim" ]; then
  cp -i ${shdir}/templates/nim/a.nim $1
elif [ ${ext} = "py" ]; then
  cp -i ${shdir}/templates/python3/a.py $1
fi