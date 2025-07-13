add_library(consumer STATIC consumer.cpp)
target_include_directories(consumer PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(consumer PUBLIC dep)
