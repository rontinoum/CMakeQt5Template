CMAKE_MINIMUM_REQUIRED(VERSION 3.0.2)
CMAKE_POLICY(SET CMP0020 NEW)
CMAKE_POLICY(SET CMP0043 OLD)

# set cmake custom scripts direcory
SET(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/)

# include custom functions
INCLUDE(${CMAKE_MODULE_PATH}/configurate.cmake)
INCLUDE(${CMAKE_MODULE_PATH}/qt.cmake)
INCLUDE(${CMAKE_MODULE_PATH}/build.cmake)
INCLUDE(${CMAKE_MODULE_PATH}/link.cmake)

CONFIGURATE()
DEFINEMODULEQTDEPENDENCY()
DEFINEMODULELINKDEPENDENCY()

SET(PROJECT "${PrjName}")

PROJECT(${PROJECT})

# set cmake prefix path to Qt5 dir (required to find qt5)
SET(CMAKE_PREFIX_PATH $ENV{QTDIR})

LOADQTPACKAGES()

set(CMAKE_AUTOMOC OFF)

# set project dirs
SET(PrjDir ${CMAKE_CURRENT_SOURCE_DIR})
SET(PrjQtGenDir ${CMAKE_CURRENT_BINARY_DIR}/_qt)
SET(PrjSrcDir ${PrjDir}/src)
SET(PrjLibDir ${PrjDir}/lib)
SET(PrjBinDir ${PrjDir}/bin)
SET(PrjInsDir ${PrjDir}/install)
SET(PrjCnfDir ${PrjDir}/config)
SET(PrjMocDir ${PrjQtGenDir}/moc)
SET(PrjUicDir ${PrjQtGenDir}/uic)
SET(PrjQrcDir ${PrjQtGenDir}/qrc)

# set project setting
SET(PROJECT_USE_PROJECT_DEFINES_HEADER TRUE CACHE BOOL "True if the global defines header should be used.")
SET(PROJECT_DYNAMIC FALSE CACHE BOOL "Build Modules as shared libs for executables or include all executables a subflder for each module.")
SET(PROJECT_DEVELOP FALSE CACHE BOOL "Executables have a Console output for Debug and Release")
SET(PROJECT_COMBINED_HEADER_SOURCES FALSE CACHE BOOL "If true combines header and sources into one folder in the project tree")
SET(PROJECT_INSTALL_PATH "${PrjInsDir}" CACHE PATH "The Project install path")

# Configure global defines from project settings
IF(${PROJECT_USE_PROJECT_DEFINES_HEADER})
    # set config header variables
    IF(${PROJECT_DYNAMIC})
        SET(S_PROJECT_DYNAMIC 1)
    ELSE(${PROJECT_DYNAMIC})
        SET(S_PROJECT_DYNAMIC 0)
    ENDIF(${PROJECT_DYNAMIC})
    
    SET(ProjectConfigHeader ${PrjCnfDir}/project_config.h)
    SET(ProjectConfigHeaderTemplate ${ProjectConfigHeader}.in)
    
    #check existance of the project header template
    IF(NOT EXISTS ${ProjectConfigHeaderTemplate})
        MESSAGE(FATAL_ERROR ${ProjectConfigHeaderTemplate} " does not exist")
    ENDIF(NOT EXISTS ${ProjectConfigHeaderTemplate})
    
    CONFIGURE_FILE(${ProjectConfigHeaderTemplate} ${ProjectConfigHeader})
    
    INCLUDE_DIRECTORIES(${PrjCnfDir})
ENDIF(${PROJECT_USE_PROJECT_DEFINES_HEADER})

# set modul_config.h variable
SET(ModuleConfigHeaderName module_config.h)
SET(ModuleConfigHeader ${PrjCnfDir}/${ModuleConfigHeaderName})
SET(ModuleConfigHeaderTemplate ${ModuleConfigHeader}.in)

# add libs and main
SET(LIBRARYFILES)
FOREACH(PrjLibrary ${PrjLibraries})
    ADDLIBRARY(LIBRARYFILES NAME ${PrjLibrary} DIR ${PrjSrcDir}/${PrjLibrary} DYNAMIC ${PROJECT_DYNAMIC})
ENDFOREACH(PrjLibrary ${PrjLibraries})

FOREACH(PrjExecutable ${PrjExecutables})
    SET(EXECUTBLEFILES ${LIBRARYFILES})
    ADDEXECUTABLE(EXECUTBLEFILES NAME ${PrjExecutable} DIR ${PrjSrcDir}/${PrjExecutable} DYNAMIC ${PROJECT_DYNAMIC})
ENDFOREACH(PrjExecutable ${PrjExecutables})

SET(MACOSX_BUNDLE_BUNDLE_NAME "${PrjName}")
SET(MACOSX_BUNDLE_BUNDLE_VERSION "1.0")
SET(MACOSX_BUNDLE_LONG_VERSION_STRING "1.0")
SET(MACOSX_BUNDLE_SHORT_VERSION_STRING "1.0")
SET(MACOSX_BUNDLE_COPYRIGHT "Copyright (c) <Year> <Name>. All rights reserved.")
SET(MACOSX_BUNDLE_GUI_IDENTIFIER "com.${PrjName}.project")
SET(MACOSX_BUNDLE_ICON_FILE AppIcon.icns)

# set usage of qt modules
SETLINKDEPENDENCIES()

# set general output postfix
set(DEBUGOUTPUTPOSTFIX "_d")

# add install for each project
IF("${PROJECT_INSTALL_PATH}" STREQUAL "")
    MESSAGE(FATAL_ERROR "PROJECT_INSTALL_PATH not set")
