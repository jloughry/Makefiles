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

include git1.mk

almost_all_repositories = BANCStar bibtex CESAR2012 CV dissertation \
	experiments fizzbuzz FreeBSD help HST13 jloughry.github.io M1 \
	Makefiles notes OpenSolaris optical_tempest PostScript public_keys \
	subset VALID2010

the_rest_of_the_repositories = FreeBSD

all_repositories = $(almost_all_repositories) $(the_rest_of_the_repositories)

.PHONY: notes bibtex

all:
	@echo "Use 'fix' to fix-up remote URLs in all repositories for SSH access to GitHub."
	@echo "Use 'commit_all' to iterate through all the repositories and commit changes."
	@echo "Use 'sync_all' to sync all repositories to GitHub."

fix:
	for REPOSITORY in $(all_repositories) ; do \
		(cd ../$$REPOSITORY && git remote set-url origin git@github.com:jloughry/$$REPOSITORY.git) ; \
	done
	@echo "This resets the .git/config file in each respository to allow SSH (harmless)."

commit_all:
	for REPOSITORY in $(almost_all_repositories) ; do \
		(cd ../$$REPOSITORY && make commit) ; \
	done
	for REPOSITORY in $(the_rest_of_the_repositories) ; do \
		(cd ../$$REPOSITORY && make -f not_Makefile commit) ; \
	done

sync_all:
	for REPOSITORY in $(almost_all_repositories) ; do \
		(cd ../$$REPOSITORY && make sync) ; \
	done
	for REPOSITORY in $(the_rest_of_the_repositories) ; do \
		(cd ../$$REPOSITORY && make -f not_Makefile sync) ; \
	done

include git2.mk

notes:
	(cd ../notes && make vi)

bibtex:
	(cd ../bibtex && make vi)

