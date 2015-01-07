cmake_minimum_required(VERSION 2.8)

project(ExtBinPkgs)

if(ANDROID)
    list(APPEND SUBDIRECTORIES openigtlink)
    list(APPEND SUBDIRECTORIES libarchive)
else()
    list(APPEND SUBDIRECTORIES libarchive)
    list(APPEND SUBDIRECTORIES openigtlink)
    list(APPEND SUBDIRECTORIES zeromq)
endif()


foreach(subdir ${SUBDIRECTORIES})
    # define an uninstall target for each project
    configure_file(
        "${CMAKE_SOURCE_DIR}/cmake_uninstall.cmake.in"
        "${CMAKE_BINARY_DIR}/${subdir}/cmake_uninstall.cmake"
        IMMEDIATE @ONLY)

    add_custom_target(${subdir}_uninstall
        COMMAND ${CMAKE_COMMAND} -P ${CMAKE_BINARY_DIR}/${subdir}/cmake_uninstall.cmake)

    # define the standard location for the intermediate install directory
    set(INSTALL_PREFIX_${subdir} ${CMAKE_CURRENT_BINARY_DIR}/${subdir}/${subdir}-prefix/src/${subdir}-install-tmp)

    add_subdirectory(${subdir})
endforeach()
