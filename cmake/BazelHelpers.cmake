include(ExternalProject)

# --- Get Bazel output path for a static library target
function(get_bazel_output_path target output_var)
  execute_process(
    COMMAND bazel cquery --output=files //${target}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    OUTPUT_VARIABLE output
    OUTPUT_STRIP_TRAILING_WHITESPACE
    ERROR_VARIABLE error_out
    RESULT_VARIABLE res
  )

  if(NOT output OR res)
    message(FATAL_ERROR "Failed to query Bazel output for target: //${target}\n"
                        "Bazel cquery error:\n${error_out}")
  endif()

  # Expecting a single output file (the .a static library)
  string(REGEX MATCH ".*\\.a" static_lib "${output}")

  if(NOT static_lib)
    message(FATAL_ERROR "Expected a single .a file from Bazel, but got:\n${output}")
  endif()

  set(${output_var} "${CMAKE_SOURCE_DIR}/${static_lib}" PARENT_SCOPE)
endfunction()

# --- Add an ExternalProject that builds the Bazel static lib
function(import_bazel_static_lib target lib_name include_dir)
  get_bazel_output_path(${target} DEP_LIB_PATH)

  ExternalProject_Add(${lib_name}_ep
    SOURCE_DIR "${CMAKE_SOURCE_DIR}"
    BINARY_DIR "${CMAKE_BINARY_DIR}/bazel_build_${lib_name}"
    CONFIGURE_COMMAND ""
    BUILD_COMMAND bazel build //${target}
    INSTALL_COMMAND ""
    BUILD_BYPRODUCTS "${DEP_LIB_PATH}"
    LOG_BUILD OFF
  )

  add_library(${lib_name} STATIC IMPORTED GLOBAL)
  add_dependencies(${lib_name} ${lib_name}_ep)

  set_target_properties(${lib_name} PROPERTIES
    IMPORTED_LOCATION "${DEP_LIB_PATH}"
    INTERFACE_INCLUDE_DIRECTORIES "${include_dir}"
  )
endfunction()
