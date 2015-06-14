MACRO(SETLINKDEPENDENCIES)
    # thi macros sets up the link dependencies to all pats of the project
    # note that you must have a explicit knowledge of all library and executable names, when editing this macro
    
    # for qt
    qt5_use_modules(sample_executable Core Widgets Gui)
    
    # for the project
    IF(${PROJECTDNAMIC})
        TARGET_LINK_LIBRARIES(sample_executable general sample_module)
    ENDIF(${PROJECTDNAMIC})
    
    TARGET_LINK_LIBRARIES(sample_executable Qt5::Core)
    TARGET_LINK_LIBRARIES(sample_executable Qt5::Widgets)
    TARGET_LINK_LIBRARIES(sample_executable Qt5::Gui)
ENDMACRO(SETLINKDEPENDENCIES)