---
layout: page
title: Language Features
permalink: /features/
---

The [LPhy reference implementation manual](/docs)
lists all generative distributions, functions, and data types in the latest release.

## LPhy language features

LPhy scripts are text files with the file extension `.lphy`, and can be written using any text editor. 
The LPhy language has an EBNF grammar (Extended Backus–Naur form). 
The reference implementation in Java uses an ANTLR-based parser internally to parse the LPhy language into Java Objects, 
where syntax checking is performed during execution.

### Syntax

The syntax for each line has a variable declaration on the left-hand side, a specification operator (`=` or `~`), followed by the generator on the right-hand side. 

* The end of a line is denoted by a semicolon character `;`. 
* The left-hand side declares the name of a variable or an array of variables (case sensitive). 
* The right-hand side can be used to specify the generator of the random variable, or constant values. 
This can be a constant value, array of constant values, or a generator (e.g., deterministic functions, generative distributions, or several nested functions). 
* Parameters inside functions or generative distributions follow the convention `[argument name] = [value]`.
* Control flow structures are not allowed
* No explicit definition of types
* Syntax checking is done during execution

### Specification operators

An equal sign `=` is used to specify deterministic or constant values for variables.

Example of a constant
```
a = 2.0;
```

A tilde sign `~` is used to specify generators for stochastic random variables. 

Example of a random variable
```
b ~ Normal(mean=0.0, sd=1.0);
```

### Arrays

Arrays can be defined using square brackets with elements delimited by comma separators. For sequences of consecutive integers, a colon ‘:’ is used to define a range.

Example of an array
```
c = [1, 2, 3, 4, 5]; 
```

Example of an array using range notation
```
d = 1:5;
```

### Code blocks

Code blocks enclosed by curly braces `{ ... }` are used to differentiate between parts of the script describing the data -- the data block `data{ ... }`, and parts describing the model -- the model block `model { ... }`. 

```
data {
    L = 200;
    taxa = taxa(names=1:10);
}
model {
    Θ ~ LogNormal(meanlog=3.0, sdlog=1.0);
    ψ ~ Coalescent(theta=Θ, taxa=taxa);
    D ~ PhyloCTMC(L=L, Q=jukesCantor(), tree=ψ);
}

```

* The data block is used to read in, store input data, and constants (e.g., number of sites) used by the model. 
This allows one script to be easily reused on another dataset by modifying the name of the input data file in the data block. 
Alignment data can be read in from a NEXUS or FASTA file. 

* The model block is used to define the models and parameters in a Bayesian phylogenetic analysis. 
This purpose of this is to allow analyses to be more easily reproduced by other researchers. 

* Generators can only be used inside the **model block**

* Note that the `data` and `model` are **reserved keywords** and cannot be used for variable names.

* If the same variable name is used for data in the `data` block 
and a random variable in the `model` block, then the value in the data block will be used for inference (i.e., 'data clamping').

An LPhy script needs to contain both a `data{ ... }` and a `model{ ... }` block. However, the data block can be left empty for some use cases (e.g., data simulation). When the data block is empty, data will be simulated from the model. 


### Generators

Generators include parametric distributions (e.g., normal, log-normal, uniform, dirichlet distributions), tree generative distributions (coalescent, birth-death models), and sequence generators (using Continuous-time Markov Chains, substitution models and clock models). 
Note that generators can only be used inside the model block.

Example of a parametric distribution
```
Θ ~ LogNormal(meanlog=3.0, sdlog=1.0);
```

Example of a tree generative distribution
```
Θ ~ LogNormal(meanlog=3.0, sdlog=1.0);
ψ ~ Coalescent(theta=Θ, taxa=taxa);
```

Example of a sequence generator (PhyloCTMC)
```
taxa = taxa(names=1:10);
Θ ~ LogNormal(meanlog=3.0, sdlog=1.0);
ψ ~ Coalescent(theta=Θ, taxa=taxa);
D ~ PhyloCTMC(L=200, Q=jukesCantor(), tree=ψ);
```

A full list of generators can be found in the [LPhy reference implementation manual](/docs).

### Variable vectorization

Control flow structures are not allowed in order to promote simplicity and readability, 
facilitating a lower barrier to entry and a gentler learning curve. 

Any variable or generator can be vectorized to produce a vector of independent and identically distributed random variables. 
This can be done in two ways: by using the "replicates" keyword, 
or by passing an array into the arguments of the generator. 

  1. Example using the replicates keyword

```
pi ~ Dirichlet(conc=[2, 2, 2, 2], replicates=3);
```

  2. Example allowing all arguments of the function `hky` to be vectorised, which results in more compact and expressive model specifications. 

```
k ~ LogNormal(meanlog=0.5, sdlog=1.0, replicates=3);
pi ~ Dirichlet(conc=[2.0, 2.0, 2.0, 2.0], replicates=3);
Q = hky(kappa=k, freq=pi);
```

## Reference implementation in Java

In the Java reference implementation, generators are matched by method signatures of their corresponding Java class. See the [LPhy reference implementation manual](/docs) for a list of functions and generative distributions. 

The type of a variable is inferred from the return type of its generator and does not need to be declared. 
For arguments of functions or generative distributions, the types are defined in the [LPhy reference implementation manual](/docs). 
Type checking and syntax checking is done during execution. 

Overloading of functions is supported (Java-style overloading). Optional arguments in functions are allowed, with or without default values. 


## LPhy Studio

Alongside the LPhy specification language, and reference implementation, we provide a Graphical User Interface for LPhy scripts called "LPhy Studio". 

### Code blocks in LPhyStudio

When using the LPhyStudio console, the `data` and `model` code block keywords can be omitted. 
The `data` and `model` tabs in the GUI are used to specify which code block we are in.
The code block keywords will be automatically added before executing scripts written in the console. 

### Greek letters

LPhy supports both standard alphanumeric characters, greek letters, and Unicode. 

LPhyStudio includes additional support for greek characters. In the LPhyStudio console, greek letters can be specified using latex conventions. 

For example, typing `\alpha` will convert it to the Unicode character alpha after a space is typed. 
Alternatively, Unicode characters can be pasted into the console. 

## More examples

### Tree generative distributions

More details on available tree generative distributions can be found here: 

* [Birth-death generative distributions](https://github.com/LinguaPhylo/linguaPhylo/blob/master/lphy/doc/lphy/evolution/birthdeath.md)
* [Coalescent generative distributions](https://github.com/LinguaPhylo/linguaPhylo/blob/master/lphy/doc/lphy/evolution/coalescent.md)

### Models of evolutionary rates and sequence evolution

Sequence generation from Continuous-time Markov Chains, substitution models, site rates, and branch rates are described below:

* [PhyloCTMC generative distribution](https://github.com/LinguaPhylo/linguaPhylo/blob/master/lphy/doc/lphy/evolution/likelihood.md)


