cmake_minimum_required(VERSION 3.1)

project(cgognBuilder)

INCLUDE(ExternalProject)

include( ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-boost.cmake )

set(CGOGN_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                        -DBoost_DEBUG=OFF
                        -DBoost_NO_SYSTEM_PATHS=ON
                        -DBoost_USE_DEBUG_PYTHON=ON
                        -DBoost_USE_MULTITHREADED=ON
                        -DBoost_COMPILER:STRING=${Boost_COMPILER}
                        -DBOOST_ROOT=${CMAKE_INSTALL_PREFIX}
)

set(CACHED_URL https://github.com/fw4spl-org/cgogn-light/archive/2016-01.tar.gz )

ExternalProject_Add(
    cgogn
    URL ${CACHED_URL}
    URL_HASH SHA256=1179f916f8c3e7ac599b980fcf0b15e085cb1fda12e36dd003ffac962a73c303
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME cgogn-light-2016-01.zip
    DEPENDS libxml zlib boost
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${CGOGN_CMAKE_ARGS}
)
