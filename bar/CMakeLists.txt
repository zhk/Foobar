if(NOT CMAKE_TOOLCHAIN_FILE)
    if(WIN32 AND NOT CYGWIN)
        set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/install" CACHE PATH "Installation Directory")
    else()
        set(CMAKE_INSTALL_PREFIX "/usr/local" CACHE PATH "Installation Directory")
    endif()
else()
    # any cross-compiling
    set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/install" CACHE PATH "Installation Directory")
endif()

cmake_minimum_required(VERSION 2.8)
project(bar)

include(GNUInstallDirs)

set(BUILD_SHARED_LIBS OFF CACHE BOOL "BUILD_SHARED_LIBS")

set(BOO_REQUIRED_ABI_VERSION 1.0)
set(BOO_REQUIRED_VERSION 0.1.0)

find_package(foo-${BOO_REQUIRED_ABI_VERSION} ${BOO_REQUIRED_VERSION} CONFIG REQUIRED)

add_executable(bar bar.cpp)

if (BUILD_SHARED_LIBS)
    target_link_libraries(bar foo::foo_shared)
else()
    target_link_libraries(bar foo::foo_static)
endif()


install(TARGETS bar
    RUNTIME DESTINATION "${INSTALL_BIN_DIR}" COMPONENT bin
)

#[[
include(GetPrerequisites)

if (CMAKE_BUILD_TYPE MATCHES "Debug" OR CMAKE_BUILD_TYPE EQUAL "None" OR NOT CMAKE_BUILD_TYPE)
    message(STATUS "----- CMAKE_BUILD_TYPE is Debug")
    set(CMAKE_BUILD_TYPE "Debug")
elseif (CMAKE_BUILD_TYPE MATCHES "Release")
    message(STATUS "----- CMAKE_BUILD_TYPE is Release")
    set(CMAKE_BUILD_TYPE "Release")
elseif (CMAKE_BUILD_TYPE MATCHES "RelWitchDebInfo")
    message(STATUS "----- CMAKE_BUILD_TYPE is RelWitchDebInfo")
    set(CMAKE_BUILD_TYPE "RelWitchDebInfo")
elseif (CMAKE_BUILD_TYPE MATCHES "MinSizeRel")
    message(STATUS "----- CMAKE_BUILD_TYPE is MinSizeRel")
    set(CMAKE_BUILD_TYPE "MinSizeRel")
else ()
    message(STATUS "----- unknown CMAKE_BUILD_TYPE = " ${CMAKE_BUILD_TYPE})
endif ()

get_property(MY_BINARY_LOCATION TARGET bar PROPERTY LOCATION_${CMAKE_BUILD_TYPE})
GET_PREREQUISITES(${MY_BINARY_LOCATION} DEPENDENCIES 1 0 "" "")
message("MY_BINARY_LOCATION='${MY_BINARY_LOCATION}'")

foreach(DEPENDENCY_FILE ${DEPENDENCIES})
    GP_RESOLVE_ITEM("${INSTALL_BIN_DIR}" "${DEPENDENCY_FILE}" "" "" resolved_file)
    message("resolved_file='${resolved_file}'")
endforeach()
]]