
if(${CMAKE_BUILD_TYPE} STREQUAL "Debug")
    set(VLFEAT_DEBUG "debug")
else()
    set(VLFEAT_DEBUG "release")
endif()

ExternalProject_Add(
    vlfeat
    URL ${CACHED_URL}
    URL_HASH SHA256=${VLFEAT_HASH}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME vlfeat-0.9.21.tar.gz
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ${MAKE} MEX="" DEBUG=${VLFEAT_DEBUG} INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    INSTALL_COMMAND ${MAKE} install MEX="" DEBUG=${VLFEAT_DEBUG} INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    STEP_TARGETS CopyConfigFileToInstall
)

ExternalProject_Add_Step(vlfeat CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${FWEXT_CMAKE_RESOURCE_PATH}/findBinpkgs/fw-vlfeat.cmake ${CMAKE_INSTALL_PREFIX}/fw-vlfeat.cmake
    COMMENT "Install configuration file"
)
