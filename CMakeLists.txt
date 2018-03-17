# Copyright (c) 2014-2018, Ruslan Baratov
# Copyright (c) 2018, Mathieu-Andre Chiasson
# All rights reserved.

cmake_minimum_required(VERSION 3.0)

include(cmake/HunterGate.cmake)
HunterGate(
    URL "https://github.com/ruslo/hunter/archive/v0.20.21.tar.gz"
    SHA1 "36bc6c263eb173697724e00adac8add4b3e52a31"
)

project(ICU)

hunter_add_package(sugar)
find_package(sugar CONFIG REQUIRED)

sugar_include("./source/stubdata") # ICU_STUBDATA_SOURCES
add_library(icudata ${ICU_TYPE} ${ICU_STUBDATA_SOURCES})
target_compile_definitions(icudata PUBLIC
    STUBDATA_BUILD
    U_USING_ICU_NAMESPACE=0
)
target_include_directories(icudata PUBLIC ${PROJECT_SOURCE_DIR}/source/common)

sugar_include("./source/common") # ICU_UC_SOURCES
add_library(icuuc ${ICU_TYPE} ${ICU_UC_SOURCES})
target_compile_definitions(icuuc PUBLIC U_ATTRIBUTE_DEPRECATED= U_COMMON_IMPLEMENTATION)
target_include_directories(icuuc PUBLIC ${PROJECT_SOURCE_DIR}/source/i18n)
target_link_libraries(icuuc icudata)

sugar_include("./source/i18n") # ICU_I18N_SOURCES
add_library(icui18n ${ICU_TYPE} ${ICU_I18N_SOURCES})
target_compile_definitions(icui18n PUBLIC U_ATTRIBUTE_DEPRECATED= U_I18N_IMPLEMENTATION)
target_include_directories(icui18n PUBLIC ${PROJECT_SOURCE_DIR}/source/common)
target_link_libraries(icui18n PUBLIC icuuc)

sugar_include("./source/io") # ICU_IO_SOURCES
add_library(icuio ${ICU_TYPE} ${ICU_IO_SOURCES})
target_compile_definitions(icuio PUBLIC U_IO_IMPLEMENTATION)
target_include_directories(icuio PUBLIC ${PROJECT_SOURCE_DIR}/source/common)
target_link_libraries(icuio PUBLIC icuuc icui18n)

sugar_include("./source/layout") # ICU_LAYOUT_SOURCES
add_library(icule ${ICU_TYPE} ${ICU_LAYOUT_SOURCES})
target_compile_definitions(icule PUBLIC U_LAYOUT_IMPLEMENTATION)
target_include_directories(icule PUBLIC ${PROJECT_SOURCE_DIR}/source/common)
target_link_libraries(icule PUBLIC icuuc)

sugar_include("./source/layoutex") # ICU_LAYOUTEX_SOURCES
add_library(iculx ${ICU_TYPE} ${ICU_LAYOUTEX_SOURCES})
target_compile_definitions(iculx PUBLIC U_LAYOUTEX_IMPLEMENTATION)
target_include_directories(icule PUBLIC ${PROJECT_SOURCE_DIR}/source/common)
target_link_libraries(iculx PUBLIC icuuc icule)

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
