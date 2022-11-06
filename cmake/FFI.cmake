function(prefix_ffi_setup target)
    # ##############
    # Get python system configuration
    # ##############
    if(NOT FFI_PYTHON_DISTUTILS_CFLAGS)
        execute_process(
            COMMAND
            python -c "import distutils.sysconfig; print(distutils.sysconfig.get_config_vars()['CFLAGS'] + distutils.sysconfig.get_config_vars()['CCSHARED'])"
            OUTPUT_VARIABLE
            FFI_PYTHON_DISTUTILS_CFLAGS
            OUTPUT_STRIP_TRAILING_WHITESPACE)
    endif()

    if(NOT FFI_PYTHON_DISTUTILS_LINK_FLAGS)
        execute_process(
            COMMAND
            python -c "import distutils.sysconfig; print(distutils.sysconfig.get_config_vars()['LDFLAGS'])"
            OUTPUT_VARIABLE
            FFI_PYTHON_DISTUTILS_LINK_FLAGS
            OUTPUT_STRIP_TRAILING_WHITESPACE)
    endif()

    if(NOT FFI_PYTHON_DISTUTILS_INCLUDE_DIRECTORIES)
        execute_process(
            COMMAND
            python -c "import distutils.sysconfig; print(distutils.sysconfig.get_config_vars()['CONFINCLUDEPY'])"
            OUTPUT_VARIABLE
            FFI_PYTHON_DISTUTILS_INCLUDE_DIRECTORIES
            OUTPUT_STRIP_TRAILING_WHITESPACE)
    endif()

    target_compile_options(${target} PRIVATE ${FFI_PYTHON_DISTUTILS_CFLAGS})
    target_include_directories(${target} PRIVATE ${FFI_PYTHON_DISTUTILS_INCLUDE_DIRECTORIES})
    target_link_options(${target} PRIVATE ${FFI_PYTHON_DISTUTILS_LINK_FLAGS})

    # ##############
    # Modify target
    # ##############
    get_target_property(target_interface_sources ${target} INTERFACE_SOURCES)
    get_target_property(target_include_directories ${target} INCLUDE_DIRECTORIES)

    configure_file(${CMAKE_CURRENT_FUNCTION_LIST_DIR}/ffi_generated.py.in ${CMAKE_CURRENT_BINARY_DIR}/${target}_ffi_generated.py)

    target_sources(mathlib_ffi
        PRIVATE
        ${CMAKE_CURRENT_BINARY_DIR}/mathlib_ffi.c)

    add_custom_command(
        OUTPUT
        ${target}.c
        COMMAND
        python ${CMAKE_CURRENT_BINARY_DIR}/${target}_ffi_generated.py
        WORKING_DIRECTORY
        ${CMAKE_CURRENT_BINARY_DIR}
        DEPENDS
        ${CMAKE_CURRENT_BINARY_DIR}/${target}_ffi_generated.py
    )

    target_sources(${target} PRIVATE ${target}.c)
endfunction()

function(target_ffi_setup target)
    prefix_ffi_setup(${target})
endfunction()
