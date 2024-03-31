buildtm
=======

Build TCL modules from multiple files


Requirements
------------
* Tcl 8.5+
* Tcllib (only for testing)


Usage
-----
To build a module, using a build config file called 'modulename.build':

    $ tclsh buildtm.tcl modulename.build


Build Config File
-----------------
buildtm uses a build config file to describe what files should be used to make
the module.  The config file is a valid Tcl dictionary which uses key value
pairs.  The config file also supports comments for lines beginning with `#`.

The file uses the following fields:

    name - The name of the module
    version - The version number of the module
    description - A brief one line description of the module to put in the header comments.  This is optional.
    files - A list of files to form the module.  Each entry supports wildcards which are compatible with the Tcl command 'glob'.

As an example, the following would build the module 'mymodule-0.1.tm':

    name mymodule
    version 0.1
    description {A module to do something interesting}
    files {lib/*.tcl}



Testing
-------
There is a testsuite in `tests/`.  To run it:

    $ tclsh tests/buildtm.tcl


Licence
-------
Copyright (C) 2024 Lawrence Woodman <https://lawrencewoodman.github.io/>

This software is licensed under an MIT Licence.  Please see the file, [LICENCE.md](https://github.com/lawrencewoodman/buildtm/blob/master/LICENCE.md), for details.
