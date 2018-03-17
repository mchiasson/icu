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

sugar_include("./source/stubdata") # ICU_STUBDATA_SOURCES
add_library(icudata ${ICU_TYPE} ${ICU_STUBDATA_SOURCES})
target_compile_definitions(icudata PUBLIC STUBDATA_BUILD)
target_include_directories(icudata PRIVATE ${PROJECT_SOURCE_DIR}/source/common)
install(FILES ${PROJECT_SOURCE_DIR}/source/stubdata/icudt55l.dat
    DESTINATION share/icu/55.1 COMPONENT Runtime
)

sugar_include("./source/common") # ICU_UC_SOURCES
add_library(icuuc ${ICU_TYPE} ${ICU_UC_SOURCES})
target_compile_definitions(icuuc PUBLIC U_ATTRIBUTE_DEPRECATED= U_COMMON_IMPLEMENTATION)
target_include_directories(icuuc PRIVATE ${PROJECT_SOURCE_DIR}/source/i18n)
target_link_libraries(icuuc icudata)
extract_headers(ICU_UC_SOURCES unicode)
install(FILES ${ICU_UC_SOURCES} DESTINATION include/unicode COMPONENT Development)

sugar_include("./source/i18n") # ICU_I18N_SOURCES
add_library(icui18n ${ICU_TYPE} ${ICU_I18N_SOURCES})
target_compile_definitions(icui18n PUBLIC U_ATTRIBUTE_DEPRECATED= U_I18N_IMPLEMENTATION)
target_include_directories(icui18n PRIVATE ${PROJECT_SOURCE_DIR}/source/common)
target_link_libraries(icui18n PUBLIC icuuc)
extract_headers(ICU_I18N_SOURCES unicode)
install(FILES ${ICU_I18N_SOURCES} DESTINATION include/unicode COMPONENT Development)

sugar_include("./source/io") # ICU_IO_SOURCES
add_library(icuio ${ICU_TYPE} ${ICU_IO_SOURCES})
target_compile_definitions(icuio PUBLIC U_IO_IMPLEMENTATION)
target_include_directories(icuio PRIVATE ${PROJECT_SOURCE_DIR}/source/common)
target_link_libraries(icuio PUBLIC icuuc icui18n)
extract_headers(ICU_IO_SOURCES unicode)
install(FILES ${ICU_IO_SOURCES} DESTINATION include/unicode COMPONENT Development)

sugar_include("./source/layout") # ICU_LAYOUT_SOURCES
add_library(icule ${ICU_TYPE} ${ICU_LAYOUT_SOURCES})
target_compile_definitions(icule PUBLIC U_LAYOUT_IMPLEMENTATION)
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
target_compile_definitions(iculx PUBLIC U_LAYOUTEX_IMPLEMENTATION)
target_include_directories(iculx PRIVATE ${PROJECT_SOURCE_DIR}/source/common)
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
