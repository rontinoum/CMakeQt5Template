SET(INCLUDEGROUP "include")
SET(SOURCEGROUP "source")
SET(UIGROUP "Ui")
SET(UIFILESGROUP "files")
SET(UIHEADERGROUP "header")
SET(RESOURCEGROUP "resource")
SET(QRESOURCEGROUP "qresource")

FUNCTION(FINDFILES files)
    set(options)
    set(oneValueArgs ABSPATH)
    set(multiValueArgs POSTFIXES)

    cmake_parse_arguments(FINDSOURCEFILES "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    
    FOREACH(FINDSOURCEFILES_POSTFIX ${FINDSOURCEFILES_POSTFIXES})        
        SET(TmpSrcFiles)
        FILE(GLOB TmpSrcFiles ${FINDSOURCEFILES_ABSPATH}/*.${FINDSOURCEFILES_POSTFIX})
        
        SET(${files} ${${files}} ${TmpSrcFiles} PARENT_SCOPE)
    ENDFOREACH(FINDSOURCEFILES_POSTFIX ${FINDSOURCEFILES_POSTFIXES})
ENDFUNCTION(FINDFILES files)

FUNCTION(ADDLIBRARY FOLDERFILES)
    set(options)
    set(oneValueArgs NAME DIR DYNAMIC)
    set(multiValueArgs)

    cmake_parse_arguments(ADDLIBRARY "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    
    SET(TMPFILES)
    ADDFOLDER(TMPFILES NAME ${ADDLIBRARY_NAME} DIR ${ADDLIBRARY_DIR} ISEXE FALSE DYNAMIC ${ADDLIBRARY_DYNAMIC})
    SET(${FOLDERFILES} ${${FOLDERFILES}} ${TMPFILES})
ENDFUNCTION(ADDLIBRARY FOLDERFILES)

FUNCTION(ADDEXECUTABLE FOLDERFILES)
    set(options)
    set(oneValueArgs NAME DIR DYNAMIC)
    set(multiValueArgs)

    cmake_parse_arguments(ADDEXECUTABLE "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    
    SET(TMPFILES)
    ADDFOLDER(TMPFILES ${FOLDERFILES} NAME ${ADDEXECUTABLE_NAME} DIR ${ADDEXECUTABLE_DIR} ISEXE TRUE DYNAMIC ${ADDEXECUTABLE_DYNAMIC})
    SET(${FOLDERFILES} ${${FOLDERFILES}} ${TMPFILES})
ENDFUNCTION(ADDEXECUTABLE FOLDERFILES)

FUNCTION(ADDFOLDER FOLDERFILES)
    set(options)
    set(oneValueArgs NAME DIR ISEXE DYNAMIC)
    set(multiValueArgs)

    cmake_parse_arguments(ADDFOLDER "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    
    # set executabale name
    SET(NAME ${ADDFOLDER_NAME})
    SET(DIR ${ADDFOLDER_DIR})
    SET(ISEXE ${ADDFOLDER_ISEXE})
    SET(DYNAMIC ${ADDFOLDER_DYNAMIC})
    
    # set file variables
    SET(INCLUDE_FILES)
    SET(SOURCE_FILES)
    SET(UI_FILES)
    SET(UI_HEADERS)
    SET(RESOURCE_FILES)
    SET(QRESOURCE_FILES)
    
    # set file endings
    SET(IncPostFixes h)
    SET(SrcPostFixes cpp)
    SET(UiPostFixes ui)
    SET(ResPostFixes rc)
    SET(QrcPostFixes qrc)
    
    # set group names
    IF(${DYNAMIC})
        SET(INCLUDEGROUPNAME ${INCLUDEGROUP})
        SET(SOURCEGROUPNAME ${SOURCEGROUP})
        SET(UIGROUPNAME ${UIGROUP})
        SET(UIFILESGROUPNAME ${UIGROUPNAME}//${UIFILESGROUP})
        SET(UIHEADERGROUPNAME ${UIGROUPNAME}//${UIHEADERGROUP})
        SET(RESOURCEGROUPNAME ${RESOURCEGROUP})
        SET(QRESOURCEGROUPNAME ${QRESOURCEGROUP})
    ELSE(${DYNAMIC})
        SET(INCLUDEGROUPNAME ${NAME}//${INCLUDEGROUP})
        SET(SOURCEGROUPNAME ${NAME}//${SOURCEGROUP})
        SET(UIGROUPNAME ${NAME}//${UIGROUP})
        SET(UIFILESGROUPNAME ${UIGROUPNAME}//${UIFILESGROUP})
        SET(UIHEADERGROUPNAME ${UIGROUPNAME}//${UIHEADERGROUP})
        SET(RESOURCEGROUPNAME ${NAME}//${RESOURCEGROUP})
        SET(QRESOURCEGROUPNAME ${NAME}//${QRESOURCEGROUP})
    ENDIF(${DYNAMIC})

    # search for include files and set
    FINDFILES(INCLUDE_FILES ABSPATH ${DIR} POSTFIXES ${IncPostFixes})
    SOURCE_GROUP("include" FILES ${INCLUDE_FILES})

    # search for include files and set
    FINDFILES(SOURCE_FILES ABSPATH ${DIR} POSTFIXES ${SrcPostFixes})
    SOURCE_GROUP("source" FILES ${SOURCE_FILES})

    FINDFILES(UI_FILES ABSPATH ${DIR} POSTFIXES ${UiPostFixes})
    qt5_wrap_ui(UI_HEADERS ${UI_FILES})
    SOURCE_GROUP("UI Files" FILES ${UI_FILES})
    SOURCE_GROUP("Ui Header" FILES ${UI_HEADERS})

    # only for executables we need resources
    IF(${ISEXE})
        # for win add rc file
        IF(WIN32)
            FINDFILES(RESOURCE_FILES ABSPATH ${DIR} POSTFIXES ${ResPostFixes})
            SOURCE_GROUP("resource" FILES ${RESOURCE_FILES})
        ENDIF()

        # for apple add the AppIcon.icns
        IF(APPLE)
            SET(RESOURCE_FILES ${RESOURCE_FILES} AppIcon.icns)
            SET_SOURCE_FILES_PROPERTIES(AppIcon.icns PROPERTIES MACOSX_PACKAGE_LOCATION Resources)
        ENDIF()

        # add qrc files
        FINDFILES(QRESOURCE_FILES ABSPATH ${DIR} POSTFIXES ${QrcPostFixes})
        qt5_add_resources(QRESOURCE_FILES ${QRESOURCE_FILES})
        SOURCE_GROUP("qrc" FILES ${QRESOURCE_FILES})
    ENDIF(${ISEXE})

    IF(${ISEXE})
        ADD_EXECUTABLE(${NAME} MACOSX_BUNDLE
            ${INCLUDE_FILES}
            ${SOURCE_FILES}
            ${RESOURCE_FILES}
            ${QRESOURCE_FILES}
            ${UI_HEADERS}
            ${UI_FILES}
            ${${FOLDERFILES}}
        )
    ELSE(${ISEXE})
        IF(${DYNAMIC})
            ADD_LIBRARY(${NAME} SHARED
                ${INCLUDE_FILES}
                ${SOURCE_FILES}
                ${RESOURCE_FILES}
                ${QRESOURCE_FILES}
                ${UI_HEADERS}
                ${UI_FILES}
            )
        ELSE(${DYNAMIC})
            SET(${FOLDERFILES} ${${FOLDERFILES}} ${INCLUDE_FILES} PARENT_SCOPE)
            SET(${FOLDERFILES} ${${FOLDERFILES}} ${SOURCE_FILES} PARENT_SCOPE)
            SET(${FOLDERFILES} ${${FOLDERFILES}} ${RESOURCE_FILES} PARENT_SCOPE)
            SET(${FOLDERFILES} ${${FOLDERFILES}} ${QRESOURCE_FILES} PARENT_SCOPE)
            SET(${FOLDERFILES} ${${FOLDERFILES}} ${UI_HEADERS} PARENT_SCOPE)
            SET(${FOLDERFILES} ${${FOLDERFILES}} ${UI_FILES} PARENT_SCOPE)
        ENDIF(${DYNAMIC})
    ENDIF(${ISEXE})
ENDFUNCTION(ADDFOLDER FOLDERFILES)