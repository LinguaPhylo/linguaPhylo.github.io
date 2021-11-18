---
layout: page
title: About
permalink: /about/
---

## Writing scripts

You can either to write LPhy scripts in LPhyStudio, which is a Java GUI,
or complete them using a text editor and save them into a file with the `.lphy` extension.   

### With or without keywords

If you are working in LPhyStudio, you do not need to add `data` and `model` keywords 
and curly brackets to define the code blocks.
We are supposed to add the lines without the `data {  }` and `model {  }` to the the command line console 
at the bottom of the window, where the `data` and `model` tabs in the GUI are used to specify 
which block we are working on.

But if you are writing scripts into a file, then these two keywords are necessary.
You may see some example files containing no `data` block. 
Because they are simulations, the data is simulated from the model.


### Greek letters

In the LPhyStudio command line console, greek letters can be inputted by using latex style (e.g. typing `\alpha`), 
and then it will get converted to the Unicode after the following space is typed.
Copy-and-paste also does the tricks.


## LPhy specification

### Code blocks

The LPhy scripts contains `data { ... }` and `model { ... }` blocks enclosed by the curly brackets.

The LPhy data block is used to input and store the data, 
which will be processed by the models defined later, 
and which also allows you to reuse the another dataset 
by simply replacing the current data. 

In the data block, for instances, we normally include the constants for models, 
the alignment loaded from a NEXUS file, 
and the meta data regarding to the information of taxa that we have known.

The model block is used to define and also describe your models and parameters
in the Bayesian phylogenetic analysis.
Therefore, your result could be easily reproduced by other researchers. 

Please be aware that `data` and `model` have been reserved and cannot be used as the variable name.


### Code conventions

- The variables that are estimated in the model are called random variables in LPhy. 
They should be assigned by `~`.
- Constants or values resulting from deterministic functions are assigned using the equal sign `=`.
- If the same variable name is used for data in the `data` block 
also appears for a random variable in the `model` block, then the value in the data block will be used for inference (called 'data clamping').


### Tree generative distributions

More details on the available tree generative distributions can be found here: 

* [Birth-death generative distributions](https://github.com/LinguaPhylo/linguaPhylo/blob/master/lphy/doc/lphy/evolution/birthdeath.md)
* [Coalescent generative distributions](https://github.com/LinguaPhylo/linguaPhylo/blob/master/lphy/doc/lphy/evolution/coalescent.md)

### Models of evolutionary rates and sequence evolution

You can read more details about the PhyloCTMC generative distribution and how to specify substitution models, 
site rates and branch rates here:

* [PhyloCTMC generative distribution](https://github.com/LinguaPhylo/linguaPhylo/blob/master/lphy/doc/lphy/evolution/likelihood.md)
