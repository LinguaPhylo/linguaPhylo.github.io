---
layout: page
title: Model Validation
author: 'Walter Xie, Fábio K. Mendes, and Alexei Drummond'
permalink: /tutorials/model-validation/
---

It is very important that LPhy and LPhyBEAST developers should
use the well-calibrated study to validate their new methods and models 
before publishing them. 
The study will verify whether the developed method or model satisfy 
its proposed functionality or accuracy.

If you are not familiar with this process, we recommend you read the 
[BEAST 2 developer guide](https://github.com/rbouckaert/DeveloperManual)
before starting this tutorial.


## Goals

From this tutorial, you suppose to learn how to use LPhy and LPhyBEAST 
to validate a model following these steps:

- write a simple LPhy script to simulation alignments;
- run simulations using LPhyStudio;
- create BEAST 2 XML using the simulated data and specified models;
- batch processing BEAST runs.

A separated guide for a 
[5-Step pipeline](https://github.com/walterxie/TraceR/blob/master/examples/Pipeline.md) 
in a R package will help you to summarise BEAST logs and visualise the result
from the model validation. 

Alternatively, this tutorial can be used for other purposes of running simulations,  
such as learning the scales or dynamics of a specified phylogenetic model.


## Creating a LPhy script

First, we need to create a LPhy script to configure our simulations.
We have provided the following
[script](https://github.com/LinguaPhylo/linguaPhylo/blob/master/tutorials/RSV2sim.lphy) 
for this tutorial:

{% include_relative model-validation/lphy.md %}

This script defines a simple 3-partition model to simulate 3 alignments 
using HKY with estimated frequencies and Coalescent at the constant population size.
The strict molecular clock is applied. 
It is modified from the script in the [time-stamped data](time-stamped-data) tutorial.
So more details about the model and priors are explained in that tutorial.

This simple model is very popular when analysing the coding genes. 
Each of 3 partitions can be referred to the sites at each codon position.

In the `data {...}` section, we are loading `RSV2.nex` to extract taxa names 
and associated dates. Such information is retained in the variable `taxa`.
In addition, the number of partitions `n` and the vector of number of sites 
in each partition `L` are also extracted from the real data.

Furthermore, In the `model {...}` section, 
the last LPhy command `sim ~ PhyloCTMC(...)` explicitly instructs 
not to clamp the real data `codon`, but to export the vector of simulated  
alignments named as `sim`.

Please note here we want to simulate data from the exactly same model as used the 
[time-stamped data](time-stamped-data) tutorial, including dates and taxa names.
It will be easy to extract these meta-data from the real data in `RSV2.nex`,
but the real data is not required in the simulations.
Please do not be confused with the requirements between simulations and real data analyses. 
You can look at another simple simulation using [HKY+Coalescent](https://github.com/LinguaPhylo/linguaPhylo/blob/master/examples/hkyCoalescent.lphy).
More examples are available in the LPhy repository "examples" folder.


## LPhy Studio

You can download 
[RSV2sim.lphy](https://github.com/LinguaPhylo/linguaPhylo/blob/master/tutorials/RSV2sim.lphy)
and load it into LPhy studio.

Change the number in the text field "reps:" from 1 to 10, 
then click the button "Sample". 
After switching the tab to "Variable Log", you can see the "true" values 
of these 10 simulations. Switching the tab to "Variable Log", 
you can see the "true" trees of these 10 simulations.
They can be saved into files by clicking the `File` menu and 
`Save (Tree) VariableLog to File ...` 

<figure class="image">
  <a href="studio.png" target="_blank">
    <img src="studio.png" alt="studio.png">
  </a>
  <figcaption>Figure 1: simulations using LPhy studio</figcaption>
</figure>


## Setup simulations

The GUI LPhy studio is not convenient for batch processing. 
We recommend to use LPhyBEAST to run the following command in the terminal, 
which will true values and true trees from the simulations, 
and also BEAST 2 XMLs for Bayesian inference.

```
$LPhyBEAST$ -r 110 -l 50000000
            -o $USER_HOME$/WorkSpace/linguaPhylo/manuscript/xmls/al2.xml
            $USER_HOME$/WorkSpace/linguaPhylo/tutorials/RSV2sim.lphy
```

where `$USER_HOME$` is your home directory assigned to the 
[path variable of IntelliJ](https://www.jetbrains.com/help/idea/absolute-path-variables.html)

BEAST XMLs and true values from 110 simulations will be created in the folder 
"~/WorkSpace/.../xmls/".


## BEAST logs

Run XMLs using BEAST 2, and put all BEAST logs and trees in the same folder 
for the pipeline. 
All required logs (we do not BEAST tree logs) are available from 
[LPhy website](https://github.com/LinguaPhylo/linguaPhylo.github.io/tree/master/covgtest).
The full version of backups is also available in the Dropbox.

## R pipeline

The results are summarised by
[5-Step Pipeline](https://github.com/walterxie/TraceR/blob/master/examples/Pipeline.md),
which will produce intermediate `*.tsv` files containing the statistic summaries 
in each step.
The R script [PlotValidations.R](PlotValidations.R) is the code to plot figures.

## Summary and Figure

The final summary `*.tsv` for each parameters and true values are in the same folder,
but figures are in the sub-folder `figs`.


