#!/bin/bash

BEAST="/Applications/BEAST2.6.3/bin/"

# cd h5n1
# run BEAST
$BEAST/beast  -beagle_SSE -overwrite h5n1.xml > out.txt

# run TreeAnnotator
$BEAST/treeannotator -heights mean -burnin 10 h5n1_with_trait.trees h5n1_with_trait.tree

# run StateTransitionCounter
$BEAST/applauncher StateTransitionCounter -burnin 10 -in h5n1_with_trait.trees -tag location -out stc.out

# plot
Rscript ../plotTransitionsHunan.R

