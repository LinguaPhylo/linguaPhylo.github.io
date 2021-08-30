
BEAST 2 reads instructions about the data and the model from a
user-provided .xml, which can be produced in a variety of ways.
Our goal with LPhy is to make the preparation of the .xml as painless,
clear and precise as possible.
In order to achieve that, we will use a companion application,
LPhyBEAST, as a bridge between the LPhy script we typed above and the
.xml.

LPhyBEAST is distributed as a [BEAST 2 package](https://www.beast2.org/managing-packages/),
we can use an application called `Package Manager`, which is distributed with BEAST 2 together,
to install it.
To start LPhyBEAST, we have to use the script `lphybeast`.
Some [technical guides](https://linguaphylo.github.io/setup/) can help you to start.

In our {{ include.lphy }}.lphy script, the alignment file is assumed to locate under the folder `tutorials/data/`.
So we need to go to the `tutorials` folder, which is normally where the LPhy is installed, 
run LPhyBEAST as below and check the end of message to find where is the generated XML. 

Let us run LPhyBEAST now:  

