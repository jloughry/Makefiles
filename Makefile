#
# The FreeBSD repository is special because its Makefile is
# distribution-significant and can't contain other stuff. So the Makefile
# in that repository that actually gets used is called not_Makefile.
#
# When creating a new repository in the GitHub for Windows app, remember
# to "publish" it there first before trying to "sync" from this Makefile.
#
# TODO: fix the above restriction.
#
# NOTE: don't run "make fix" in this directory; run it one level above.
#

almost_all_repositories = 33-questions BANCStar bibtex CESAR2012 CV thesis \
	experiments fizzbuzz FreeBSD help HST13 jloughry.github.io M1 \
	Makefiles notes.new OpenSolaris optical_tempest PostScript public_keys \
	subset Unicode VALID2010 \
	5280-1.0 Douglas2017 EMC_Europe_2018 GAS-Assembly-Language-Module \
	Karabiner-Elements PowerKey RTOS applied-math.org bad_postscript \
	bucklespring clojure cnadocs.com crontab_backup_script diy-ecb-penguin \
	essay et-book fuse-ext2 gcc-arm-none-eabi-6-2017-q1-update iA-Fonts \
	libdvdcss main_recursively metasploit mla13 namecoin-core netoir.com \
	new_paper non-computational_models optimal_banker_codes optimised_graph \
	osx-cpu-temp python raspberrypi recursive_descent runlamp scheme_yoga \
	signal_processing teensy thesis turingwasright.com

the_rest_of_the_repositories = FreeBSD

all_repositories = $(almost_all_repositories) $(the_rest_of_the_repositories)

documentation = README.md

commit_message = /tmp/commit_message.txt

.PHONY: notes bibtex cv

all::
	@echo "Use 'fix' to fix-up remote URLs in all repositories for SSH" \
		"access to GitHub."
	@echo
	@echo "Use 'commit_all' to iterate through all the repositories and" \
		"commit changes"
	@echo "(and sync)."
	@echo
	@echo "Use 'sync_all' to ONLY sync all the repositories to GitHub" \
		"(this should not"
	@echo "be needed often)."
	@echo
	@echo "Use 'local_commit' to commit changes to the files in *this*" \
		"directory."

clean::
	@echo "\"make clean\" doesn't do anything here."

fix:
	for REPOSITORY in $(all_repositories) ; do \
		(cd $$REPOSITORY && git remote set-url origin \
			git@github.com:jloughry/$$REPOSITORY.git) ; \
	done
	@echo "This resets the .git/config file in each respository to allow SSH"
	@echo "(it's harmless)."

#
# convenience targets in case I mistype the underscore.
#

local-commit: local_commit
local-commit-only: local_commit_only
local-sync: local_sync
commit-local: local_commit

local_commit:
	make local_commit_only
	make local_sync

local_commit_only: $(commit_message)
	make clean
	git add .
	git commit -F $(commit_message)
	rm -fv $(commit_message)

$(commit_message):
	@./get_commit_message.sh

local_sync:
	git pull
	git push

commit_all:
	for REPOSITORY in $(almost_all_repositories) ; do \
		(cd $$REPOSITORY && make commit) ; \
	done
	# make commit_freebsd

commit_freebsd:
	(cd FreeBSD && make -f not_Makefile commit)

sync_all:
	for REPOSITORY in $(almost_all_repositories) ; do \
		(cd $$REPOSITORY && make sync) ; \
	done
	# make sync_freebsd

sync_freebsd:
	(cd FreeBSD && make -f not_Makefile sync)

readme:
	vi $(documentation)

spell::
	aspell --lang=en_GB check $(documentation)

notes:
	(cd ../notes.new && make vi)

quotes:
	(cd ../notes.new && make quotes)

bibtex:
	(cd ../bibtex && make vi)

cv:
	(cd ../CV && make vi)

changes:
	git diff

#
# Note: do not include common.mk here: it could cause all of the repositories
# to be recursively committed to GitHub. The reason is because the common.mk
# file defines targets "commit" and "sync" and those, if called from here,
# might cause an infinite loop (I think).
#

