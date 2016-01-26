cmake_minimum_required(VERSION 3.0)

project(wxWidgetsBuilder)

include(ExternalProject)

set(CACHED_URL http://freefr.dl.sourceforge.net/wxwindows/wxWidgets-3.0.2.tar.bz2)

if(WIN32)
    if(${IS_DEBUG})
        set(BUILDTYPE "debug")
    else()
        set(BUILDTYPE "release")
    endif()
    set(WX_SRC_DIR ${CMAKE_CURRENT_BINARY_DIR}/wxWidgets-prefix/src/wxWidgets)
    
    set(BUILD_CMD
        -f 
        ${WX_SRC_DIR}/build/msw/makefile.vc
        BUILD=${BUILDTYPE}
        UNICODE=1
        SHARED=1
        MONOLITHIC=0
        USE_GUI=1
        USE_HTML=1
        USE_WEBVIEW=1
        USE_MEDIA=1
        USE_XRC=1
        USE_AUI=1
        USE_RIBBON=1
        USE_PROPGRID=1
        USE_RICHTEXT=1
        USE_STC=1
        USE_OPENGL=1
        USE_QA=1
        USE_EXCEPTIONS=1
        USE_RTTI=1
        USE_THREADS=1
        USE_CAIRO=0
    )
    
    set(WX_DEBUG_FLAG "")
    if(${IS_DEBUG})
        set(WX_DEBUG_FLAG "d")
    endif()
    
    ExternalProject_Add(
        wxWidgets
        URL ${CACHED_URL}
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        CONFIGURE_COMMAND ""
        BINARY_DIR ${WX_SRC_DIR}/build/msw/
        BUILD_COMMAND ${MAKE} ${BUILD_CMD}
        INSTALL_COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/InstallWxWidgets.cmake
    )

    file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/InstallWxWidgets.cmake
        "
        file(INSTALL ${WX_SRC_DIR}/lib/vc_dll/ DESTINATION ${CMAKE_INSTALL_PREFIX}/bin/ FILES_MATCHING PATTERN \"*.dll\")
        file(INSTALL ${WX_SRC_DIR}/lib/vc_dll/ DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/ FILES_MATCHING PATTERN \"*.lib\")
        file(INSTALL ${WX_SRC_DIR}/include/ DESTINATION ${CMAKE_INSTALL_PREFIX}/include/)
        file(INSTALL ${WX_SRC_DIR}/lib/vc_dll/mswu${WX_DEBUG_FLAG} DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/)
        "
    )
else()
    if(NOT APPLE)
        # There is no way to tell configure to look for dependencies (jpeg, png, etc...)
        # Thus we modify environment variables to help configuring program scripts to find headers and libraries
        set(SETENV CC=${CMAKE_C_COMPILER} CXX=${CMAKE_CXX_COMPILER} )
    endif()

    set(WX_SRC_DIR ${CMAKE_CURRENT_BINARY_DIR}/wxWidgets-prefix/src/wxWidgets)
    set(WX_CONFIGURE
            ${WX_SRC_DIR}/configure
            --prefix=${CMAKE_INSTALL_PREFIX}
            --enable-shared
            --disable-static
            --enable-unicode
            --with-opengl
            --with-libjpeg=builtin
            --with-libpng=builtin
            --with-libtiff=builtin
            --with-zlib=builtin
            --with-expat=builtin
            --disable-samples
            --without-subdirs
    )
    ExternalProject_Add(
        wxWidgets
        URL ${CACHED_URL}
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        DEPENDS zlib jpeg libpng tiff expat freetype libiconv
        CONFIGURE_COMMAND ${SETENV} ${WX_CONFIGURE}
        BUILD_IN_SOURCE 1
        BUILD_COMMAND ${MAKE} -j${NUMBER_OF_PARALLEL_BUILD} install
        INSTALL_COMMAND ""
        STEP_TARGETS CopyConfigFileToInstall
    )
endif()

ExternalProject_Add_Step(wxWidgets CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-wxWidgets.cmake ${CMAKE_INSTALL_PREFIX}/fw-wxWidgets.cmake
    COMMENT "Install configuration file"
)
