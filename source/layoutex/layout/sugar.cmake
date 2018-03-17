# This file generated automatically by:
#   generate_sugar_files.py
# see wiki for more info:
#   https://github.com/ruslo/sugar/wiki/Collecting-sources

if(DEFINED ICU_SOURCE_LAYOUTEX_LAYOUT_SUGAR_CMAKE_)
  return()
else()
  set(ICU_SOURCE_LAYOUTEX_LAYOUT_SUGAR_CMAKE_ 1)
endif()

include(sugar_files)

sugar_files(
    ICU_LAYOUTEX_SOURCES
    RunArrays.h
    plruns.h
    ParagraphLayout.h
    playout.h
)
