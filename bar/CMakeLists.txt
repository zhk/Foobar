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


set(BUILD_SHARED_LIBS "" ON)

set(BOO_REQUIRED_VERSION 0.1.0)
set(BOO_REQUIRED_ABI_VERSION 1.0)

if (BUILD_SHARED_LIBS)
    find_package(foo-${BOO_REQUIRED_ABI_VERSION} ${BOO_REQUIRED_VERSION} REQUIRED)
    set(foo_libraries ${FOO_LIBRARIES})
    set(foo_include_directories ${FOO_INCLUDE_DIRS})
    set(foo_definitions ${FOO_DEFINITIONS})
else()
    find_package(foo-static-${BOO_REQUIRED_ABI_VERSION} ${BOO_REQUIRED_VERSION} REQUIRED)
    set(foo_libraries ${FOO_STATIC_LIBRARIES})
    set(foo_include_directories ${FOO_STATIC_INCLUDE_DIRS})
    set(foo_definitions ${FOO_STATIC_DEFINITIONS})
endif()

message(STATUS "foo_include_directories: " ${foo_include_directories})
message(STATUS "foo_libraries: " ${foo_libraries})

add_executable(bar bar.cpp)

target_include_directories(bar PUBLIC include
    PRIVATE ${foo_include_directories}
    )
target_compile_definitions(bar PRIVATE ${foo_definitions})
target_link_libraries(bar ${foo_libraries})

install(TARGETS bar
  RUNTIME DESTINATION "${INSTALL_BIN_DIR}" COMPONENT bin
 )
