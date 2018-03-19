# Copyright (c) 2014-2018, Ruslan Baratov
# Copyright (c) 2018, Mathieu-Andre Chiasson
# All rights reserved.

cmake_minimum_required(VERSION 3.0)

include(cmake/HunterGate.cmake)
HunterGate(
    URL "https://github.com/ruslo/hunter/archive/v0.20.21.tar.gz"
    SHA1 "36bc6c263eb173697724e00adac8add4b3e52a31"
)

macro(extract_headers source_list header_dir)
    foreach (TMP_PATH ${${source_list}})
        get_filename_component(_ext ${TMP_PATH} EXT)
        string (FIND ${TMP_PATH} "/${header_dir}/" _DIR_FOUND)
        if (NOT _ext STREQUAL ".h" OR _DIR_FOUND EQUAL -1)
            list (REMOVE_ITEM ${source_list} ${TMP_PATH})
        endif()
    endforeach(TMP_PATH)
    unset(_ext)
    unset(_DIR_FOUND)
endmacro()

project(ICU)

hunter_add_package(sugar)
find_package(sugar CONFIG REQUIRED)

set(ICU_VERSION_MAJOR 55)
set(ICU_VERSION_MINOR 1)

option(ICU_ENABLE_AUTO_CLEANUP "enable auto cleanup of libraries"       OFF)
option(ICU_ENABLE_DRAFT        "enable draft APIs (and internal APIs)"  ON)
option(ICU_ENABLE_RENAMING     "add a version suffix to symbols"        ON)
option(ICU_ENABLE_TRACING      "enable function and data tracing"       OFF)
option(ICU_DISABLE_DYLOAD      "disable dynamic loading"                OFF)
option(ICU_ENABLE_ICUIO        "build ICU's icuio library"              ON)
option(ICU_ENABLE_LAYOUT       "build ICU's DEPRECATED layout library"  ON)
option(ICU_ENABLE_LAYOUTEX     "build ICU's Paragraph Layout library"   ON)

unset(U_CONFIG)
list(APPEND U_CONFIG 
    $<$<CONFIG:Debug>:U_DEBUG=1>
    $<$<BOOL:${ICU_ENABLE_AUTO_CLEANUP}>:UCLN_NO_AUTO_CLEANUP=0>
    $<$<NOT:$<BOOL:${ICU_ENABLE_DRAFT}>>:U_DEFAULT_SHOW_DRAFT=0>
    $<$<NOT:$<BOOL:${ICU_ENABLE_RENAMING}>>:U_DISABLE_RENAMING=1>
    $<$<BOOL:${ICU_ENABLE_TRACING}>:U_ENABLE_TRACING=1>
    $<$<BOOL:${ICU_DISABLE_DYLOAD}>:U_ENABLE_DYLOAD=0>

    # These are recommended build options (see readme.html#RecBuild)
    U_USING_ICU_NAMESPACE=0
    U_CHARSET_IS_UTF8=1
)


################################################################################
# icudata
################################################################################
sugar_include("./source/stubdata") # ICU_STUBDATA_SOURCES
add_library(icudata ${ICU_TYPE} ${ICU_STUBDATA_SOURCES})
target_compile_definitions(icudata
    PRIVATE STUBDATA_BUILD
    PUBLIC ${U_CONFIG})
target_include_directories(icudata PRIVATE ${PROJECT_SOURCE_DIR}/source/common)
set_target_properties(icudata PROPERTIES
  VERSION ${ICU_VERSION_MAJOR}.${ICU_VERSION_MINOR}
  SOVERSION ${ICU_VERSION_MAJOR})
install(FILES ${PROJECT_SOURCE_DIR}/source/stubdata/icudt${ICU_VERSION_MAJOR}l.dat
    DESTINATION share/icu/${ICU_VERSION_MAJOR}.${ICU_VERSION_MINOR} COMPONENT Runtime)

################################################################################
# icuuc
################################################################################
sugar_include("./source/common") # ICU_UC_SOURCES
add_library(icuuc ${ICU_TYPE} ${ICU_UC_SOURCES})
target_compile_definitions(icuuc
    PRIVATE U_ATTRIBUTE_DEPRECATED= U_COMMON_IMPLEMENTATION
    PUBLIC ${U_CONFIG})
target_include_directories(icuuc PRIVATE
    ${PROJECT_SOURCE_DIR}/source/common
    ${PROJECT_SOURCE_DIR}/source/i18n)
