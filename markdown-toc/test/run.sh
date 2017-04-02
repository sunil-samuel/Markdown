# A sample run using a directory.
#(cd ../src;perl markdown-toc.pl --docdir "../test/documentation" \
#	--noverbose --baseurl "/markdown-toc/test/documentation/" \
#	--context --toclink "/markdown-toc/Readme.md#example" \
#	--toctext "Table of Contents")
#	
# A sample run using a list of files.	
#(cd ../src;perl markdown-toc.pl \
#	--list ../test/documentation/01.\ document-information.md \
#	../test/documentation/02.\ introduction.md ../test/documentation/03.\ detail-information.md \
#	--noverbose --baseurl "/markdown-toc/test/documentation/" \
#	--context --toclink "/markdown-toc/Readme.md#example" \
#	--toctext "Table of Contents" --noverbose)

#
# THIS IS FOR THE BRMS STUFF
#
(cd ../src;perl markdown-toc.pl \
	--docdir "/Users/sunilsamuel/git/Work/RedHat/TKE/brms/service-sight-rules/resources/documentation" \
	--noverbose --baseurl "/resources/documentation/" \
	--context --toclink "/README.md" \
	--toctext "Table Of Contents")

#
# THIS IS FOR OPTAPLANNER
#
#(cd ../src;perl markdown-toc.pl \
# --docdir "/Users/sunilsamuel/git/Work/RedHat/TKE/vehicle-routing/route-planner/documentation" \
# --noverbose --baseurl "/documentation/" \
# --context --toclink "/Readme.md" \
# --toctext "Table Of Contents")

