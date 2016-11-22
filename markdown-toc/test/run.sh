# A sample run using a directory.
(cd ../src;perl markdown-toc.pl --docdir "../test/documentation" \
	--noverbose --baseurl "/markdown-toc/test/documentation/" \
	--context --toclink "/markdown-toc/Readme.md#example" \
	--toctext "Table of Contents")
	
# A sample run using a list of files.	
(cd ../src;perl markdown-toc.pl \
	--list ../test/documentation/01.\ document-information.md \
	../test/documentation/02.\ introduction.md ../test/documentation/03.\ detail-information.md \
	--noverbose --baseurl "/markdown-toc/test/documentation/" \
	--context --toclink "/markdown-toc/Readme.md#example" \
	--toctext "Table of Contents" --noverbose)