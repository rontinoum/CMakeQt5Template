MACRO(CONFIGURATE)
    # set project name
    SET(PrjName Sample_Project)

    # define libraries
    SET(PrjLibraries 
        sample_module)

    # define executables
    SET(PrjExecutables 
        sample_executable)
ENDMACRO(CONFIGURATE)

MACRO(DEFINEMODULEQTDEPENDENCY)
    SETMODULEQTTARGETSLIST(sample_executable Core Widgets Gui)
ENDMACRO(DEFINEMODULEQTDEPENDENCY)

MACRO(DEFINEMODULELINKDEPENDENCY)
    SETMODULELINKTARGETSLIST(sample_executable sample_module)
ENDMACRO(DEFINEMODULELINKDEPENDENCY)