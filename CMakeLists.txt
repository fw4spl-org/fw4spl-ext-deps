cmake_minimum_required(VERSION 3.0)

project(ExtBinPkgs)

option(ENABLE_WXWIDGETS "Set to ON to build wxWidgets library." OFF)

list(APPEND SUBDIRECTORIES libarchive)
list(APPEND SUBDIRECTORIES openigtlink)
list(APPEND SUBDIRECTORIES zeromq)
list(APPEND SUBDIRECTORIES cgogn)

if(ENABLE_WXWIDGETS)
    list(APPEND SUBDIRECTORIES wxWidgets)
endif()

get_filename_component(CURRENT_DIR_NAME ${CMAKE_CURRENT_LIST_DIR} NAME)
foreach(subdir ${SUBDIRECTORIES})

    createUninstallTarget(${subdir})
    createCleanTarget(${subdir})

    add_subdirectory(${subdir})
endforeach()
