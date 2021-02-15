
When we are happy with the analysis defined by this set of LPhy scripts, 
we save them into a file named `{{ include.lphy }}.lphy`.
Then, we can use another software called `LPhyBEAST` to produce BEAST XML from these scripts, 
which is released as a Java jar file.
After you make sure both the data file `{{ include.nex }}.nex` 
and the LPhy scripts `{{ include.lphy }}.lphy` are ready, 
preferred in the same folder, you can run the following command line in your terminal.

