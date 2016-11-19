<p align='right'>
<small>Sunil Samuel<br>
web_github@sunilsamuel.com<br>
http://www.sunilsamuel.com
</small>
</p>
# Introduction

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
2. Create a section at the top and end of each markdown file to navigate to previous, next, and the
Table of Content files (optional)

## Parameters

The parameters.

