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

set(CACHED_URL https://github.com/fw4spl-org/cgogn-light/archive/2017-04.tar.gz )

if(NOT CMAKE_SYSTEM_NAME STREQUAL Linux)
    set(CGOGN_DEPENDS libxml zlib)
endif()

ExternalProject_Add(
    cgogn
    URL ${CACHED_URL}
    URL_HASH SHA256=292ab0ad619c10b4ff1ad9e5481d6c12e134bcf78cc439079ee886225e7cb99f
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME cgogn-light-2017-04.zip
    DEPENDS ${CGOGN_DEPENDS} boost
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${CGOGN_CMAKE_ARGS}
)
