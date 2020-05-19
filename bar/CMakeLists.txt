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
