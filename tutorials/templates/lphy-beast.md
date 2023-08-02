
BEAST 2 retrieves the data and model specifications from a XML file.
One of our goals with LPhy is to make configuring Bayesian phylogenetic analysis 
as painless, clear and precise as possible.
In order to achieve that, we will utilize an additional companion application called LPhyBEAST, 
which acts as a bridge between the LPhy script and the BEAST 2 xml.
It is distributed as a [BEAST 2 package](https://www.beast2.org/managing-packages/),
please follow the [instruction](https://linguaphylo.github.io/setup/#lphybeast-installation) 
to install it.

To run LPhyBEAST and produce a BEAST 2 xml, you need to use the terminal 
and execute the script `lphybeast`. 
The [LPhyBEAST usage](/setup/#lphybeast-usage) can help you get started. 
In our {{ include.lphy }}.lphy script, the alignment file is assumed to be located 
under the subfolder `tutorials/data/`. 
To generate the XML, navigate to the `tutorials` folder where LPhy is installed, 
and run the following command in your terminal. 
After it completes, check the message in the end to find the location of the generated XML file. 

For example, on a Mac, after replacing all "x" with the correct version number, 
you can execute the following `lphybeast` command in the terminal to launch LPhyBEAST:

```bash
# go to the folder containing lphy script
cd /Applications/lphystudio-1.x.x/tutorials
# run lphybeast
'/Applications/BEAST 2.7.x/bin/lphybeast' {{ include.args }}{{ include.lphy }}.lphy
```

If you are not familiar with inputting valid paths in the command line, 
here is our [Tech Help](/tutorials/tech-help/#obtaining-the-valid-file-paths-in-the-terminal) that may help you.

For Windows users, please note that "C:\Program Files" is usually a protected directory. 
However, you can copy the "examples" and "tutorials" folders with "data" 
into your "Documents" folder and work in that location to avoid any permission issues.
Alternatively, run `lphybeast.bat` on a Windows terminal like this:

```dos
# go to the subfolder containing lphy script
cd "C:\Users\<YourUserName>\Documents\tutorials"
# run lphybeast
"C:\Program Files\BEAST2.7.x\bat\lphybeast.bat" {{ include.args }}{{ include.lphy }}.lphy
```

Please note that the single or double **quotation marks** ensure that the whitespace in the path 
is treated as valid.

