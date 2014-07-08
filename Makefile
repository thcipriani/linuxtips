.PHONY: clean all

all: clean index.txt

clean:
	@rm -f index.txt

index.txt:
	@git show origin/master:README > index.txt
