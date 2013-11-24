#
# This file needs to be included BEFORE the first target in another Makefile.
#

documentation = README.md

#
# Note: make requires that we set the value of a variable OUTSIDE any rules.
#

timestamp = `date +%Y%m%d.%H%M`

