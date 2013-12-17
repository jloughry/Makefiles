#
# double-colon targets are done in addition to anything that might exist in the parent Makefile.
#

#
# I hate to hard-code this path even as much as is done here, because
# the result only works for repositories underneath my `github' directory,
# but trying to apply too much automation violates the YAGNI principle.
#

github_repository_level = /cygdrive/c/Documents\ and\ Settings/rjl/My\ Documents/thesis/github/

all::
	@echo "This is \"all\" in the common.mk file"

clean::
	@echo "This is \"clean\" in the common.mk file"
	rm -f README.md.bak

spell::
	aspell --lang=en_GB -H check README.md

readme:
	vi README.md

commit:
	@if [ ! -d .git ]; then \
		echo "Not in a Git respository. Try going up a level." ;    \
	else                                                            \
		make clean ;                                                \
		git add . ;                                                 \
		git commit -am "commit from Makefile `date +%Y%m%d.%H%M`" ; \
		make sync ;                                                 \
	fi

sync:
	@if [ ! -d .git ]; then                                      \
		echo "Not in a Git respository. Try going up a level." ; \
	else                                                         \
		git pull --rebase ;                                      \
		git push ;                                               \
	fi

notes:
	(cd $(github_repository_level)/notes && vi notes.tex)

quotes:
	(cd $(github_repository_level)/notes && vi quotes.tex)

bibtex:
	(cd $(github_repository_level)/bibtex && make vi)

cv:
	(cd $(github_repository_level)/CV && make vi loughry_cv.tex)

