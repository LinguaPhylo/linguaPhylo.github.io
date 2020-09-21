---
layout: post
title:  "LinguaPhylo for developers"
date:   2020-09-22
categories: programming
---

The reference implementation of the LinguaPhylo language is implemented in the Java programming language.

The source code for the reference implementation is available for download at [https://github.com/LinguaPhylo/linguaPhylo](https://github.com/LinguaPhylo/linguaPhylo).

The central concepts are `Value<T>` and `Generator<T>`. 
`Value<T>` is a concrete class that is a container for a value of type `T`. `Generator<T>` is an interface
for implementations that can generate a `Value<T>`. Both are united by implementing the `GraphicalModelNode<T>` interface:

{% highlight java %}
package lphy.graphicalModel;

import java.util.List;

public interface GraphicalModelNode<T> {

    /**
     * inputs are the arguments of a function or distribution or the function/distribution that produced this model node value/variable.
     * @return
     */
    List<GraphicalModelNode> getInputs();

    /**
     * @return a unique string representing this graphical model node. For named variables it should be the name. 
     */
    String getUniqueId();

    /**
     * @return current value of the Constant, DeterministicFunction (or GenerativeDistribution?)
     */
    T value();
}
{% endhighlight %}
