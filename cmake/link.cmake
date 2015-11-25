MACRO(SETMODULEQTTARGETSLIST)
    SET(ARGUMENTS "${ARGN}")
    
    # get module name
    LIST(GET ARGUMENTS 0 MODULENAME)
    
    # check if module is present in modules or libraries
    LIST(FIND PrjExecutables ${MODULENAME} found_in_exec)
    LIST(FIND PrjLibraries ${MODULENAME} found_in_libs)
    
    IF("${found_in_exec}" STREQUAL "-1" AND "${found_in_libs}" STREQUAL "-1")
        MESSAGE(FATAL_ERROR "Could not find Module: " ${MODULENAME})
    ENDIF("${found_in_exec}" STREQUAL "-1" AND "${found_in_libs}" STREQUAL "-1")
    
    # iterate over list
    SET(index 1)
    LIST(LENGTH ARGUMENTS ARGUMENTS_LENGTH)
    WHILE(index LESS ${ARGC})
        LIST(GET ARGUMENTS ${index} ARGUMENT)
        
        # append Target to Module
        LIST(APPEND ${MODULENAME}_QTTARGETS ${ARGUMENT})
        
        # add qt targetes to global list
        LIST(APPEND QTTARGETS ${ARGUMENT})
        
        MATH(EXPR index "${index}+1")
    ENDWHILE(index LESS ${ARGC})
ENDMACRO(SETMODULEQTTARGETSLIST)

MACRO(SETMODULELINKTARGETSLIST)
    SET(ARGUMENTS "${ARGN}")
    
    # get module name
    LIST(GET ARGUMENTS 0 MODULENAME)
    
    # check if module is present in modules or libraries
    LIST(FIND PrjExecutables ${MODULENAME} found_in_exec)
    LIST(FIND PrjLibraries ${MODULENAME} found_in_libs)
    
    IF("${found_in_exec}" STREQUAL "-1" AND "${found_in_libs}" STREQUAL "-1")
        MESSAGE(FATAL_ERROR "Could not find Module: " ${MODULENAME})
    ENDIF("${found_in_exec}" STREQUAL "-1" AND "${found_in_libs}" STREQUAL "-1")
    
    # iterate over list
    SET(index 1)
    LIST(LENGTH ARGUMENTS ARGUMENTS_LENGTH)
    WHILE(index LESS ${ARGC})
        LIST(GET ARGUMENTS ${index} ARGUMENT)
        
        # append Target to Module
        LIST(APPEND ${MODULENAME}_LINKTARGETS ${ARGUMENT})
        
        MATH(EXPR index "${index}+1")
    ENDWHILE(index LESS ${ARGC})
ENDMACRO(SETMODULELINKTARGETSLIST)

MACRO(LOADQTPACKAGES)
    MESSAGE(STATUS "Load Qt Packages")
    SET(QTPACKAGELIST ${QTTARGETS})
    LIST(REMOVE_DUPLICATES QTPACKAGELIST)
    
    FOREACH(QTPACKAGE ${QTPACKAGELIST})
        FIND_PACKAGE(Qt5${QTPACKAGE} REQUIRED)
    ENDFOREACH(QTPACKAGE ${QTPACKAGELIST})
ENDMACRO(LOADQTPACKAGES)

