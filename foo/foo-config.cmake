include("${CMAKE_CURRENT_LIST_DIR}/foo-targets.cmake")

set (FOO_MAJOR_VERSION 1)
set (FOO_MINOR_VERSION 0)
set (FOO_MICRO_VERSION 0)
set (FOO_VERSION 1.0.0-pre)

get_filename_component(PACKAGE_PREFIX_DIR "${CMAKE_CURRENT_LIST_DIR}/../../../" ABSOLUTE)

macro(set_and_check _var _file)
  set(${_var} "${_file}")
  if(NOT EXISTS "${_file}")
    message(FATAL_ERROR "File or directory ${_file} referenced by variable ${_var} does not exist !")
  endif()
endmacro()

macro(check_required_components _NAME)
  foreach(comp ${${_NAME}_FIND_COMPONENTS})
    if(NOT ${_NAME}_${comp}_FOUND)
      if(${_NAME}_FIND_REQUIRED_${comp})
        set(${_NAME}_FOUND FALSE)
      endif()
    endif()
  endforeach()
endmacro()

####################################################################################

set_and_check (FOO_INCLUDE_DIRS "${PACKAGE_PREFIX_DIR}/include/foo-1.0")

# We want to provide an absolute path to the library and we know the
# directory and the base name, but not the suffix, so we use CMake's
# find_library () to pick that up.  Users can override this by configuring
# FOO_LIBRARY themselves.
find_library (FOO_LIBRARY FOO-1.0 PATHS "${PACKAGE_PREFIX_DIR}/lib" NO_DEFAULT_PATH)

set (FOO_LIBRARIES ${FOO_LIBRARY})
