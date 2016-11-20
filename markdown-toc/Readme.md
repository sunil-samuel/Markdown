<p align='right'>
<small>Sunil Samuel<br>
web_github@sunilsamuel.com<br>
http://www.sunilsamuel.com
</small>
</p>

**<p align='center' style='font-size:18px;'>Markdown Table of Contents</p>**

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

1. Create a list of headers in the form of a Table of Content
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