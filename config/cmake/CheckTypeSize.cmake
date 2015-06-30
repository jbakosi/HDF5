#
# Check if the type exists and determine size of type.  if the type
# exists, the size will be stored to the variable.
#
# CHECK_TYPE_SIZE - macro which checks the size of type
# VARIABLE - variable to store size if the type exists.
# HAVE_${VARIABLE} - does the variable exists or not
#

MACRO (HDF_CHECK_TYPE_SIZE TYPE VARIABLE)
  set (CMAKE_ALLOW_UNKNOWN_VARIABLE_READ_ACCESS 1)
  if ("HAVE_${VARIABLE}" MATCHES "^HAVE_${VARIABLE}$")
    set (MACRO_CHECK_TYPE_SIZE_FLAGS 
        "-DCHECK_TYPE_SIZE_TYPE=\"${TYPE}\" ${CMAKE_REQUIRED_FLAGS}"
    )
    foreach (def HAVE_SYS_TYPES_H HAVE_STDINT_H HAVE_STDDEF_H HAVE_INTTYPES_H)
      if ("${def}")
        set (MACRO_CHECK_TYPE_SIZE_FLAGS "${MACRO_CHECK_TYPE_SIZE_FLAGS} -D${def}")
      ENDIF("${def}")
    endforeach (def)

    message (STATUS "Check size of ${TYPE}")
    if (CMAKE_REQUIRED_LIBRARIES)
      set (CHECK_TYPE_SIZE_ADD_LIBRARIES 
          "-DLINK_LIBRARIES:STRING=${CMAKE_REQUIRED_LIBRARIES}"
      )
    endif (CMAKE_REQUIRED_LIBRARIES)
    TRY_RUN (${VARIABLE} HAVE_${VARIABLE}
        ${CMAKE_BINARY_DIR}
        ${HDF5_RESOURCES_DIR}/CheckTypeSize.c
        CMAKE_FLAGS -DCOMPILE_DEFINITIONS:STRING=${MACRO_CHECK_TYPE_SIZE_FLAGS}
        "${CHECK_TYPE_SIZE_ADD_LIBRARIES}"
        OUTPUT_VARIABLE OUTPUT
    )
    if (HAVE_${VARIABLE})
      message (STATUS "Check size of ${TYPE} - done")
      file (APPEND ${CMAKE_BINARY_DIR}/CMakeFiles/CMakeOutput.log 
          "Determining size of ${TYPE} passed with the following output:\n${OUTPUT}\n\n"
      )
    else (HAVE_${VARIABLE})
      message (STATUS "Check size of ${TYPE} - failed")
      file (APPEND ${CMAKE_BINARY_DIR}/CMakeFiles/CMakeError.log 
          "Determining size of ${TYPE} failed with the following output:\n${OUTPUT}\n\n"
      )
    endif (HAVE_${VARIABLE})
  endif ("HAVE_${VARIABLE}" MATCHES "^HAVE_${VARIABLE}$")
  set (CMAKE_ALLOW_UNKNOWN_VARIABLE_READ_ACCESS)
ENDMACRO (HDF_CHECK_TYPE_SIZE)
