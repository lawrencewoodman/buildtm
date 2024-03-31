# Build TCL modules from multiple files
#
# Copyright (C) 2024 Lawrence Woodman <https://lawrencewoodman.github.io/>
#
# Licensed under an MIT licence.  Please see LICENCE.md for details.
#

proc appendFileToModule {fdModule filename} {
  set fd [open $filename r]
  puts $fdModule [read $fd]
  close $fd
}

# TODO: Add error detection

proc buildModule {configDir config} {
  set name [dict get $config name]
  set version [dict get $config version]
  set files [dict get $config files]
  set moduleFilename "$name-$version.tm"
  
  puts "Building: $moduleFilename"
  set fdModule [open $moduleFilename w]
  puts $fdModule "# $name v$version"
  if {[dict exists $config description]} {
    puts $fdModule "# [dict get $config description]"
  }
  puts $fdModule "#"
  # TODO: Add more to header, what it was built with and when
  
  foreach file $files {
    set incFiles [
      list {*}[lsort [glob -directory $configDir $file]] \
    ]

    foreach incFile [lsort $incFiles] {
      puts "  Adding file: $incFile"
      appendFileToModule $fdModule $incFile
    }
  }
  close $fdModule
}


# Check the config is valid
proc verifyConfig {config} {
  if {[catch {dict keys $config} err]} {
    return -code error "config: $err"
  }
  
  set mandatoryEntries {name version files}
  set optionalEntries {description}
  set allEntries [concat $mandatoryEntries $optionalEntries]
  foreach mandatoryEntry $mandatoryEntries {
    if {$mandatoryEntry ni [dict keys $config]} {
      return -code error "config missing entry: $mandatoryEntry"
    }
  }
  foreach configEntry [dict keys $config] {
    if {$configEntry ni $allEntries} {
      puts "  Warning: unknown entry in config: $configEntry"
    }
  }
}


proc loadBuildConfig {filename} {
  set fd [open $filename r]
  set configContents [read $fd]
  set cleanLines {}
  foreach line [split $configContents "\n"] {
    if {![regexp -- {\s*#.*$} $line]} {
      lappend cleanLines $line
    }  
  }
  close $fd
  set  config [join $cleanLines "\n"]
  verifyConfig $config
  return $config
}

proc usage {} {
  puts "Usage: buildtm.tcl configFilename"
}


proc main {args} {
  if {[llength $args] != 1} {
    usage
    puts stderr "Error: incorrect number of arguments"
    exit 1
  }
  if {[llength $args] == 1} {
    lassign $args buildFilename
    if {$buildFilename eq ""} {
      usage
      puts stderr "Error: missing configFilename"
      exit 1
    }
  }
  
  set isErr [catch {
    set buildConfigDir [file dirname $buildFilename]
    set buildConfig [loadBuildConfig $buildFilename]
    buildModule $buildConfigDir $buildConfig
  } err]
  if {$isErr} {
    puts stderr "  Error: $err"
    puts "Build failed"
    exit 1
  }
  puts "Build successful"
}

main $argv
