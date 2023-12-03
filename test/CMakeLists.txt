cmake_minimum_required(VERSION 3.20)
project(DX_Test)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED True)

set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /SUBSYSTEM:WINDOWS /ENTRY:mainCRTStartup")

add_executable(DX_Test directx_test.cpp)

target_link_libraries(DX_Test user32)
