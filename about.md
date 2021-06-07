---
layout: page
title: About
permalink: /about/
---

## LPhy specification

### Code blocks

The LPhy scripts contains `data` and `model` blocks.

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

### Code convetions

- The variables that are estimated in the model are called random variables in LPhy. 
They should be assigned by `~`.
- The other variables are used to store values should be assigned by common sign `=`.
- If the same variable (name) storing alignment in the `model` block 
also appears in the `data` block, the simulated alignment will be replaced by 
the (e.g. imported) alignment, which is known as "data clamping".



### Tree generative distributions

More details on the available tree generative distributions can be found here: 

* [Birth-death generative distributions](https://github.com/LinguaPhylo/linguaPhylo/blob/master/doc/lphy/evolution/birthdeath.md)
* [Coalescent generative distributions](https://github.com/LinguaPhylo/linguaPhylo/blob/master/doc/lphy/evolution/coalescent.md)

### Models of evolutionary rates and sequence evolution

You can read more details about the PhyloCTMC generative distribution and how to specify substitution models, 
site rates and branch rates here:

* [PhyloCTMC generative distribution](https://github.com/LinguaPhylo/linguaPhylo/blob/master/doc/lphy/evolution/likelihood.md)
