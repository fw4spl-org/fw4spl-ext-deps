CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(zeromqBuilder)

INCLUDE(ExternalProject)

getCachedUrl(http://download.zeromq.org/zeromq-4.0.4.tar.gz CACHED_URL)


if(WIN32)
    set(ZEROMQ_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
    set(ZEROMQ_CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} 
                          -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                          -DZMQ_BUILD_TESTS:BOOL=OFF
    )

    ExternalProject_Add(
        zeromq
        URL ${CACHED_URL}
        URL_HASH SHA256=1ef71d46e94f33e27dd5a1661ed626cd39be4d2d6967792a275040e34457d399
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        PATCH_COMMAND ${CMAKE_COMMAND} -E  copy_directory "${ZEROMQ_PATCH_DIR}/" "<SOURCE_DIR>/"
        INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
        CMAKE_ARGS ${ZEROMQ_CMAKE_ARGS}
        STEP_TARGETS CopyConfigFileToInstall
    )
    
    ExternalProject_Add_Step(zeromq CPP_ZEROMQ
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/cpp-zeromq ${CMAKE_INSTALL_PREFIX}/include/zmq
        DEPENDEES build
        DEPENDERS install
    )
else()
    ExternalProject_Add(
        zeromq
        URL ${CACHED_URL}
        URL_HASH SHA256=1ef71d46e94f33e27dd5a1661ed626cd39be4d2d6967792a275040e34457d399
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        BUILD_IN_SOURCE 1
        CONFIGURE_COMMAND <SOURCE_DIR>/configure
                        --enable-shared 
                        --disable-static
                        --prefix=${CMAKE_INSTALL_PREFIX}
        BUILD_COMMAND ${MAKE} -f <SOURCE_DIR>/Makefile
        INSTALL_COMMAND ${MAKE} -f <SOURCE_DIR>/Makefile DESTDIR=${INSTALL_PREFIX_zeromq} install
        STEP_TARGETS CopyConfigFileToInstall
    )

    ExternalProject_Add_Step(zeromq CPP_ZEROMQ
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/cpp-zeromq ${INSTALL_PREFIX_zeromq}/${CMAKE_INSTALL_PREFIX}/include/
        DEPENDEES build
        DEPENDERS install
    )

    ExternalProject_Add_Step(zeromq COPY_FILES
        COMMAND ${CMAKE_COMMAND} -D SRC:PATH=${INSTALL_PREFIX_zeromq} -D DST:PATH=${CMAKE_INSTALL_PREFIX} -P ${CMAKE_SOURCE_DIR}/Install.txt
        DEPENDEES install
    )

endif()

ExternalProject_Add_Step(zeromq CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/findBinpkgs/FindZEROMQ.cmake ${CMAKE_INSTALL_PREFIX}/FindZEROMQ.cmake
    COMMENT "Install configuration file"
)

if(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -fPIC")
endif()
