---
layout: page
title:  "Java extension mechanism of LPhy and LPhyBEAST"
author: Walter Xie
permalink: /developer/java-dev/
---

We will use the [Phylonco](https://github.com/bioDS/beast-phylonco) project as an example,
to learn how to create the Java classes and module to extend LPhy and LPhyBEAST.

## The extension "phylonco-lphy"

To create a LPhy extension, first you need to write your own classes to extend or implement 
the extensible components defined from the core.
At the time of writing, LPhy makes three components extensible:

  a) [GenerativeDistribution](https://github.com/LinguaPhylo/linguaPhylo/blob/0e07fb16df152a5613ccb43ae4cf2952af4335f0/lphy/src/main/java/lphy/graphicalModel/GenerativeDistribution.java)

It is a Java interface to represent all types of generative distributions, such as 
[probability distributions](https://github.com/LinguaPhylo/linguaPhylo/tree/master/lphy/src/main/java/lphy/core/distributions),
tree generative distributions (e.g. [Birth-death](https://github.com/LinguaPhylo/linguaPhylo/blob/master/lphy/doc/lphy/evolution/birthdeath.md),
[Coalescent](https://github.com/LinguaPhylo/linguaPhylo/blob/master/lphy/doc/lphy/evolution/coalescent.md)),
and [PhyloCTMC](https://github.com/LinguaPhylo/linguaPhylo/blob/master/lphy/doc/lphy/evolution/likelihood.md) 
generative distributions.

  b) [Fun](https://github.com/LinguaPhylo/linguaPhylo/blob/0e07fb16df152a5613ccb43ae4cf2952af4335f0/lphy/src/main/java/lphy/graphicalModel/Func.java)

It is an abstract class to represent 
all [functions](https://github.com/LinguaPhylo/linguaPhylo/tree/master/lphy/src/main/java/lphy/core/functions) 
in LPhy language.

  c) [SequenceType](https://github.com/LinguaPhylo/jebl3/blob/e6c4193bfa51aaa37dcba06ea6eaa5f258085841/src/main/java/jebl/evolution/sequences/SequenceType.java)

It is a Java interface in the [jebl3](https://search.maven.org/search?q=a:jebl) library,
and stands for all sorts of data types, such as 
[Nucleotide](https://github.com/LinguaPhylo/jebl3/blob/e6c4193bfa51aaa37dcba06ea6eaa5f258085841/src/main/java/jebl/evolution/sequences/SequenceType.java#L133-L201),
[Binary](https://github.com/LinguaPhylo/linguaPhylo/blob/master/lphy/src/main/java/lphy/evolution/datatype/Binary.java),
and [PhasedGenotype](https://github.com/bioDS/beast-phylonco/blob/eab627fec2ce278ddc81403e75936dee431ecd4b/phylonco-lphy/src/main/java/phylonco/lphy/evolution/datatype/PhasedGenotype.java)
in this extension, etc.


### The container provider class

The second step is to register your extended or implemented Java classes into the extension mechanism.
This will involve two files: 
[module-info.java](https://github.com/bioDS/beast-phylonco/blob/eab627fec2ce278ddc81403e75936dee431ecd4b/phylonco-lphy/src/main/java/module-info.java) 
and phylonco.lphy.spi.[Phylonco.java](https://github.com/bioDS/beast-phylonco/blob/eab627fec2ce278ddc81403e75936dee431ecd4b/phylonco-lphy/src/main/java/phylonco/lphy/spi/Phylonco.java).
There is an extra provider configuration file located under the `resources` subfolder for Java 1.8 only.

{% assign current_fig_num = 1 %}

<figure class="image">
<a href="phylonco-lphy.png">
  <img src="phylonco-lphy.png" alt="phylonco-lphy">
  </a>
  <figcaption>Figure {{ current_fig_num }}: The extension "phylonco-lphy".</figcaption>
</figure>

As you can see in Figure {{ current_fig_num }}, `phylonco.lphy.spi.Phylonco` is a container class 
to provide services defined in the service provider interface (SPI), 
which lists all extended classes in the extension.
It is also a service provider class, hence a public no-args constructor is required.
Here we create a new concept, called as 
[container provider class]({% link _posts/2021-07-19-lphy-extension.markdown %}), 
to collect all extended classes in one class, 
so that we can avoid to create a no-args constructor for every classes.

When you create an extension, you need to give a sensible name to 
the container provider class in your extension, 
and place it into a package having the name similar to `mypackage.lphy.spi`.

Then, the line pointed by a red arrow in `module-info.java`
declares the service provider class `phylonco.lphy.spi.Phylonco` 
implements SPI `lphy.spi.LPhyExtension`.
Here SPI is the Java interface 
[LPhyExtension](https://github.com/LinguaPhylo/linguaPhylo/blob/0e07fb16df152a5613ccb43ae4cf2952af4335f0/lphy/src/main/java/lphy/spi/LPhyExtension.java).


### Java 1.8

The 3rd file named as `lphy.spi.LPhyExtension` in the subfolder `src/main/resources/META-INF/services`
is the provider configuration file used to register the 
[service provider in Java 1.8](https://docs.oracle.com/javase/tutorial/ext/basics/spi.html).
This allows the LPhy and its extensions to be able to integrate with the non-module system,
such as BEAST 2 and its packages.  

This file name is same as the SPI file name concatenated with its package, 
which is required by the mechanism.

But please __note__ the recommended LPhy extension mechanism is using the Java module system
and configuring the SPI and providers in the `module-info.java` file,
which is a different mechanism comparing with the provider configuration file under the resources subfolder.

### Naming conventions

Following Java package [naming conventions](https://docs.oracle.com/javase/tutorial/java/package/namingpkgs.html)
is critical. Though we are using the module system to avoid namespace collision,
it'd better to always name your Java package by starting with your extension name, 
but not the reserved core name, such as lphy, lphybeast, beast, etc. 
For example, here we have the package `phylonco.lphy.evolution` to contain the extended LPhy data types and models.
The package `phylonco.lphy.spi` includes the container provider class.


## The extension "phylonco-lphybeast"

To create a LPhyBEAST extension, first you need to write your own mapping classes to implement 
the interface [ValueToBEAST](https://github.com/LinguaPhylo/LPhyBeast/blob/d564e09c9bd4e81d9236c9dd536bf46b488775d2/lphybeast/src/main/java/lphybeast/ValueToBEAST.java)
and [GeneratorToBEAST](https://github.com/LinguaPhylo/LPhyBeast/blob/d564e09c9bd4e81d9236c9dd536bf46b488775d2/lphybeast/src/main/java/lphybeast/GeneratorToBEAST.java).
The former maps a LPhy [Value](https://github.com/LinguaPhylo/linguaPhylo/blob/0e07fb16df152a5613ccb43ae4cf2952af4335f0/lphy/src/main/java/lphy/graphicalModel/Value.java) 
object to a [BEASTInterface](https://github.com/CompEvol/beast2/blob/89defbbf4448854002caf25699c5566727822268/src/beast/core/BEASTInterface.java),
the latter maps a LPhy [Generator](https://github.com/LinguaPhylo/linguaPhylo/blob/0e07fb16df152a5613ccb43ae4cf2952af4335f0/lphy/src/main/java/lphy/graphicalModel/Generator.java) 
to a [BEASTInterface](https://github.com/CompEvol/beast2/blob/89defbbf4448854002caf25699c5566727822268/src/beast/core/BEASTInterface.java). 


{% assign current_fig_num = current_fig_num | plus: 1 %}

<figure class="image">
<a href="phylonco-lphybeast.png">
  <img src="phylonco-lphybeast.png" alt="phylonco-lphybeast">
  </a>
  <figcaption>Figure {{ current_fig_num }}: The extension "phylonco-lphybeast".</figcaption>
</figure>

In Figure {{ current_fig_num }}, 




