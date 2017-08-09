OS := $(shell uname -s)

ifeq ($(OS), Darwin)
    github_repository_level = ~/thesis/github
endif

ifeq ($(OS), CYGWIN_NT-5.1)
    github_repository_level = /cygdrive/c/Documents\ and\ Settings/rjl/My\ Documents/thesis/github
endif

# Version: 21st January 2014.

bibtex_file = consolidated_bibtex_file.bib
bibtex_source = ../bibtex/consolidated_bibtex_source.bib

commit_message = /tmp/commit_message.txt
get_commit_message = get_commit_message.sh
fix_bad_commits = fix_bad_commits.sh

spurious_files = readme.md.bak \' make.exe.stackdump

editor_cmd = /usr/bin/vi
editor_readonly = /usr/bin/view

#
# double-colon targets are done in addition to anything that might exist in the parent Makefile.
#

.PHONY: all clean allclean spell readme commit commit_only sync \
		notes quotes cv symlink-to-bibtex-file commit-bibtex \
		honda mini hyundai

all:: symlink-to-bibtex-file
	@echo "This is \"all\" in the common.mk file."

clean::
	@echo "This is \"clean\" in the common.mk file."
	rm -vf $(commit_message) ./commit_message.txt $(spurious_files)

spell::
	aspell --lang=en_GB -H check README.md

readme:
	@$(editor_cmd) README.md && echo "OK" || echo "return code from vi was $$?"

#
# Link to the BibTeX file if the link doesn't already exist (so we always have latest).
# This will leave some spam in directories that don't care about BibTeX, but it's not
# easy to prevent without a complicated and fragile mechanism.
#

symlink-to-bibtex-file:
	@if [ ! -L $(bibtex_file) ]; then           \
		ln -fs $(bibtex_source) $(bibtex_file) ; \
	fi

#
# I have been completely unable to find a solution to the problem of Makefiles
# failing to notice when the consolidated_bibtex_file.bib has changed. It's as
# if `make' is not looking through the symlink, but the manual says it should.
#

$(bibtex_file): symlink-to-bibtex-file

#
# This works like a lazy evaluation for commit message.
#

$(commit_message): $(get_commit_message)
	@./$(get_commit_message)

#
# make symlink to shell scripts if they don't already exist
#

$(get_commit_message):
	ln -fs ../Makefiles/$(get_commit_message)
	chmod u+x $(get_commit_message)

commit::
	make commit_only
	make sync

commit-bibtex:
	(cd $(github_repository_level)/bibtex && make commit)

#
# convenience target in case I mis-type the underscore.
#

commit-only: commit_only

#
# Defensive targets in case I mis-type `vi' as `ci': ci and co are old RCS
# commands and I don't want those ever running.
#

.PHONY: ci co

ci co:
	@echo "Did you mean 'vi'?"

commit_only:
	@if [ ! -d .git ]; then \
		echo                                                   ; \
		echo "Not in a Git respository. Try going up a level." ; \
		echo                                                   ; \
		/bin/false                                             ; \
	else \
		make clean                                             ; \
		make $(commit_message)                                 ; \
		git add -A                                             ; \
		git commit -aF $(commit_message)                       ; \
		rm -vf $(commit_message)                                ; \
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
# Additional convenience targets:
#

reset: clean

ro:
	(cd $(github_repository_level)/notes.new && $(editor_readonly) + notes.tex \
		&& echo "OK" || echo "return code from vi was $$?")

#
# Makefile depends on common.mk to be sure everything gets rebuilt
# if common.mk changes, but it has to be done this way to `force'
# the Makefile out-of-date if common.mk changes.
#

Makefile: common.mk
	touch Makefile

notes:
	@(cd $(github_repository_level)/notes.new && $(editor_cmd) + notes.tex \
		&& echo "OK" || echo "return code from vi was $$?")

quotes:
	@(cd $(github_repository_level)/notes.new && $(editor_cmd) quotes.tex \
		&& echo "OK" || echo "return code from vi was $$?")

bibtex:
	@(cd $(github_repository_level)/bibtex && make vi \
		&& echo "OK" || echo "return code from vi was $$?")

bib: bibtex

cv:
	@(cd $(github_repository_level)/CV && make vi loughry_cv.tex \
		&& echo "OK" || echo "return code from vi was $$?")

honda_mileage_file = honda_mileage.txt
mini_mileage_file = mini_mileage.txt
hyundai_mileage_file = hyundai_mileage.txt
difference_in_mileage_file = difference_in_mileage.txt

honda:
	@(cd $(github_repository_level)/notes.new/graphics \
		&& $(editor_cmd) + $(honda_mileage_file) \
		&& echo "OK" || echo "return code from vi was $$?")

mini:
	@echo "Use 'make hyundai' instead"
	exit 1
	@(cd $(github_repository_level)/notes.new/graphics \
		&& $(editor_cmd) + $(mini_mileage_file) \
		&& echo "OK" || echo "return code from vi was $$?")

	$(eval last_line = $(shell (cd $(github_repository_level)/notes.new/graphics \
		&& tail -1 $(mini_mileage_file))))

	@if [ "$(last_line)" = "" ]; then \
		echo "Grabbing the second to last line of $(mini_mileage_file)" ; \
		(cd $(github_repository_level)/notes.new/graphics \
			&& tail -2 $(mini_mileage_file) | head -1 \
			>> $(difference_in_mileage_file)) ; \
	else \
		echo "Grabbing last line only of $(mini_mileage_file)" ; \
		(cd $(github_repository_level)/notes.new/graphics \
			&& tail -1 $(mini_mileage_file) \
			>> $(difference_in_mileage_file)) ; \
	fi

	@echo "Here's what the last few lines of the $(mini_mileage_file) look like:"
	@(cd $(github_repository_level)/notes.new/graphics && tail -5 $(mini_mileage_file))
	@echo "And here's what the last few lines of the $(difference_in_mileage_file) look like:"
	@(cd $(github_repository_level)/notes.new/graphics && tail -5 $(difference_in_mileage_file))

hyundai:
	@(cd $(github_repository_level)/notes.new/graphics \
		&& $(editor_cmd) + $(hyundai_mileage_file) \
		&& echo "OK" || echo "return code from vi was $$?")

	$(eval last_line = $(shell (cd $(github_repository_level)/notes.new/graphics \
		&& tail -1 $(hyundai_mileage_file))))

	@if [ "$(last_line)" = "" ]; then \
		echo "Grabbing the second to last line of $(hyundai_mileage_file)" ; \
		(cd $(github_repository_level)/notes.new/graphics \
			&& tail -2 $(hyundai_mileage_file) | head -1 \
			>> $(difference_in_mileage_file)) ; \
	else \
		echo "Grabbing last line only of $(hyundai_mileage_file)" ; \
		(cd $(github_repository_level)/notes.new/graphics \
			&& tail -1 $(hyundai_mileage_file) \
			>> $(difference_in_mileage_file)) ; \
	fi

	@echo "Here's what the last few lines of the $(hyundai_mileage_file) look like:"
	@(cd $(github_repository_level)/notes.new/graphics && tail -5 $(hyundai_mileage_file))
	@echo "And here's what the last few lines of the $(difference_in_mileage_file) look like:"
	@(cd $(github_repository_level)/notes.new/graphics && tail -5 $(difference_in_mileage_file))

changes:
	git diff

# This is a file truncation sentinel; it should be the last line in the file.

