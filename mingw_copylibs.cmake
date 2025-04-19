function (mingw_copylibs_install exe)
    get_filename_component(barename ${exe} NAME)
    set(extradlldirs ${ARGN})

    configure_file(${mingw_copylibs_DIR}/mingw_copylibs_install.cmake.in
        ${CMAKE_CURRENT_BINARY_DIR}/${barename}.install.cmake @ONLY
    )
    install(SCRIPT ${CMAKE_CURRENT_BINARY_DIR}/${barename}.install.cmake)
endfunction()
