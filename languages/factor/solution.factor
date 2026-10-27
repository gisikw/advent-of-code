USING: command-line io io.encodings.utf8 io.files kernel math.parser namespaces sequences ;
command-line get first2
[ utf8 file-lines length number>string ] dip swap
"Received " prepend " lines of input for part " append swap append print
