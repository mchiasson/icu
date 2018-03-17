# This file generated automatically by:
#   generate_sugar_files.py
# see wiki for more info:
#   https://github.com/ruslo/sugar/wiki/Collecting-sources

if(DEFINED ICU_SOURCE_LAYOUTEX_SUGAR_CMAKE_)
  return()
else()
  set(ICU_SOURCE_LAYOUTEX_SUGAR_CMAKE_ 1)
endif()

include(sugar_files)
include(sugar_include)

sugar_include(layout)

sugar_files(
    ICU_LAYOUTEX_SOURCES
    layoutex.rc
    ParagraphLayout.cpp
    LXUtilities.cpp
    plruns.cpp
    Makefile.in
    RunArrays.cpp
    layoutex.vcxproj.filters
    playout.cpp
    layoutex.vcxproj
    LXUtilities.h
)
