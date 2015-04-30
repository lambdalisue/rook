#!/usr/bin/env perl
$latexargs        = '-shell-escape -synctex=1';
$latexsilentargs  = $latexargs . ' -interaction=batchmode';
$latex            = 'uplatex ' . $latexargs;
$latex_silent     = 'uplatex ' . $latexsilentargs;
$dvipdf           = 'dvipdfmx %O -o %D %S';
$bibtex           = 'pbibtex';
$biber            = 'biber --bblencoding=utf8 -u -U --output_safechars';
$makeindex        = 'mendex %O -o %D %S';
$max_repeat       = 5;
#$pdf_mode         = 0; # No PDF
#$pdf_mode         = 1; # with pdflatex
#$pdf_mode         = 2; # with ps2pdf
$pdf_mode         = 3; # with dvipdfmx

$aux_dir          = 'build';
$out_dir          = $aux_dir;

# Prevent latexmk from removing PDF after typeset.
# This enables Skim to chase the update in PDF automatically.
$pvc_view_file_via_temporary = 0;
