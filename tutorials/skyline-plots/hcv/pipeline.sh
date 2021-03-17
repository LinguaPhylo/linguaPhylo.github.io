#!/bin/bash

BEAST="/Applications/BEAST2.6.3/bin/"

# cd hcv
# run BEAST
$BEAST/beast  -beagle_SSE -overwrite hcv_coal.xml > out.txt

# run TreeAnnotator
$BEAST/treeannotator -heights mean -burnin 10 hcv_coal.trees hcv_coal.tree

