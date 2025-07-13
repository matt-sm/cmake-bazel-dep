cmake_minimum_required(VERSION 3.20)
project(MixedBuildExample)

include(${CMAKE_SOURCE_DIR}/cmake/BazelHelpers.cmake)

add_bazel_build_target("dep:dep" DEP_LIB_PATH dep_bazel)

add_library(dep STATIC IMPORTED GLOBAL)
add_dependencies(dep dep_bazel)
set_target_properties(dep PROPERTIES
  IMPORTED_LOCATION "${DEP_LIB_PATH}"
  INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_SOURCE_DIR}/dep"
)

add_subdirectory(consumer)
add_subdirectory(app)
