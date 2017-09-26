cmake_minimum_required(VERSION 3.0)

project(orbslam2Builder)

include(ExternalProject)

set(CACHED_URL https://github.com/fw4spl-org/ORB_SLAM2/archive/v0.2.tar.gz)

set(ORBSLAM2_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
    -DPangolin_DIR=${CMAKE_INSTALL_PREFIX}
)

ExternalProject_Add(
    orbslam2
    URL ${CACHED_URL}
    URL_HASH SHA256=aa57f35cf5ae17757d4dbce314d0ac1c0461ee62c4f1631d2b70f3d08740c6e3
    DOWNLOAD_NAME orbslam2-0.2.tar.gz
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DEPENDS opencv eigen pangolin
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${ORBSLAM2_CMAKE_ARGS} 
)

ExternalProject_Add_Step(orbslam2 CopyFindFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${FWEXT_CMAKE_RESOURCE_PATH}/findBinpkgs/FindORB_SLAM2.cmake
                                     ${CMAKE_INSTALL_PREFIX}/FindORB_SLAM2.cmake
    COMMENT "Install FindORB_SLAM2.cmake file"
    DEPENDEES install
)
