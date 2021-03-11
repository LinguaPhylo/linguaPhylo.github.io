
After LPhyBEAST generates a BEAST 2 .xml file (e.g., {{ include.xml
}}), we can point BEAST 2 to it, which will then start the inferential
MCMC analysis.

BEAST 2 will write its outputs to disk into text files specified in
the .xml file (specific paths can be passed in, but in their absence BEAST
2 will write the outputs in the same directory from where it was called).

BEAST 2 will also output the progress of the analysis and some summaries to
the screen, like this:  
