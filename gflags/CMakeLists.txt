cmake_minimum_required(VERSION 2.8)

project(GFlagsBuilder)

include(ExternalProject)

set(CACHED_URL https://github.com/gflags/gflags/archive/v2.1.2.tar.gz)

set(GFLAGS_PATCH_CMD "${PATCH_EXECUTABLE}" -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/patch/msvc2015.diff -d <SOURCE_DIR>)
set(GFLAGS_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                      -DGFLAGS_NAMESPACE:STRING=google
                      -DBUILD_SHARED_LIBS:BOOL=ON
                      -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS} -std=c++11 )

ExternalProject_Add(
        gflags
        URL ${CACHED_URL}
        URL_HASH SHA256=d8331bd0f7367c8afd5fcb5f5e85e96868a00fd24b7276fa5fcee1e5575c2662
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        DOWNLOAD_NAME gflags_v2.1.2.tar.gz
        PATCH_COMMAND ${GFLAGS_PATCH_CMD}
        INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
        CMAKE_ARGS ${GFLAGS_CMAKE_ARGS}
)

if (WIN32)
    ExternalProject_Add_Step(gflags MoveDll
        COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_INSTALL_PREFIX}/lib/gflags.dll ${CMAKE_INSTALL_PREFIX}/bin/gflags.dll
        COMMAND ${CMAKE_COMMAND} -E remove ${CMAKE_INSTALL_PREFIX}/lib/gflags.dll
        COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_INSTALL_PREFIX}/lib/gflags_nothreads.dll ${CMAKE_INSTALL_PREFIX}/bin/gflags_nothreads.dll
        COMMAND ${CMAKE_COMMAND} -E remove ${CMAKE_INSTALL_PREFIX}/lib/gflags_nothreads.dll
        DEPENDEES install
        COMMENT "Move dll files."
)
endif()
