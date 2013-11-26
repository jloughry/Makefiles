#
# NOTE: any makefile that includes this file needs to have a "clean" target
# even if it doesn't do anything.
#

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
	(cd ../notes && make vi)

quotes:
	(cd ../notes && make quotes)

bibtex:
	(cd ../bibtex && make vi)

cv:
	(cd ../CV && make vi)

