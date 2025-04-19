cmake_minimum_required(VERSION 3.16)
project(mingw-copylibs-tests)

set(mingw_copylibs_DIR ${CMAKE_CURRENT_SOURCE_DIR}/..)
include(${mingw_copylibs_DIR}/mingw_copylibs.cmake)

add_executable(pthreadtest pthreadtest.c)
add_library(testlib testlib.h testlib.c)
target_link_libraries(pthreadtest PRIVATE testlib)
install(TARGETS pthreadtest 
    DESTINATION bin/tests)
install(TARGETS testlib
    DESTINATION lib/tests)

mingw_copylibs_install(
    bin/tests/pthreadtest.exe

    lib/tests # all paths will have absolute ${CMAKE_INSTALL_PREFIX} appended
    /usr/lib #dummy
    /some/random/path #wont be added if not exists
)
