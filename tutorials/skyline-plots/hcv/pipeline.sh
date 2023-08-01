#!/bin/bash

BEAST="/Applications/BEAST 2.7.5/bin/"

# cd hcv
# run BEAST
"$BEAST/beast" -beagle_SSE hcv_coal.xml > out.txt

# run TreeAnnotator
"$BEAST/treeannotator" -heights mean -burnin 10 hcv_coal.trees hcv_coal.tree

