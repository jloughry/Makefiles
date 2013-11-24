readme:
	vi $(documentation)

commit:
	git add .
	git commit -am "commit from Makefile `date +%Y%m%d.%H%M`"
	make sync

sync:
	git pull --rebase
	git push

