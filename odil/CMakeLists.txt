cmake_minimum_required(VERSION 3.0)

project(odilBuilder)

include(ExternalProject)
include( ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-boost.cmake )

set(CACHED_URL https://github.com/fw4spl-org/odil/archive/fix_windows_build.zip)

if(WIN32)
    # Grab compile definitions from fw-boost.cmake
    get_directory_property(ODIL_DEFINITIONS COMPILE_DEFINITIONS)
    foreach(DEF ${ODIL_DEFINITIONS})
        set(ODIL_CMAKE_CXX_FLAGS "/D${DEF} ${ODIL_CMAKE_CXX_FLAGS}")
    endforeach()
    
    # Add exception flag for noexcept keyword
    set(ODIL_CMAKE_CXX_FLAGS "/EHsc ${ODIL_CMAKE_CXX_FLAGS}")
    
    set(CMAKE_CXX_STANDARD 11)
    set(ODIL_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                        -DBUILD_WRAPPERS=OFF
                        -DBUILD_EXAMPLES=OFF
                        -DBUILD_TESTING=OFF
                        -DCMAKE_CXX_FLAGS:STRING=${ODIL_CMAKE_CXX_FLAGS}
                        -DPC_ICU_INCLUDE_DIRS:PATH=${CMAKE_INSTALL_PREFIX}/include/icu
                        -DLog4Cpp_INCLUDE_DIR:PATH=${CMAKE_INSTALL_PREFIX}/include
                        -DJsonCpp_INCLUDE_DIR:PATH=${CMAKE_INSTALL_PREFIX}/include
                        -DPC_JsonCpp_LIBRARY_DIRS:PATH=${CMAKE_INSTALL_PREFIX}/lib
                        -DPC_ICU_LIBRARY_DIRS:PATH=${CMAKE_INSTALL_PREFIX}/lib
    )
else()
    set(ODIL_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                        -DBUILD_WRAPPERS=OFF
                        -DBUILD_EXAMPLES=OFF
                        -DBUILD_TESTING=OFF
                        -DBoost_USE_DEBUG_PYTHON=ON
                        -DBoost_USE_MULTITHREADED=ON
                        -DBoost_COMPILER:STRING=${Boost_COMPILER}
                        -DCMAKE_CXX_FLAGS:STRING=-std=c++11
    )
endif()


ExternalProject_Add(
    odil
    URL ${CACHED_URL}
    URL_HASH SHA256=bc03fa3492d1270a3f1afb01f0e6e370d6bf8c8e9bd4f795828ae74ec50c8bbe
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME odil-0.7.0.1.zip
    DEPENDS boost dcmtk jsoncpp icu4c log4cpp 
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${ODIL_CMAKE_ARGS}
)

ExternalProject_Add_Step(odil CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${FWEXT_CMAKE_RESOURCE_PATH}/findBinpkgs/FindODIL.cmake ${CMAKE_INSTALL_PREFIX}/FindODIL.cmake
    COMMENT "Install CMake find package"
    DEPENDEES install
)