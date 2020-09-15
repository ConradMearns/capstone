pdfname = Logbook.pdf
all:
	pandoc *.md -o $(pdfname)

entr:
	ls *.md | entr -c bash -c 'make'
