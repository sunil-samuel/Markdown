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
    [-b | --baseurl <string>      ] - The baseurl to add to every link
    [-c | --context | --nocontext ] - Print contextual links on each file
    [-d | --docdir <string>       ] - The document root directory
    [-h | --help                  ] - Print this help
    [-l | --list <file1>...<fileN>] - The list of files to process in order
    [-t | --toclink <string>      ] - The link to the table of content page
    [-o | --toctext <string>      ] - The text to the table of content link (default: toc)
    [-v | --verbose | --noverbose ] - Print additional information during processing
    
           https://github.com/sunil-samuel/Markdown/tree/master/markdown-toc
           
  [fedora]>perl $0 --help

ENDUSAGE

	die "\n";
}

sub main {

	my (
		$docdir,  $verbose, $help,    $list,
		$baseurl, $context, $tocLink, $tocText
	) = ( undef, 0, 0, undef, undef, undef, undef, undef );

	GetOptions(
		'baseurl=s' => \$baseurl,
		'context!'  => \$context,
		'docdir=s'  => \$docdir,
		'help'      => \$help,
		'list=s{,}' => \@list,
		'toclink=s' => \$tocLink,
		'toctext=s' => \$tocText,
		'verbose!'  => \$verbose
	);

	printUsage() if $help;

	if ( !@list and !$docdir ) {
		warn "Either --list or --docdir parameter is required\n";
		printUsage();
	}

	my $createtoc = MarkdownTOC::createToc->new();
	if ( !$createtoc ) {
		warn "Could not create toc\n";
		warn $createtoc->getError() . "\n";
	}

	$createtoc->setDocDir($docdir);
	$createtoc->setVerbose($verbose);
	$createtoc->setBaseUrl($baseurl);
	$createtoc->setContextFlag($context);
	$createtoc->setTocLink($tocLink);
	$createtoc->setTocText($tocText);
	$createtoc->setDocList(@list);

	$createtoc->process();
	if ( !$createtoc ) {
		warn "Error processing files\n";
		warn $createtoc->getError() . "\n";
	}
}

main;

