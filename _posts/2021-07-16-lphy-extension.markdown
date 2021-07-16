---
layout: post
title:  "LPhy Extension Mechanism"
author: Walter Xie
date:   2021-07-16
categories: programming
---

The LPhy extension mechanism uses the Service Provider Interface (SPI) with the Java Platform Module System (JPMS).
But in this mechanism, every _Service Provider_ class that implements _SPI_ requires a zero argument constructor.
To avoid this complexity to create such a constructor for every extensible service, 
we invented a _Container_ class (in each Java module) used as the _Provider_ class, 
which lists all extended Java classes from Lphy.

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

The [module lphy](https://github.com/LinguaPhylo/linguaPhylo/blob/master/LPhy/src/module-info.java)
declares the package dependencies and SPI 
[LPhyExtension](https://github.com/LinguaPhylo/linguaPhylo/blob/master/LPhy/src/lphy/spi/LPhyExtImpl.java)
using the following code. 

{% highlight java %}
exports lphy.spi;
uses lphy.spi.LPhyExtension;
{% endhighlight %}

Becaseu we consider the core itself as an extension, so the Container Provider class 
[LPhyExtImpl](https://github.com/LinguaPhylo/linguaPhylo/blob/master/LPhy/src/lphy/spi/LPhyExtension.java)
is also declared in this module.

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
     * @return the list of new {@link GenerativeDistribution} implemented in the LPhy extension.
     */
    List<Class<? extends GenerativeDistribution>> getDistributions();

    /**
     * @return the list of new {@link Func} implemented in the LPhy extension.
     */
    List<Class<? extends Func>> getFunctions();

    /**
     * @return the map of new {@link SequenceType} implemented in the LPhy extension.
     *         The string key is a keyword to represent this SequenceType.
     *         The keyword can be used to identify and initialise the corresponding sequence type.
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
            Normal.class, LogNormal.class, Exp.class, Bernoulli.class, Poisson.class, 
            ... );

    List<Class<? extends Func>> functions = Arrays.asList(ARange.class, ArgI.class,
            // Substitution models
            JukesCantor.class, K80.class, F81.class, HKY.class, GTR.class, WAG.class, 
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


After downloading the modular jar files (lphy-studio-?.?.?.jar and lphy-?.?.?.jar) from the LPhy release, 
the following command line can be used to launch LPhy Studio.

```
java -p lib:lphy-studio-0.1.0.jar -m lphystudio
```

where `-p` declares the module path separated by `:`. 
Here it includes the jar file of LPhy Studio, 
and the "lib" folder under this jar file to contain all required libraries or LPhy extensions,
such as the LPhy modular jar. 
You can replace your "lib" folder to a different path. 
`-m` declares the module name and it should be always "lphystudio".
If you are using any LPhy extensions, copy its modular jar into the "lib" folder and then launch LPhy Studio.


