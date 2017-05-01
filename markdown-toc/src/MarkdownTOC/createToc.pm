package MarkdownTOC::createToc;

use File::Basename;

#
# Create a new instance of the object.
#
sub new {
	my $self = {};
	bless $self;
	$self->{context} = 0;
	$self->{success} = 1;
	$self->{msg}     = "";
	$self->{toclink} = "";
	$self->{toctext} = "TOC";
	my @headers = ();
	$self->{headers} = \@headers;

	my @fileHeaders = ();
	$self->{fileheaders} = \@fileHeaders;

	return $self;
}

use overload 'bool' => sub {
	my $self = shift;
	return $self->{success};
};

#
# For each file, keep track of the first header for it.
# This will be used for contextual links.
#
sub addToFileHeaders {
	my ( $self, $file, $line ) = (@_);

	my $fileHeaders = $self->{fileheaders};

	my @fh = @$fileHeaders;

	# If there is already a header for this file, then
	#skip this header.
	foreach $element (@fh) {
		my %fileInfo = %$element;
		return $self if ( $fileInfo{'file'} eq $file );
	}

	my %fileInfo = {};
	$fileInfo{'file'}   = $file;
	$fileInfo{'header'} = $line;
	push( @fh, \%fileInfo );
	$self->{fileheaders} = \@fh;
	return $self;
}

sub addError {
	my $self = shift;
	my $err  = shift;

	warn "$err\n";
	$self->{msg}     = $self->{msg} . "\n" . $err;
	$self->{success} = 0;
	return $self;
}

sub getError {
	my $self = shift;

	return $self->{msg};
}

#
# Set the baseurl to be used for links.
#
sub setBaseUrl {
	my $self = shift;
	my $url  = shift;
	unless ( $url =~ /\/$/ ) {
		$url = "$url/";
	}
	$self->{baseurl} = $url;
	return $self;
}

#
# Set the context flag that indicates to print the contextual links.
#
sub setContextFlag {
	my $self    = shift;
	my $context = shift;
	$self->{context} = $context;
	return $self;
}

#
# Set the document directory where all of the markdown files are located.
#
sub setDocDir {
	my $self   = shift;
	my $docdir = shift;

	return if $docdir =~ /^\s*$/;

	# Make sure that the docdir ends with a slash
	$docdir = $docdir . "/" unless $docdir =~ /\/$/;
	$self->{docdir} = $docdir;
	return $self;
}

#
# Set the list of document to process.
#
sub setDocList {
	my ( $self, @doclist ) = (@_);
	return if !@doclist || scalar(@doclist) <= 0;
	$self->{doclist} = \@doclist;
	return $self;
}

#
# Set the link to the table of content page.  This link will be used
# to point every page back to the toc page.
#
sub setTocLink {
	my $self = shift;
	$self->{toclink} = shift;
	return $self;
}

sub setTocText {
	my $self    = shift;
	my $tocText = shift;
	return if $tocText =~ /^\s*$/;
	$self->{toctext} = $tocText;
	return $self;
}

#
# Turn verbose on
#
sub setVerbose {
	my $self = shift;
	$self->{verbose} = shift;
	return $self;
}

#
# Take a string and normalize it so that it can be used as a anchor link
# within the table of contents.  This will convert all of the parts to be
# markdown compliant.
#
sub normalizeHeader {
	my ( $self, $header ) = (@_);

	$header = lc($header);
	$header =~ s/://g;
	$header =~ s/\(//g;
	$header =~ s/\)//g;
	$header =~ s/\s/-/g;
	return $header;
}

