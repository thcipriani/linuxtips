.PHONY: clean all

all: clean index.html

clean:
	@rm -f index.html

index.html:
	@git show origin/master:README > index.html
	@perl -i -pe 'print "<html>\n<title>Linux Tips</title>\n<body>\n<pre>\n" if $$. == 1' index.html
	@perl -i -ne 'print $$_; print "</pre>\n</body>\n</html>\n" if eof' index.html
