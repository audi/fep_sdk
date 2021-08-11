## ℹ️ This repository is archived 

It is now maintained at https://github.com/cariad-tech


---

FEP SDK 
=================

## Description ##

This installed package is a bundle package and contains (or pulls in) all of the FEP SDK:

### FEP SDK Participant Library 

    fep_sdk_participant/2.6.1@aev25/stable

* Middleware for distributed simulation systems
* a_util platform abstraction library
* DDL library (data description language with codec API)
* RPC library with JSON-RPC code generator

### FEP SDK System Library 

    fep_sdk_system/2.6.1@aev25/stable

* Connect and control a bundle of participants, put them together to a fep::System

### FEP SDK Controller Library 

    fep_sdk_controller/1.1.1@aev25/stable

* Connect and control a bundle of participants as a system with the help of the FEP SDK Metamodel File Descriptions

### FEP SDK Meta Library 

    fep_sdk_metamodel/1.0.1@aev25/stable

* Definition and a parser helper library for the  FEP SDK Metamodel File Descriptions

### FEP SDK Documentation

* see fep_sdk/doc/fep-sdk.html

## How to use ###

The FEP SDK provides a CMake >= 3.5 configuration. Here's how to use it from your own CMake projects:

    find_package(FEP_SDK REQUIRED)

After this instruction, you can create CMake executable targets linking against FEP using the following command:

    fep_add_executable(my_new_target source_file1.cpp source_file2.cpp)

Alternatively, you can append the FEP Core Target to your existing targets to add a dependency:

    target_link_libraries(my_existing_target PRIVATE ${FEP_SDK_LIBRARY})
    fep_deploy_libraries(my_existing_target)

Note that the ${FEP_SDK_LIBRARY} target will transitively pull in all required include directories and libraries.
This target is only a dummy target using the fep_participant

### Build Environment ####

The libraries are build and tested only under following compilers and operating systems: 
* Windows 7 x64 with Visual Studio C++ 2015 Update 3.1 (Update 3 and KB3165756)
* Linux Ubuntu 16.04 LTS x64 with GCC 5.4 and libstdc++11 (C++11 ABI)

## How to build the examples ###

Simply point CMake to the examples directory (containing the CMakeLists.txt file) and generate a project.
Choose "Visual Studio 15 2017 Win64" with the v140 toolset or "Unix Makefiles" generator, depending on your platform.

CMake might ask for the CMAKE_BUILD_TYPE variable to be defined. Possible values are Debug, Release or RelWithDebInfo
