# mingw-copylibs
cmake script to copy any executable or dll runtime dependencies at install using [mingw-ldd](https://github.com/nurupo/mingw-ldd)  
the [bash script](mingw_copylibs.sh) can also be executed directly

# required
- working `python3`, `pip3`, `bash`, `grep`, `sed`. It's assumed you are working on msys2 or mingw where all are readily avaiable

# add to your project
```bash
#cd deps
git submodule add https://github.com/Denzy7/mingw-copylibs
git submodule update --init --recursive --depth 1 mingw-copylibs
```

# usage
```cmake
# include once somewhere in your root CMakeLists.txt
set(mingw_copylibs_DIR <location-of-mingw-copylibs>)
include(${mingw_copylibs_DIR}/mingw_copylibs.cmake)

add_executable(myexe ...)
add_library(mylib SHARED ...)

target_link_libraries(myexe PRIVATE mylib)

install(TARGETS myexe DESTINATION customdir/bin)
install(TARGETS mylib DESTINATION customdir/lib)

mingw_copylibs_install(
    customdir/bin/myexe.exe #you could use target OUTPUT_NAME. we will recurse in install prefix to find it

    # add optional dll lookup dirs. useful when exe depends on project built dlls 
    # and you want them also next to exe

    customdir/lib # all paths will have absolute ${CMAKE_INSTALL_PREFIX} appended
    /usr/lib #dummy
    /some/random/path #wont be added if not exists
    )
```
