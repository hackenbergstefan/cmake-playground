cmake_minimum_required(VERSION 3.1)

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

get_target_property(FFI_INTERFACE_SOURCES mathlib_ffi INTERFACE_SOURCES)
get_target_property(FFI_INCLUDE_DIRECTORIES mathlib_ffi INCLUDE_DIRECTORIES)

execute_process(
    COMMAND
    python -c "import distutils.sysconfig; print(distutils.sysconfig.get_config_vars()['CFLAGS'] + distutils.sysconfig.get_config_vars()['CCSHARED'])"
    OUTPUT_VARIABLE
    PYTHON_DISTUTILS_CFLAGS
    OUTPUT_STRIP_TRAILING_WHITESPACE)
message("PYTHON_DISTUTILS_CFLAGS ${PYTHON_DISTUTILS_CFLAGS}")

execute_process(
    COMMAND
    python -c "import distutils.sysconfig; print(distutils.sysconfig.get_config_vars()['CONFINCLUDEPY'])"
    OUTPUT_VARIABLE
    PYTHON_DISTUTILS_INCLUDE_DIRECTORIES
    OUTPUT_STRIP_TRAILING_WHITESPACE)
message("PYTHON_DISTUTILS_INCLUDE_DIRECTORIES ${PYTHON_DISTUTILS_INCLUDE_DIRECTORIES}")

execute_process(
    COMMAND
    python -c "import distutils.sysconfig; print(distutils.sysconfig.get_config_vars()['LDFLAGS'])"
    OUTPUT_VARIABLE
    PYTHON_DISTUTILS_LINK_FLAGS
    OUTPUT_STRIP_TRAILING_WHITESPACE)
message("PYTHON_DISTUTILS_LINK_FLAGS ${PYTHON_DISTUTILS_LINK_FLAGS}")

target_compile_options(mathlib_ffi PRIVATE ${PYTHON_DISTUTILS_CFLAGS})
target_include_directories(mathlib_ffi PRIVATE ${PYTHON_DISTUTILS_INCLUDE_DIRECTORIES})
target_link_options(mathlib_ffi PRIVATE ${PYTHON_DISTUTILS_LINK_FLAGS})

configure_file(ffi_generated.py.in ${CMAKE_BINARY_DIR}/ffi_generated.py)
add_custom_command(
    OUTPUT
    ${CMAKE_BINARY_DIR}/mathlib_ffi.c
    COMMAND python ${CMAKE_BINARY_DIR}/ffi_generated.py
    DEPENDS ${CMAKE_BINARY_DIR}/ffi_generated.py
)

target_sources(mathlib_ffi
    PRIVATE
    ${CMAKE_BINARY_DIR}/mathlib_ffi.c)

# get_cmake_property(_variableNames VARIABLES)
# list(SORT _variableNames)

# foreach(_variableName ${_variableNames})
# message(STATUS "${_variableName}=${${_variableName}}")
# endforeach()
