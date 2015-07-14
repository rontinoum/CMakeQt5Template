SET(INCLUDEGROUP "include")
SET(SOURCEGROUP "source")
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
    SET(INCLUDEGROUPNAME ${INCLUDEGROUP})
    SET(SOURCEGROUPNAME ${SOURCEGROUP})
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
    SOURCE_GROUP(${INCLUDEGROUPNAME} FILES ${INCLUDE_FILES})

    # search for include files and set
    FINDFILES(SOURCE_FILES ABSPATH ${ADDFOLDER_DIR} POSTFIXES ${SrcPostFixes})
    SOURCE_GROUP(${SOURCEGROUPNAME} FILES ${SOURCE_FILES})
    
    # gather  h files to moc
    GATHERMOCHEADER(MOC_FILES HEADER ${INCLUDE_FILES})
    SOURCE_GROUP(${QTMOCGROUPNAME} FILES ${MOC_FILES})

    # find ui files to uic
    FINDFILES(UI_FILES ABSPATH ${ADDFOLDER_DIR} POSTFIXES ${UiPostFixes})
    SOURCE_GROUP(${UIGROUPNAME} FILES ${UI_FILES})
    
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
        
        TARGET_INCLUDE_DIRECTORIES(${ADDFOLDER_NAME} PUBLIC ${PrjSrcDir})
        
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
ENDFUNCTION(ADDFOLDER FOLDERFILES)