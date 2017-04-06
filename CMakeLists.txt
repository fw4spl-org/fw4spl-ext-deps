cmake_minimum_required(VERSION 3.0)

project(ExtBinPkgs)

set(FWEXT_CMAKE_RESOURCE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

option(ENABLE_WXWIDGETS "Set to ON to build wxWidgets library." OFF)
option(ENABLE_EXPERIMENTAL_DEPS "Set to ON to build experimentals libraries" OFF)
option(ENABLED_BUILD_INFINITAM "Set to ON to build infinitam" OFF)
option(ENABLED_BUILD_ORB_SLAM2 "Set to ON to build ORB Slam 2" OFF)
option(ENABLED_BUILD_PTAM "Set to ON to build PTAM dependencies" OFF)
option(ENABLED_BUILD_NUMPY "Set to ON to build numpy dependencies" OFF)



if(NOT ANDROID)

    list(APPEND SUBDIRECTORIES cgogn)
    list(APPEND SUBDIRECTORIES cryptopp)

    if (ENABLED_BUILD_NUMPY)
        list(APPEND SUBDIRECTORIES numpy)
    endif()

    if(NOT APPLE)
        list(APPEND SUBDIRECTORIES curl)
    endif()

    if(ENABLE_EXPERIMENTAL_DEPS)
        list(APPEND SUBDIRECTORIES aram)
        list(APPEND SUBDIRECTORIES vlfeat)
    endif()

    if(ENABLED_BUILD_INFINITAM)
        if(NOT ENABLED_REALSENSE)
            message(WARNING "ENABLED_REALSENSE should be set to ON if you want to build infinitam")
        else()
            list(APPEND SUBDIRECTORIES infinitam)
        endif()

    endif()

    list(APPEND SUBDIRECTORIES vlc)

    if(ENABLED_BUILD_ORB_SLAM2)
        if (NOT ENABLED_SOFA_DEPS)
            # GLEW is required by Pangolin
            list(APPEND SUBDIRECTORIES glew)
        endif()
        list(APPEND SUBDIRECTORIES pangolin)
        list(APPEND SUBDIRECTORIES orbslam2)
    endif()

    if(ENABLED_BUILD_PTAM)
        list(APPEND SUBDIRECTORIES glog)
        list(APPEND SUBDIRECTORIES CXSparse)
        list(APPEND SUBDIRECTORIES ceresSolver)
    endif()

    if(ENABLE_WXWIDGETS)
        list(APPEND SUBDIRECTORIES wxWidgets)
    endif()

else()
    if(ENABLE_EXPERIMENTAL_DEPS)
        list(APPEND SUBDIRECTORIES ndkgui)
        list(APPEND SUBDIRECTORIES tango)
    endif()
endif()

get_filename_component(CURRENT_DIR_NAME ${CMAKE_CURRENT_LIST_DIR} NAME)
foreach(subdir ${SUBDIRECTORIES})

    createUninstallTarget(${subdir})
    createCleanTarget(${subdir})

    add_subdirectory(${subdir})
endforeach()
