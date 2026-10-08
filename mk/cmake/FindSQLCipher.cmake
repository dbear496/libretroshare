## ---------------------------------------------------------------------- ##
 # mk/cmake/FindSQLCipher.cmake
 # This file is part of libRetroShare.
 #
 # Copyright (C) 2026      David Bears <dbear4q@gmail.com>
 #
 # This program is free software; you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
 # the Free Software Foundation; either version 2 of the License, or
 # (at your option) any later version.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # You should have received a copy of the GNU General Public License along
 # with this program; if not, write to the Free Software Foundation, Inc.,
 # 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
## ---------------------------------------------------------------------- ##

# 3.19: find_package_handle_standard_args(HANDLE_VERSION_RANGE)
cmake_minimum_required(VERSION 3.19...4.4)

# pkg-config is only a hint here. It is not sysroot-aware: asked during a cross
# build it answers with the host's .pc files, and the Android sysroot ships
# libsqlcipher.a with no .pc at all -- which made this module report the host library
# and the link fail with "incompatible with aarch64linux". find_library and
# find_path honour CMAKE_LIBRARY_PATH / CMAKE_INCLUDE_PATH, which that build
# points at the sysroot, so they pick the right one in both cases.
find_package(PkgConfig)
if(PkgConfig_FOUND)
  pkg_check_modules(PC_SQLCipher QUIET sqlcipher)
endif()

find_path(SQLCipher_INCLUDE_DIR
  NAMES sqlcipher/sqlite3.h
  HINTS ${PC_SQLCipher_INCLUDE_DIRS}
)
find_library(SQLCipher_LIBRARY
  NAMES sqlcipher
  HINTS ${PC_SQLCipher_LIBRARY_DIRS}
)
# Only pkg-config's own library answers for its version string: in a cross build
# the hint describes the host package, not the one found above.
get_filename_component(_SQLCipher_dir "${SQLCipher_LIBRARY}" DIRECTORY)
if(_SQLCipher_dir IN_LIST PC_SQLCipher_LIBRARY_DIRS)
  set(SQLCipher_VERSION "${PC_SQLCipher_VERSION}")
endif()
unset(_SQLCipher_dir)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(SQLCipher
  REQUIRED_VARS SQLCipher_LIBRARY SQLCipher_INCLUDE_DIR
  VERSION_VAR SQLCipher_VERSION
  HANDLE_VERSION_RANGE
)

if(SQLCipher_FOUND AND NOT TARGET SQLCipher::SQLCipher)
  add_library(SQLCipher::SQLCipher UNKNOWN IMPORTED)
  set_target_properties(SQLCipher::SQLCipher PROPERTIES
    IMPORTED_LOCATION "${SQLCipher_LIBRARY}"
    INTERFACE_INCLUDE_DIRECTORIES "${SQLCipher_INCLUDE_DIR}"
  )
endif()
