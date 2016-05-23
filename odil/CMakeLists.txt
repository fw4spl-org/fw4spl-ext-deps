cmake_minimum_required(VERSION 3.0)

project(odilBuilder)

include(ExternalProject)
include( ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-boost.cmake )

set(CACHED_URL https://github.com/fw4spl-org/odil/archive/0.7.0.1.zip)

if(WIN32)
	set (CMAKE_CXX_STANDARD 11)
	set(ODIL_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
						-DBUILD_WRAPPERS=OFF
						-DBUILD_EXAMPLES=OFF
						-DBUILD_TESTING=OFF
						-DBoost_USE_DEBUG_PYTHON=ON
						-DBoost_USE_MULTITHREADED=ON
						-DBoost_COMPILER:STRING=${Boost_COMPILER}
						-DCMAKE_CXX_FLAGS:STRING=/EHsc 
                        -DJsonCpp_LIBRARY:PATH=${CMAKE_INSTALL_PREFIX}/lib
                        -DLog4Cpp_LIBRARY:PATH=${CMAKE_INSTALL_PREFIX}/lib
                        -DICU_LIBRARY:PATH=${CMAKE_INSTALL_PREFIX}/lib
                        -DLog4Cpp_INCLUDE_DIR:PATH=${CMAKE_INSTALL_PREFIX}/include
                        -DJsonCpp_INCLUDE_DIR:PATH=${CMAKE_INSTALL_PREFIX}/include
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
                        -DLog4Cpp_LIBRARY:PATH=${CMAKE_INSTALL_PREFIX}/lib
                        -DJsonCpp_LIBRARY:PATH=${CMAKE_INSTALL_PREFIX}/lib
                        -DICU_LIBRARY:PATH=${CMAKE_INSTALL_PREFIX}/lib
                        -DLog4Cpp_INCLUDE_DIR:PATH=${CMAKE_INSTALL_PREFIX}/include
                        -DJsonCpp_INCLUDE_DIR:PATH=${CMAKE_INSTALL_PREFIX}/include
    )
endif()


ExternalProject_Add(
    odil
    URL ${CACHED_URL}
    URL_HASH SHA256=f204787d9d490c039095dbfb513753154a6aac86a36a53da52180c80d83758d3
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