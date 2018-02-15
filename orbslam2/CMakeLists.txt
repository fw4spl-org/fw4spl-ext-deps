cmake_minimum_required(VERSION 3.0)

project(orbslam2Builder)

include(ExternalProject)

set(CACHED_URL https://github.com/fw4spl-org/ORB_SLAM2/archive/v0.3.3.tar.gz)
include( ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-boost.cmake )

set(ORBSLAM2_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
    -DPangolin_DIR=${CMAKE_INSTALL_PREFIX}
    -DCUDA_TOOLKIT_ROOT_DIR:PATH=${CUDA_TOOLKIT_ROOT_DIR}
    -DBoost_COMPILER:STRING=${Boost_COMPILER}
    -DBOOST_ROOT:PATH=${CMAKE_INSTALL_PREFIX}
    -DBoost_USE_DEBUG_PYTHON:BOOL=ON
    -DBoost_USE_MULTITHREADED:BOOL=ON
    -DBoost_USE_STATIC_LIBS:BOOL=OFF
)

ExternalProject_Add(
    orbslam2
    URL ${CACHED_URL}
    URL_HASH SHA256=ff49f5d93c2154246a8255d9c6faff3073ea44ba2a0535ee7c4195c0461dfe44
    DOWNLOAD_NAME orbslam2-0.3.3.tar.gz
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DEPENDS boost opencv eigen pangolin
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${ORBSLAM2_CMAKE_ARGS} 
)

ExternalProject_Add_Step(orbslam2 CopyFindFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${FWEXT_CMAKE_RESOURCE_PATH}/findBinpkgs/FindORB_SLAM2.cmake
                                     ${CMAKE_INSTALL_PREFIX}/FindORB_SLAM2.cmake
    COMMENT "Install FindORB_SLAM2.cmake file"
    DEPENDEES install
)

# Convert txt vocabulary format to binary
ExternalProject_Add_Step(orbslam2 generateVocabulary
    COMMAND ${CMAKE_INSTALL_PREFIX}/bin/bin_vocabulary
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_INSTALL_PREFIX}/bin/ORBvoc.bin ${CMAKE_INSTALL_PREFIX}/share/ORB_SLAM2/ORBvoc.bin
    COMMAND ${CMAKE_COMMAND} -E remove ${CMAKE_INSTALL_PREFIX}/bin/ORBvoc.txt ${CMAKE_INSTALL_PREFIX}/bin/ORBvoc.bin
    WORKING_DIRECTORY ${CMAKE_INSTALL_PREFIX}/bin
    COMMENT "Generate Vocabulary"
    DEPENDEES install
)
