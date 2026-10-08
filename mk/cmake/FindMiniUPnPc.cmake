## ---------------------------------------------------------------------- ##
 # mk/cmake/FindMiniUPnPc.cmake
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
# libminiupnpc.a with no .pc at all -- which made this module report the host library
# and the link fail with "incompatible with aarch64linux". find_library and
# find_path honour CMAKE_LIBRARY_PATH / CMAKE_INCLUDE_PATH, which that build
# points at the sysroot, so they pick the right one in both cases.
find_package(PkgConfig)
if(PkgConfig_FOUND)
  pkg_check_modules(PC_MiniUPnPc QUIET miniupnpc)
endif()

find_path(MiniUPnPc_INCLUDE_DIR
  NAMES miniupnpc/miniupnpc.h
  HINTS ${PC_MiniUPnPc_INCLUDE_DIRS}
)
find_library(MiniUPnPc_LIBRARY
  NAMES miniupnpc
  HINTS ${PC_MiniUPnPc_LIBRARY_DIRS}
)
# Only pkg-config's own library answers for its version string: in a cross build
# the hint describes the host package, not the one found above.
get_filename_component(_MiniUPnPc_dir "${MiniUPnPc_LIBRARY}" DIRECTORY)
if(_MiniUPnPc_dir IN_LIST PC_MiniUPnPc_LIBRARY_DIRS)
  set(MiniUPnPc_VERSION "${PC_MiniUPnPc_VERSION}")
endif()
unset(_MiniUPnPc_dir)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(MiniUPnPc
  REQUIRED_VARS MiniUPnPc_LIBRARY MiniUPnPc_INCLUDE_DIR
  VERSION_VAR MiniUPnPc_VERSION
  HANDLE_VERSION_RANGE
)

if(MiniUPnPc_FOUND AND NOT TARGET miniupnpc::miniupnpc)
  add_library(miniupnpc::miniupnpc UNKNOWN IMPORTED)
  set_target_properties(miniupnpc::miniupnpc PROPERTIES
    IMPORTED_LOCATION "${MiniUPnPc_LIBRARY}"
    INTERFACE_INCLUDE_DIRECTORIES "${MiniUPnPc_INCLUDE_DIR}"
  )
endif()
