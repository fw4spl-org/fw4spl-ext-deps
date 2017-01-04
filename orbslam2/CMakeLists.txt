cmake_minimum_required(VERSION 3.0)

project(orbslam2Builder)

include(ExternalProject)

set(CACHED_URL https://github.com/fw4spl-org/ORB_SLAM2/archive/c456b9de70d6ba3012dbeae7b60e03706287278b.tar.gz)
set(ORBSLAM2_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
    -DPangolin_DIR=${CMAKE_INSTALL_PREFIX}
)

ExternalProject_Add(
    orbslam2
    URL ${CACHED_URL}
    URL_HASH SHA256=47e72f6a6f7e4a98f670e82dab07bb8014b1692aa1005b7a2dbcfca69b65fbc4
    DOWNLOAD_NAME orbslam2-0.1-rev_c456b9d.tar.gz
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
