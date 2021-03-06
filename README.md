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

common.mk
---------

The file `common.mk` is included at the end of most of the other makefiles and contains
convenience targets. **NOTE: do not include it in the notes, bibtex, CV, or *this* directory's
makefiles; it can cause an infinite loop.**

TODO:
-----

Fix the broken dependency of `$(bibtex_file)` in `common.mk`. I don't know why it
doesn't detect that the local copy of `$(bibtex_file) is out of date and copy in a
new one like it's supposed to. I implemented a workaround, poor but sufficient, by
adding a `make $(bibtex_file)` early in the build process everywhere that needed
it.

### Update: I still don't know why the dependency on `$(bibtex_file` doesn't work,
but the latest BibTeX is no longer copied in; it is symlinked. The `make $(bibtex_file)`
is still needed early in the build process for anything that uses BibTeX, but it uses
the new symlink mechanism now. I'll go around and delete the local copies of
`consolidated_bibtex_file.bib` everywhere and let `common.mk` establish symlinks
where needed.

Git Usage Notes:
----------------

To commit changes to `common.mk` itself, use `make local_commit`.

The `common.mk` file is not included in the Makefile in this directory to avoid
recursion problems. I'm unhappy with the solution and intend to fix it some day.

