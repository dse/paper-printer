%.pdf: %.svg Makefile
	inkscape $(INKSCAPE_OPTIONS) --export-dpi=600 --export-filename="$@.tmp.pdf" "$<"
	mv "$@.tmp.pdf" "$@"
