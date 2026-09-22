# ------------------------------------------------------------------------ *\
# mk/cmake/fetchcontent_provider.cmake
# This file is part of libRetroShare.
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


macro(fetchcontent_provide_dependency method package)
	if(${package} IN_LIST fetchcontent_provider_packages OR
		${package}_external IN_LIST fetchcontent_provider_packages
	)
		# cmake_parse_arguments(fetchcontent_provider_${package}
		# 	REQUIRED;OPTIONAL;QUIET
		# 	""
		# 	""
		# 	${ARGN}
		# )
		set(fetchcontent_provider_${package}_findargs
			${ARGN} BYPASS_PROVIDER OPTIONAL
		)
		list(REMOVE_ITEM fetchcontent_provider_${package}_findargs REQUIRED)
		find_package(${package} ${fetchcontent_provider_${package}_findargs})
		if(NOT ${package}_FOUND)
			if(${package} IN_LIST fetchcontent_provider_packages)
				message(STATUS "${package} not found. Using FetchContent to get it.")
				FetchContent_MakeAvailable(${package})
			else()
				message(STATUS "${package} not found. Using ExternalProject to get it.")
			endif()
			string(TOLOWER ${package} fetchcontent_provider_${package}_lower)
			set(${package}_FOUND TRUE)
			include(${fetchcontent_provider_${package}_lower}-extra OPTIONAL)
			include(${package}Extra OPTIONAL)
		endif()
	endif()
endmacro(fetchcontent_provide_dependency)

cmake_language(SET_DEPENDENCY_PROVIDER fetchcontent_provide_dependency
	SUPPORTED_METHODS FIND_PACKAGE
)
