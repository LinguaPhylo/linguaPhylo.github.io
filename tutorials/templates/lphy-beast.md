
BEAST 2 the data and model specifications from a XML file.
Our goal with LPhy is to make the preparation of the XML as painless, clear and precise as possible.
In order to achieve that, we will use a companion application,
LPhyBEAST, as a bridge between the LPhy script and the BEAST 2 xml.
It is distributed as a [BEAST 2 package](https://www.beast2.org/managing-packages/),
please follow the [instruction](https://linguaphylo.github.io/setup/#lphybeast-installation) 
to install it.

To run LPhyBEAST and produce a BEAST 2 xml, you need to use the terminal 
and execute the script `lphybeast`. 
The [LPhyBEAST usage](https://linguaphylo.github.io/setup/#lphybeast-usage) can help you get started. 
In our {{ include.lphy }}.lphy script, the alignment file is assumed to be located 
under the subfolder `tutorials/data/`. 
To generate the XML, navigate to the `tutorials` folder where LPhy is installed, 
and run the following command in your terminal. 
After it completes, check the message in the end to find the location of the generated XML file. 
