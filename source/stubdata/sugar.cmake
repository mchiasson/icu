# This file generated automatically by:
#   generate_sugar_files.py
# see wiki for more info:
#   https://github.com/ruslo/sugar/wiki/Collecting-sources

if(DEFINED ICU_SOURCE_STUBDATA_SUGAR_CMAKE_)
  return()
else()
  set(ICU_SOURCE_STUBDATA_SUGAR_CMAKE_ 1)
endif()

include(sugar_files)

sugar_files(
    ICU_STUBDATA_SOURCES
    stubdata.vcxproj
    stubdata.vcxproj.filters
    Makefile.in
    stubdata.c
)