set_target_properties(icuuc PROPERTIES
  VERSION ${ICU_VERSION_MAJOR}.${ICU_VERSION_MINOR}
  SOVERSION ${ICU_VERSION_MAJOR})
extract_headers(ICU_UC_SOURCES unicode)
install(FILES ${ICU_UC_SOURCES}
    DESTINATION include/unicode
    COMPONENT Development)

################################################################################
# icui18n
################################################################################
sugar_include("./source/i18n") # ICU_I18N_SOURCES
add_library(icui18n ${ICU_TYPE} ${ICU_I18N_SOURCES})
target_compile_definitions(icui18n
    PRIVATE U_ATTRIBUTE_DEPRECATED= U_I18N_IMPLEMENTATION
    PUBLIC ${U_CONFIG})
target_include_directories(icui18n PRIVATE
    ${PROJECT_SOURCE_DIR}/source/i18n
    ${PROJECT_SOURCE_DIR}/source/common)
set_target_properties(icui18n PROPERTIES
  VERSION ${ICU_VERSION_MAJOR}.${ICU_VERSION_MINOR}
  SOVERSION ${ICU_VERSION_MAJOR})
extract_headers(ICU_I18N_SOURCES unicode)
install(FILES ${ICU_I18N_SOURCES}
    DESTINATION include/unicode
    COMPONENT Development)

################################################################################
# icuio (optional)
################################################################################
if(ICU_ENABLE_ICUIO)
    sugar_include("./source/io") # ICU_IO_SOURCES
    add_library(icuio ${ICU_TYPE} ${ICU_IO_SOURCES})
    target_compile_definitions(icuio
        PRIVATE U_IO_IMPLEMENTATION
        PUBLIC ${U_CONFIG})
    target_include_directories(icuio PRIVATE
        ${PROJECT_SOURCE_DIR}/source/i18n
        ${PROJECT_SOURCE_DIR}/source/common)
    set_target_properties(icuio PROPERTIES
      VERSION ${ICU_VERSION_MAJOR}.${ICU_VERSION_MINOR}
      SOVERSION ${ICU_VERSION_MAJOR})
    extract_headers(ICU_IO_SOURCES unicode)
    install(FILES ${ICU_IO_SOURCES}
        DESTINATION include/unicode
        COMPONENT Development)
endif()

################################################################################
# icule (optional)
################################################################################
if (ICU_ENABLE_LAYOUT)
    sugar_include("./source/layout") # ICU_LAYOUT_SOURCES
    add_library(icule ${ICU_TYPE} ${ICU_LAYOUT_SOURCES})
    target_compile_definitions(icule
        PRIVATE U_LAYOUT_IMPLEMENTATION
        PUBLIC ${U_CONFIG})
    target_include_directories(icule PRIVATE ${PROJECT_SOURCE_DIR}/source/common)
    set_target_properties(icule PROPERTIES
      VERSION ${ICU_VERSION_MAJOR}.${ICU_VERSION_MINOR}
      SOVERSION ${ICU_VERSION_MAJOR})
    install(FILES
        ${PROJECT_SOURCE_DIR}/source/layout/LayoutEngine.h
        ${PROJECT_SOURCE_DIR}/source/layout/LEFontInstance.h
        ${PROJECT_SOURCE_DIR}/source/layout/LEGlyphFilter.h
        ${PROJECT_SOURCE_DIR}/source/layout/LEGlyphStorage.h
        ${PROJECT_SOURCE_DIR}/source/layout/LEInsertionList.h
        ${PROJECT_SOURCE_DIR}/source/layout/LELanguages.h
        ${PROJECT_SOURCE_DIR}/source/layout/LEScripts.h
        ${PROJECT_SOURCE_DIR}/source/layout/LESwaps.h
        ${PROJECT_SOURCE_DIR}/source/layout/LETypes.h
        ${PROJECT_SOURCE_DIR}/source/layout/loengine.h
        DESTINATION include/layout COMPONENT Development
    )

    ############################################################################
    # iculx (optional)
    ############################################################################
    if (ICU_ENABLE_LAYOUTEX)
        sugar_include("./source/layoutex") # ICU_LAYOUTEX_SOURCES
        add_library(iculx ${ICU_TYPE} ${ICU_LAYOUTEX_SOURCES})
        target_compile_definitions(iculx
            PRIVATE U_LAYOUTEX_IMPLEMENTATION
            PUBLIC ${U_CONFIG})
        target_include_directories(iculx PRIVATE
            ${PROJECT_SOURCE_DIR}/source
            ${PROJECT_SOURCE_DIR}/source/layoutex
            ${PROJECT_SOURCE_DIR}/source/common)
        set_target_properties(iculx PROPERTIES
          VERSION ${ICU_VERSION_MAJOR}.${ICU_VERSION_MINOR}
          SOVERSION ${ICU_VERSION_MAJOR})
        extract_headers(ICU_LAYOUTEX_SOURCES layout)
        install(FILES ${ICU_LAYOUTEX_SOURCES}
            DESTINATION include/layout
            COMPONENT Development)
    endif()
