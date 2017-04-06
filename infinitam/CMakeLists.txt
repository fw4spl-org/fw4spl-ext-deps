cmake_minimum_required(VERSION 3.0)

project(InfiniTAMBuild)

include(ExternalProject)

set(INFINITAM_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)

if(APPLE)
    set(INFINITAM_PATCH_CMD ${PATCH_EXECUTABLE} -p1 -i ${INFINITAM_PATCH_DIR}/macos.diff -d <SOURCE_DIR>) 
endif()

set(CACHED_URL https://github.com/fw4spl-org/InfiniTAM/archive/v0.1.tar.gz)

ExternalProject_Add(
    infinitam
    DEPENDS realsense
    URL ${CACHED_URL}
    URL_HASH SHA256=6a5e690018fb8a33599e5bd9ce309836085c4887a6274c9db830ae59482578ab
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME InfiniTAM-v0.1.tar.gz
    DEPENDS ${REALSENSE_DEPENDS}
    PATCH_COMMAND ${INFINITAM_PATCH_CMD}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${COMMON_CMAKE_ARGS} -DWITH_GLUT=OFF
)


