cmake_minimum_required(VERSION 3.0)

project(ExtBinPkgs)

set(FWEXT_CMAKE_RESOURCE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

option(ENABLE_EXPERIMENTAL_DEPS "Set to ON to build experimentals libraries" OFF)

if(NOT ANDROID)

    if(ENABLE_EXPERIMENTAL_DEPS)
        list(APPEND SUBDIRECTORIES aram)
    endif()
endif()

get_filename_component(CURRENT_DIR_NAME ${CMAKE_CURRENT_LIST_DIR} NAME)
foreach(subdir ${SUBDIRECTORIES})

    createUninstallTarget(${subdir})
    createCleanTarget(${subdir})

    add_subdirectory(${subdir})
endforeach()
