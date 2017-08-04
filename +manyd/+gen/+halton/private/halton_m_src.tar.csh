#!/bin/csh
#
#  Purpose:
#
#    Create a GZIP'ed TAR file of the m_src/halton files.
#
#  Modified:
#
#    02 January 2006
#
#  Author:
#
#    John Burkardt
#
#  Move to the directory just above the "halton" directory.
#
cd $HOME/public_html/m_src
#
#  Delete any TAR or GZ file in the directory.
#
echo "Remove TAR and GZ files."
rm halton/*.tar
rm halton/*.gz
#
#  Create a TAR file of the "halton" directory.
#
echo "Create TAR file."
tar cvf halton_m_src.tar halton/*
#
#  Compress the file.
#
echo "Compress the TAR file."
gzip halton_m_src.tar
#
#  Move the compressed file into the "halton" directory.
#
echo "Move the compressed file into the directory."
mv halton_m_src.tar.gz halton
#
#  Say goodnight.
#
echo "The halton_m_src gzip file has been created."
