Joe Loughry (joe.loughry@gmail.com)
===========

This is a place to store common pieces of makefiles.  Everything here is maintained
in sync with GitHub.

There is nothing here that cannot deleted and restored from github with a simple clone
command. Everything that isn't was moved out of here into the "moved_out_of_github_directory"
directory when I rationalised the Makefiles on 20131119.1814.

Consider further rationalising the Makefiles here by having them all `include' boilerplate
that is common from a common source file.

**TODO:** finish putting include files in other repos; currently only a few are done.

Targets
-------

There are three interesting targets in the Makefile:

 - `make sync_all` will synchronise all twenty-odd repositories with GitHub, via SSH.

 - `make commit_all` will go into each directory and do a `make commit` there.

 - `make fix` will adjust the .git/config files of all repositories to work with SSH.

git1.mk
-------

The file `git1.mk` is included near the beginning of a Makefile and contains some variable
definitions and sets the timestamp.

git2.mk
-------

The file `git2.mk` is included near the end of a Makefile and contains definitions common
to Git repositories such as "commit" and "sync".

