cmake_minimum_required(VERSION 3.1)

project(cgognBuilder)

INCLUDE(ExternalProject)

include( ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-boost.cmake )

set(CGOGN_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                        -DDISABLE_AUTO_LINK=ON
                        -DBoost_DEBUG=OFF
                        -DBoost_NO_SYSTEM_PATHS=ON
                        -DBoost_USE_DEBUG_PYTHON=ON
                        -DBoost_USE_MULTITHREADED=ON
                        -DBoost_COMPILER:STRING=${Boost_COMPILER}
                        -DBOOST_ROOT=${CMAKE_INSTALL_PREFIX}
)

set(CACHED_URL https://github.com/fw4spl-org/cgogn-light/archive/2016-10.tar.gz )

ExternalProject_Add(
    cgogn
    URL ${CACHED_URL}
    URL_HASH SHA256=e2fb42df1043aa5f28b7f519a907dd26a395f860a0cd207fe3a70249131f0225
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME cgogn-light-2016-10.zip
    DEPENDS libxml zlib boost
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${CGOGN_CMAKE_ARGS}
)
