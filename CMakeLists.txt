cmake_minimum_required(VERSION 3.0)

project(ExtBinPkgs)

option(ENABLE_WXWIDGETS "Set to ON to build wxWidgets library." OFF)
option(ENABLE_EXPERIMENTAL_DEPS "Set to ON to build experimentals libraries" OFF)
option(ENABLED_BUILD_REALSENSE "Set to ON to build libRealSense" OFF)
option(ENABLED_BUILD_ORB_SLAM2 "Set to ON to build ORB Slam 2" OFF)
option(ENABLED_BUILD_PTAM "Set to ON to build PTAM dependencies" OFF)


if(NOT ANDROID)
    
    list(APPEND SUBDIRECTORIES cgogn)

    if(ENABLE_EXPERIMENTAL_DEPS)
        list(APPEND SUBDIRECTORIES aram)
        list(APPEND SUBDIRECTORIES vlfeat)
    endif()
    
    if(ENABLED_BUILD_REALSENSE)
        if (NOT ENABLED_PCL_DEPS AND UNIX)
            # On Linux and OSX, libusb is required by libRealSense
            list(APPEND SUBDIRECTORIES libusb)
        endif()
        list(APPEND SUBDIRECTORIES realsense)
        list(APPEND SUBDIRECTORIES infinitam)
    endif()
    
    if(UNIX AND NOT APPLE)
        list(APPEND SUBDIRECTORIES vlc)
    endif()
    
    if(ENABLED_BUILD_ORB_SLAM2)
        if (NOT ENABLED_SOFA_DEPS)
            # GLEW is required by Pangolin
            list(APPEND SUBDIRECTORIES glew)
        endif()
        list(APPEND SUBDIRECTORIES pangolin)
        list(APPEND SUBDIRECTORIES orbslam2)
    endif()
    
    if(ENABLED_BUILD_PTAM)
        list(APPEND SUBDIRECTORIES gflags)
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
