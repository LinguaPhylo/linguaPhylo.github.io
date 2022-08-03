---
layout: page
title: Structured coalescent
subtitle: MASCOT - parameter and state inference using the approximate structured coalescent
author: 'LinguaPhylo core team'
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
MASCOT is short for **M**arginal **A**pproximation of the **S**tructured **C****O**alescen**T** [Müller, Rasmussen, & Stadler, 2018](#references) 
and implements a structured coalescent approximation [Müller, Rasmussen, & Stadler, 2017](#references). 
This approximation doesn't require migration histories to be sampled using MCMC 
and therefore allows to analyse phylogenies with more than three or four states.


# Practical: Parameter and State inference using the approximate structured coalescent

In this tutorial we will estimate migration rates, effective population sizes and locations of internal nodes 
using the marginal approximation of the structured coalescent implemented in BEAST2, 
MASCOT [Müller, Rasmussen, & Stadler, 2018](#references).

Instead of following the "traditional" BEAST pipeline, we will use LPhy to build the MASCOT model for the analysis,
and then use LPhyBEAST to create the XML from the LPhy scripts.

The aim is to:

- Learn how to infer structure from trees with sampling location
- Get to know how to choose the set-up of such an analysis
- Learn how to read the output of a MASCOT analysis

The programs used in this tutorial are listed [below](#programs-used-in-this-tutorial).

## The NEXUS alignment

{% include_relative templates/download-data.md df='H3N2' 
                    df_link='http://github.com/nicfel/Mascot-Tutorial/raw/master/data/H3N2.nexus' %}

The dataset consists of 24 Influenza A/H3N2 sequences (between 2000 and 2001) subsampled from the original dataset, which are sampled in Hong Kong, New York and in New Zealand. 
South-East Asia has been hypothesized to be a global source location of seasonal Influenza, 
while more temperate regions such as New Zealand are assumed to be global sinks (missing reference), 
meaning that Influenza strains are more likely to migrate from the tropic to the temperate regions then vice versa. 
We want to see if we can infer this source-sink dynamic from sequence data using the structured coalescent.


## Constructing the scripts in LPhy Studio

{% include_relative templates/lphy-studio-intro.md %}

The LPhy scripts to define this analysis is listed below.

{% assign current_fig_num = 1 %}
{% assign lphy_fig = "Figure " | append: current_fig_num  %}

[//]: # (## Code, Graphical Model)
{% capture lphy_md %}
{% include_relative structured-coalescent/lphy.md fignum=lphy_fig %}
{% endcapture %}

{{ lphy_md | replace: "11pt", "10pt" }}


### Data block

{% include_relative templates/lphy-data.md %}

### Tip dates

Since the sequences were sampled through time, we have to specify the sampling dates. 
These are included in the sequence names split by `\|`. 
To set the sampling dates, We will use the regular expression `".*\|.*\|(\d*\.\d+|\d+\.\d*)\|.*$"` 
to extract these decimal numbers and turn to ages. 

How to set the age direction in LPhy is available in the [Time-stamped data](/tutorials/time-stamped-data/#tip-dates) tutorial.

{% assign current_fig_num = current_fig_num | plus: 1 %}

<figure class="image">
  <img src="ages.png" alt="ages">
  <figcaption>Figure {{ current_fig_num }}: The ages of tips</figcaption>
</figure>


### Tip locations

{% include_relative templates/discrete-traits.md  locations='Hong Kong, New York and New Zealand' 
                    using='`split` given the separator `|`, and taking the 4th element given `i=3`' 
                    traits='demes' %}
It is an array of locations required by the `StructuredCoalescent` in the `model` section later.


### Model block

{% include_relative templates/lphy-model.md %}

In this analysis, we will use three HKY models with estimated frequencies. 
{% include_relative templates/rate-heterogeneity.md shape='shape' %}
More details can be seen in the [Bayesian Skyline Plots](/tutorials/skyline-plots/#constructing-the-model-block-in-linguaphylo) tutorial. 

Next, we are going to set the priors for MASCOT. 
First, consider the effective population size parameter. 
Since we have only a few samples per location, meaning little information about the different effective population sizes, 
we will need an informative prior. 
In this case we will use a log normal prior with parameters M=0 and S=1. 
(These are respectively the mean and variance of the corresponding normal distribution in log space.) 

The existing exponential distribution as a prior on the migration rate puts much weight on lower values while not prohibiting larger ones. 
For migration rates, a prior that prohibits too large values while not greatly distinguishing 
between very small and very very small values is generally a good choice. 
Be aware however that the exponential distribution is quite an informative prior: 
one should be careful that to choose a mean so that feasible rates are at least within the 95% HPD interval of the prior. 
(This can be determined by using R script)

A more in depth explanation of what backwards migration really are can be found in the
[Peter Beerli's blog post](http://popgen.sc.fsu.edu/Migrate/Blog/Entries/2013/3/22_forward-backward_migration_rates.html).
 
Finally, set the prior for the clock rate. We have a good idea about the clock rate of Influenza A/H3N2 Hemagglutinin. 
From previous work by other people, we know that the clock rate will be around 0.005 substitution per site per year. 
To include that prior knowledger, we can set the prior on the clock rate to a log normal distribution. 
If we set `meanlog=-5.298` and `sdlog=0.25`, then we expect the clock rate to be with 95% certainty between 0.00306 and 0.00816.

Please note the dimension of effective population sizes should equal to 
the number of locations (assuming it is `x`),
then the dimension of migration rates backwards in time should equal to 
`x*(x-1)`.


## Producing BEAST XML using LPhyBEAST

{% include_relative templates/lphy-beast.md lphy="h3n2" %}

```
# BEAST_DIR="/Applications/BEAST2"
$BEAST_DIR/bin/lphybeast -l 30000000 h3n2.lphy
```


## Running BEAST

{% include_relative templates/run-beast.md xml="h3n2.xml" %}


```
                         BEAST v2.6.7, 2002-2020
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

File: h3n2.xml seed: 1630296535307 threads: 1

    ...

    ...
       28500000     -1953.9985     -1903.1770       -50.8214         0.3498         0.2198         0.1937         0.2365         5.4560         0.0046         0.5595         3.7798         0.4518         0.6711         2.5347         0.1795         2.1426         2.4587         3.7122         0.1873 1m13s/Msamples
       30000000     -1948.5394     -1906.5726       -41.9668         0.3486         0.2210         0.2017         0.2285         7.4471         0.0047         1.6167         0.4554         0.9991         1.1398         0.5408         1.4781         1.0904         0.5761         2.9541         0.2147 1m14s/Msamples

Operator                                    Tuning    #accept    #reject      Pr(m)  Pr(acc|m)
ScaleOperator(Theta.scale)                 0.19848     237417     626849    0.02879    0.27470 
ScaleOperator(gamma.scale)                 0.15667     111703     288282    0.01334    0.27927 
ScaleOperator(kappa.scale)                 0.29863     104221     295014    0.01334    0.26105 
ScaleOperator(m.scale)                     0.15125     372893    1027107    0.04677    0.26635 
ScaleOperator(mu.scale)                    0.52516     102708     297837    0.01334    0.25642 
UpDownOperator(muUppsiDownOperator)        0.87133     355238    3345290    0.12343    0.09600 Try setting scaleFactor to about 0.933
DeltaExchangeOperator(pi.deltaExchange)    0.07892     182142     681135    0.02879    0.21099 
Exchange(psi.narrowExchange)                     -    1647945    1947578    0.11981    0.45833 
ScaleOperator(psi.rootAgeScale)            0.57049      78998     321178    0.01334    0.19741 
ScaleOperator(psi.scale)                   0.85243     280423    3313199    0.11981    0.07803 Try setting scaleFactor to about 0.923
SubtreeSlide(psi.subtreeSlide)             1.01886     513876    3082581    0.11981    0.14288 
Uniform(psi.uniform)                             -    2218465    1377464    0.11981    0.61694 
Exchange(psi.wideExchange)                       -      91547    3505021    0.11981    0.02545 
WilsonBalding(psi.wilsonBalding)                 -     159258    3434632    0.11981    0.04431 

     Tuning: The value of the operator's tuning parameter, or '-' if the operator can't be optimized.
    #accept: The total number of times a proposal by this operator has been accepted.
    #reject: The total number of times a proposal by this operator has been rejected.
      Pr(m): The probability this operator is chosen in a step of the MCMC (i.e. the normalized weight).
  Pr(acc|m): The acceptance probability (#accept as a fraction of the total proposals for this operator).


Total calculation time: 2239.001 seconds
End likelihood: -1948.5394379603993
```

## Analysing the BEAST output

First, we can open the `h3n2.log` file in tracer to check if the MCMC has converged. 
The ESS value should be above 200 for almost all values and especially for the posterior estimates.

{% assign current_fig_num = current_fig_num | plus: 1 %}
<figure class="image">
  <img src="posterior.png" alt="Tracer">
  <figcaption>Figure {{ current_fig_num }}: Check if the posterior converged.</figcaption>
</figure>


We can have a look at the marginal posterior distributions for the effective population sizes. 
New York is inferred to have the largest effective population size before Hong Kong and New Zealand. 
This tells us that two lineages that are in New Zealand are expected to coalesce quicker than two lineages in Hong Kong or New York.

Tips: you can click the `Setup...` button to adjust the view range of X-axis.

{% assign current_fig_num = current_fig_num | plus: 1 %}
<figure class="image">
  <img src="popsize.png" alt="The trace of long run">
  <figcaption>Figure {{ current_fig_num }}: Compare the different inferred effective population sizes.</figcaption>
</figure>

In this example, we have relatively little information about the effective population sizes of each location. 
This can lead to estimates that are greatly informed by the prior. 
Additionally, there can be great differences between median and mean estimates. 
The median estimates are generally more reliable since they are less influence by extreme values.

{% assign current_fig_num = current_fig_num | plus: 1 %}
<figure class="image">
  <img src="popsize2.png" alt="marginal density">
  <figcaption>Figure {{ current_fig_num }}: Differences between mean and median estimates.</figcaption>
</figure>

We can then look at the inferred migration rates. 
The migration rates have the label `b_m.*`, meaning that they are backwards in time migration rates. 
The highest rates are from New York to Hong Kong. Because they are backwards in time migration rates, 
this means that lineages from New York are inferred to be likely from Hong Kong if we're going backwards in time. 
In the inferred phylogenies, we should therefore make the observation that lineages ancestral to samples from New York 
are inferred to be from Hong Kong backwards.

{% assign current_fig_num = current_fig_num | plus: 1 %}
<figure class="image">
  <img src="migrationRates.png" alt="relative substitution rates">
  <figcaption>Figure {{ current_fig_num }}: Compare the inferred migration rates.</figcaption>
</figure>


### Make the MCC tree using TreeAnnotator

{% assign current_fig_num = current_fig_num | plus: 1 %}
{% include_relative templates/tree-annotator.md fig="TreeAnnotator.png" 
                    fignum=current_fig_num trees="h3n2.mascot.trees" mcctree="h3n2.mascot.tree" %}


### Check the MCC tree using FigTree

In each logging step of the tree during the MCMC, MASCOT logs several different things. 
It logs the inferred probability of each node being in any possible location. 
In this example, these would be the inferred probabilities of being in Hong Kong, New York and New Zealand. 
Additonally, it logs the most likely location of each node.

After opening the MCC tree in FigTree, we can visualize several things. 
To color branches, you can go to `Appearance >> Colour` by and select `max`. 
This is the location that was inferred to be most often the most likely location of the node.
In addition, you can set the branch `Width by` `max.prob`, and increase the `Line Weight`, which will make the branch width more different regarding to its posterior support. Finally, tick `Legend` and select `max` in the drop list of `Attribute`. 

{% assign current_fig_num = current_fig_num | plus: 1 %}
<figure class="image">
  <a href="tree.png" target="_blank"><img src="tree.png" alt="MCC tree"></a>
  <figcaption>Figure {{ current_fig_num }}: Inferred node locations.</figcaption>
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

### Questions

```
1. How to decide the dimensions of effective population sizes 
   and migration rates respectively in an analysis? 

2. How to interpret the differences among the effective population sizes? 
   How to interpret the backwards migration rates? 

3. How to determine the inferred locations of ancestral lineages? 
   What assumptions are made on this result?
```

### Errors that can occur (Work in progress)

One of the errors message that can occur regularly is the following: `too many iterations, return negative infinity`. 
This occurs when the integration step size of the ODE's 
to compute the probability of observing a phylogenetic tree in MASCOT is becoming too small. 
This generally occurs if at least one migration rate is really large or at least one effective population size is really small 
(i.e. the coalescent rate is really high). 
This causes integration steps to be extremely small, 
which in turn would require a lot of time to compute the probability of a phylogenetic tree under MASCOT. 
Instead of doing that, this state is rejected by assigning its log probability the value negative infinity.

This error can have different origins and a likely incomplete list is the following: 
1. The priors on migration rates put too much weight on really high rates. To fix this, reconsider your priors on the migration rates. 
   Particularly, check if the prior on the migration rates make sense in comparison to the height of the tree. 
   If, for example, the tree has a height of 1000 years, but the prior on the migration rate is exponential with mean 1, 
   then the prior assumption is that between any two states, we expected approximately 1000 migration events. 
2. The prior on the effective population sizes is too low, meaning that the prior on the coalescent rates 
   (1 over the effective population size) is too high. 
   This can for example occur when the prior on the effective population size was chosen to be 1/X. 
   To fix, reconsider your prior on the effective population size. 
3. There is substantial changes of the effective population sizes and/or migration rates over time that are not modeled. 
   In that case, changes in the effective population sizes or migration rates have to be explained by population structure, 
   which can again lead to some effective population sizes being very low and some migration rates being very high. 
   In that case, there is unfortunately not much that can be done, since MASCOT is not an appropriate model for the dataset. 
4. There is strong subpopulation structure within the different subpopulations used. 
   In that case, reconsider if the individual sub-populations used are reasonable.

## Programs used in this tutorial

{% include_relative templates/programs-used.md %}
* MASCOT package - Marginal approximation of the structured coalescent.
* LPhyBeastExt package - The BEAST 2 package extended from the core project LPhyBeast, 
  which includes Mascot LPhyBeast extension.



[//]: # (## Data, Model, Posterior)
{% include_relative structured-coalescent/narrative.md %}


## Useful Links

If you interested in the derivations of the marginal approximation of the structured coalescent, 
you can find them from [Müller, Rasmussen, & Stadler, 2017](#references). 
This paper also explains the mathematical differences to other methods such as the theory underlying BASTA. 
To get a better idea of how the states of internal nodes are calculated, have a look in this paper [Müller, Rasmussen, & Stadler, 2018](#references).

* MASCOT source code: [https://github.com/nicfel/Mascot](https://github.com/nicfel/Mascot)
{% include_relative templates/links.md %}


[//]: # (## References)

{% include_relative structured-coalescent/references.md %}
* Müller, N. F., Rasmussen, D., & Stadler, T. (2018). MASCOT: Parameter and state inference under the marginal structured coalescent approximation. Bioinformatics, bty406. https://doi.org/10.1093/bioinformatics/bty406
* Müller, N. F., Rasmussen, D. A., & Stadler, T. (2017). The Structured Coalescent and its Approximations. Molecular Biology and Evolution, msx186.
* Drummond, A. J., & Bouckaert, R. R. (2014). Bayesian evolutionary analysis with BEAST 2. Cambridge University Press.
