#!/bin/bash

BEAST="/Applications/BEAST 2.7.5/bin/"

# cd hcv
# run BEAST
$BEAST/beast  -beagle_SSE -overwrite h3n2.xml > out.txt

# run TreeAnnotator
$BEAST/treeannotator -heights mean -burnin 10 h3n2.mascot.trees h3n2.mascot.tree

