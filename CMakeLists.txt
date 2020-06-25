#
# Copyright @ 2020 Audi AG. All rights reserved.
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
cmake_minimum_required(VERSION 3.5 FATAL_ERROR)
cmake_policy(SET CMP0011 NEW)

# Disable extensions here and require the chosen CMAKE_CXX_STANDARD (coming from Conan)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Use shared libraries from current directory on Linux (same behavior as on Windows)
SET(CMAKE_INSTALL_RPATH "$ORIGIN")

if(CMAKE_CXX_STANDARD LESS 14)
    message(FATAL_ERROR "The FEP SDK requires CMAKE_CXX_STANDARD >= 14")
endif()

project(fep-sdk-collect VERSION 2.6.1)
set(VERSION_FEP "2020")
set(FEP_SDK_LIBRARY fep_core)

set(FEP_SDK_LIB_VERSION_MAJOR ${PROJECT_VERSION_MAJOR})
set(FEP_SDK_LIB_VERSION_MINOR ${PROJECT_VERSION_MINOR})
set(FEP_SDK_LIB_VERSION_PATCH ${PROJECT_VERSION_PATCH})

set(FEP_SDK_LIB_VERSION "${FEP_SDK_LIB_VERSION_MAJOR}.${FEP_SDK_LIB_VERSION_MINOR}.${FEP_SDK_LIB_VERSION_PATCH}")

# Enable strict compiler warnings
if(WIN32)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /W4 /wd4100 /wd4251 /wd4505 /wd4290")
else()
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wno-unknown-pragmas -Wno-reorder")
endif()

# check for conan
if(CONAN_COMPILER)
    message(STATUS "Including Conan build info")
    if ( EXISTS ${CMAKE_CURRENT_BINARY_DIR}/conanbuildinfo.cmake)
        include(${CMAKE_CURRENT_BINARY_DIR}/conanbuildinfo.cmake)
    elseif ( EXISTS ${CMAKE_CURRENT_BINARY_DIR}/../conanbuildinfo.cmake)
        include(${CMAKE_CURRENT_BINARY_DIR}/../conanbuildinfo.cmake)
    elseif ( EXISTS ${CMAKE_CURRENT_BINARY_DIR}/conanbuildinfo_multi.cmake)
        include(${CMAKE_CURRENT_BINARY_DIR}/conanbuildinfo_multi.cmake)
    elseif ( EXISTS ${CMAKE_CURRENT_BINARY_DIR}/../conanbuildinfo_multi.cmake)
        include(${CMAKE_CURRENT_BINARY_DIR}/../conanbuildinfo_multi.cmake)
    else()
        message(FATAL_ERROR "Conan build info can't be found.")
    endif()

    if(CORTEX_WORKSPACE)
        conan_basic_setup(TARGETS)
    else()
        conan_basic_setup(TARGETS NO_OUTPUT_DIRS)
    endif()
endif()

set(FEP_SDK_PARTICIPANT_DIR ${CONAN_FEP_SDK_PARTICIPANT_ROOT})
set(FEP_SDK_SYSTEM_DIR ${CONAN_FEP_SDK_SYSTEM_ROOT})
set(USE_SHARED_RTIDDS false CACHE BOOL "Use shared RTI DDS Libraries.")

include(scripts/cmake/enable_multicore_compilation.cmake)
include(scripts/cmake/use_integrated_debug_symbols.cmake)
configure_file(FEP_SDKSettings.cmake.in FEP_SDKSettings.cmake)
configure_file(FEP_SDKConfigVersion.cmake.in FEP_SDKConfigVersion.cmake @ONLY)
include(${CMAKE_CURRENT_BINARY_DIR}/FEP_SDKSettings.cmake)
include(${CMAKE_CURRENT_BINARY_DIR}/FEP_SDKConfigVersion.cmake)

### Set basic and obligatory CMake parameters and find Project Templates package.
set(AEV_PRODUCT_FULL_NAME "FEP SDK - Functional Engineering Platform SDK")
set(AEV_PRODUCT_SHORT_NAME "fep-sdk")
set(AEV_CMAKE_NAMESPACE_NAME "FEP")

### Product specific
set(FEP_SDK_DIR ${CMAKE_CURRENT_SOURCE_DIR})
set(FEP_BUILD_SDK true)
set(BETA_BUILD false CACHE BOOL "Mark as beta")
set(BUILD_NR 0xffff CACHE STRING "The current build nr")
set(FEP_SDK_BUILD_NR ${BUILD_NR})
set(REFERENCE_VERSION ${CONAN_PACKAGE_VERSION})

# some settings need to be set explicitly for QNX
if (UNIX)
    set(CMAKE_BUILD_WITH_INSTALL_RPATH ON)
    set(CMAKE_INSTALL_RPATH_USE_LINK_PATH ON)
    set(CMAKE_SKIP_BUILD_RPATH  OFF)
endif(UNIX)

################################################################################
### Setting up packages
################################################################################


# compensate for the missing platform if building locally
if(NOT DEFINED PLATFORM)
    set(PLATFORM "developer")
endif(NOT DEFINED PLATFORM)

# set shared flags
set(FEPSDK_SHARED_LIB ${BUILD_SHARED_LIBS})

configure_file(include/fep_sdk_version.h.in include/fep_sdk_version.h)
install(
    FILES ${CMAKE_CURRENT_BINARY_DIR}/include/fep_sdk_version.h
          include/fep_core_sdk.h
    DESTINATION include
)


# add subdirectories core
add_subdirectory(doc)
# Licenses
add_subdirectory(doc/extern/license)

# install files for cmake purposes
install(
    FILES
       README.md
       FEP_SDKConfig.cmake
       ${CMAKE_CURRENT_BINARY_DIR}/FEP_SDKSettings.cmake
       ${CMAKE_CURRENT_BINARY_DIR}/FEP_SDKConfigVersion.cmake
    DESTINATION
       ./
)

# install files of all FEP SDK relevant libraries
set(FEP_SDK_LIBS FEP_SDK_PARTICIPANT;FEP_SDK_SYSTEM)

foreach(fep_sdk_lib ${FEP_SDK_LIBS})
    set(PACKAGE_ROOT ${CONAN_${fep_sdk_lib}_ROOT})    
endforeach(fep_sdk_lib)
