<p align='right'>
<small>Sunil Samuel<br>
web_github@sunilsamuel.com<br>
http://www.sunilsamuel.com
</small>
</p>

<font size="8">**<p align='center'><font size="8" color="red">Markdown Table of Contents</p>**</font>

# Overview

This perl script generates a table of contents given a list of `markdown` files to process.  
The script looks for lines that starts with a hash (#), which marks the beginning of the header.  
According to markdown rules, any lines that starts with a hash denotes a header.  There could be
different levels of headers indicated by the number of hashes.  That is ## denotes second level
header, ### denotes a third level, and so forth.

# Usage

The script can process several markdown files together to generate the table of contents.  Each
markdown file should have a header as its first line.  The idea is to separate every top level
headers into separate files such that each file is a section of the document.

The script will:

1. Create a list of headers in the form of a Table of Content (TOC).  The TOC is is outputted
to the screen and should be copied into the root markdown page.
2. Create a section at the top and end of each markdown file to navigate to previous, next,
and the Table of Content files (optional)

## Parameters

The script is run with several command line parameters.
 
```sh
  create-toc.pl
    [-b | --baseurl <string>       ] - The baseurl to add to every link
    [-c | --context | --nocontext  ] - Print contextual links on each file
    [-d | --docdir <string>        ] - The document root directory
    [-h | --help                   ] - Print this help
    [-l | --list <file1>...<fileN> ] - The list of files to process in order
    [-t | --toclink <string>       ] - The link to the table of content page
    [-o | --toctext <string>       ] - The text to the table of content link (default: toc)
    [-v | --verbose                ] - Print additional information during processing
```
>**-b | --baseurl &lt;string&gt;**<br>
The baseurl is prepended to all of the links that are generated for each file.  For instance,
if the baseurl is `/resources/documentation/` and the markdown file name is `01.intro.md`, then 
th link will be:

>```markdown
<a href="/resources/documentation/01.intro.md#header1">header text</a>
```
>default: resources/documentations


>**-c | --context | --nocontext**<br>
Create the previous, next, and table of content links within each of the markdown file
that is processed.  This will allow the reader the ability to traverse all of the documentation
files without going back to the toc page.

>default: 1

>**-d | --docdir &lt;string&gt;**<br>
The path to the directory where all of the markdown files reside.  Files that have the .md
or .markdown (case insensitive) extensions will be processed for headers from within this
directory.<br><br>
NOTE: The files within this directory will be sorted in alphabetical order to be processed.
Therefore, if using this parameter, make sure that the files are named accordingly.  Either 
`docdir` or `list` must be specified.

>**-h | --help**<br>
Output the help and usage information.

>**-l | --list &lt;file1&gt; ... &lt;fileN&gt;**<br>
The list of files (with directory path) to process.  The files will be processed in the 
order of this list.  Either `docdir` or `list` must be specified.

>**-t | --toclink &lt;string&gt;**<br>
Since the script does not know the name of the page that contains the table of content, this
parameter is used to specify the name of the file.  This text will be used as the link that
points back to the toc page.
```sh
Example: --toclink /resources/documentation/Readme.md
```

>**-o | --toctext &lt;string&gt;**<br>
The link title for the table of contents.  This is used to create the link back to the table
of content page from within each markdown page.

>default: TOC
```sh
Example: --toctext "Table of Contents"
```

>**-v | --verbose**<br>
Output additional messages during processing of files

## Examples

```sh
create-toc.pl --baseurl /resources/documentation --nocontext --docdir ../docs  --toclink Readme.md
```

```sh
create-toc.pl --baseurl /resources/docs --context --list file1.md file2.md --toclink /docs/Readme.md
```

# Example
The following Table of Content is created using this script.  The markdown pages in the 
test/documentation directory are used to generate this TOC.

**<p align='center'>Table of Contents</p>**
<!-- BEGIN HEADERS (copy into root page) -->
* [Document Information](/markdown-toc/test/documentation/01.%20document-information.md#document-information)
	* <sub>[Creator](/markdown-toc/test/documentation/01.%20document-information.md#creator)</sub>
	* <sub>[Copyright](/markdown-toc/test/documentation/01.%20document-information.md#copyright)</sub>
	* <sub>[Awareness](/markdown-toc/test/documentation/01.%20document-information.md#awareness)</sub>
	* <sub>[Private](/markdown-toc/test/documentation/01.%20document-information.md#private)</sub>
	* <sub>[Additional Information](/markdown-toc/test/documentation/01.%20document-information.md#additional-information)</sub>
* [Introduction](/markdown-toc/test/documentation/02.%20introduction.md#introduction)
	* <sub>[Purpose](/markdown-toc/test/documentation/02.%20introduction.md#purpose)</sub>
	* <sub>[Terminologies](/markdown-toc/test/documentation/02.%20introduction.md#terminologies)</sub>
	* <sub>[Current Implementation](/markdown-toc/test/documentation/02.%20introduction.md#current-implementation)</sub>
	* <sub>[Projected Implementation](/markdown-toc/test/documentation/02.%20introduction.md#projected-implementation)</sub>
* [Functionality](/markdown-toc/test/documentation/03.%20detail-information.md#functionality)
	* <sub>[Service Definition](/markdown-toc/test/documentation/03.%20detail-information.md#service-definition)</sub>
	* <sub>[Second Header](/markdown-toc/test/documentation/03.%20detail-information.md#second-header)</sub>
		* <sub>[Third Header](/markdown-toc/test/documentation/03.%20detail-information.md#third-header)</sub>
			* <sub>[Fourth Header](/markdown-toc/test/documentation/03.%20detail-information.md#fourth-header)</sub>
				* <sub>[Fifth Header](/markdown-toc/test/documentation/03.%20detail-information.md#fifth-header)</sub>
<!-- END HEADERS (copy into root page) -->
