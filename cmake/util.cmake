include(CMakeParseArguments)

Function(CacheSet Name Value)
	GET_PROPERTY(V_ADVANCED CACHE "${Name}" PROPERTY ADVANCED)
	GET_PROPERTY(V_TYPE CACHE "${Name}" PROPERTY TYPE)
	GET_PROPERTY(V_HELPSTRING CACHE "${Name}" PROPERTY HELPSTRING)
	Set(${Name} ${Value} CACHE ${V_TYPE} ${V_HELPSTRING} FORCE)
	If(${V_ADVANCED})
		Mark_As_Advanced(FORCE ${Name})
	EndIf()
EndFunction()

Function(CacheClear Name)
	GET_PROPERTY(V_ADVANCED CACHE "${Name}" PROPERTY ADVANCED)
	GET_PROPERTY(V_TYPE CACHE "${Name}" PROPERTY TYPE)
	GET_PROPERTY(V_HELPSTRING CACHE "${Name}" PROPERTY HELPSTRING)
	Set(${Name} 0 CACHE ${V_TYPE} ${V_HELPSTRING} FORCE)
	If(${V_ADVANCED})
		Mark_As_Advanced(FORCE ${Name})
	EndIf()
EndFunction()

function(mac_get_linker_id)
	cmake_parse_arguments(
		_MGLI "" "TARGET;OUTPUT" "" ${ARGN}
	)

	get_target_property(_MGLI_TARGET_LOC ${_MGLI_TARGET} IMPORTED_LOCATION)
	if(NOT _MGLI_TARGET_LOC)
		get_target_property(_MGLI_TARGET_LOC ${_MGLI_TARGET} IMPORTED_LOCATION_MINSIZEREL)
	endif()
	if(NOT _MGLI_TARGET_LOC)
		get_target_property(_MGLI_TARGET_LOC ${_MGLI_TARGET} IMPORTED_LOCATION_RELEASE)
	endif()
	if(NOT _MGLI_TARGET_LOC)
		get_target_property(_MGLI_TARGET_LOC ${_MGLI_TARGET} IMPORTED_LOCATION_RELWITHDEBINFO)
	endif()
	if(NOT _MGLI_TARGET_LOC)
		get_target_property(_MGLI_TARGET_LOC ${_MGLI_TARGET} IMPORTED_LOCATION_DEBUG)
	endif()

	execute_process(
		COMMAND otool -D ${_MGLI_TARGET_LOC}
		WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
		RESULT_VARIABLE _MGLI_RES
		OUTPUT_VARIABLE _MGLI_LINK OUTPUT_STRIP_TRAILING_WHITESPACE
		ERROR_VARIABLE _MGLI_ERR ERROR_STRIP_TRAILING_WHITESPACE ERROR_QUIET
	)
	STRING(REGEX REPLACE ";" "\\\\;" _MGLI_LINK "${_MGLI_LINK}")
	STRING(REGEX REPLACE "\n" ";" _MGLI_LINK "${_MGLI_LINK}")
	list(POP_FRONT _MGLI_LINK)

	set(${_MGLI_OUTPUT} "${_MGLI_LINK}" PARENT_SCOPE)
endfunction()