# 
# Synthesis run script generated by Vivado
# 

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param xicom.use_bs_reader 1
set_param synth.incrementalSynthesisCache ./.Xil/Vivado-7540-kammce-Lenovo-Y40-80/incrSyn
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir /home/kammce/Documents/University/CMPE127/CMPE127-Toolkit/CMPE127-Toolkit.cache/wt [current_project]
set_property parent.project_path /home/kammce/Documents/University/CMPE127/CMPE127-Toolkit/CMPE127-Toolkit.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo /home/kammce/Documents/University/CMPE127/CMPE127-Toolkit/CMPE127-Toolkit.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_mem {
  /home/kammce/Documents/University/CMPE127/CMPE127-Toolkit/CMPE127-Toolkit.srcs/sources_1/new/ram.mem
  /home/kammce/Documents/University/CMPE127/CMPE127-Toolkit/CMPE127-Toolkit.srcs/sources_1/new/rom.mem
  /home/kammce/Documents/University/CMPE127/CMPE127-Toolkit/CMPE127-Toolkit.srcs/sources_1/new/CPU_TEST.mem
  /home/kammce/Documents/University/CMPE127/CMPE127-Toolkit/CMPE127-Toolkit.srcs/sources_1/new/CPU_DATA_TEST.mem
}
read_verilog -library xil_defaultlib {
  /home/kammce/Documents/University/CMPE127/CMPE127-Toolkit/CMPE127-Toolkit.srcs/sources_1/new/AmbientLightSensor.v
  /home/kammce/Documents/University/CMPE127/CMPE127-Toolkit/CMPE127-Toolkit.srcs/sources_1/new/BinaryToLEDDisplay.v
  /home/kammce/Documents/University/CMPE127/CMPE127-Toolkit/CMPE127-Toolkit.srcs/sources_1/imports/new/ExtToIntSync.v
  /home/kammce/Documents/University/CMPE127/CMPE127-Toolkit/CMPE127-Toolkit.srcs/sources_1/new/Font.v
  /home/kammce/Documents/University/CMPE127/CMPE127-Toolkit/CMPE127-Toolkit.srcs/sources_1/new/GlueLogic.v
  /home/kammce/Documents/University/CMPE127/CMPE127-Toolkit/CMPE127-Toolkit.srcs/sources_1/new/Memory.v
  /home/kammce/Documents/University/CMPE127/CMPE127-Toolkit/CMPE127-Toolkit.srcs/sources_1/new/Motherboard.v
  /home/kammce/Documents/University/CMPE127/CMPE127-Toolkit/CMPE127-Toolkit.srcs/sources_1/new/PWMCapture.v
  /home/kammce/Documents/University/CMPE127/CMPE127-Toolkit/CMPE127-Toolkit.srcs/sources_1/new/PWMCaptureTop.v
  /home/kammce/Documents/University/CMPE127/CMPE127-Toolkit/CMPE127-Toolkit.srcs/sources_1/new/QuadratureDecoder.v
  /home/kammce/Documents/University/CMPE127/CMPE127-Toolkit/CMPE127-Toolkit.srcs/sources_1/new/SPI.v
  /home/kammce/Documents/University/CMPE127/CMPE127-Toolkit/CMPE127-Toolkit.srcs/sources_1/new/ServoController.v
  /home/kammce/Documents/University/CMPE127/CMPE127-Toolkit/CMPE127-Toolkit.srcs/sources_1/new/ServoModule.v
  /home/kammce/Documents/University/CMPE127/CMPE127-Toolkit/CMPE127-Toolkit.srcs/sources_1/new/ServoTop.v
  /home/kammce/Documents/University/CMPE127/CMPE127-Toolkit/CMPE127-Toolkit.srcs/sources_1/new/VGA.v
  /home/kammce/Documents/University/CMPE127/CMPE127-Toolkit/CMPE127-Toolkit.srcs/sources_1/new/Keyboard.v
  /home/kammce/Documents/University/CMPE127/CMPE127-Toolkit/CMPE127-Toolkit.srcs/sources_1/new/MIPS.v
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc /home/kammce/Documents/University/CMPE127/CMPE127-Toolkit/CMPE127-Toolkit.srcs/Motherboard/imports/new/Motherboard.xdc
set_property used_in_implementation false [get_files /home/kammce/Documents/University/CMPE127/CMPE127-Toolkit/CMPE127-Toolkit.srcs/Motherboard/imports/new/Motherboard.xdc]


synth_design -top Motherboard -part xc7a100tcsg324-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef Motherboard.dcp
create_report "synth_2_synth_report_utilization_0" "report_utilization -file Motherboard_utilization_synth.rpt -pb VGA_Terminal_utilization_synth.pb"
