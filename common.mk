#
# double-colon targets are done in addition to anything that might exist in the parent Makefile.
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
	make clean
	git add .
	git commit -am "commit from Makefile `date +%Y%m%d.%H%M`"
	make sync

sync:
	git pull --rebase
	git push

notes:
	(cd $(github_repository_level)/notes && vi notes.tex)

quotes:
	(cd $(github_repository_level)/notes && vi quotes.tex)

bibtex:
	(cd $(github_repository_level)/bibtex && make vi)

cv:
	(cd $(github_repository_level)/CV && make vi loughry_cv.tex)

