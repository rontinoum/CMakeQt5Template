SET(INCLUDEGROUP "include")
SET(SOURCEGROUP "source")
SET(SOURCESGROUP "sources")
SET(UIGROUP "ui")
SET(RESOURCEGROUP "rc")
SET(QRESOURCEGROUP "qrc")

SET(QTGENERATEDGROUPT "_qt")
SET(QTMOCGROUP "moc")
SET(QTUICGROUP "uic")
SET(QTQRCGROUP "qrc")

FUNCTION(FINDFILES files)
    set(options)
    set(oneValueArgs ABSPATH)
    set(multiValueArgs POSTFIXES)

    cmake_parse_arguments(FINDSOURCEFILES "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    
    FOREACH(FINDSOURCEFILES_POSTFIX ${FINDSOURCEFILES_POSTFIXES})        
        SET(TmpSrcFiles)
        FILE(GLOB_RECURSE TmpSrcFiles ${FINDSOURCEFILES_ABSPATH}/*.${FINDSOURCEFILES_POSTFIX})
        
        SET(${files} ${${files}} ${TmpSrcFiles} PARENT_SCOPE)
    ENDFOREACH(FINDSOURCEFILES_POSTFIX ${FINDSOURCEFILES_POSTFIXES})
ENDFUNCTION(FINDFILES files)

MACRO(CONFIGUREMODULECONFIG ModuleName)    
    SET(S_MODULE_NAME ${ModuleName})
    STRING(TOUPPER ${S_MODULE_NAME} S_MODULE_NAME_UPPER)
    CONFIGURE_FILE(${ModuleConfigHeaderTemplate} ${PrjCnfDir}/${ModuleName}/${ModuleConfigHeaderName})
ENDMACRO(CONFIGUREMODULECONFIG ModuleName)

FUNCTION(ADDLIBRARY FOLDERFILES)
    set(options)
    set(oneValueArgs NAME DIR DYNAMIC)
    set(multiValueArgs)

    cmake_parse_arguments(ADDLIBRARY "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    
    SET(TMPFILES)
    ADDFOLDER(TMPFILES NAME ${ADDLIBRARY_NAME} DIR ${ADDLIBRARY_DIR} ISEXE FALSE DYNAMIC ${ADDLIBRARY_DYNAMIC})
    SET(${FOLDERFILES} ${${FOLDERFILES}} ${TMPFILES} PARENT_SCOPE)
ENDFUNCTION(ADDLIBRARY FOLDERFILES)

FUNCTION(ADDEXECUTABLE FOLDERFILES)
    set(options)
    set(oneValueArgs NAME DIR DYNAMIC)
    set(multiValueArgs)

    cmake_parse_arguments(ADDEXECUTABLE "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    
    ADDFOLDER(${FOLDERFILES} NAME ${ADDEXECUTABLE_NAME} DIR ${ADDEXECUTABLE_DIR} ISEXE TRUE DYNAMIC ${ADDEXECUTABLE_DYNAMIC})
ENDFUNCTION(ADDEXECUTABLE FOLDERFILES)

FUNCTION(ADDTOSOURCEGROUP)
    set(options)
    set(oneValueArgs GROUPNAME DIR)
    set(multiValueArgs FILENAMES)
    
    cmake_parse_arguments(ADDTOSOURCEGROUP "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    
    # get string length of source dir + 1
    STRING(LENGTH ${ADDTOSOURCEGROUP_DIR} SOURCE_DIR_LENGTH)
    MATH(EXPR SOURCE_DIR_LENGTH "${SOURCE_DIR_LENGTH} + 1")
    
    FOREACH(FILENAME ${ADDTOSOURCEGROUP_FILENAMES})
        IF(NOT "${FILENAME}" STREQUAL "${ProjectConfigHeader}")
            # split file name into folders and file name
            STRING(LENGTH ${FILENAME} FILE_PATH_LENGTH)
            MATH(EXPR SUB_STRING_LENGTH "${FILE_PATH_LENGTH} - ${SOURCE_DIR_LENGTH}")
            STRING(SUBSTRING ${FILENAME} ${SOURCE_DIR_LENGTH} ${SUB_STRING_LENGTH} SHORT_SOURCE_PATH)
            
            STRING(FIND ${SHORT_SOURCE_PATH} "/" LAST_SLASH REVERSE)
                    
            IF("${LAST_SLASH}" STREQUAL "-1")
                SET(SUBFOLDER_GROUP_NAME)
            ELSE("${LAST_SLASH}" STREQUAL "-1")
                STRING(SUBSTRING ${SHORT_SOURCE_PATH} 0 ${LAST_SLASH} SUBFOLDER_GROUP_NAME)
                STRING(REPLACE  "/" "\\" SUBFOLDER_GROUP_NAME ${SUBFOLDER_GROUP_NAME})
            ENDIF("${LAST_SLASH}" STREQUAL "-1")
            
            SOURCE_GROUP(${ADDTOSOURCEGROUP_GROUPNAME}\\${SUBFOLDER_GROUP_NAME} FILES ${FILENAME})
        ENDIF(NOT "${FILENAME}" STREQUAL "${ProjectConfigHeader}")
    ENDFOREACH(FILENAME ${ADDTOSOURCEGROUP_FILENAMES})
ENDFUNCTION(ADDTOSOURCEGROUP)

FUNCTION(ADDFOLDER FOLDERFILES)
    set(options)
    set(oneValueArgs NAME DIR ISEXE DYNAMIC)
    set(multiValueArgs)

    cmake_parse_arguments(ADDFOLDER "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
        
    # set file variables
    SET(INCLUDE_FILES)
    SET(SOURCE_FILES)
    SET(UI_FILES)
    SET(RESOURCE_FILES)
    SET(QRESOURCE_FILES)
    SET(MOC_FILES)
    SET(UIC_FILES)
    SET(QRC_FILES)
    
    # set file endings
    SET(IncPostFixes h)
    SET(SrcPostFixes cpp)
    SET(UiPostFixes ui)
    SET(ResPostFixes rc)
    SET(QrcPostFixes qrc)
    
    # set group names
    IF(PROJECT_COMBINED_HEADER_SOURCES)
        SET(INCLUDEGROUPNAME ${SOURCESGROUP})
        SET(SOURCEGROUPNAME ${SOURCESGROUP})
    ELSE(PROJECT_COMBINED_HEADER_SOURCES)
        SET(INCLUDEGROUPNAME ${INCLUDEGROUP})
        SET(SOURCEGROUPNAME ${SOURCEGROUP})
    ENDIF(PROJECT_COMBINED_HEADER_SOURCES)
    SET(UIGROUPNAME ${UIGROUP})
    SET(RESOURCEGROUPNAME ${RESOURCEGROUP})
    SET(QRESOURCEGROUPNAME ${QRESOURCEGROUP})
    SET(QTMOCGROUPNAME ${QTGENERATEDGROUPT}\\${QTMOCGROUP})
    SET(QTUICGROUPNAME ${QTGENERATEDGROUPT}\\${QTUICGROUP})
    SET(QTQRCGROUPNAME ${QTGENERATEDGROUPT}\\${QTQRCGROUP})
    
    IF(NOT ${ADDFOLDER_DYNAMIC})
        SET(INCLUDEGROUPNAME ${ADDFOLDER_NAME}\\${INCLUDEGROUPNAME})
        SET(SOURCEGROUPNAME ${ADDFOLDER_NAME}\\${SOURCEGROUPNAME})
        SET(UIGROUPNAME ${ADDFOLDER_NAME}\\${UIGROUPNAME})
        SET(RESOURCEGROUPNAME ${ADDFOLDER_NAME}\\${RESOURCEGROUPNAME})
        SET(QRESOURCEGROUPNAME ${ADDFOLDER_NAME}\\${QRESOURCEGROUPNAME})
        SET(QTMOCGROUPNAME ${ADDFOLDER_NAME}\\${QTMOCGROUPNAME})
        SET(QTUICGROUPNAME ${ADDFOLDER_NAME}\\${QTUICGROUPNAME})
        SET(QTQRCGROUPNAME ${ADDFOLDER_NAME}\\${QTQRCGROUPNAME})
    ENDIF(NOT ${ADDFOLDER_DYNAMIC})
    
    # search for include files and set
    FINDFILES(INCLUDE_FILES ABSPATH ${ADDFOLDER_DIR} POSTFIXES ${IncPostFixes})
    ADDTOSOURCEGROUP(GROUPNAME ${INCLUDEGROUPNAME} DIR ${ADDFOLDER_DIR} FILENAMES ${INCLUDE_FILES})

    # search for include files and set
    FINDFILES(SOURCE_FILES ABSPATH ${ADDFOLDER_DIR} POSTFIXES ${SrcPostFixes})
    ADDTOSOURCEGROUP(GROUPNAME ${SOURCEGROUPNAME} DIR ${ADDFOLDER_DIR} FILENAMES ${SOURCE_FILES})
    
    # gather  h files to moc
    GATHERMOCHEADER(MOC_FILES HEADER ${INCLUDE_FILES})
    SOURCE_GROUP(${QTMOCGROUPNAME} FILES ${MOC_FILES})

    # find ui files to uic
    FINDFILES(UI_FILES ABSPATH ${ADDFOLDER_DIR} POSTFIXES ${UiPostFixes})
    ADDTOSOURCEGROUP(GROUPNAME ${UIGROUPNAME} DIR ${ADDFOLDER_DIR} FILENAMES ${UI_FILES})
    
    # process ic files
    GATHERUIFILES(UIC_FILES UIFILES ${UI_FILES})
    SOURCE_GROUP(${QTUICGROUPNAME} FILES ${UIC_FILES})

    # only for executables we need resources
    IF(${ADDFOLDER_ISEXE})
        # for win add rc file
        IF(WIN32)
            FINDFILES(RESOURCE_FILES ABSPATH ${ADDFOLDER_DIR} POSTFIXES ${ResPostFixes})
            SOURCE_GROUP(${RESOURCEGROUPNAME} FILES ${RESOURCE_FILES})
        ENDIF()

        # for apple add the AppIcon.icns
        IF(APPLE)
            SET(RESOURCE_FILES ${RESOURCE_FILES} AppIcon.icns)
            SET_SOURCE_FILES_PROPERTIES(AppIcon.icns PROPERTIES MACOSX_PACKAGE_LOCATION Resources)
        ENDIF()

        # add qrc files
        FINDFILES(QRESOURCE_FILES ABSPATH ${ADDFOLDER_DIR} POSTFIXES ${QrcPostFixes})
        SOURCE_GROUP(${QRESOURCEGROUPNAME} FILES ${QRESOURCE_FILES})
        
        GATHERQRCFILES(QRC_FILES QRCFILES ${QRESOURCE_FILES})
        SOURCE_GROUP(${QTQRCGROUPNAME} FILES ${QRC_FILES})
    ENDIF(${ADDFOLDER_ISEXE})

    # add files to exe or lib
    IF(${ADDFOLDER_ISEXE})
        SET(PARENTFILES)
        IF(NOT ${ADDFOLDER_DYNAMIC})
            SET(PARENTFILES ${${FOLDERFILES}})
        ENDIF(NOT ${ADDFOLDER_DYNAMIC})
        
        ADD_EXECUTABLE(${ADDFOLDER_NAME} WIN32
            ${INCLUDE_FILES}
            ${SOURCE_FILES}
            ${RESOURCE_FILES}
            ${QRESOURCE_FILES}
            ${UI_FILES}
            ${MOC_FILES}
            ${UIC_FILES}
            ${QRC_FILES}
            ${PARENTFILES}
        )
        
        SET(${ADDFOLDER_NAME}_INCLUDES)
        LIST(APPEND ${ADDFOLDER_NAME}_INCLUDES ${PrjSrcDir})
        LIST(APPEND ${ADDFOLDER_NAME}_INCLUDES ${PrjUicDir})
        
        FOREACH(EXTERNALINCLUDEDIR ${${ADDFOLDER_NAME}_EXTERNALINCLUDES})
            LIST(APPEND ${ADDFOLDER_NAME}_INCLUDES ${EXTERNALINCLUDEDIR})
        ENDFOREACH(EXTERNALINCLUDEDIR ${${ADDFOLDER_NAME}_EXTERNALINCLUDES})
        
        # if is not project dynamic, add all librarie includes
        IF(NOT ${ADDFOLDER_DYNAMIC})
            FOREACH(PrjLibrary ${PrjLibraries})
                FOREACH(EXTERNALINCLUDEDIR ${${PrjLibrary}_EXTERNALINCLUDES})
                    TARGET_INCLUDE_DIRECTORIES(${ADDFOLDER_NAME} PUBLIC ${INCLUDE_DIR})
                ENDFOREACH(EXTERNALINCLUDEDIR ${${PrjLibrary}_EXTERNALINCLUDES})
            ENDFOREACH(PrjLibrary ${PrjLibraries})
        ENDIF(NOT ${ADDFOLDER_DYNAMIC})
        
        FOREACH(INCLUDE_DIR ${${ADDFOLDER_NAME}_INCLUDES})
            TARGET_INCLUDE_DIRECTORIES(${ADDFOLDER_NAME} PUBLIC ${INCLUDE_DIR})
        ENDFOREACH(INCLUDE_DIR ${${ADDFOLDER_NAME}_INCLUDES})
        
    ELSE(${ADDFOLDER_ISEXE})
        IF(${ADDFOLDER_DYNAMIC})
            ADD_LIBRARY(${ADDFOLDER_NAME} SHARED
                ${INCLUDE_FILES}
                ${SOURCE_FILES}
                ${RESOURCE_FILES}
                ${QRESOURCE_FILES}
                ${UI_HEADERS}
                ${MOC_FILES}
                ${UIC_FILES}
                ${QRC_FILES}
            )
            
            SET(${ADDFOLDER_NAME}_INCLUDES)
            LIST(APPEND ${ADDFOLDER_NAME}_INCLUDES ${PrjSrcDir})
            LIST(APPEND ${ADDFOLDER_NAME}_INCLUDES ${PrjUicDir})
            
            FOREACH(EXTERNALINCLUDEDIR ${${ADDFOLDER_NAME}_EXTERNALINCLUDES})
                LIST(APPEND ${ADDFOLDER_NAME}_INCLUDES ${EXTERNALINCLUDEDIR})
            ENDFOREACH(EXTERNALINCLUDEDIR ${${ADDFOLDER_NAME}_EXTERNALINCLUDES})
            
            FOREACH(INCLUDE_DIR ${${ADDFOLDER_NAME}_INCLUDES})
                TARGET_INCLUDE_DIRECTORIES(${ADDFOLDER_NAME} PUBLIC ${INCLUDE_DIR})
            ENDFOREACH(INCLUDE_DIR ${${ADDFOLDER_NAME}_INCLUDES})
        ENDIF(${ADDFOLDER_DYNAMIC})
        
        SET(TMPFILES)
        SET(TMPFILES ${TMPFILES} ${INCLUDE_FILES})
        SET(TMPFILES ${TMPFILES} ${SOURCE_FILES})
        SET(TMPFILES ${TMPFILES} ${RESOURCE_FILES})
        SET(TMPFILES ${TMPFILES} ${RESOURCE_FILES})
        SET(TMPFILES ${TMPFILES} ${UI_HEADERS})
        SET(TMPFILES ${TMPFILES} ${MOC_FILES})
        SET(TMPFILES ${TMPFILES} ${UIC_FILES})
        SET(TMPFILES ${TMPFILES} ${QRC_FILES})
        
        SET(${FOLDERFILES} ${${FOLDERFILES}} ${TMPFILES} PARENT_SCOPE)
    ENDIF(${ADDFOLDER_ISEXE})
    
    # add includes
    SET(${ADDFOLDER_NAME}_INCLUDES)
    LIST(APPEND ${ADDFOLDER_NAME}_INCLUDES ${PrjSrcDir})
    LIST(APPEND ${ADDFOLDER_NAME}_INCLUDES ${PrjUicDir})
    
    FOREACH(EXTERNALINCLUDEDIR ${${ADDFOLDER_NAME}_EXTERNALINCLUDES})
        LIST(APPEND ${ADDFOLDER_NAME}_INCLUDES ${EXTERNALINCLUDEDIR})
    ENDFOREACH(EXTERNALINCLUDEDIR ${${ADDFOLDER_NAME}_EXTERNALINCLUDES})
    
    # if is not project dynamic, add all librarie includes
    IF(${ADDFOLDER_ISEXE} AND NOT ${ADDFOLDER_DYNAMIC})
        FOREACH(PrjLibrary ${PrjLibraries})
            FOREACH(EXTERNALINCLUDEDIR ${${PrjLibrary}_EXTERNALINCLUDES})
                TARGET_INCLUDE_DIRECTORIES(${ADDFOLDER_NAME} PUBLIC ${EXTERNALINCLUDEDIR})
            ENDFOREACH(EXTERNALINCLUDEDIR ${${PrjLibrary}_EXTERNALINCLUDES})
        ENDFOREACH(PrjLibrary ${PrjLibraries})
    ENDIF(${ADDFOLDER_ISEXE} AND NOT ${ADDFOLDER_DYNAMIC})
    
    IF(${ADDFOLDER_DYNAMIC})
        FOREACH(INCLUDE_DIR ${${ADDFOLDER_NAME}_INCLUDES})
            TARGET_INCLUDE_DIRECTORIES(${ADDFOLDER_NAME} PUBLIC ${INCLUDE_DIR})
        ENDFOREACH(INCLUDE_DIR ${${ADDFOLDER_NAME}_INCLUDES})
    ENDIF(${ADDFOLDER_DYNAMIC})
    
    # configure module_config
    CONFIGUREMODULECONFIG(${ADDFOLDER_NAME})
ENDFUNCTION(ADDFOLDER FOLDERFILES)