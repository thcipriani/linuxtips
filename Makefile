INDEX = ${CURDIR}/index.md
PERLCMD = 

.PHONY: create

create:
	@ git show origin/master:README.md > $(INDEX)
	@ perl -i -pe 'print "---\nlayout: default\ntitle: Linux Tips\n---\n\n" if $$. == 1;' $(INDEX)