ENDIF("${PROJECT_INSTALL_PATH}" STREQUAL "")

FOREACH(PrjExecutable ${PrjExecutables})
    INSTALL(TARGETS ${PrjExecutable} RUNTIME DESTINATION ${PROJECT_INSTALL_PATH} INCLUDES DESTINATION ${PROJECT_INSTALL_PATH}/include)
ENDFOREACH(PrjExecutable ${PrjExecutables})

IF(${PROJECT_DYNAMIC})
    FOREACH(PrjLibrary ${PrjLibraries})
        INSTALL(TARGETS ${PrjLibrary} RUNTIME DESTINATION ${PROJECT_INSTALL_PATH} INCLUDES DESTINATION ${PROJECT_INSTALL_PATH}/include)
    ENDFOREACH(PrjLibrary ${PrjLibraries})
ENDIF(${PROJECT_DYNAMIC})

# set target properties on tagets (libs and exec)
IF(MSVC)    
    IF(${PROJECT_DYNAMIC})
        FOREACH(PrjLibrary ${PrjLibraries})
            SET_TARGET_PROPERTIES(${PrjLibrary} PROPERTIES DEBUG_OUTPUT_NAME   ${PrjLibrary}${DEBUGOUTPUTPOSTFIX})
            SET_TARGET_PROPERTIES(${PrjLibrary} PROPERTIES RELEASE_OUTPUT_NAME ${PrjLibrary})
        
            SET_TARGET_PROPERTIES(${PrjLibrary} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY_DEBUG ${PrjLibDir})
            SET_TARGET_PROPERTIES(${PrjLibrary} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${PrjLibDir})
            
            SET_TARGET_PROPERTIES(${PrjLibrary} PROPERTIES LIBRARY_OUTPUT_DIRECTORY_DEBUG ${PrjLibDir})
            SET_TARGET_PROPERTIES(${PrjLibrary} PROPERTIES LIBRARY_OUTPUT_DIRECTORY_RELEASE ${PrjLibDir})
            
            SET_TARGET_PROPERTIES(${PrjLibrary} PROPERTIES PDB_OUTPUT_DIRECTORY_DEBUG ${PrjLibDir})
            SET_TARGET_PROPERTIES(${PrjLibrary} PROPERTIES PDB_OUTPUT_DIRECTORY_RELEASE ${PrjLibDir})
            
            SET_TARGET_PROPERTIES(${PrjLibrary} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${PrjBinDir})
        ENDFOREACH(PrjLibrary ${PrjLibraries})
    ENDIF(${PROJECT_DYNAMIC})
    
    FOREACH(PrjExecutable ${PrjExecutables})
        SET_TARGET_PROPERTIES(${PrjExecutable} PROPERTIES DEBUG_OUTPUT_NAME   ${PrjExecutable}${DEBUGOUTPUTPOSTFIX})
        SET_TARGET_PROPERTIES(${PrjExecutable} PROPERTIES RELEASE_OUTPUT_NAME ${PrjExecutable})
    
        SET_TARGET_PROPERTIES(${PrjExecutable} PROPERTIES
            WIN32_EXECUTABLE YES
            LINK_FLAGS "/ENTRY:mainCRTStartup"
        )
        
        SET(LINKFLAG)        
        IF(${PROJECT_DEVELOP})
            SET(LINKFLAG "/SUBSYSTEM:CONSOLE")
        ELSE(${PROJECT_DEVELOP})
            SET(LINKFLAG "/SUBSYSTEM:WINDOWS")
        ENDIF(${PROJECT_DEVELOP})      
        
        SET_TARGET_PROPERTIES(${PrjExecutable} PROPERTIES LINK_FLAGS_DEBUG ${LINKFLAG})
        SET_TARGET_PROPERTIES(${PrjExecutable} PROPERTIES LINK_FLAGS_RELWITHDEBINFO ${LINKFLAG})
        SET_TARGET_PROPERTIES(${PrjExecutable} PROPERTIES LINK_FLAGS_RELEASE ${LINKFLAG})
        SET_TARGET_PROPERTIES(${PrjExecutable} PROPERTIES LINK_FLAGS_MINSIZEREL ${LINKFLAG})
        
        IF(${PROJECT_DEVELOP})
            SET_TARGET_PROPERTIES(${PrjExecutable} PROPERTIES COMPILE_DEFINITIONS_DEBUG "_CONSOLE")
            SET_TARGET_PROPERTIES(${PrjExecutable} PROPERTIES COMPILE_DEFINITIONS_RELWITHDEBINFO "_CONSOLE")
        ENDIF(${PROJECT_DEVELOP})
        
        SET_TARGET_PROPERTIES(${PrjExecutable} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY_DEBUG ${PrjLibDir})
        SET_TARGET_PROPERTIES(${PrjExecutable} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${PrjLibDir})
        
        SET_TARGET_PROPERTIES(${PrjExecutable} PROPERTIES LIBRARY_OUTPUT_DIRECTORY_DEBUG   ${PrjLibDir})
        SET_TARGET_PROPERTIES(${PrjExecutable} PROPERTIES LIBRARY_OUTPUT_DIRECTORY_RELEASE ${PrjLibDir})
        
        SET_TARGET_PROPERTIES(${PrjExecutable} PROPERTIES PDB_OUTPUT_DIRECTORY ${PrjBinDir})
        
        SET_TARGET_PROPERTIES(${PrjExecutable} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${PrjBinDir})
    ENDFOREACH(PrjExecutable ${PrjExecutables})
ENDIF()
