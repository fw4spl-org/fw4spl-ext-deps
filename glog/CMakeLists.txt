cmake_minimum_required(VERSION 2.8)

project(GlogBuilder)

include(ExternalProject)

set(CACHED_URL https://github.com/emzeat/google-glog/archive/a2854b7db529a95d54ada2e250cf884e761c26bd.tar.gz)

set(GLOG_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
set(GLOG_PATCH_CMD ${PATCH_EXECUTABLE} -p1 -i ${GLOG_PATCH_DIR}/CMakeLists.diff -d <SOURCE_DIR>
    COMMAND ${PATCH_EXECUTABLE} -p1 -i ${GLOG_PATCH_DIR}/logging.cc.diff -d <SOURCE_DIR>
    COMMAND ${PATCH_EXECUTABLE} -p1 -i ${GLOG_PATCH_DIR}/windows_config.diff -d <SOURCE_DIR>
    COMMAND ${PATCH_EXECUTABLE} -p1 -i ${GLOG_PATCH_DIR}/config.h.in.diff -d <SOURCE_DIR>
)

set(GLOG_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                    -DGFLAGS_INCLUDE_DIRS=${CMAKE_INSTALL_PREFIX}/include
                    -DGFLAGS_LIBRARY_DIRS=${CMAKE_INSTALL_PREFIX}/lib
                    -DBUILD_SHARED_LIBS:BOOL=ON
            -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS} -std=c++11
)

ExternalProject_Add(
        glog
        URL ${CACHED_URL}
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        DOWNLOAD_NAME google-glog.tar.gz
        DEPENDS gflags
        PATCH_COMMAND ${GLOG_PATCH_CMD}
        INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
        CMAKE_ARGS ${GLOG_CMAKE_ARGS}
)
