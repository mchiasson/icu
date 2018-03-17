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


option(UCLN_NO_AUTO_CLEANUP "Determines wheter to enable auto cleanup of libraries." TRUE)
option(U_DISABLE_RENAMING "Determines whether to disable renaming or not." FALSE)
option(U_OVERRIDE_CXX_ALLOCATION "Determines whether to override new and delete." TRUE)
option(U_ENABLE_TRACING "Determines whether to enable tracing." FALSE)
option(U_ENABLE_DYLOAD "Whether to enable Dynamic loading in ICU." TRUE)
option(U_CHECK_DYLOAD "Whether to test Dynamic loading as an OS capability." TRUE)
option(U_DEFAULT_SHOW_DRAFT "Do we allow ICU users to use the draft APIs by default?" TRUE)
option(UCONFIG_ONLY_COLLATION "This switch turns off modules that are not needed for collation." FALSE)
option(UCONFIG_NO_FILE_IO "This switch turns off all file access in the common library where file access is only used for data loading." FALSE)
option(UCONFIG_NO_CONVERSION "ICU will not completely build with this switch turned on." FALSE)
option(UCONFIG_ONLY_HTML_CONVERSION "This switch turns off all of the converters NOT listed in the HTML encoding standard" FALSE)
option(UCONFIG_NO_LEGACY_CONVERSION "This switch turns off all converters" FALSE)
option(UCONFIG_NO_NORMALIZATION "This switch turns off normalization." FALSE)
option(UCONFIG_NO_BREAK_ITERATION "This switch turns off break iteration." FALSE)
option(UCONFIG_NO_IDNA "This switch turns off IDNA." FALSE)
option(UCONFIG_NO_COLLATION "This switch turns off collation and collation-based string search." FALSE)
option(UCONFIG_NO_FORMATTING "This switch turns off transliteration." FALSE)
option(UCONFIG_NO_TRANSLITERATION "his switch turns off transliteration." FALSE)
option(UCONFIG_NO_REGULAR_EXPRESSIONS "This switch turns off regular expressions." FALSE)
option(UCONFIG_NO_SERVICE "This switch turns off service registration." FALSE)
option(UCONFIG_HAVE_PARSEALLINPUT "This switch turns on the \"parse all input\" attribute. Binary incompatible." TRUE)
option(UCONFIG_FORMAT_FASTPATHS_49 "This switch turns on other formatting fastpaths." TRUE)
option(UCONFIG_NO_FILTERED_BREAK_ITERATION "This switch turns off filtered break iteration code." FALSE)

list(APPEND U_CONFIG 
    U_DEBUG=$<CONFIG:Debug>
    UCLN_NO_AUTO_CLEANUP=$<BOOL:${UCLN_NO_AUTO_CLEANUP}>
    U_DISABLE_RENAMING=$<BOOL:${U_DISABLE_RENAMING}>
    U_OVERRIDE_CXX_ALLOCATION=$<BOOL:${U_OVERRIDE_CXX_ALLOCATION}>
    U_ENABLE_TRACING=$<BOOL:${U_ENABLE_TRACING}>
    U_ENABLE_DYLOAD=$<BOOL:${U_ENABLE_DYLOAD}>
    U_CHECK_DYLOAD=$<BOOL:${U_CHECK_DYLOAD}>
    U_DEFAULT_SHOW_DRAFT=$<BOOL:${U_DEFAULT_SHOW_DRAFT}>
    UCONFIG_ONLY_COLLATION=$<BOOL:${UCONFIG_ONLY_COLLATION}>
    UCONFIG_NO_FILE_IO=$<BOOL:${UCONFIG_NO_FILE_IO}>
    UCONFIG_NO_CONVERSION=$<BOOL:${UCONFIG_NO_CONVERSION}>
    UCONFIG_ONLY_HTML_CONVERSION=$<BOOL:${UCONFIG_ONLY_HTML_CONVERSION}>
    UCONFIG_NO_LEGACY_CONVERSION=$<BOOL:${UCONFIG_NO_LEGACY_CONVERSION}>
    UCONFIG_NO_NORMALIZATION=$<BOOL:${UCONFIG_NO_NORMALIZATION}>
    UCONFIG_NO_BREAK_ITERATION=$<BOOL:${UCONFIG_NO_BREAK_ITERATION}>
    UCONFIG_NO_IDNA=$<BOOL:${UCONFIG_NO_IDNA}>
    UCONFIG_NO_COLLATION=$<BOOL:${UCONFIG_NO_COLLATION}>
    UCONFIG_NO_FORMATTING=$<BOOL:${UCONFIG_NO_FORMATTING}>
    UCONFIG_NO_TRANSLITERATION=$<BOOL:${UCONFIG_NO_TRANSLITERATION}>
    UCONFIG_NO_REGULAR_EXPRESSIONS=$<BOOL:${UCONFIG_NO_REGULAR_EXPRESSIONS}>
    UCONFIG_NO_SERVICE=$<BOOL:${UCONFIG_NO_SERVICE}>
    UCONFIG_HAVE_PARSEALLINPUT=$<BOOL:${UCONFIG_HAVE_PARSEALLINPUT}>
    UCONFIG_FORMAT_FASTPATHS_49=$<BOOL:${UCONFIG_FORMAT_FASTPATHS_49}>
    UCONFIG_NO_FILTERED_BREAK_ITERATION=$<BOOL:${UCONFIG_NO_FILTERED_BREAK_ITERATION}>
)

sugar_include("./source/stubdata") # ICU_STUBDATA_SOURCES
add_library(icudata ${ICU_TYPE} ${ICU_STUBDATA_SOURCES})
target_compile_definitions(icudata PUBLIC STUBDATA_BUILD ${U_CONFIG})
target_include_directories(icudata PRIVATE ${PROJECT_SOURCE_DIR}/source/common)
install(FILES ${PROJECT_SOURCE_DIR}/source/stubdata/icudt55l.dat
    DESTINATION share/icu/55.1 COMPONENT Runtime
)

