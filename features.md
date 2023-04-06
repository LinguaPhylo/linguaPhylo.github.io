---
layout: page
title: Language Features
permalink: /features/
---

The [LPhy reference implementation manual](https://github.com/LinguaPhylo/linguaPhylo/blob/master/lphy/doc/index.md)
lists all generative distributions, functions, and data types in the latest release.


## Language features

LPhy scripts are text files with the file extension `.lphy`, and can be written using any text editor. 
The LPhy language uses EBNF grammar (Extended Backus–Naur form) with an ANTLR-based parser internally to parse the language into Java Objects. 

### Syntax

The syntax for each line has a variable declaration on the left-hand side, a specification operator (`=` or `~`), followed by the generator on the right-hand side. 

* The end of a line is denoted by a semicolon character `;`. 
* The left-hand side declares the name of a variable or an array of variables (case sensitive). 
* The right-hand side can be used to specify the generator of the random variable, or constant values. 
This can be a constant value, array of constant values, or a generator (e.g., deterministic functions, generative distributions, or several nested functions). 
* Parameters inside functions or generative distributions follow the convention `[argument name] = [value]`, for example, `b ~ Normal(mean = 0.0, sd = 1.0);`. 

### Specification operators

* An equal sign `=` is used for specifying deterministic or constant values to variables, such as `a = 2;`. 
* A tilde sign `~` is used for specifying generators for stochastic random variables, such as `b ~ Normal(mean = 0.0, sd = 1.0);`. 

Example of a constant
```
a = 2.0;
```

Example of a random variable
```
b ~ Normal(mean=0.0, sd=1.0);
```

### Generators

A list of generators can be found in the [LPhy reference implementation manual](https://github.com/LinguaPhylo/linguaPhylo/blob/master/lphy/doc/index.md).

### Variable vectorization
Any variable or generator can be vectorized to produce a vector of independent and identically distributed random variables. This can be done in two ways: by using the 'replicates' keyword, or by passing an array into the arguments of the generator. 

Example using the replicates keyword
```
pi ~ Dirichlet(conc=[2, 2, 2, 2], replicates=3);
```

Example using array vectorization
```
Q = hky(kappa=k, freq=pi);
```

### Code blocks

Code blocks enclosed by curly braces `{ ... }` are used to differentiate between parts of the script describing the data -- the data block `data{ ... }`, and parts describing the model -- the model block `model { ... }`. 

* The data block is used to read in, store input data, and constants (e.g., number of taxa) used by the model. 
This allows one script to be easily reused on another dataset by modifying the name of the input data file in the data block. 
Alignment data can be read in from a NEXUS or FASTA file. 

* The model block is used to define the models and parameters in a Bayesian phylogenetic analysis. 
This purpose of this is to allow analyses to be more easily reproduced by other researchers. 

* Note that the `data` and `model` are **reserved keywords** and cannot be used for variable names.

An LPhy script needs to contain both a `data{ ... }` and a `model{ ... }` block. However, the data block can be left empty for some use cases (e.g., data simulation). 
When the data block is empty, data will be simulated from the model. 

## Reference implementation in Java

In the Java reference implementation, generators are matched by method signatures of their corresponding Java class. See the [LPhy reference implementation manual](https://github.com/LinguaPhylo/linguaPhylo/blob/master/lphy/doc/index.md) for a list of functions and generative distributions. 

The type of a variable is inferred from the return type of its generator and does not need to be declared. 
For arguments of functions or generative distributions, the types are defined in the [LPhy reference implementation manual](https://github.com/LinguaPhylo/linguaPhylo/blob/master/lphy/doc/index.md). 
Type checking and syntax checking is done during execution. 

Overloading of functions is supported (Java-style overloading). Optional arguments in functions are allowed, with or without default values. 

## LPhy Studio

### Code blocks in LPhyStudio

When using the LPhyStudio console, the `data` and `model` code block keywords can be omitted. 
The `data` and `model` tabs in the GUI are used to specify which code block we are in.
The code block keywords will be automatically added before executing scripts written in the console. 

### Greek letters

LPhy supports both standard alphanumeric characters, greek letters, and Unicode. 
We include additional support for greek characters in LPhyStudio. 
In the LPhyStudio console, greek letters can be specified using latex conventions. 
For example, typing `\alpha` will convert it to the Unicode character alpha after a space is typed. 
Alternatively, Unicode characters can be pasted into the console. 

### Coding conventions

* Stochastic random variables should be assigned using the tilde sign `~`.
* Constants or results from deterministic functions are assigned using the equal sign `=`.
* If the same variable name is used for data in the `data` block 
and a random variable in the `model` block, then the value in the data block will be used for inference (i.e., 'data clamping').


## Examples

### Tree generative distributions

More details on available tree generative distributions can be found here: 

* [Birth-death generative distributions](https://github.com/LinguaPhylo/linguaPhylo/blob/master/lphy/doc/lphy/evolution/birthdeath.md)
* [Coalescent generative distributions](https://github.com/LinguaPhylo/linguaPhylo/blob/master/lphy/doc/lphy/evolution/coalescent.md)

### Models of evolutionary rates and sequence evolution

Sequence generation from Continuous-time Markov Chains, substitution models, site rates, and branch rates are described below:

* [PhyloCTMC generative distribution](https://github.com/LinguaPhylo/linguaPhylo/blob/master/lphy/doc/lphy/evolution/likelihood.md)
