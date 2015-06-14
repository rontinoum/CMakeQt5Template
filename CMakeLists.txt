CMAKE_MINIMUM_REQUIRED(VERSION 2.8.12)
CMAKE_POLICY(SET CMP0020 NEW)

SET(PROJECT "Qt5Template")

PROJECT(${PROJECT})

SET(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
SET(CMAKE_INCLUDE_CURRENT_DIR ON)
SET(CMAKE_AUTOMOC ON)

# set necessary qt libraries
FIND_PACKAGE(Qt5Widgets REQUIRED)

# get project dir
SET(PrjDir ${CMAKE_CURRENT_SOURCE_DIR})
SET(PrjSrcDir ${PrjDir}/src/)
SET(PrjLibDir ${PrjDir}/lib)
SET(PrjBinDir ${PrjDir}/bin)

# search for source files and set
SET(SrcPostFixes h cpp)
SET(PrjSrcFiles)
FOREACH(SrcPostFix ${SrcPostFixes})
    FILE(GLOB TmpSrcFiles ${PrjSrcDir}/*.${SrcPostFix})
    SET(PrjSrcFiles ${PrjSrcFiles} ${TmpSrcFiles})
ENDFOREACH(SrcPostFix ${SrcPostFixes})

SET(SOURCE_FILES ${PrjSrcFiles})

# for win add rc file
IF(WIN32)
    SET(SOURCE_FILES ${SOURCE_FILES} src/main.rc)
ENDIF()

SET(UiPostFixes ui)
SET(PrjUiFiles)
FOREACH(UiPostFix ${UiPostFixes})
    FILE(GLOB TmpUiFiles ${PrjSrcDir}/*.${UiPostFix})
    SET(PrjUiFiles ${PrjUiFiles} ${TmpUiFiles})
ENDFOREACH(UiPostFix ${UiPostFixes})

SET(UI_FILES ${PrjUiFiles})
SOURCE_GROUP("UI Files" FILES ${UI_FILES})

qt5_wrap_ui(UI_HEADERS ${UI_FILES})
SOURCE_GROUP("Generated UI Headers" FILES ${UI_HEADERS})

qt5_add_resources(RESOURCE_FILES src/main.qrc)

IF(APPLE)
    SET(SOURCE_FILES ${SOURCE_FILES} AppIcon.icns)
    SET_SOURCE_FILES_PROPERTIES(AppIcon.icns PROPERTIES MACOSX_PACKAGE_LOCATION Resources)
ENDIF()

ADD_EXECUTABLE(${PROJECT} MACOSX_BUNDLE
    ${SOURCE_FILES}
    ${UI_HEADERS}
    ${UI_FILES}
    ${RESOURCE_FILES}
)

SET(MACOSX_BUNDLE_BUNDLE_NAME "Qt5Template")
SET(MACOSX_BUNDLE_BUNDLE_VERSION "1.0")
SET(MACOSX_BUNDLE_LONG_VERSION_STRING "1.0")
SET(MACOSX_BUNDLE_SHORT_VERSION_STRING "1.0")
SET(MACOSX_BUNDLE_COPYRIGHT "Copyright (c) <Year> <Name>. All rights reserved.")
SET(MACOSX_BUNDLE_GUI_IDENTIFIER "com.project.name")
SET(MACOSX_BUNDLE_ICON_FILE AppIcon.icns)

qt5_use_modules(${PROJECT} Widgets)

IF(MSVC)
    SET_TARGET_PROPERTIES(${PROJECT} PROPERTIES
        WIN32_EXECUTABLE YES
        LINK_FLAGS "/ENTRY:mainCRTStartup"
    )
    
    SET_TARGET_PROPERTIES(${PROJECT} PROPERTIES
        LIBRARY_OUTPUT_DIRECTORY ${PrjLibDir}
        RUNTIME_OUTPUT_DIRECTORY ${PrjBinDir}
    )
ENDIF()
