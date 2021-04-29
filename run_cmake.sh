#! /bin/bash
#
# Because otherwise I loose the magic incantation...
# 

mkdir build
cd build
rm *.txt
# cmake -D CMAKE_FIND_DEBUG_MODE=ON   ..
cmake -D WITH_INFLATE_ALLOW_INVALID_DIST=ON -D ZLIB_COMPAT=ON  ..
