# The following lines of boilerplate have to be in your project's
# CMakeLists in this exact order for cmake to work correctly
cmake_minimum_required(VERSION 3.5)
set(EXTRA_COMPONENT_DIRS ../windowhandlerinstrumentation/components)
include($ENV{IDF_PATH}/tools/cmake/project.cmake)
project(app-template)
idf_build_set_property(COMPILE_OPTIONS -DMETHOD=${METHOD} APPEND)
idf_build_set_property(COMPILE_OPTIONS -DSTORAGE=${STORAGE} APPEND)
idf_build_set_property(COMPILE_OPTIONS -DPRIVILEGED=${PRIVILEGED} APPEND)