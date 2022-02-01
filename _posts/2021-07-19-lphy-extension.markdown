---
layout: post
title:  "LPhy Extension Mechanism"
author: Walter Xie
date:   2021-07-19
categories: programming
---

LPhy extensions are implemented by using the Service Provider Interface (SPI) 
within the Java Platform Module System (JPMS).
An LPhy extension module implements the [LPhyExtension](https://github.com/LinguaPhylo/linguaPhylo/tree/1.0.1/LPhy/src/lphy/spi/LPhyExtension.java) 
interface to provide a list of the classes that the extension module provides to extend the functionality of LPhy.


## Project structure

The [LPhy repository](https://github.com/LinguaPhylo/linguaPhylo) contains two modules 
separated in two subfolder LPhy (containing core classes, such as parser, distributions, functions and data types) 
and LPhyStudio (GUI). The project folder structure looks like:

```
linguaPhylo
    ├── build.gradle.kts
    ├── examples
    ├── lphy
    │    ├── build.gradle.kts
    │    ├── doc
    │    └── src
    │         ├── main
    │         │    ├── java
    │         │    │      ├── lphy
    │         │    │      └── module-info.java
    │         │    └── resources
    │         └── test
    │    
    ├──lphy-studio
    │    ├── build.gradle.kts
    │    └── src
    │         ├── main
    │         │    ├── java
    │         │    │      ├── lphystudio
    │         │    │      └── module-info.java
    │         │    └── resources
    │         └── test
    ├──settings.gradle.kts
    └──tutorials
```

## SPI and the extension's container provider class

The [module lphy](https://github.com/LinguaPhylo/linguaPhylo/blob/master/lphy/src/main/java/module-info.java)
declares the package dependencies and SPI `LPhyExtension` using the following code. 
Because we consider the core itself as an extension, the Container Provider class `LPhyExtImpl`
is also required to declare in this module using the following one-line code.

{% highlight java %}
exports lphy.spi;
uses lphy.spi.LPhyExtension;

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

Then the Container Provider class `LPhyExtImpl` lists all classes required to be extended:
_GenerativeDistribution_, _Func_, and _SequenceType_.

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

These two classes can be seen from the package [lphy.spi](https://github.com/LinguaPhylo/linguaPhylo/blob/master/lphy/src/main/java/lphy/spi/).


In the next sub-project `lphy-studio`, even though it is not going to extend anything from `lphy`, 
we still create an empty class LPhyStudioImpl as a flag to make it recognised by the extension mechanism. 


## Setting up

The project is migrated to a Gradle project from version 1.1.0.
How to set up the project is available in the [developer note](https://github.com/LinguaPhylo/linguaPhylo/blob/master/DEV_NOTE.md).

