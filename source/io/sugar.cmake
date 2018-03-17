# This file generated automatically by:
#   generate_sugar_files.py
# see wiki for more info:
#   https://github.com/ruslo/sugar/wiki/Collecting-sources

if(DEFINED ICU_SOURCE_IO_SUGAR_CMAKE_)
  return()
else()
  set(ICU_SOURCE_IO_SUGAR_CMAKE_ 1)
endif()

include(sugar_files)
include(sugar_include)

sugar_include(unicode)

sugar_files(
    ICU_IO_SOURCES
    ucln_io.cpp
    locbund.h
    locbund.cpp
    ufmt_cmn.c
    sprintf.c
    uprintf.h
    io.vcxproj
    ucln_io.h
    uscanf.c
    ustream.cpp
    Makefile.in
    ufmt_cmn.h
    uscanf.h
    ufile.c
    uprntf_p.c
    io.vcxproj.filters
    uprintf.cpp
    ufile.h
    io.rc
    uscanf_p.c
    ustdio.c
    sscanf.c
)
