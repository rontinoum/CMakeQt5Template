FUNCTION(GATHERMOCHEADER MOCFILES)
    set(options)
    set(oneValueArgs HEADER)
    set(multiValueArgs)

    cmake_parse_arguments(GATHERMOCHEADER "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    
    # test if get a proper output from moc
    SET(MOCOUTPUTFILES)
    FOREACH(HEADERFILE ${GATHERMOCHEADER_HEADER})
        GET_FILENAME_COMPONENT(MOCWORKONGDIR ${HEADERFILE} DIRECTORY)
        EXECUTE_PROCESS(COMMAND ${QT_MOC_EXECUTABLE} ${HEADERFILE}
                WORKING_DIRECTORY ${MOCWORKONGDIR}
                ERROR_VARIABLE MOCERROR)
                
        IF("${MOCERROR}" STREQUAL "")
            STRING(REPLACE ${PrjSrcDir} ${PrjMocDir} MOCOUTPUTFILE ${HEADERFILE})
            
            GET_FILENAME_COMPONENT(MOCFILE_DIRECTORY ${MOCOUTPUTFILE} DIRECTORY)
            GET_FILENAME_COMPONENT(MOCFILE_NAME_WE   ${MOCOUTPUTFILE} NAME_WE)
            
            SET(MOCOUTPUTFILE ${MOCFILE_DIRECTORY}/${MOCFILE_NAME_WE}_moc.cpp)
            
            # generate moc command for each header
            QT5_GENERATE_MOC(${HEADERFILE} ${MOCOUTPUTFILE})
            
            SET(MOCOUTPUTFILES ${MOCOUTPUTFILES} ${MOCOUTPUTFILE})
        ENDIF("${MOCERROR}" STREQUAL "")
    ENDFOREACH(HEADERFILE ${GATHERMOCHEADER_HEADER})
    
    # set Moc files
    SET(${MOCFILES} ${MOCOUTPUTFILES} PARENT_SCOPE)
ENDFUNCTION(GATHERMOCHEADER MOCFILES)

FUNCTION(GATHERUIFILES UIC_FILES) 
    set(options)
    set(oneValueArgs UIFILES)
    set(multiValueArgs)

    cmake_parse_arguments(GATHERUIFILES "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    
    SET(UI_OPTIONS)
    
    # process uic files
    SET(UICOUTPUTFILES)
    FOREACH(UIFILE ${GATHERUIFILES_UIFILES})
        STRING(REPLACE ${PrjSrcDir} ${PrjUicDir} UICOUTPUTFILE ${UIFILE})
            
        GET_FILENAME_COMPONENT(UICFILE_DIRECTORY ${UICOUTPUTFILE} DIRECTORY)
        GET_FILENAME_COMPONENT(UICFILE_NAME_WE   ${UICOUTPUTFILE} NAME_WE)
            
        SET(UICOUTPUTFILE ${UICFILE_DIRECTORY}/${UICFILE_NAME_WE}_uic.h)
            
        # generate moc command for each header
        add_custom_command(OUTPUT ${UICOUTPUTFILE}
          COMMAND ${Qt5Widgets_UIC_EXECUTABLE}
          ARGS ${UI_OPTIONS} -o ${UICOUTPUTFILE} ${UIFILE}
          MAIN_DEPENDENCY ${UIFILE} VERBATIM)
            
        SET(UICOUTPUTFILES ${UICOUTPUTFILES} ${UICOUTPUTFILE})
    ENDFOREACH(UIFILE ${GATHERUIFILES_UIFILES})
    
    # set Uic files
    SET(${UIC_FILES} ${UICOUTPUTFILES} PARENT_SCOPE)
ENDFUNCTION(GATHERUIFILES UIC_FILES)

FUNCTION(GATHERQRCFILES QRC_OUT_FILES) 
    set(options)
    set(oneValueArgs QRCFILES)
    set(multiValueArgs)

    cmake_parse_arguments(GATHERQRCFILES "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    
    # store current cmake binary dir
    SET(TMP_CMAKE_CURRENT_BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR})
    SET(CMAKE_CURRENT_BINARY_DIR ${PrjQrcDir})
    
    SET(QRCOUTPUTFILES)
    QT5_ADD_RESOURCES(QRCOUTPUTFILES ${GATHERQRCFILES_QRCFILES})
    
    # restore cmake binary dir
    SET(CMAKE_CURRENT_BINARY_DIR ${TMP_CMAKE_CURRENT_BINARY_DIR})
    
    # set Uic files
    SET(${QRC_OUT_FILES} ${QRCOUTPUTFILES} PARENT_SCOPE)
ENDFUNCTION(GATHERQRCFILES QRC_OUT_FILES)