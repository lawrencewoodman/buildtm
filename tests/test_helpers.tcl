# Helper functions for the tests
package require fileutil

namespace eval TestHelpers {}


proc TestHelpers::buildtm {{configFilename {}}} {
  set tmpDir [BuildTmpDir]
  cd $tmpDir
    
  set stdout ""
  if {$configFilename eq {}} {
    set pipe [open "|/bin/env tclsh buildtm.tcl" "r"]
  } else {
    set pipe [open "|/bin/env tclsh buildtm.tcl $configFilename" "r"]
  }
  while {[gets $pipe line] >= 0} {
    append stdout "$line\n"
  }
  catch {close $pipe} stderr
  set tmContents [ReadTMFile $tmpDir]
  
  return [list $stdout $stderr $tmContents]
}


proc TestHelpers::BuildTmpDir {} {
  global RepoRootDir
  set tmpDir [::fileutil::maketempdir -prefix buildtmtest]
  file mkdir [file join $tmpDir lib]
  file copy [file join $RepoRootDir buildtm.tcl] $tmpDir
  file copy [file join $RepoRootDir tests fixtures lib filea.tcl] [file join $tmpDir lib]
  file copy [file join $RepoRootDir tests fixtures lib fileb.tcl] [file join $tmpDir lib]
  file copy [file join $RepoRootDir tests fixtures lib filec.tcl] [file join $tmpDir lib]
  file copy [file join $RepoRootDir tests fixtures missing_files.build] [file join $tmpDir]
  file copy [file join $RepoRootDir tests fixtures missing_value.build] [file join $tmpDir]
  file copy [file join $RepoRootDir tests fixtures missing_description.build] [file join $tmpDir]
  file copy [file join $RepoRootDir tests fixtures missing_name.build] [file join $tmpDir]
  return $tmpDir
}


proc TestHelpers::ReadTMFile {dir} {
  set contents {}
  set tmFiles [glob -nocomplain -directory $dir *.tm]
  if {[llength $tmFiles] == 1} {
    lassign $tmFiles filename
    set fd [open $filename r]
    set contents [read $fd]
    close $fd
  }
  return $contents
}
