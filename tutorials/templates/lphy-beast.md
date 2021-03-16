
BEAST 2 reads instructions about the data and the model from a
user-provided .xml, which can be produced in a variety of ways.
Our goal with LPhy is to make the preparation of the .xml as painless,
clear and precise as possible.
In order to achieve that, we will use a companion application,
LPhyBEAST, as a bridge between the LPhy script we typed above and the
.xml.

LPhyBEAST is distributed as a Java .jar file.
A .jar file is just a compressed file that contains all the Java code
and instructions for running a Java application.
You can put LPHyBEAST's .jar file wherever you want, just remember to
point your `java` binary to the correct path when executing the
command below.
We will just place the .jar file in the same folder as our {{
include.lphy }}.lphy script.

Let us run LPhyBEAST now:  

