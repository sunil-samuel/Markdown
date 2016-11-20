#!/usr/bin/perl

use File::Basename;
use Getopt::Long;

my $dir = "../documentation";

my $relLink = "resources/documentation/";

#
# Return a link
sub getLink {
	my ( $headerLink, $file ) = (@_);
	$file =~ s/^\s*|\s$//;
	return "$relLink${file}#${headerLink}";
}

sub validateFileExtensions {
	my (@files) = (@_);

	my @validFiles = ();

	foreach my $file (@files) {

		#
		# Select only the files with .md or .markdown (ignore case) extensions.
		#
		next unless ( $file =~ /(\.md$)|(\.markdown)/i );

		#
		# Ignore file that starts with a dot (.).
		#
		next if ( $file =~ /^\./ );
		push( @validFiles, $file );
	}
	@validFiles;
}

sub getHeaderLink {
	my ($line) = (@_);

	$line =~ s/^\s*[#]+\s*//;

	my $headerLink = lc($line);
	$headerLink =~ s/://g;
	$headerLink =~ s/\s/-/g;
	$headerLink;
}

sub getHeaderAndLink {
	my ( $line, $file ) = (@_);

	$line =~ s/^\s*[#]+\s*//;
	my $header = $line;

	my $headerLink = getHeaderLink($line);

	( $header, getLink( $headerLink, $file ) );
}

sub writeContextualLinksToFile {
	my ( $prevLink, $nextLink, $file ) = (@_);

	my $outValue = "";

	my $newFile = "$dir/$file.new.md";
	my $oldFile = "$dir/$file";

	open my $in, '<:encoding(UTF-8)', $oldFile
	  or die "Can't read file $oldFile: $!";
	open my $out, '>:encoding(UTF-8)', $newFile
	  or die "Can't write new file $newFile: $!";

	$outValue .= "<p align='center'>";

	if ( $prevLink && length($prevLink) > 0 ) {
		$outValue .= "[&larr; $prevLink ]";
	}
	if ( $nextLink && length($nextLink) > 0 ) {
		$outValue .= "&nbsp;" x 20 if ( $prevLink && length($prevLink) > 0 );
		$outValue .= "[ $nextLink &rarr;]";
	}
	$outValue .= "</p>";
	print $out "<!--autoheader-->$outValue<!--/autoheader-->\n";

	my $previousLine = undef;
	while (<$in>) {
		( print $out $_ ) && ( $previousLine = $_ ) unless /<!--autoheader-->/;
	}
	print $out "\n" unless $previousLine =~ /\n$|\r$/;
	print $out "<!--autoheader-->$outValue<!--/autoheader-->";
	close $out;
	close $in;

	unlink($oldFile) or die "Can't delete file $oldFile: $!";
	rename( $newFile, $oldFile )
	  or die "Can't rename file $newFile to $oldFile :$!";
}

sub generateContextualLinks {
	my ( $prev, $next, $curFile ) = (@_);

	my ( $prevLink, $nextLink, $homeLink ) = ( undef, undef, undef );

	if ( !$prev ) {
		$prevLink = "";
	}
	else {
		my ( $header, $link ) =
		  getHeaderAndLink( $prev->{'header'}, $prev->{'file'} );
		$prevLink = "<a href='$link'>$header</a>";
	}
	if ( !$next ) {
		$nextLink = "";
	}
	else {
		my ( $header, $link ) =
		  getHeaderAndLink( $next->{'header'}, $next->{'file'} );
		$nextLink = "<a href='$link'>$header</a>";
	}
	writeContextualLinksToFile( $prevLink, $nextLink, $curFile );
}

sub processLinksForFile {
	my ($pFilesRef) = (@_);

	print "\n\n";
	my ( $prev, $next ) = ( undef, undef );
	my $totalFiles = (@$pFilesRef);
	for ( my $count = 0 ; $count < $totalFiles ; $count++ ) {
		my $current = @$pFilesRef[$count];
		$next =
		  ( $count + 1 >= $totalFiles ? undef : @$pFilesRef[ $count + 1 ] );
		generateContextualLinks( $prev, $next, $current->{'file'} );
		$prev = $current;
	}

}

sub processLine {
	my ( $line, $file ) = (@_);

	#
	# Check if there is a hash (#) which denotes the beginning of a header
	# in markdown.  If there is none, then return.  Otherwise, capture
	# the number of hash (#) we found.  This define the level of header.
	#
	return unless $line =~ /^([#]+)/;
	my $length = $1;

	my ( $header, $link ) = getHeaderAndLink( $line, $file );

	print length($length) == 1
	  ? "* [$header]($link)\n"
	  : " " x ( 2 * length($length) ) . "* <sub>[$header]($link)</sub>\n";
}

sub processFile {
	my ($file) = (@_);
	open( my $fh, '<:encoding(UTF-8)', "$dir/$file" )
	  or die "Could not open file $file: $!";

	my $fileHeader = undef;
	while ( my $line = <$fh> ) {
		chomp $line;
		if ( $line =~ /^#/ ) {
			$fileHeader = $line if ( !$fileHeader );
			processLine( $line, $file );
		}
	}
	close($fh);
	$fileHeader;
}

sub printUsage {
	print <<ENDUSAGE;
  $0
    [-b | --baseurl <string>     ] - The baseurl to add to every link
    [-c | --context | --nocontext] - Print contextual links on each file
    [-d | --docdir <string>      ] - The document root directory
    [-h | --help                 ] - Print this help
    [-t | --toclink <string>     ] - The link to the table of content page
    [-v | --verbose              ] - Print additional information during processing

ENDUSAGE

	return 0;
}

sub main {

	my ( $baseurl, $contextLinks, $docdir, $help, $tocLink, $verbose );

	GetOptions(
		'baseurl=s' => \$baseurl,
		'context!'  => \$contextLinks,
		'docdir=s'  => \$docdir,
		'help'      => \$help,
		'toclink!'  => \$tocLink,
		'verbose!'  => \$verbose
	);

	printUsage() if $help;
	$dir     = $docdir  if $docdir;
	$relLink = $baseurl if $baseurl;

	opendir( my $dh, $dir ) || die "Cannot open $dir\n";
	my @files = sort { $a <=> $b } readdir($dh);
	closedir $dh;

	my @processedFiles = ();

	#
	# Only use files that have the valid extension
	#
	my @validFiles = validateFileExtensions(@files);
	my $totalFiles = @validFiles;
	my ( $prev, $next ) = ( undef, undef );
	foreach my $file (@validFiles) {
		my $fileHeader = processFile($file);
		my %fileTags   = {};
		$fileTags{'file'}   = $file;
		$fileTags{'header'} = $fileHeader;
		push( @processedFiles, \%fileTags );
	}

	processLinksForFile( \@processedFiles );
}

main;