MACRO(SETLINKDEPENDENCIES)    
    # for the project    
    IF(${PROJECT_DYNAMIC})
        FOREACH(PrjExecutable ${PrjExecutables})
            FOREACH(LINKTARGET ${${PrjExecutable}_LINKTARGETS})
                TARGET_LINK_LIBRARIES(${PrjExecutable} general ${LINKTARGET})
            ENDFOREACH(LINKTARGET ${${PrjExecutable}_LINKTARGETS})
        ENDFOREACH(PrjExecutable ${PrjExecutables})
        
        FOREACH(PrjLibrary ${PrjLibraries})
            FOREACH(LINKTARGET ${${PrjLibrary}_LINKTARGETS})
                TARGET_LINK_LIBRARIES(${PrjLibrary} general ${LINKTARGET})
            ENDFOREACH(LINKTARGET ${${PrjLibrary}_LINKTARGETS})
        ENDFOREACH(PrjLibrary ${PrjLibraries})
    
        FOREACH(PrjExecutable ${PrjExecutables})
            FOREACH(QTTARGET ${${PrjExecutable}_QTTARGETS})
                TARGET_LINK_LIBRARIES(${PrjExecutable} Qt5::${QTTARGET})
            ENDFOREACH(QTTARGET ${${PrjExecutable}_QTTARGETS})
        ENDFOREACH(PrjExecutable ${PrjExecutables})
        
        FOREACH(PrjLibrary ${PrjLibraries})
            FOREACH(QTTARGET ${${PrjLibrary}_QTTARGETS})
                TARGET_LINK_LIBRARIES(${PrjLibrary} Qt5::${QTTARGET})
            ENDFOREACH(QTTARGET ${${PrjLibrary}_QTTARGETS})
        ENDFOREACH(PrjLibrary ${PrjLibraries})
        
        FOREACH(PrjExecutable ${PrjExecutables})
            FOREACH(EXTERNALLIB ${${PrjExecutable}_EXTERNALLIBS_DBG})
                TARGET_LINK_LIBRARIES(${PrjExecutable} debug ${EXTERNALLIB})
            ENDFOREACH(EXTERNALLIB ${${PrjExecutable}_EXTERNALLIBS_DBG})
        ENDFOREACH(PrjExecutable ${PrjExecutables})
        
        FOREACH(PrjExecutable ${PrjExecutables})
            FOREACH(EXTERNALLIB ${${PrjExecutable}_EXTERNALLIBS_REL})
                TARGET_LINK_LIBRARIES(${PrjExecutable} optimized ${EXTERNALLIB})
            ENDFOREACH(EXTERNALLIB ${${PrjExecutable}_EXTERNALLIBS_REL})
        ENDFOREACH(PrjExecutable ${PrjExecutables})
        
        FOREACH(PrjLibrary ${PrjLibraries})
            FOREACH(EXTERNALLIB ${${PrjLibrary}_EXTERNALLIBS_DBG})
                TARGET_LINK_LIBRARIES(${PrjLibrary} debug ${EXTERNALLIB})
            ENDFOREACH(EXTERNALLIB ${${PrjLibrary}_EXTERNALLIBS_DBG})
        ENDFOREACH(PrjLibrary ${PrjLibraries})
        
        FOREACH(PrjLibrary ${PrjLibraries})
            FOREACH(EXTERNALLIB ${${PrjLibrary}_EXTERNALLIBS_REL})
                TARGET_LINK_LIBRARIES(${PrjLibrary} optimized ${EXTERNALLIB})
            ENDFOREACH(EXTERNALLIB ${${PrjLibrary}_EXTERNALLIBS_REL})
        ENDFOREACH(PrjLibrary ${PrjLibraries})
    ELSE(${PROJECT_DYNAMIC})
        SET(QTLINKTARGETS ${QTTARGETS})
        LIST(REMOVE_DUPLICATES QTLINKTARGETS)
        
        FOREACH(PrjExecutable ${PrjExecutables})
            FOREACH(QTLINKTARGET ${QTLINKTARGETS})
                TARGET_LINK_LIBRARIES(${PrjExecutable} Qt5::${QTLINKTARGET})
            ENDFOREACH(QTLINKTARGET ${QTLINKTARGETS})
        ENDFOREACH(PrjExecutable ${PrjExecutables})
        
        SET(EXTERNALLINKTARGETSDBG)
        SET(EXTERNALLINKTARGETSREL)
        FOREACH(PrjExecutable ${PrjExecutables})
            FOREACH(EXTERNALLIB ${${PrjExecutable}_EXTERNALLIBS_DBG})
                LIST(APPEND EXTERNALLINKTARGETSDBG ${EXTERNALLIB})
            ENDFOREACH(EXTERNALLIB ${${PrjExecutable}_EXTERNALLIBS_DBG})
            
            FOREACH(EXTERNALLIB ${${PrjExecutable}_EXTERNALLIBS_REL})
                LIST(APPEND EXTERNALLINKTARGETSREL ${EXTERNALLIB})
            ENDFOREACH(EXTERNALLIB ${${PrjExecutable}_EXTERNALLIBS_REL})
        ENDFOREACH(PrjExecutable ${PrjExecutables})
        
        FOREACH(PrjLibrary ${PrjLibraries})
            FOREACH(EXTERNALLIB ${${PrjLibrary}_EXTERNALLIBS_DBG})
                LIST(APPEND EXTERNALLINKTARGETSDBG ${EXTERNALLIB})
            ENDFOREACH(EXTERNALLIB ${${PrjLibrary}_EXTERNALLIBS_DBG})
            
            FOREACH(EXTERNALLIB ${${PrjLibrary}_EXTERNALLIBS_REL})
                LIST(APPEND EXTERNALLINKTARGETSREL ${EXTERNALLIB})
            ENDFOREACH(EXTERNALLIB ${${PrjLibrary}_EXTERNALLIBS_REL})
        ENDFOREACH(PrjLibrary ${PrjLibraries})
        
        IF(EXTERNALLINKTARGETSDBG)
            LIST(REMOVE_DUPLICATES EXTERNALLINKTARGETSDBG)
        ENDIF(EXTERNALLINKTARGETSDBG)
        IF(EXTERNALLINKTARGETSREL)
            LIST(REMOVE_DUPLICATES EXTERNALLINKTARGETSREL)
        ENDIF(EXTERNALLINKTARGETSREL)
        
        FOREACH(PrjExecutable ${PrjExecutables})
            FOREACH(EXTERNALLIB ${EXTERNALLINKTARGETSDBG})
                TARGET_LINK_LIBRARIES(${PrjExecutable} debug ${EXTERNALLIB})
            ENDFOREACH(EXTERNALLIB ${EXTERNALLINKTARGETSDBG})
            
            FOREACH(EXTERNALLIB ${EXTERNALLINKTARGETSREL})
                TARGET_LINK_LIBRARIES(${PrjExecutable} optimized ${EXTERNALLIB})
            ENDFOREACH(EXTERNALLIB ${EXTERNALLINKTARGETSREL})
        ENDFOREACH(PrjExecutable ${PrjExecutables})
        
    ENDIF(${PROJECT_DYNAMIC})
ENDMACRO(SETLINKDEPENDENCIES)