sugar_include("./source/common") # ICU_UC_SOURCES
add_library(icuuc ${ICU_TYPE} ${ICU_UC_SOURCES})
target_compile_definitions(icuuc PUBLIC U_ATTRIBUTE_DEPRECATED= U_COMMON_IMPLEMENTATION ${U_CONFIG})
target_include_directories(icuuc PRIVATE ${PROJECT_SOURCE_DIR}/source/common ${PROJECT_SOURCE_DIR}/source/i18n)
target_link_libraries(icuuc icudata)
extract_headers(ICU_UC_SOURCES unicode)
install(FILES ${ICU_UC_SOURCES} DESTINATION include/unicode COMPONENT Development)

sugar_include("./source/i18n") # ICU_I18N_SOURCES
add_library(icui18n ${ICU_TYPE} ${ICU_I18N_SOURCES})
target_compile_definitions(icui18n PUBLIC U_ATTRIBUTE_DEPRECATED= U_I18N_IMPLEMENTATION ${U_CONFIG})
target_include_directories(icui18n PRIVATE ${PROJECT_SOURCE_DIR}/source/i18n ${PROJECT_SOURCE_DIR}/source/common)
target_link_libraries(icui18n PUBLIC icuuc)
extract_headers(ICU_I18N_SOURCES unicode)
install(FILES ${ICU_I18N_SOURCES} DESTINATION include/unicode COMPONENT Development)

sugar_include("./source/io") # ICU_IO_SOURCES
add_library(icuio ${ICU_TYPE} ${ICU_IO_SOURCES})
target_compile_definitions(icuio PUBLIC U_IO_IMPLEMENTATION ${U_CONFIG})
target_include_directories(icuio PRIVATE ${PROJECT_SOURCE_DIR}/source/i18n ${PROJECT_SOURCE_DIR}/source/common)
target_link_libraries(icuio PUBLIC icuuc icui18n)
extract_headers(ICU_IO_SOURCES unicode)
install(FILES ${ICU_IO_SOURCES} DESTINATION include/unicode COMPONENT Development)

sugar_include("./source/layout") # ICU_LAYOUT_SOURCES
add_library(icule ${ICU_TYPE} ${ICU_LAYOUT_SOURCES})
target_compile_definitions(icule PUBLIC U_LAYOUT_IMPLEMENTATION ${U_CONFIG})
target_include_directories(icule PRIVATE ${PROJECT_SOURCE_DIR}/source/common)
target_link_libraries(icule PUBLIC icuuc)
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

sugar_include("./source/layoutex") # ICU_LAYOUTEX_SOURCES
add_library(iculx ${ICU_TYPE} ${ICU_LAYOUTEX_SOURCES})
target_compile_definitions(iculx PUBLIC U_LAYOUTEX_IMPLEMENTATION ${U_CONFIG})
target_include_directories(iculx PRIVATE ${PROJECT_SOURCE_DIR}/source ${PROJECT_SOURCE_DIR}/source/layoutex ${PROJECT_SOURCE_DIR}/source/common)
target_link_libraries(iculx PUBLIC icuuc icule)
extract_headers(ICU_LAYOUTEX_SOURCES layout)
install(FILES ${ICU_LAYOUTEX_SOURCES} DESTINATION include/layout COMPONENT Development)

if (MSVC)
    target_compile_definitions(icudata PUBLIC _CRT_SECURE_NO_DEPRECATE)
    target_compile_definitions(icuuc PUBLIC _CRT_SECURE_NO_DEPRECATE)
    target_compile_definitions(icui18n PUBLIC _CRT_SECURE_NO_DEPRECATE)
    target_compile_definitions(icuio PUBLIC _CRT_SECURE_NO_DEPRECATE)
    target_compile_definitions(icule PUBLIC _CRT_SECURE_NO_DEPRECATE)
    target_compile_definitions(iculx PUBLIC _CRT_SECURE_NO_DEPRECATE)
endif()

if(NOT BUILD_SHARED_LIBS)
  target_compile_definitions(icudata PUBLIC U_STATIC_IMPLEMENTATION)
  target_compile_definitions(icuuc PUBLIC U_STATIC_IMPLEMENTATION)
  target_compile_definitions(icui18n PUBLIC U_STATIC_IMPLEMENTATION)
  target_compile_definitions(icuio PUBLIC U_STATIC_IMPLEMENTATION)
  target_compile_definitions(icule PUBLIC U_STATIC_IMPLEMENTATION)
  target_compile_definitions(iculx PUBLIC U_STATIC_IMPLEMENTATION)
endif()

# Create the CMake version file.
include(CMakePackageConfigHelpers)
write_basic_package_version_file(
  "${CMAKE_CURRENT_BINARY_DIR}/icuConfigVersion.cmake"
  VERSION 55.1
  COMPATIBILITY AnyNewerVersion
)

set(targets_export_name "ICUTargets")

# Create the Config file.
include(CMakePackageConfigHelpers)
set(ConfigPackageLocation lib/cmake/icu)
configure_package_config_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/cmake/icuConfig.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/icuConfig.cmake
  INSTALL_DESTINATION ${ConfigPackageLocation}
)

install(TARGETS icudata icui18n icuio icule iculx icuuc
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
  FILES "${CMAKE_CURRENT_BINARY_DIR}/icuConfigVersion.cmake"
        "${CMAKE_CURRENT_BINARY_DIR}/icuConfig.cmake"
  DESTINATION ${ConfigPackageLocation}
)
