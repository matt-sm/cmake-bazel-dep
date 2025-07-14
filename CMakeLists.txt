cmake_minimum_required(VERSION 3.20)
project(MixedBuildExample)

include(${CMAKE_SOURCE_DIR}/cmake/BazelHelpers.cmake)

import_bazel_static_lib("dep:dep" dep "${CMAKE_SOURCE_DIR}/dep")

add_subdirectory(consumer)
add_subdirectory(app)
