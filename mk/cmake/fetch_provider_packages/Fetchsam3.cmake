# ------------------------------------------------------------------------ *\
# mk/cmake/Fetchsam3.cmake
# This file is part of RetroShare.
#
# Copyright (C) 2026      David Bears <dbear4q@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
# ------------------------------------------------------------------------ */

ExternalProject_Get_Property(sam3_external SOURCE_DIR BINARY_DIR)
set(${FETCH_PROVIDER_PACKAGE_NAME}_FOUND TRUE)

if(NOT TARGET libsam3::libsam3)
  add_library(libsam3::libsam3 STATIC IMPORTED)
  set_target_properties(libsam3::libsam3 PROPERTIES
    IMPORTED_LOCATION "${BINARY_DIR}/libsam3.a"
    INTERFACE_INCLUDE_DIRECTORIES
      "${SOURCE_DIR}/src/libsam3;${SOURCE_DIR}/src/libsam3a"
  )
  add_dependencies(libsam3::libsam3 libsam3_external)

  if(WIN32)
    target_link_libraries(libsam3::libsam3 INTERFACE ws2_32)
  endif()
endif()
