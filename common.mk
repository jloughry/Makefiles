#
# I hate to hard-code this path, because the resulting functionality only
# works for repositories underneath my `github' directory, but trying to
# make automation too intelligent violates the YAGNI principle and I have
# a thesis to write.
#

github_repository_level = /cygdrive/c/Documents\ and\ Settings/rjl/My\ Documents/thesis/github

# Version: 20th January 2014.

bibtex_file = consolidated_bibtex_file.bib
bibtex_source = $(github_repository_level)/bibtex/consolidated_bibtex_source.bib

commit_message = commit_message.txt
get_commit_message = get_commit_message.sh
fix_bad_commits = fix_bad_commits.sh

#
# double-colon targets are done in addition to anything that might exist in the parent Makefile.
#

.PHONY: all clean allclean spell readme commit commit_only sync notes quotes bibtex cv commit-bibtex

all::
	@echo "This is \"all\" in the common.mk file"

clean::
	@echo "This is \"clean\" in the common.mk file"
	rm -f README.md.bak $(commit_message)

spell::
	aspell --lang=en_GB -H check README.md

readme:
	vi README.md

#
# Link to the BibTeX file if the link doesn't already exist (so we always have latest).
#

.PHONY: .FORCE

$(bibtex_file): .FORCE
	@if [ ! -L $(bibtex_file) ]; then           \
		ln -s $(bibtex_source) $(bibtex_file) ; \
	fi

#
# This works like a lazy evaluation for commit message.
#

$(commit_message): $(get_commit_message)
	@./$(get_commit_message)

#
# make symlink to shell scripts if they don't already exist
#

$(get_commit_message):
	ln -s $(github_repository_level)/Makefiles/$(get_commit_message)

commit:
	make commit_only
	make sync

commit-bibtex:
	(cd $(github_repository_level)/bibtex && make commit)

#
# convenience target in case I mis-type the underscore.
#

commit-only: commit_only

commit_only:
	@if [ ! -d .git ]; then \
		echo                                                   ; \
		echo "Not in a Git respository. Try going up a level." ; \
		echo                                                   ; \
		/bin/false                                             ; \
	else \
		make clean                                             ; \
		make $(commit_message)                                 ; \
		git add .                                              ; \
		git commit -aF $(commit_message)                       ; \
		rm -f $(commit_message)                                ; \
	fi

sync:
	@if [ ! -d .git ]; then \
		echo                                                   ; \
		echo "Not in a Git respository. Try going up a level." ; \
		echo                                                   ; \
		/bin/false                                             ; \
	else \
		git pull                                               ; \
		git push                                               ; \
	fi

#
# Makefile depends on common.mk to be sure everything gets rebuilt
# if common.mk changes, but it has to be done this way to `force'
# the Makefile out-of-date if common.mk changes.
#

Makefile: common.mk
	touch Makefile

notes:
	(cd $(github_repository_level)/notes.new && vi notes.tex)

quotes:
	(cd $(github_repository_level)/notes.new && vi quotes.tex)

bibtex:
	(cd $(github_repository_level)/bibtex && make vi)

cv:
	(cd $(github_repository_level)/CV && make vi loughry_cv.tex)

