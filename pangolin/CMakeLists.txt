cmake_minimum_required(VERSION 3.0)

project(pangolinBuilder)

include(ExternalProject)

set(CACHED_URL https://github.com/fw4spl-org/Pangolin/archive/v0.5.1.tar.gz)

set(PANGOLIN_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
    -DBUILD_SHARED_LIBS=True
    -DBUILD_PANGOLIN_VIDEO=True
    -DBUILD_PANGOLIN_GUI=True
    -DBUILD_PANGOLIN_PYTHON=False
    -DBUILD_EXAMPLES=False
    -DBUILD_EXTERN_GLEW=False
    -DBUILD_EXTERN_LIBJPEG=False
    -DBUILD_EXTERN_LIBPNG=False
)

ExternalProject_Add(pangolin
    URL ${CACHED_URL}
    URL_HASH SHA256=94eb6804af19366effde868a5d629271330e9bf3439d86a0a4db2ca1eef55ad7
    DOWNLOAD_NAME pangolin-0.5.1.tar.gz
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DEPENDS glew eigen jpeg libpng
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${PANGOLIN_CMAKE_ARGS}
)

if(WIN32)
    ExternalProject_Add_Step(pangolin pangolinExportInstall
        COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_BINARY_DIR}/Pangolin-prefix/src/Pangolin-build/src/include/pangolin/pangolin_export.h"
                "${CMAKE_INSTALL_PREFIX}/include/pangolin/pangolin_export.h"
        COMMENT "Install pangolin_export"
        DEPENDEES install)
endif()
