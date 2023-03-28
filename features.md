---
layout: page
title: Language Features
permalink: /features/
---

The [LPhy language reference manual](https://github.com/LinguaPhylo/linguaPhylo/blob/master/lphy/doc/index.md)
lists all generative distributions, functions, and data types in the latest release.


## LPhy specification

### Language features
LPhy scripts are text files with the file extension `.lphy`, which can be written or viewed using any text editor. 
The LPhy language uses EBNF grammar (Extended Backus–Naur form) with an ANTLR based parser to parse the language into Java Objects. 
It has typed variables, arrays of variables (vectorization similar to R), generative distributions, and functions that can return variables or arrays. 
Functions can be deterministic or stochastic. 
Both standard variable types (e.g., double, integer, boolean, string) and custom types (alignments, sequences, discrete traits) are supported.

The syntax `LHS = RHS;` follows a variable declaration on the left-hand side, an assignment symbol (`=` or `~`), followed by the assignee on the right-hand side. 
The end of a line is denoted by a semicolon character `;`. 
The right-hand side can be a constant value, deterministic function, stochastic generative distribution, or several nested functions. 

An equal sign `=` is used for assigning deterministic or constant values to variables, such as `a = 2;`. 

A tilde sign `~` is used for assigning stochastic random variables, such as `b ~ Normal(mean = 0.0, sd = 1.0);`. 

As a scripting language, the syntax is checked during execution. 

The language is strongly typed, but explicit type declarations are not required within the LPhy script. 
The type of a variable is inferred from the return type of its assigned function. 
For arguments of functions, the types are defined in the [LPhy language reference manual](https://github.com/LinguaPhylo/linguaPhylo/blob/master/lphy/doc/index.md).
Type-checking of variables and arguments is done during execution. 

Overloading of functions is supported (Java-style overloading). Optional arguments in functions are allowed, with or without default values. 
Code blocks surrounded by curly braces `{ ... }` are used to differentiate between parts of the script describing the data -- the data block `data{ ... }`, and parts describing the model -- the model block `model { ... }`.


### Code blocks

The data block `data { ... }` and model block `model { ... }` are enclosed by curly brackets.

* The data block is used to read in and store input data, which are used by the model. 
This allows the script to be easily reused on another dataset by modifying the data block. 
In the data block, we can read in alignment data from a NEXUS file, include constant values, and store metadata about the taxa. 

* The model block is used to define the models and parameters in a Bayesian phylogenetic analysis.
This should allow your analyses to be more easily reproduced by other researchers. 

Be aware that `data` and `model` are **reserved keywords** and cannot be used for variable names.

An LPhy script needs to contain both a `data{ ... }` and a `model{ ... }` block. 
When the data block is empty, the data will be simulated from the model. 

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
