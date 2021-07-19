---
layout: post
title:  "LPhy Extension Mechanism"
author: Walter Xie
date:   2021-07-19
categories: programming
---

LPhy extensions are implemented by using the Service Provider Interface (SPI) 
within the Java Platform Module System (JPMS).
An LPhy extension module implements the [LPhyExtension](https://github.com/LinguaPhylo/linguaPhylo/blob/master/LPhy/src/lphy/spi/LPhyExtImpl.java) 
interface to provide a list of the classes that the extension module provides to extend the functionality of LPhy.


## Project structure

The [LPhy repository](https://github.com/LinguaPhylo/linguaPhylo) contains two modules 
separated in two subfolder LPhy (containing core classes, such as parser, distributions, functions and data types) 
and LPhyStudio (GUI). The project folder structure looks like:

```
linguaPhylo
    ├── build.xml
    ├── examples
    ├── LPhy
    │    ├── build.xml
    │    ├── doc
    │    ├── lib
    │    ├── src
    │    │    ├── lphy
    │    │    └── module-info.java
    │    └── test
    ├──LPhyStudio
    │    ├── build.xml
    │    └── src
    │         ├── lphystudio
    │         └── module-info.java
    └──tutorials
```

## SPI and the extension's container provider class

The [module lphy](https://github.com/LinguaPhylo/linguaPhylo/blob/master/LPhy/src/module-info.java)
declares the package dependencies and SPI 
[LPhyExtension](https://github.com/LinguaPhylo/linguaPhylo/blob/master/LPhy/src/lphy/spi/LPhyExtImpl.java)
using the following code. 

{% highlight java %}
exports lphy.spi;
uses lphy.spi.LPhyExtension;
{% endhighlight %}

Becaseu we consider the core itself as an extension, the Container Provider class 
[LPhyExtImpl](https://github.com/LinguaPhylo/linguaPhylo/blob/master/LPhy/src/lphy/spi/LPhyExtension.java)
is also required to declare in this module using the following one-line code.

{% highlight java %}
provides lphy.spi.LPhyExtension with lphy.spi.LPhyExtImpl;
{% endhighlight %}

Here is the source code of SPI in LPhy :

{% highlight java %}
package lphy.spi;

import ...;

/**
 * The service interface defined for SPI.
 * Implement this interface to create one "Container" provider class
 * for each module of LPhy or its extensions,
 * which should include {@link GenerativeDistribution}, {@link Func},
 * and {@link SequenceType}.
 *
 * @author Walter Xie
 */
public interface LPhyExtension {

    /**
     * @return the list of new {@link GenerativeDistribution} implemented 
     *         in the LPhy extension.
     */
    List<Class<? extends GenerativeDistribution>> getDistributions();

    /**
     * @return the list of new {@link Func} implemented in the LPhy extension.
     */
    List<Class<? extends Func>> getFunctions();

    /**
     * @return the map of new {@link SequenceType} implemented in the LPhy extension.
     *         The string key is a keyword to represent this SequenceType.
     *         The keyword can be used to identify and initialise the 
     *         corresponding sequence type.
     */
    Map<String, ? extends SequenceType> getSequenceTypes();

}
{% endhighlight %}

Then the Container Provider class [LPhyExtImpl](https://github.com/LinguaPhylo/linguaPhylo/blob/master/LPhy/src/lphy/spi/LPhyExtension.java)
lists all required _GenerativeDistribution_, _Func_, and _SequenceType_.

{% highlight java %}
package lphy.spi;

import ...;

/**
 * The "Container" provider class that implements SPI
 * which include a list of {@link GenerativeDistribution}, {@link Func},
 * and {@link SequenceType} to extend.
 * It requires a public no-args constructor.
 * @author Walter Xie
 */
public class LPhyExtImpl implements LPhyExtension {

    List<Class<? extends GenerativeDistribution>> genDists = Arrays.asList(
            // probability distribution
            Normal.class, LogNormal.class, Exp.class, 
            ... );

    List<Class<? extends Func>> functions = Arrays.asList(ARange.class, ArgI.class,
            // Substitution models
            JukesCantor.class, K80.class, F81.class, HKY.class, 
            ... );

    /**
     * Required by ServiceLoader.
     */
    public LPhyExtImpl() { }

    @Override
    public List<Class<? extends GenerativeDistribution>> getDistributions() {
        return genDists;
    }

    @Override
    public List<Class<? extends Func>> getFunctions() {
        return functions;
    }

    @Override
    public Map<String, ? extends SequenceType> getSequenceTypes() {
        Map<String, SequenceType> dataTypeMap = new ConcurrentHashMap<>();
        dataTypeMap.put("rna", SequenceType.NUCLEOTIDE);
        dataTypeMap.put("dna", SequenceType.NUCLEOTIDE);
        ...
        return dataTypeMap;
    }
}
{% endhighlight %}


In the next sub-project LPhyStudio, as it is not a LPhy extension, 
the [module lphystudio](https://github.com/LinguaPhylo/linguaPhylo/blob/master/LPhyStudio/src/module-info.java)
only has an one-line declaration to require the module lphy, but no Provider class. 


## Launching LPhy studio

As a developer, you can launch LPhy studio from an IDE (e.g. IntelliJ). 
First, you need to create two IntelliJ modules as below:

{% assign current_fig_num = 1 %}

<center>
<figure class="image">
  <img src="/images/LPhyModule.png" width="80%" alt="LPhy module">
  <figcaption>Figure {{ current_fig_num }}: LPhy module in IntelliJ.</figcaption>
</figure>  
</center>

This LPhy module has a "lib" folder to containing all 3rd part library jars that it depends on.
I recommand to create an IntelliJ [global library](https://www.jetbrains.com/help/idea/library.html) 
as below, so that it can be reused by different IntelliJ projects. 
If you want to control which jar should be in or not in your dependencies, 
you can alternatively add those jars one by one into the LPhy module. 
If you choose to do the latter, then you do not need to create the IntelliJ library from the "lib" folder. 

{% assign current_fig_num = current_fig_num | plus: 1 %}

<center>
<figure class="image">
  <img src="/images/LPhyLib.png" width="80%" alt="LPhy module lib">
  <figcaption>Figure {{ current_fig_num }}: LPhy module "lib" configuration in IntelliJ.</figcaption>
</figure>
</center>
  

{% assign current_fig_num = current_fig_num | plus: 1 %}

<center>
<figure class="image">
  <img src="/images/LPhyModuleSrc.png" alt="LPhy module Sources">
  <figcaption>Figure {{ current_fig_num }}: LPhy module "Sources" configuration in IntelliJ.</figcaption>
</figure>
</center>
  

{% assign current_fig_num = current_fig_num | plus: 1 %}

<center>
<figure class="image">
  <img src="/images/LPhyStudioModule.png" width="80%" alt="LPhyStudio module">
  <figcaption>Figure {{ current_fig_num }}: LPhyStudio module in IntelliJ.</figcaption>
</figure>
</center>
  

Here, the LPhyStudio module is depeneded on the LPhy module. 
After creating an IntelliJ application as below, you can run LPhy Studio or debug the code.

{% assign current_fig_num = current_fig_num | plus: 1 %}

<center>
<figure class="image">
  <img src="/images/LPhyStudioApp.png" width="80%" alt="LPhy Studio App">
  <figcaption>Figure {{ current_fig_num }}: LPhy studio app in IntelliJ.</figcaption>
</figure>
</center>
  

If you still prefer to see these two modules in one place in the IntelliJ project, 
you can create an empty IntelliJ module from the root folder of this repository.

{% assign current_fig_num = current_fig_num | plus: 1 %}

<center>
<figure class="image">
  <img src="/images/EmptyModule.png" width="80%" alt="EmptyModule">
  <figcaption>Figure {{ current_fig_num }}: Empty root module in IntelliJ.</figcaption>
</figure>
</center>
  

{% assign current_fig_num = current_fig_num | plus: 1 %}

<center>
<figure class="image">
  <img src="/images/EmptyModule2.png" alt="EmptyModule2">
  <figcaption>Figure {{ current_fig_num }}: Empty root module in IntelliJ.</figcaption>
</figure>
</center>
  


As an user, you can download the released version from the 
[LPhy release page](https://github.com/LinguaPhylo/linguaPhylo/releases).
The release will contain two modular jar files (lphy-studio-?.?.?.jar and lphy-?.?.?.jar) 
besides the required 3rd party libraries. 
The following command line can be used to launch the LPhy studio application:

```
java -p lib:lphy-studio-0.1.0.jar -m lphystudio
```

where `-p` declares the module path separated by `:`. 
Here it includes the jar file of LPhy Studio, 
and the "lib" folder under this jar file to contain all required libraries or LPhy extensions,
such as the LPhy modular jar. 
You can replace the "lib" folder path to your own library path, 
or add another modular jar not existing in the "lib" folder. 
`-m` declares the module name and it should be always "lphystudio".
If you are using any LPhy extensions, copy its modular jar into the "lib" folder 
and then restart LPhy Studio.


