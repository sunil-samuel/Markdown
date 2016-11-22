#
# This script is used to create the table of contents for the markdown applications.
# It is run using command line parameters to dictate the output.
#                                                                       Sunil Samuel
#                                                         web_github@sunilsamuel.com
#
use MarkdownTOC::createToc;
use Getopt::Long;

#
# Method to print the usage.
#
sub printUsage {
	print <<ENDUSAGE;
  $0
    [-b | --baseurl <string>     ] - The baseurl to add to every link
    [-c | --context | --nocontext] - Print contextual links on each file
    [-d | --docdir <string>      ] - The document root directory
    [-h | --help                 ] - Print this help
    [-t | --toclink <string>     ] - The link to the table of content page
    [-o | --toctext <string>     ] - The text to the table of content link (default: toc)
    [-v | --verbose              ] - Print additional information during processing
    
           https://github.com/sunil-samuel/Markdown/tree/master/markdown-toc

ENDUSAGE

	die "\n";
}

sub main {

	my (
		$docdir,  $verbose, $help,    $list,
		$baseurl, $context, $tocLink, $tocText
	);

	GetOptions(
		'baseurl=s'  => \$baseurl,
		'context!'   => \$context,
		'docdir=s'   => \$docdir,
		'help'       => \$help,
		'list=s{0,}' => \$list,
		'toclink=s'  => \$tocLink,
		'toctext=s'  => \$tocText,
		'verbose!'   => \$verbose
	);

	printUsage() if $help;

	my $createtoc = MarkdownTOC::createToc->new();

	$createtoc->setDocDir("../test/documentation");
	$createtoc->setVerbose(0);
	$createtoc->setBaseUrl("/resources/documentation/");
	$createtoc->setContextFlag(1);
	$createtoc->setTocLink("/home/Readme.md");
	$createtoc->setTocText("Home");

	$createtoc->process();

	if ( !$createtoc ) {
		print "error\n";
	}
}

main;

