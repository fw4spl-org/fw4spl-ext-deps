cmake_minimum_required(VERSION 3.0)

project(ExtBinPkgs)

set(FWEXT_CMAKE_RESOURCE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

option(ENABLE_EXPERIMENTAL_DEPS "Set to ON to build experimentals libraries" OFF)
option(ENABLE_INFINITAM "Set to ON to build infinitam" OFF)
option(ENABLE_ORB_SLAM2 "Set to ON to build ORB Slam 2" OFF)

if(NOT ANDROID)

    list(APPEND SUBDIRECTORIES cgogn)
    list(APPEND SUBDIRECTORIES cryptopp)

    if(NOT APPLE)
        list(APPEND SUBDIRECTORIES curl)
    endif()

    if(ENABLE_EXPERIMENTAL_DEPS)
        list(APPEND SUBDIRECTORIES aram)
        list(APPEND SUBDIRECTORIES vlfeat)
    endif()

    if(ENABLE_INFINITAM)
        if(NOT ENABLE_REALSENSE)
            message(WARNING "ENABLE_REALSENSE should be set to ON if you want to build infinitam")
        else()
            list(APPEND SUBDIRECTORIES infinitam)
        endif()

    endif()

    list(APPEND SUBDIRECTORIES vlc)

    if(ENABLE_ORB_SLAM2)
        list(APPEND SUBDIRECTORIES pangolin)
        list(APPEND SUBDIRECTORIES orbslam2)
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
