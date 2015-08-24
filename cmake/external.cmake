MACRO(INITEXTERNAL)
    IF(MSVC)
        SET(CMAKE_FIND_LIBRARY_SUFFIXES .lib)
    ENDIF(MSVC)
ENDMACRO(INITEXTERNAL)

MACRO(SETMODULEEXTERNALINCLUDELIST)
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
        LIST(APPEND ${MODULENAME}_EXTERNALINCLUDES ${ARGUMENT})
        
        MATH(EXPR index "${index}+1")
    ENDWHILE(index LESS ${ARGC})
ENDMACRO(SETMODULEEXTERNALINCLUDELIST)

MACRO(SETMODULEEXTERNALLIBLIST)
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
        
        IF("${ARGUMENT}" STREQUAL "debug")
            MATH(EXPR index "${index}+1")
            IF(NOT index LESS ${ARGC})
                MESSAGE(FATAL_ERROR "index out of range")
            ENDIF(NOT index LESS ${ARGC})
            LIST(GET ARGUMENTS ${index} ARGUMENT)
            
            # append debug Target to Module
            LIST(APPEND ${MODULENAME}_EXTERNALLIBS_DBG ${ARGUMENT})
        ELSEIF("${ARGUMENT}" STREQUAL "optimized")
            MATH(EXPR index "${index}+1")
            IF(NOT index LESS ${ARGC})
                MESSAGE(FATAL_ERROR "index out of range")
            ENDIF(NOT index LESS ${ARGC})
            LIST(GET ARGUMENTS ${index} ARGUMENT)
            
            # append release Target to Module
            LIST(APPEND ${MODULENAME}_EXTERNALLIBS_REL ${ARGUMENT})
        ELSE("${ARGUMENT}" STREQUAL "optimized")
            # append debug and release Target to Module
            LIST(APPEND ${MODULENAME}_EXTERNALLIBS_DBG ${ARGUMENT})
            LIST(APPEND ${MODULENAME}_EXTERNALLIBS_REL ${ARGUMENT})
        ENDIF("${ARGUMENT}" STREQUAL "debug")
        
        MATH(EXPR index "${index}+1")
    ENDWHILE(index LESS ${ARGC})
ENDMACRO(SETMODULEEXTERNALLIBLIST)