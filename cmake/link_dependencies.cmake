MACRO(SETLINKDEPENDENCIES)
    # thi macros sets up the link dependencies to all pats of the project
    # note that you must have a explicit knowledge of all library and executable names, when editing this macro
    
    # for qt
    qt5_use_modules(exampleexe Core Widgets Gui)
    
    # for the project
    IF(${PROJECTDNAMIC})
        TARGET_LINK_LIBRARIES(exampleexe general examplelib)
    ENDIF(${PROJECTDNAMIC})
ENDMACRO(SETLINKDEPENDENCIES)
