package require tcltest
namespace import tcltest::*

set ThisScriptDir [file normalize [file dirname [info script]]]
set RepoRootDir [file normalize [file join $ThisScriptDir ..]]
source [file join $ThisScriptDir test_helpers.tcl]
tcltest::configure {*}$argv


test buildtm-1 {Config filename doesn't exist} \
-body {
  TestHelpers::buildtm
} -result [list "Usage: buildtm.tcl configFilename\n" {Error: missing configFilename}]


test buildtm-2 {Config filename doesn't exist} \
-body {
  lassign [TestHelpers::buildtm [file join $ThisScriptDir fixtures not_present.build]] stdout stderr
  list $stdout [regsub -- {".*not_present.build"} $stderr {"not_present.build"}]
} -result [list "Build failed\n" {  Error: couldn't open "not_present.build": no such file or directory}]


test buildtm-3 {Check raises error if config missing value for a key} \
-body {
  TestHelpers::buildtm [file join $ThisScriptDir fixtures missing_value.build]
} -result [list "Build failed\n" "  Error: config: missing value to go with key"]


test buildtm-4 {Check raises error if config missing name entry} \
-body {
  TestHelpers::buildtm [file join $ThisScriptDir fixtures missing_name.build]
} -result [list "Build failed\n" "  Error: config missing entry: name"]


test buildtm-5 {Check raises error if config missing version entry} \
-body {
  TestHelpers::buildtm [file join $ThisScriptDir fixtures missing_version.build]
} -result [list "Build failed\n" "  Error: config missing entry: version"]


test buildtm-6 {Check raises error if config missing files entry} \
-body {
  TestHelpers::buildtm [file join $ThisScriptDir fixtures missing_files.build]
} -result [list "Build failed\n" "  Error: config missing entry: files"]


test buildtm-7 {Check allows config to omit the description entry} \
-body {
  lassign [TestHelpers::buildtm [file join $ThisScriptDir fixtures missing_description.build]] stdout stderr
  set stdout [regsub -all -- {Adding file: .*?(file.\.tcl)} $stdout {Adding filer: \1}]
  list $stdout $stderr
} -result [list [join [list "Building: mymodule-0.1.tm" \
  "  Adding filer: filea.tcl" \
  "  Adding filer: fileb.tcl" \
  "  Adding filer: filec.tcl" \
  "Build successful" ""] "\n"] {}]


cleanupTests
