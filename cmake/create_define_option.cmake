FUNCTION(CREATE_DEFINE_OPTION DEFINENAME TEXT DEFAULT_V)
   OPTION(${DEFINENAME} "${TEXT}" ${DEFAULT_V} )
   IF(${DEFINENAME})
       SET(${DEFINENAME} 1 PARENT_SCOPE)
   ELSE(${DEFINENAME})
       SET(${DEFINENAME} 0 PARENT_SCOPE)
   ENDIF(${DEFINENAME})
ENDFUNCTION(CREATE_DEFINE_OPTION)