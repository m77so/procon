#!/bin/bash
dir=${PWD##*/} 
if [ ${dir} = "workspace" ]; then
  ext=${1#*.}
  nam=${1%.*}
  if [ ${ext} = "cpp" ]; then
    cp ../templates/cpp/a.cpp ${nam}.cpp
  elif [ ${ext} = "nim" ]; then
    cp ../templates/nim/a.nim ${nam}.nim
  elif [ ${ext} = "py" ]; then
    cp ../templates/python3/a.py ${nam}.py
  fi
else
  echo "${dir} is not workspace"
fi
