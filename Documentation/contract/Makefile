pdfname = Contract.pdf
all:
	pandoc main.md -o $(pdfname)
	wc -w main.md

entr:
	ls *.md | entr -c bash -c 'make'