#######################################################################
#
# FEP SDK Config File
# # Copyright @ 2019 Audi AG. All rights reserved.
# 
#     This Source Code Form is subject to the terms of the Mozilla
#     Public License, v. 2.0. If a copy of the MPL was not distributed
#     with this file, You can obtain one at https://mozilla.org/MPL/2.0/.
# 
# If it is not possible or desirable to put the notice in a particular file, then
# You may include the notice in a location (such as a LICENSE file in a
# relevant directory) where a recipient would be likely to look for such a notice.
# 
# You may add additional accurate notices of copyright ownership.
#
#
#######################################################################

# execute only once
if (FEP_SDK_FOUND)
    return()
endif (FEP_SDK_FOUND)

if (EXISTS ${CMAKE_CURRENT_LIST_DIR}/FEP_SDKSettings.cmake)
    include(${CMAKE_CURRENT_LIST_DIR}/FEP_SDKSettings.cmake)
else()
    set(FEP_USE_SHARED_RTIDDS ${USE_SHARED_RTIDDS})
    set(FEP_USE_SHARED_LIBS ${BUILD_SHARED_LIBS})
endif()

if (WIN32)
    cmake_minimum_required(VERSION 3.5 FATAL_ERROR)
endif()

if(UNIX AND NOT CMAKE_BUILD_TYPE)
    message(FATAL_ERROR "The CMAKE_BUILD_TYPE has to be specified first!")
endif(UNIX AND NOT CMAKE_BUILD_TYPE)

set(FEP_ENABLE_DEPRECATED_PLATFORM_NOMENCLATURE true)

set(FEP_SDK_LIB_VERSION "${FEP_SDK_VERSION_MAJOR}.${FEP_SDK_VERSION_MINOR}.${FEP_SDK_VERSION_PATCH}")

find_package(fep_participant ${FEP_SDK_LIB_VERSION} REQUIRED)
find_package(fep_system ${FEP_SDK_LIB_VERSION} REQUIRED)

set(FEP_SDK_LIBRARY fep_core)
add_library(fep_core INTERFACE IMPORTED)
set_target_properties(fep_core PROPERTIES
        INTERFACE_LINK_LIBRARIES fep_participant
        INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_CURRENT_LIST_DIR}/include;${fep_participant_DIR}/include"
    )

set(FEP_SDK_FOUND true)
