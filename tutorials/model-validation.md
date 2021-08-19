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
which will log true values and true trees from the simulations, 
and also create BEAST 2 XMLs for Bayesian inference.

```
$LPhyBEAST -r 110 -l 50000000
           -o ~/WorkSpace/linguaPhylo/manuscript/xmls/al2.xml
           ~/WorkSpace/linguaPhylo/tutorials/RSV2sim.lphy
```

where `$LPhyBEAST` is the command to start your LPhyBEAST. 
The rests are the arguments to indicate creating 
BEAST XMLs (including extra logs containing "true" values and "true" trees) 
from 110 simulations with a file steam "al2",
and saving to the folder "~/WorkSpace/.../xmls/".

The benefit of using `-r` is that LPhyBEAST will create the XMLs 
whose log file names are distinct to one another.
They are concatenated by the same file steam and index numbers 
which are separated by an underscore.

For example, in the generated `al2_0.xml`, the log file name is `al2_0.log`
and tree log file name is `al2_0.trees`. 
So you do not need to worry about the overwriting problem, when you run all XMLs
in the same folder.

More usage details are available [here](https://linguaphylo.github.io/setup/).

## BEAST runs

The following Linux commands will run all XMLs in the same folder,
where `$BEAST2` is the folder containing BEAST 2. 

```
for xml in *.xml; do
    echo "run $xml"
    $BEAST2/bin/beast -beagle_SSE $xml
done
```

It will take a while if not using a HPC (High Performance Computing) cluster. 
But you can download all required logs (we do not need BEAST tree logs) from 
[LPhy website](https://github.com/LinguaPhylo/linguaPhylo.github.io/tree/master/covgtest).

The Linux command below will uncompress all `tar.gz` files:

```
ls *.gz |xargs -n1 tar -xzf
```


## Coverage

The results can be summarised by
[5-Step Pipeline](https://github.com/walterxie/TraceR/blob/master/examples/Pipeline.md),
which will produce intermediate `*.tsv` files containing the statistic summaries 
in each step.

It can create the figure to report coverage, for example, the coverage of 
mutation rate parameter "mu" looks like:

<figure class="image">
  <a href="mu.png" target="_blank">
    <img src="mu.png" alt="mu.png">
  </a>
  <figcaption>Figure 2: the coverage of mu</figcaption>
</figure>

The x-axis represents the "true" value of "mu", which has been created by 
LPhy during the simulation. The y-axis represents the posterior of "mu"
sampled by BEAST 2. There are 100 dots and bars in this graph. 
Each bar is the 95% HPD interval of the posterior samples of "mu" in one simulation, 
and the dot inside the bar is the mean. 

If the "true" value falls into the 95% HPD interval, the result will be valid,
and then the bar will be coloured as blue.
Otherwise, the validation will fail, and the bar is red.
There are 93 simulations having the "true" value falling into the 95% HPD interval
for "mu", so the coverage will be 93%.

Sometimes, the log-scale is required, such as "theta":

<figure class="image">
  <a href="theta-lg10.png" target="_blank">
    <img src="theta-lg10.png" alt="theta-lg10.png">
  </a>
  <figcaption>Figure 3: the coverage of theta</figcaption>
</figure>

A good coverage for all parameters from model validation is the confirmation of 
a valid method or model.

If the coverage is low, before you make a conclusion that your method or model 
would have something wrong, you should check whether the posteriors are converged.
It is not solid evidence to prove the convergence, 
even though the ESSs of every parameters are greater than 200.


