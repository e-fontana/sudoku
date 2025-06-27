set_global_assignment -entity "main_communicator" -library "lib_main_communicator" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "main_communicator" -library "lib_main_communicator" -name IP_TOOL_VERSION "24.1"
set_global_assignment -entity "main_communicator" -library "lib_main_communicator" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_main_communicator" -name SPD_FILE [file join $::quartus(sip_path) "../main_communicator.spd"]
set_global_assignment -library "lib_main_communicator" -name MISC_FILE [file join $::quartus(sip_path) "../../main_communicator.qsys"]

set_global_assignment -library "lib_main_communicator" -name MISC_FILE [file join $::quartus(sip_path) "main_communicator.v"]
set_global_assignment -library "lib_main_communicator" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_up_rs232_counters.v"]
set_global_assignment -library "lib_main_communicator" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_up_rs232_in_deserializer.v"]
set_global_assignment -library "lib_main_communicator" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_up_rs232_out_serializer.v"]
set_global_assignment -library "lib_main_communicator" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_up_sync_fifo.v"]
set_global_assignment -library "lib_main_communicator" -name MISC_FILE [file join $::quartus(sip_path) "submodules/main_communicator_rs232_0.v"]