sub writeContextLinks {
	my ( $self, $file, $prev, $next ) = (@_);

	my $newFile = "$file.new.md";
	my ( $in, $out ) = ( undef, undef );
	unless ( open $in, '<:encoding(UTF-8)', $file ) {
		warn "Could not open file '$file' to read: $!\n";
		$self->verbose("Could not open file '$file' to read:$!");
		return $self;
	}

	# Output the previous page link.
	unless ( open $out, '>:encoding(UTF-8)', $newFile ) {
		warn "Could not open file '$newFile' to read: $!\n";
		$self->verbose("Could not open file '$newFile' to read:$!");
		close($in);
		return $self;
	}

	#Output the toc link.
	my $tocLink = "";
	if ( $self->{toclink} ) {

		#$tocLink =
		#    "&nbsp;" x 5 . "[ ["
		#  . $self->{toctext} . "]("
		#  . $self->{toclink}
		#  . ") &uarr; ]";
		$tocLink = "&nbsp;" x 5
		  . "[ <a href='$self->{toclink}'>$self->{toctext}</a> &uarr; ]";
	}
	my $outValue =
	  "<p align='center'>" . ( $prev ? "[ &larr; $prev ]" : "" ) . $tocLink;
	if ($next) {
		$outValue .= "&nbsp;" x 5 if ($prev);

		#$outValue .= "[ <a href='";
		$outValue .= "[ $next &rarr; ]";

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

	unless ( unlink($file) ) {
		warn("Could not remove old file '$file': $!\n");
		$self->verbose("Could not remove old file '$file' : $!");
	}
	unless ( rename( $newFile, $file ) ) {
		warn("Could not rename file '$newFile' to '$file'\n");
		$self->verbose("Could not rename file '$newFile' to '$file'\n");
	}
}

sub createContextLinks {
	my ($self) = (@_);

	return unless $self->{context};
	$self->verbose("Creating context links for files");

	my @fileHeaders = @{ $self->{fileheaders} };
	my $totalFiles  = (@fileHeaders);

	for ( my $count = 0 ; $count < $totalFiles ; $count++ ) {
		my ( $pLink, $nLink ) = ( undef, undef );
		unless ( $count - 1 < 0 ) {
			$pLink = $self->createLink( $fileHeaders[ $count - 1 ]{'header'},
				$self->replaceSpaces( $fileHeaders[ $count - 1 ]{'file'} ),
				'html' );

			#$pLink =
			#  "["
			#. $fileHeaders[ $count - 1 ]{'header'} . "]("
			#. $self->createLink( $fileHeaders[ $count - 1 ]{'header'},
			#	$self->replaceSpaces( $fileHeaders[ $count - 1 ]{'file'} ) )
			#  . ")";
		}

		unless ( $count + 1 >= $totalFiles ) {
			$nLink = $self->createLink( $fileHeaders[ $count + 1 ]{'header'},
				$self->replaceSpaces( $fileHeaders[ $count + 1 ]{'file'} ),
				'html' );

			#$nLink =
			#    "["
			#  . $fileHeaders[ $count + 1 ]{'header'} . "]("
			#  . $self->createLink( $fileHeaders[ $count + 1 ]{'header'},
			#		$self->replaceSpaces( $fileHeaders[ $count + 1 ]{'file'} ) )
			#		  . ")";
		}

		$self->writeContextLinks( $fileHeaders[$count]{'file'}, $pLink,
			$nLink );
	}

}

#
# Using the file name, create the link given the baseurl parameter.
#
sub createLink {
	my ( $self, $header, $file, $type ) = (@_);
	my $link = (
		  $self->{baseurl}
		? $self->{baseurl} . basename($file)
		: $file
	);
	$link = $link . "#" . $self->normalizeHeader($header);

	# The next line creates a html link.
	if ( $type eq 'html' ) {
		$link = "<a href='$link'>$header</a>";
	}
	return $link;
}

sub createToc {
	my $self = shift;

	my @headers = @{ $self->{headers} };
	print "<!-- BEGIN HEADERS (copy into root page) -->\n";
	foreach my $header (@headers) {
		my $link =
		  $self->createLink( $header->{'header'},
			$self->replaceSpaces( $header->{'file'} ) );
		print $header->{'level'} == 1
		  ? "* [" . $header->{'header'} . "](" . $link . ")\n"
		  : "\t" x ( $header->{'level'} - 1 )
		  . "* <sub>["
		  . $header->{'header'} . "]("
		  . $link
		  . ")</sub>\n";
	}
	print "<!-- END HEADERS (copy into root page) -->\n";

}

sub replaceSpaces {
	my ( $self, $text ) = (@_);
	$text =~ s/ /%20/g;
	return $text;
}

sub addToHeaders {
	my ( $self, $file, $line ) = (@_);
	$line =~ s/^[>]*([#]+)\s*//;
	my $header = $line;
	my $level  = length($1);
	$header =~ s/^\s+|\s+$//g;

	$self->addToFileHeaders( $file, $line );

	my $headers  = $self->{headers};
	my %metaData = {};
	$self->verbose("File '$file', header '$header', level '$level'");
	$metaData{'file'}   = $file;
	$metaData{'header'} = $header;
	$metaData{'level'}  = $level;
	push( @$headers, \%metaData );
	$self->{headers} = \@$headers;
	return $self;
}

#
# Traverse the directory and get the list of files from this directory.
#
sub getFileListFromDir {
	my $self = shift;
	my $dh;
	if ( !opendir( $dh, $self->{docdir} ) ) {
		$self->addError(
			"Could not open directory " . $self->{docdir} . ":$!" );
		return $self;
	}
	my @files = sort { $a <=> $b } readdir($dh);
	closedir $dh;
	$self->setDocList(@files);

	return $self;
}

#
# Print the verbose message if the user chose to print verbose
# messages to standard out.
#
sub verbose {
	my $self = shift;
	my $msg  = shift;
	if ( $self->{verbose} ) {
		print "    [verbose]$msg\n";
	}
	return $self;
}

#
# Look at the list of files from the doclist and ensure that this file
# satisfy certain conditions, such as 1) it does not start with a dot (.)
# 2) it has an extension of .md or .markdown (ignore case)
#
sub validateFiles {
	my $self       = shift;
	my @validFiles = ();
	my @files      = @{ $self->{doclist} };
	foreach my $file (@files) {

		# Only files with .md or .markdown (ignore case) extensions
		$self->verbose("Checking file '$file' for .md or .markdown extension");
		next unless ( $file =~ /(\.md$)|(\.markdown)/i );

		# Ignore file that starts with a dot (.).
		$self->verbose("Checking if file '$file' starts with a dot");
		next if ( basename($file) =~ /^\./ );
		$self->verbose("Adding file '$file' to the list of valid files");
		push( @validFiles, $self->{docdir} . $file );
	}
	$self->{validfiles} = \@validFiles;
	return $self;
}

sub getFileList {
	my $self = shift;
	if ( $self->{doclist} && $self->{docdir} ) {
		$self->addError("Both doclist and docdir cannot be set.  Set only one");
		$self->verbose(
			"Both doclist and docdir is set, therefore erroring out");
		return $self;
	}
	if ( $self->{docdir} ) {
		$self->verbose(
			"Getting list of files from directory '" . $self->{docdir} . "'" );
		$self->getFileListFromDir();
	}
	$self->validateFiles();
	return $self;
}

sub processFile {
	my ( $self, $file ) = (@_);
	unless ( open( $fh, '<:encoding(UTF-8)', $file ) ) {
		$self->addError("Could not open file '$file': $!");
		return $self;
	}
	while ( my $line = <$fh> ) {
		chomp $line;
		$self->addToHeaders( $file, $line ) if $line =~ /^#|^>#/;
	}
	close($fh);
	return $self;

}

sub process {
	my $self = shift;

	$self->getFileList();
	return unless $self->{success};
	my @files = @{ $self->{validfiles} };
	foreach my $file (@files) {
		$self->verbose("Processing file '$file'");
		$self->processFile($file);
	}

	$self->createToc();
	$self->createContextLinks();
}

1;