endif()

# convenient all-in-one library
add_library(icu INTERFACE)
target_link_libraries(icu INTERFACE icudata)
target_link_libraries(icu INTERFACE icui18n)
if(ICU_ENABLE_ICUIO)
    target_link_libraries(icu INTERFACE icuio)
endif()
if (ICU_ENABLE_LAYOUT)
    target_link_libraries(icu INTERFACE icule)
    if (ICU_ENABLE_LAYOUTEX)
        target_link_libraries(icu INTERFACE iculx)
    endif()
endif()
target_link_libraries(icu INTERFACE icuuc)


if (MSVC)
    target_compile_definitions(icudata PUBLIC _CRT_SECURE_NO_DEPRECATE)
    target_compile_definitions(icuuc PUBLIC _CRT_SECURE_NO_DEPRECATE)
    target_compile_definitions(icui18n PUBLIC _CRT_SECURE_NO_DEPRECATE)
    if(ICU_ENABLE_ICUIO)
        target_compile_definitions(icuio PUBLIC _CRT_SECURE_NO_DEPRECATE)
    endif()
    if (ICU_ENABLE_LAYOUT)
        target_compile_definitions(icule PUBLIC _CRT_SECURE_NO_DEPRECATE)
        if (ICU_ENABLE_LAYOUTEX)
            target_compile_definitions(iculx PUBLIC _CRT_SECURE_NO_DEPRECATE)
        endif()
    endif()
endif()

if(NOT BUILD_SHARED_LIBS)
  target_compile_definitions(icudata PUBLIC U_STATIC_IMPLEMENTATION)
  target_compile_definitions(icuuc PUBLIC U_STATIC_IMPLEMENTATION)
  target_compile_definitions(icui18n PUBLIC U_STATIC_IMPLEMENTATION)
  if(ICU_ENABLE_ICUIO)
      target_compile_definitions(icuio PUBLIC U_STATIC_IMPLEMENTATION)
  endif()
  if (ICU_ENABLE_LAYOUT)
      target_compile_definitions(icule PUBLIC U_STATIC_IMPLEMENTATION)
      if (ICU_ENABLE_LAYOUTEX)
          target_compile_definitions(iculx PUBLIC U_STATIC_IMPLEMENTATION)
      endif()
  endif()
endif()

# Create the CMake version file.
include(CMakePackageConfigHelpers)
write_basic_package_version_file(
  "${CMAKE_CURRENT_BINARY_DIR}/ICUConfigVersion.cmake"
  VERSION ${ICU_VERSION_MAJOR}.${ICU_VERSION_MINOR}
  COMPATIBILITY AnyNewerVersion
)

set(targets_export_name "ICUTargets")

# Create the Config file.
include(CMakePackageConfigHelpers)
set(ConfigPackageLocation lib/cmake/icu)
configure_package_config_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/cmake/ICUConfig.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/ICUConfig.cmake
  INSTALL_DESTINATION ${ConfigPackageLocation}
)

install(TARGETS icu icudata icui18n icuio icule iculx icuuc
    EXPORT ${targets_export_name}
    LIBRARY DESTINATION lib COMPONENT Runtime
    ARCHIVE DESTINATION lib COMPONENT Development
    RUNTIME DESTINATION bin COMPONENT Runtime
    BUNDLE DESTINATION bin COMPONENT Runtime
    PUBLIC_HEADER DESTINATION include COMPONENT Development
    BUNDLE DESTINATION bin COMPONENT Runtime
)

# Install the generated CMake files.
install(EXPORT ${targets_export_name} NAMESPACE "ICU::" DESTINATION lib/cmake/icu)
install(
  FILES "${CMAKE_CURRENT_BINARY_DIR}/ICUConfigVersion.cmake"
        "${CMAKE_CURRENT_BINARY_DIR}/ICUConfig.cmake"
  DESTINATION ${ConfigPackageLocation}
)
