#
# The FreeBSD repository is special because its Makefile is distribution-significant
# and can't contain other stuff. So the Makefile in that repository that actually
# gets used is called not_Makefile.
#
# When creating a new repository in the GitHub for Windows app, remember to "publish"
# it there first before trying to "sync" from this Makefile.
#
# TODO: fix the above restriction.
#
# NOTE: don't run "make fix" in this directory; run it one level above.
#

almost_all_repositories = 33-questions BANCStar bibtex CESAR2012 CV dissertation \
	experiments fizzbuzz FreeBSD help HST13 jloughry.github.io M1 \
	Makefiles notes OpenSolaris optical_tempest PostScript public_keys \
	subset Unicode VALID2010

the_rest_of_the_repositories = FreeBSD

all_repositories = $(almost_all_repositories) $(the_rest_of_the_repositories)

documentation = README.md

.PHONY: notes bibtex cv

all::
	@echo "Use 'fix' to fix-up remote URLs in all repositories for SSH access to GitHub."
	@echo "Use 'commit_all' to iterate through all the repositories and commit changes (and sync)."
	@echo "Use 'sync_all' to ONLY sync all repositories to GitHub (should not be needed often)."

clean::
	@echo "\"make clean\" doesn't do anything here."

fix:
	for REPOSITORY in $(all_repositories) ; do \
		(cd $$REPOSITORY && git remote set-url origin git@github.com:jloughry/$$REPOSITORY.git) ; \
	done
	@echo "This resets the .git/config file in each respository to allow SSH (harmless)."

local_commit: commit_message.txt
	make clean
	git add .
	git commit -aF commit_message.txt
	make local_sync
	rm -f commit_message.txt

commit_message.txt:
	@./get_commit_message.sh

local_sync:
	git pull --rebase
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
	(cd notes && make vi)

quotes:
	(cd notes && make quotes)

bibtex:
	(cd bibtex && make vi)

cv:
	(cd CV && make vi)

#
# Note: do not include common.mk here: it could cause all of the repositories to be
# recursively committed to GitHub. The reason is because the common.mk file defines
# targets "commit" and "sync" and those, if called from here, might cause an infinite
# loop (I think).
#

