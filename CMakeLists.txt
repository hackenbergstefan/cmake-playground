cmake_minimum_required(VERSION 3.1)

project(mathlib)

list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)
list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake/clangformat-cmake/cmake)
include(ClangFormat)

if(NOT ${CMAKE_CROSSCOMPILING})
    add_library(mathlib_ffi SHARED)
    set(CMAKE_SHARED_LIBRARY_PREFIX "")
    target_sources(mathlib_ffi
        PRIVATE
        src/mathlib.c
        INTERFACE
        ${CMAKE_SOURCE_DIR}/inc/mathlib.h
    )
    target_include_directories(mathlib_ffi
        PRIVATE
        ${CMAKE_SOURCE_DIR}/inc
    )

    include(FFI)
    target_ffi_setup(mathlib_ffi)
endif()

add_library(mathlib STATIC)
set(CMAKE_SHARED_LIBRARY_PREFIX "")
target_sources(mathlib
    PRIVATE
    src/mathlib.c
    INTERFACE
    ${CMAKE_SOURCE_DIR}/inc/mathlib.h)
target_include_directories(mathlib
    PRIVATE
    inc)
target_clangformat_setup(mathlib)

set(CLANG_TIDY_COMMAND "${CLANG_TIDY_EXE}" "-checks=-*,modernize-*")
set_target_properties(mathlib PROPERTIES
    C_CLANG_TIDY "clang-tidy"
    C_INCLUDE_WHAT_YOU_USE "include-what-you-use")
