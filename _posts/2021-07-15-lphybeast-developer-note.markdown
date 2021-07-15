---
layout: post
title:  "LPhyBEAST Developer Note"
author: Walter Xie
date:   2021-07-15
categories: programming
---

LPhyBEAST is a project that takes an [LPhy](https://linguaphylo.github.io) model specification, 
and some data and produces a [BEAST 2](https://www.beast2.org) XML input file. 
It is separately distributed as a BEAST 2 package,
and the source code is available at [https://github.com/LinguaPhylo/LPhyBeast](https://github.com/LinguaPhylo/LPhyBeast).

Most of LPhy `Value` and `Generator` can directly map to BEAST 2 objects, 
so that the Java code to create their corresponding BEAST 2 objects will be implemented into a concrete class, 
that implements the respective interface from either `ValueToBEAST<T, S extends BEASTInterface>` 
or `GeneratorToBEAST<T extends Generator, S extends BEASTInterface>`.

The type `T` in `ValueToBEAST` is a (LPhy) data type wrapped by `Value<T>`, 
but in `GeneratorToBEAST` it is a `Generator` (mostly `GenerativeDistribution`) that generates `Value`.
The type `S` will be the BEAST 2 object to be created eventually in both cases.


{% highlight java %}
package lphybeast;

import beast.core.BEASTInterface;
import lphy.graphicalModel.Value;

public interface ValueToBEAST<T, S extends BEASTInterface> {

    /**
     * @param value the value to be converted
     * @param context all beast objects already converted by the value-inorder generator-postorder traversal.
     * @return
     */
    S valueToBEAST(Value<T> value, BEASTContext context);

    /**
     * The type of value that can be consumed but this ValueToBEAST.
     * @return a class representing the type of value that can be consumed.
     */
    @Deprecated
    Class getValueClass();

    /**
     * @param value a value to be tested for consumption by this ValueToBEAST
     * @return true if this value can be converted by this ValueToBEAST class, false otherwise.
     */
    default boolean match(Value value) {
        return getValueClass().isAssignableFrom(value.value().getClass());
    }

    /**
     * @param rawValue a raw value to be tested for consumption by this ValueToBEAST
     * @return true if this value can be converted by this ValueToBEAST class, false otherwise.
     */
    default boolean match(Object rawValue) {
        return getValueClass().isAssignableFrom(rawValue.getClass());
    }

    /**
     * The BEAST class to be converted. It is only used for summarising at the moment.
     *
     * @return
     */
    default Class<S> getBEASTClass() {
        return (Class<S>)BEASTInterface.class;
    }
}
{% endhighlight %}


{% highlight java %}
package lphybeast;

import beast.core.BEASTInterface;
import lphy.graphicalModel.Generator;

import javax.naming.OperationNotSupportedException;
import java.util.List;

public interface GeneratorToBEAST<T extends Generator, S extends BEASTInterface> {

    /**
     * converts a generator to an equivalent BEAST object
     * @param generator the generator to be converted
     * @param value the already-converted value that this generator produced for the conversion
     * @param context the BEASTContext object holding other Beast objects already converted
     * @return a new BEAST object representing this generator
     */
    S generatorToBEAST(T generator, BEASTInterface value, BEASTContext context);

    /**
     * converts a generator to an equivalent BEAST object
     * @param generator the generator to be converted
     * @param value the list of already-converted values that this generator produced for the conversion
     * @param context the BEASTContext object holding other Beast objects already converted
     * @return a new BEAST object representing this generator
     */
    default S generatorToBEAST(T generator, List<BEASTInterface> value, BEASTContext context) {

        if (value.size() > 1) throw new IllegalArgumentException("A multi value version of this generator is not supported!");

        return generatorToBEAST(generator,value.get(0), context);
    }

    /**
     * provides a hook to allow generators that need to, to modify/replace the values that represent their
     * inputs or outputs. This is called after all the automatic beast value creation, but before
     * generatorToBEAST is called on any of the generators.
     * @param generator the generator
     * @param value the already-converted value that this generator produced for the conversion
     * @param context the BEASTContext object holding other Beast objects already converted
     */
    default void modifyBEASTValues(T generator, BEASTInterface value, BEASTContext context) {
        // default do nothing
    }

    /**
     * The class of value that can be converted to BEAST.
     * @return
     */
    Class<T> getGeneratorClass();

    /**
     * The BEAST class to be converted. It is only used for summarising at the moment.
     *
     * @return
     */
    default Class<S> getBEASTClass() {
        return (Class<S>)BEASTInterface.class;
    }

}
{% endhighlight %}

However, sometimes there is no directly mapping between LPhy and BEAST 2 objects. 
In this circumstance, we have to either create some intermediate BEAST 2 objects 
in order to generate the correct BEAST 2 XML, 
or remove some "unnecessary" BEAST 2 objects created by the above "auto-mapping" mechanism
to generate a particular XML section.

In addition, there are two validations to check if any LPhy `Value` and `Generator` 
parsed from scripts have their `ValueToBEAST` or `GeneratorToBEAST` being implemented. 
So, the utility class `lphybeast.Exclusion` is used to exclude those LPhy `Value` and `Generator` 
that do not need to map to BEAST 2 objects, 
which avoids throwing _UnsupportedOperationException_ from the validation.

