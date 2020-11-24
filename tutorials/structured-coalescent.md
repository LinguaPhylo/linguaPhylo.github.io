---
layout: page
title: Structured coalescent
subtitle: MASCOT - parameter and state inference using the approximate structured coalescent
author: 'Walter Xie and Alexei Drummond'
permalink: /tutorials/structured-coalescent/
---

This tutorial is modified from Taming the BEAST [MASCOT Tutorial](https://taming-the-beast.org/tutorials/Mascot-Tutorial/).

# Background

Phylogeographic methods can help reveal the movement of genes between populations of organisms. 
This has been widely used to quantify pathogen movement between different host populations, 
the migration history of humans, and the geographic spread of languages or the gene flow between species 
using the location or state of samples alongside sequence data. 
Phylogenies therefore offer insights into migration processes not available from classic epidemiological or occurrence data alone.

The structured coalescent allows to coherently model the migration and coalescent process, 
but struggles with complex datasets due to the need to infer ancestral migration histories. 
Thus, approximations to the structured coalescent, which integrate over all ancestral migration histories, have been developed. 
This tutorial gives an introduction into how a MASCOT analysis in BEAST2 can be set-up. 
MASCOT is short for **M**arginal **A**pproximation of the **S**tructured **C****O**alescen**T** (Müller, Rasmussen, & Stadler, 2018) 
and implements a structured coalescent approximation (Müller, Rasmussen, & Stadler, 2017). 
This approximation doesn't require migration histories to be sampled using MCMC 
and therefore allows to analyse phylogenies with more than three or four states.

# Programs used in this Exercise

The following software will be used in this tutorial:

* LPhyBEAST - this software will construct an input file for BEAST
* BEAST - this package contains the BEAST program, BEAUti, DensiTree, TreeAnnotator and other utility programs. 
  This tutorial is written for BEAST v2.6.x, which has support for multiple partitions. 
  It is available for download from [http://www.beast2.org](http://www.beast2.org).
* BEAST outercore package - this package of BEAST 2 has core features, but not in the core.
  You can install and use it following the instruction of [managing BEAST 2 packages](http://www.beast2.org/managing-packages/).
* BEAST labs package - containing some generally useful stuff used by other packages.
* BEAST [feast](https://github.com/tgvaughan/feast) package - this is a small BEAST 2 package 
  which contains additions to the core functionality. 
* MASCOT package - Marginal approximation of the structured coalescent.
* Tracer - this program is used to explore the output of BEAST (and other Bayesian MCMC programs). 
  It graphically and quantitively summarises the distributions of continuous parameters and provides diagnostic information. 
  At the time of writing, the current version is v1.7. It is available for download from [http://beast.community/tracer](http://beast.community/tracer).
* FigTree - this is an application for displaying and printing molecular phylogenies, in particular those obtained using BEAST. 
  At the time of writing, the current version is v1.4.3. It is available for download from [http://beast.community/figtree](http://beast.community/figtree).

# Practical: Parameter and State inference using the approximate structured coalescent

In this tutorial we will estimate migration rates, effective population sizes and locations of internal nodes 
using the marginal approximation of the structured coalescent implemented in BEAST2, 
MASCOT (Müller, Rasmussen, & Stadler, 2018).

Instead of following the "traditional" BEAST pipeline, we will use LPhy to build the MASCOT model for the analysis,
and then use LPhyBEAST to create the XML from the LPhy scripts.

The aim is to:

- Learn how to infer structure from trees with sampling location
- Get to know how to choose the set-up of such an analysis
- Learn how to read the output of a MASCOT analysis

# The Data

The dataset [H3N2.nexus](http://github.com/nicfel/Mascot-Tutorial/raw/master/data/H3N2.nexus) 
consists of 24 Influenza A/H3N2 sequences (between 2000 and 2001) subsampled from the original dataset, 
which are sampled in Hong Kong, New York and in New Zealand. 
South-East Asia has been hypothesized to be a global source location of seasonal Influenza, 
while more temperate regions such as New Zealand are assumed to be global sinks (missing reference), 
meaning that Influenza strains are more likely to migrate from the tropic to the temperate regions then vice versa. 
We want to see if we can infer this source-sink dynamic from sequence data using the structured coalescent.


### Tip dates

Since the sequences were sampled through time, we have to specify the sampling dates. 
These are included in the sequence names split by `|`. 
To set the sampling dates, We will use the regular expression `".*\|.*\|(\d*\.\d+|\d+\.\d*)\|.*$"` 
to extract these decimal numbers and turn to ages. 

How to set the age direction in LPhy is available in the [Time-stamped data](/tutorials/time-stamped-data/#tip-dates) tutorial.

<figure class="image">
  <img src="ages.png" alt="ages">
  <figcaption>The ages of tips</figcaption>
</figure>


### Tip locations

The main contrast in the setup to previous analyses is that we include additional information about the sampling location of sequences. 
Sequences were taken from patients in Hong Kong, New York and New Zealand. 
We can specify these sampling locations by extracting them from taxa labels. 
Use `split` to split the taxa names by the separator `|`, and take the 4th group given `i=3` 
where `i` is the index of split elements and starts from 0. 
You can check the locations by clicking the graphical component `demes`. 


### Constructing the data block in LinguaPhylo

The LPhy data block is used to input and store the data, 
which will be processed by the models defined later. 
The data concepts here include the alignment loaded from a NEXUS file, 
and the meta data regarding to the information of taxa that we have known. 

Please make sure the tab above the command console is set to `data`, 
and type or copy and paste the following scripts into the console.

```
data {
  options = {ageDirection="forward", ageRegex=".*\|.*\|(\d*\.\d+|\d+\.\d*)\|.*$"};
  D = readNexus(file="examples/h3n2.nexus", options=options);
  taxa = D.taxa();
  L = nchar(D);
  demes = split(str=D.getTaxaNames(), regex="\|", i=3);
}
```

When you write your LPhy scripts, please be aware that `data` and `model` have been reserved 
and cannot be used as the variable name.


## Models

This block is to define and also describe your models and parameters used in the Bayesian phylogenetic analysis.
Therefore, your results could be reproduced by other researchers using the same model. 

In this analysis, we will use three HKY models with estimated frequencies. 
We allow for rate heterogeneity among sites by approximating the continuous rate distribution (for each site in the alignment) 
with a discretized gamma probability distribution (mean = 1), 
where the number of bins in the discretization `ncat = 4`.
The _shape_ parameter will be estimated in this analysis. 
More details can be seen in the [Bayesian Skyline Plots](/tutorials/skyline-plots/#constructing-the-model-block-in-LinguaPhylo) tutorial. 

Next, we are going to set the priors for MASCOT. 
First, consider the effective population size parameter. 
Since we have only a few samples per location, meaning little information about the different effective population sizes, 
we will need an informative prior. 
In this case we will use a log normal prior with parameters M=0 and S=1. 
(These are respectively the mean and variance of the corresponding normal distribution in log space.) 

For migration rates, a prior that prohibits too large values while not greatly distinguishing 
between very small and very very small values is generally a good choice. 
We will need an informative prior, such as log normal with `meanlog=-1` and `sdlog=1.5`. 
Then we expect the migration rates to be with 95% certainty between 0.0194 and 6.958 at the mean of 0.368.

A more in depth explanation of what backwards migration really are can be found in the
[Peter Beerli's blog post](http://popgen.sc.fsu.edu/Migrate/Blog/Entries/2013/3/22_forward-backward_migration_rates.html).
 
Finally, set the prior for the clock rate. We have a good idea about the clock rate of Influenza A/H3N2 Hemagglutinin. 
From previous work by other people, we know that the clock rate will be around 0.005 substitution per site per year. 
To include that prior knowledger, we can set the prior on the clock rate to a log normal distribution. 
If we set `meanlog=-5.298` and `sdlog=0.25`, then we expect the clock rate to be with 95% certainty between 0.00306 and 0.00816.


So, we define the priors for the following parameters:
1. three effective population sizes _Θ_;  
2. six migration rates backwards in time _m_;
3. the general clock rate _clockRate_;
4. the transition/transversion ratio _κ_;
5. the base frequencies _π_;
6. the shape of the discretized gamma distribution _shape_.

The benefit of using 3 relative substitution rates here instead of 3 clock rates is that we could use the DeltaExchangeOperator
to these relative rates in the MCMC sampling to help the converagence.

Please note the tree here is already the time tree, the age direction will have been processed in `data` block.


### Constructing the model block in LinguaPhylo

Please switch the tab to `model`, 
and type or copy and paste the following scripts into the console.

```
model {
  κ ~ LogNormal(meanlog=1.0, sdlog=1.25);
  π ~ Dirichlet(conc=[2.0,2.0,2.0,2.0]);

  shape ~ LogNormal(meanlog=0.0, sdlog=2.0);
  siteRates ~ DiscretizeGamma(shape=shape, ncat=4, reps=L);

  // 0.005 substitutions * site^{-1} * year^{-1} is closer to the truth
  clockRate ~ LogNormal(meanlog=-5.298, sdlog=0.25);

  // 3 population sizes
  Θ ~ LogNormal(meanlog=0.0, sdlog=1.0, n=3);
  // 6 migration rates backwards in time
  m ~ LogNormal(meanlog=-1.0, sdlog=1.5, n=6);
  M = migrationMatrix(theta=Θ, m=m);
  tree ~ StructuredCoalescent(M=M, taxa=taxa, demes=demes);
  rootAge = tree.rootAge();

  D ~ PhyloCTMC(siteRates=siteRates, Q=hky(kappa=κ, freq=π), mu=clockRate, tree=tree);
}
```

### LinguaPhylo

After the data and model are successfully loaded, you can view the probability graph for this analysis. 
You can also look at the value, including alignment or tree, by simply clicking the component in the graph.  

<figure class="image">
  <img src="LinguaPhyloStudio.png" alt="LinguaPhyloStudio">
  <figcaption>The Screenshot of LinguaPhylo Studio</figcaption>
</figure>

Tips: the example file `h3n2.lphy` is also available. Looking for the menu `File` and then `Examples`, 
you can find it and load the scripts after clicking. 


## Producing BEAST XML using LPhyBEAST

When we are happy with the analysis defined by this set of LPhy scripts, we save them into a file named `h3n2.lphy`.  
Then, we can use another software called `LPhyBEAST` to produce BEAST XML from these scripts, 
which is released as a Java jar file.
After you make sure both the data file `h3n2.nex` and the LPhy scripts `h3n2.lphy` are ready, 
preferred in the same folder, you can run the following command line in your terminal.

```
java -jar LPhyBEAST.jar -l 30000000 h3n2.lphy
```


## Running BEAST

Once the BEAST file (e.g. h3n2.xml) is generated, the next step is to run it in BEAST.
You also need to make sue all required BEAST 2 packages (e.g. `outercore`) have been installed in your local computer.

Now run BEAST and when it asks for an input file, provide your newly created XML file as input. 
BEAST will then run until it has finished reporting information to the screen. 
The actual results files are save to the disk in the same location as your input file. 
The output to the screen will look something like this:


```
                         BEAST v2.6.3, 2002-2020
             Bayesian Evolutionary Analysis Sampling Trees
                       Designed and developed by
 Remco Bouckaert, Alexei J. Drummond, Andrew Rambaut & Marc A. Suchard
                                    
                   Centre for Computational Evolution
                         University of Auckland
                       r.bouckaert@auckland.ac.nz
                        alexei@cs.auckland.ac.nz
                                    
                   Institute of Evolutionary Biology
                        University of Edinburgh
                           a.rambaut@ed.ac.uk
                                    
                    David Geffen School of Medicine
                 University of California, Los Angeles
                           msuchard@ucla.edu
                                    
                      Downloads, Help & Resources:
                           http://beast2.org/
                                    
  Source code distributed under the GNU Lesser General Public License:
                   http://github.com/CompEvol/beast2
                                    
                           BEAST developers:
   Alex Alekseyenko, Trevor Bedford, Erik Bloomquist, Joseph Heled, 
 Sebastian Hoehna, Denise Kuehnert, Philippe Lemey, Wai Lok Sibon Li, 
Gerton Lunter, Sidney Markowitz, Vladimir Minin, Michael Defoin Platel, 
          Oliver Pybus, Tim Vaughan, Chieh-Hsi Wu, Walter Xie
                                    
                               Thanks to:
          Roald Forsberg, Beth Shapiro and Korbinian Strimmer

File: h3n2.xml seed: 1606190366122 threads: 1
Loading package outercore v0.0.4
Loading package BEAST v2.6.3
Loading package feast v7.5.0
Loading package Mascot v2.1.2
Loading package BEASTLabs v1.9.5

    ...

    ...
        2850000     -1950.9120     -1905.8629       -45.0491         0.3245         0.2202         0.2238         0.2312         5.9605         0.0043         1.0620         2.3167         1.0318         1.8431         0.2604         0.4698         0.1620         6.3070         0.4156         0.8188 1m17s/Msamples
        3000000     -1959.6673     -1906.1070       -53.5603         0.3435         0.2285         0.2071         0.2207         6.9287         0.0035        10.4963         0.3925         0.0310        18.1239         3.6498         0.1204         0.2569         1.0837         1.5967         0.6890 1m17s/Msamples

Operator                                        Tuning    #accept    #reject      Pr(m)  Pr(acc|m)
ScaleOperator(Theta.scale)                     0.21521      26140      60659    0.02879    0.30116 
ScaleOperator(clockRate.scale)                 0.53748      10742      28974    0.01334    0.27047 
UpDownOperator(clockRateUptreeDownOperator)    0.83108      28133     341846    0.12343    0.07604 Try setting scaleFactor to about 0.912
ScaleOperator(kappa.scale)                     0.33142      12417      27857    0.01334    0.30831 
ScaleOperator(m.scale)                         0.17020      43165      97278    0.04677    0.30735 
DeltaExchangeOperator(pi.deltaExchange)        0.08084      17403      68939    0.02879    0.20156 
ScaleOperator(shape.scale)                     0.18007      12923      27018    0.01334    0.32355 
Exchange(tree.narrowExchange)                        -     165599     192867    0.11981    0.46197 
ScaleOperator(tree.rootAgeScale)               0.56866       7827      32270    0.01334    0.19520 
ScaleOperator(tree.scale)                      0.81570      23214     337243    0.11981    0.06440 Try setting scaleFactor to about 0.903
SubtreeSlide(tree.subtreeSlide)                1.02437      52633     306985    0.11981    0.14636 
Uniform(tree.uniform)                                -     221501     138054    0.11981    0.61604 
Exchange(tree.wideExchange)                          -       9084     350384    0.11981    0.02527 
WilsonBalding(tree.wilsonBalding)                    -      15733     343113    0.11981    0.04384 

     Tuning: The value of the operator's tuning parameter, or '-' if the operator can't be optimized.
    #accept: The total number of times a proposal by this operator has been accepted.
    #reject: The total number of times a proposal by this operator has been rejected.
      Pr(m): The probability this operator is chosen in a step of the MCMC (i.e. the normalized weight).
  Pr(acc|m): The acceptance probability (#accept as a fraction of the total proposals for this operator).


Total calculation time: 232.935 seconds
End likelihood: -1959.6673970489076
```

## Analysing the BEAST output

First, we can open the *.log file in tracer to check if the MCMC has converged. 
The ESS value should be above 200 for almost all values and especially for the posterior estimates.

<figure class="image">
  <img src="posterior.png" alt="Tracer">
  <figcaption>Check if the posterior converged.</figcaption>
</figure>


We can have a look at the marginal posterior distributions for the effective population sizes. 
New York is inferred to have the largest effective population size before Hong Kong and New Zealand. 
This tells us that two lineages that are in New Zealand are expected to coalesce quicker than two lineages in Hong Kong or New York.

<figure class="image">
  <img src="popsize.png" alt="The trace of long run">
  <figcaption>Compare the different inferred effective population sizes.</figcaption>
</figure>

In this example, we have relatively little information about the effective population sizes of each location. 
This can lead to estimates that are greatly informed by the prior. 
Additionally, there can be great differences between median and mean estimates. 
The median estimates are generally more reliable since they are less influence by extreme values.

<figure class="image">
  <img src="popsize2.png" alt="marginal density">
  <figcaption>Differences between mean and median estimates.</figcaption>
</figure>

We can then look at the inferred migration rates. 
The migration rates have the label b_migration.*, meaning that they are backwards in time migration rates. 
The highest rates are from New York to Hong Kong. Because they are backwards in time migration rates, 
this means that lineages from New York are inferred to be likely from Hong Kong if we're going backwards in time. 
In the inferred phylogenies, we should therefore make the observation that lineages ancestral to samples from New York 
are inferred to be from Hong Kong backwards.

<figure class="image">
  <img src="migrationRates.png" alt="relative substitution rates">
  <figcaption>Compare the inferred migration rates.</figcaption>
</figure>


## Make the MCC tree using TreeAnnotator

Use the program TreeAnnotator to summarise the tree. TreeAnnotator is an application that comes with BEAST.

<figure class="image">
  <img src="TreeAnnotator.png" alt="TreeAnnotator">
  <figcaption>TreeAnnotator for creating a summary tree from a posterior tree set.</figcaption>
</figure>


## Check the MCC tree using FigTree

In each logging step of the tree during the MCMC, MASCOT logs several different things. 
It logs the inferred probability of each node being in any possible location. 
In this example, these would be the inferred probabilities of being in Hong Kong, New York and New Zealand. 
Additonally, it logs the most likely location of each node.

After opening the MCC tree in FigTree, we can visualize several things. 
To color branches, you can go to `Appearance >> Colour` by and select `max`. 
This is the location that was inferred to be most often the most likely location of the node.

<figure class="image">
  <img src="tree.svg" alt="MCC tree">
  <figcaption>Inferred node locations.</figcaption>
</figure>

We can now determine if lineages ancestral to samples from New York are actually inferred to be from Hong Kong, 
or the probability of the root being in any of the locations.

To get the actual inferred probabilities of each node being in any of the 3 locations, 
you can go to `Node Labels >> Display` an then choose Hong_Kong, New_York or New_Zealand. 
These are the actual inferred probabilities of the nodes being in any location.

It should however be mentioned that the inference of nodes being in a particular location makes some simplifying assumptions, 
such as that there are no other locations (i.e. apart from the sampled locations) where lineages could have been.

Another important thing to know is that currently, we assume rates to be constant. 
This means that we assume that the population size of the different locations does not change over time. 
We also make the same assumption about the migration rates through time.


## Errors that can occur (Work in progress)
One of the errors message that can occur regularly is the following: `too many iterations, return negative infinity`. 
This occurs when the integration step size of the ODE's 
to compute the probability of observing a phylogenetic tree in MASCOT is becoming too small. 
This generally occurs if at least one migration rate is really large or at least one effective population size is really small 
(i.e. the coalescent rate is really high). 
This causes integration steps to be extremely small, 
which in turn would require a lot of time to compute the probability of a phylogenetic tree under MASCOT. 
Instead of doing that, this state is rejected by assigning its log probability the value negative infinity.

This error can have different origins and a likely incomplete list is the following: 1. The priors on migration rates put too much weight on really high rates. To fix this, reconsider your priors on the migration rates. Particularly, check if the prior on the migration rates make sense in comparison to the height of the tree. If, for example, the tree has a height of 1000 years, but the prior on the migration rate is exponential with mean 1, then the prior assumption is that between any two states, we expected approximately 1000 migration events. 2. The prior on the effective population sizes is too low, meaning that the prior on the coalescent rates (1 over the effective population size) is too high. This can for example occur when the prior on the effective population size was chosen to be 1/X. To fix, reconsider your prior on the effective population size. 3. There is substantial changes of the effective population sizes and/or migration rates over time that are not modeled. In that case, changes in the effective population sizes or migration rates have to be explained by population structure, which can again lead to some effective population sizes being very low and some migration rates being very high. In that case, there is unfortunately not much that can be done, since MASCOT is not an appropriate model for the dataset. 4. There is strong subpopulation structure within the different subpopulations used. In that case, reconsider if the individual sub-populations used are reasonable.


## Useful Links

If you interested in the derivations of the marginal approximation of the structured coalescent, 
you can find them here (Müller, Rasmussen, & Stadler, 2017). 
This paper also explains the mathematical differences to other methods such as the theory underlying BASTA. 
To get a better idea of how the states of internal nodes are calculated, have a look in this paper (Müller, Rasmussen, & Stadler, 2018).

* MASCOT source code: https://github.com/nicfel/Mascot
* LinguaPhylo: https://linguaphylo.github.io*
* BEAST 2 website and documentation: http://www.beast2.org/
* Join the BEAST user discussion: http://groups.google.com/group/beast-users

## Relevant References

* Müller, N. F., Rasmussen, D., & Stadler, T. (2018). MASCOT: Parameter and state inference under the marginal structured coalescent approximation. Bioinformatics, bty406. https://doi.org/10.1093/bioinformatics/bty406
* Müller, N. F., Rasmussen, D. A., & Stadler, T. (2017). The Structured Coalescent and its Approximations. Molecular Biology and Evolution, msx186.
* Drummond, A. J., & Bouckaert, R. R. (2014). Bayesian evolutionary analysis with BEAST 2. Cambridge University Press.
