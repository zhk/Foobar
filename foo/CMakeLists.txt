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


cmake_minimum_required(VERSION 3.1)

project(FooBar LANGUAGES CXX)

include(GNUInstallDirs)


set (CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${PROJECT_SOURCE_DIR}/build/cmake)

set (FOO_OUTPUT_BASENAME "foo" CACHE STRING "Output foo library base name")

set(FOO_MAJOR_VERSION 0)
set(FOO_MINOR_VERSION 1)
set(FOO_PATCH_VERSION 0)
set(FOO_VERSION ${FOO_MAJOR_VERSION}.${FOO_MINOR_VERSION}.${FOO_PATCH_VERSION})

set (FOO_API_VERSION 1.0)

set (CPACK_PACKAGE_VERSION_MAJOR ${FOO_MAJOR_VERSION})
set (CPACK_PACKAGE_VERSION_MINOR ${FOO_MINOR_VERSION})



configure_file (
   "${PROJECT_SOURCE_DIR}/foo-config.h.in"
   "${PROJECT_BINARY_DIR}/foo/foo-config.h"
)

include_directories ("${PROJECT_BINARY_DIR}")
# For the generated files, like foo-config.h, add src/foo to the include path
# so it can be included relatively when building, like #include "foo-config.h"
# But when installed, all foo headers will be in the same directory.

set (SOURCES
   ${PROJECT_SOURCE_DIR}/foo.cpp
)

set (HEADERS
   ${PROJECT_BINARY_DIR}/foo/foo-config.h
   ${PROJECT_SOURCE_DIR}/foo.h
)

# shared library
add_library (foo_shared SHARED ${SOURCES} ${HEADERS} )
target_include_directories (foo_shared INTERFACE
	$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/foo>
	$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/foo>
)
set_target_properties (foo_shared PROPERTIES VERSION 0.0.0 SOVERSION 0)
set_target_properties (foo_shared PROPERTIES OUTPUT_NAME "${FOO_OUTPUT_BASENAME}-${FOO_API_VERSION}")


# static library
add_library (foo_static STATIC ${SOURCES} ${HEADERS} )
target_compile_definitions (foo_static PUBLIC FOO_STATIC)
target_include_directories (foo_static INTERFACE
	$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/foo>
	$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/foo>
)
set_target_properties (foo_static PROPERTIES VERSION 0.0.0)
set_target_properties (foo_static PROPERTIES OUTPUT_NAME "${FOO_OUTPUT_BASENAME}-static-${FOO_API_VERSION}")


set (FOO_HEADER_INSTALL_DIR "${CMAKE_INSTALL_INCLUDEDIR}/foo-${FOO_API_VERSION}")

install (
   TARGETS foo_shared foo_static
   EXPORT foo-targets
   LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
   ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
   RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
   INCLUDES DESTINATION ${FOO_HEADER_INSTALL_DIR}
   FRAMEWORK DESTINATION ${CMAKE_INSTALL_BINDIR}
)

install (
   FILES ${HEADERS}
   DESTINATION "${FOO_HEADER_INSTALL_DIR}/foo"
)

#foo-targets.cmake
install (
    EXPORT foo-targets
    NAMESPACE foo::
    FILE foo-targets.cmake
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/foo-${FOO_API_VERSION}
)

#[[
# variables unsed in foo-1.0.pc.in and foo-static-1.0.pc.in
set (VERSION "${FOO_VERSION}")
set (prefix "${CMAKE_INSTALL_PREFIX}")
set (libdir "\${prefix}/${CMAKE_INSTALL_LIBDIR}")
configure_file (
   ${CMAKE_CURRENT_SOURCE_DIR}/foo-1.0.pc.in
   ${CMAKE_CURRENT_BINARY_DIR}/foo-1.0.pc
   @ONLY)

install (
   FILES ${CMAKE_CURRENT_BINARY_DIR}/foo-1.0.pc
   DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig
)

configure_file (
  ${CMAKE_CURRENT_SOURCE_DIR}/foo-static-1.0.pc.in
  ${CMAKE_CURRENT_BINARY_DIR}/foo-static-1.0.pc
  @ONLY)

install (
  FILES
	 ${CMAKE_CURRENT_BINARY_DIR}/foo-static-1.0.pc
  DESTINATION
	 ${CMAKE_INSTALL_LIBDIR}/pkgconfig
)
]]


include (CMakePackageConfigHelpers)

configure_package_config_file(
  foo-config.cmake.in "${CMAKE_CURRENT_BINARY_DIR}/foo-${FOO_API_VERSION}-config.cmake"
  INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/foo-${FOO_API_VERSION}
)

#foo-1.0-config-version.cmake
write_basic_package_version_file (
   "${CMAKE_CURRENT_BINARY_DIR}/foo-${FOO_API_VERSION}-config-version.cmake"
   VERSION ${FOO_VERSION}
   COMPATIBILITY AnyNewerVersion
)


install (
   FILES
      "${CMAKE_CURRENT_BINARY_DIR}/foo-${FOO_API_VERSION}-config.cmake"
      "${CMAKE_CURRENT_BINARY_DIR}/foo-${FOO_API_VERSION}-config-version.cmake"
   DESTINATION
      ${CMAKE_INSTALL_LIBDIR}/cmake/foo-${FOO_API_VERSION}
   COMPONENT
      Devel
)

