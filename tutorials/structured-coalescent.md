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
MASCOT is short for __M__arginal __A__pproximation of the __S__tructured __C____O__alescen__T__ (Müller, Rasmussen, & Stadler, 2018) 
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

How to set the age direction in LPhy is available in the [Time-stamped data](/tutorials/time-stamped-data###Tip_dates) tutorial.

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
where the number of bins in the discretization `ncat = 4` (normally between 4 and 6).
The _shape_ parameter will be estimated in this analysis. 
More details can be seen in the [Bayesian Skyline Plots](/tutorials/skyline-plots###Constructing_the_model_block_in_LinguaPhylo) tutorial. 

Next, we set the priors for MASCOT. 
First, consider the effective population size parameter. 
Since we have only a few samples per location, meaning little information about the different effective population sizes, 
we will need an informative prior. In this case we will use a log normal prior with parameters M=0 and S=1. 
(These are respectively the mean and variance of the corresponding normal distribution in log space.) 
To use this prior, choose "Log Normal" from the dropdown menu to the right of the Ne.t:H3N2 parameter label, 
then click the arrow to the left of the same label and fill in the parameter values appropriately (i.e. M=0 and S=1). 
Ensure that the "mean in real space" checkbox remains unchecked.

The existing exponential distribution as a prior on the migration rate puts much weight on lower values while not prohibiting larger ones. 
For migration rates, a prior that prohibits too large values while not greatly distinguishing 
between very small and very very small values is generally a good choice. 
Be aware however that the exponential distribution is quite an informative prior: 
one should be careful that to choose a mean so that feasible rates are at least within the 95% HPD interval of the prior. 
(This can be determined by clicking the arrow to the left of the parameter name and 
looking at the values below the graph that appears on the right.)

Finally, set the prior for the clock rate. We have a good idea about the clock rate of Influenza A/H3N2 Hemagglutinin. 
From previous work by other people, we know that the clock rate will be around 0.005 substitution per site per year. 
To include that prior knowledger, we can set the prior on the clock rate to a log normal distribution. 
If we set `meanlog=-5.298` and `sdlog=0.25`, then we expect the clock rate to be with 95% certainty between 0.00306 and 0.00816.


So, we define the priors for the following parameters:
1. the effective population size _Θ_;  
2. the general clock rate _clockRate_ 
3. the relative substitution rates _mu_ which has 3 dimensions;
4. the transition/transversion ratio _kappa_ which also has 3 dimensions;
5. the base frequencies _pi_. 

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

  // two population sizes
  Θ ~ LogNormal(meanlog=0.0, sdlog=1.0, n=3);
  // m01 and m10 migration rates backwards in time
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

Tips: the example file `RSV2.lphy` is also available. Looking for the menu `File` and then `Examples`, 
you can find it and load the scripts after clicking. 


## Producing BEAST XML using LPhyBEAST

When we are happy with the analysis defined by this set of LPhy scripts, we save them into a file named `RSV2.lphy`.  
Then, we can use another software called `LPhyBEAST` to produce BEAST XML from these scripts, 
which is released as a Java jar file.
After you make sure both the data file `RSV2.nex` and the LPhy scripts `RSV2.lphy` are ready, 
preferred in the same folder, you can run the following command line in your terminal.

```
java -jar LPhyBEAST.jar RSV2.lphy
```


## Running BEAST

Once the BEAST file (e.g. RSV2.xml) is generated, the next step is to run it in BEAST.
You also need to make sue all required BEAST 2 packages (e.g. `outercore`) have been installed in your local computer.

<figure class="image">
  <img src="package.png" alt="Package manager">
  <figcaption>A screenshot of Package Manager.</figcaption>
</figure>

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

Random number seed: 1604351815445

Loading package outercore v0.0.2
Loading package BEAST v2.6.3
Loading package feast v7.4.1
Loading package BEASTLabs v1.9.5

    ...

    ...
         950000         0.4356         0.2557         0.0979         0.2106         9.2069         2.3817         1.9275         0.6596         0.8792         1.4594         0.0021        39.4713         0.3258         0.4043         0.1045         0.1652         0.3525         0.3588         0.0750         0.2135     -5478.1747     -6077.4442      -599.2694 1m48s/Msamples
        1000000         0.5169         0.2383         0.0990         0.1456         8.7778         1.3571         3.7831         0.6944         0.9176         1.3864         0.0022        41.4335         0.2924         0.4086         0.0971         0.2016         0.2956         0.4024         0.0686         0.2332     -5473.1158     -6066.4592      -593.3433 1m48s/Msamples

Operator                                       Tuning    #accept    #reject      Pr(m)  Pr(acc|m)
ScaleOperator(Theta.scale)                    0.62309       1361       3188    0.00450    0.29919 
ScaleOperator(clockRate.scale)                0.74084        854       3741    0.00450    0.18585 
UpDownOperator(clockRateUppsiDownOperator)    0.96191       9130     126260    0.13497    0.06743 Try setting scaleFactor to about 0.981
ScaleOperator(kappa.scale)                    0.30503       3169       6610    0.00970    0.32406 
DeltaExchangeOperator(mu.deltaExchange)       0.30496       1633       5624    0.00730    0.22502 
DeltaExchangeOperator(pi0.deltaExchange)      0.12657       1737       7987    0.00970    0.17863 
DeltaExchangeOperator(pi1.deltaExchange)      0.12929       1597       8009    0.00970    0.16625 
DeltaExchangeOperator(pi2.deltaExchange)      0.11330       1666       8078    0.00970    0.17098 
Exchange(psi.narrowExchange)                        -      33755     100525    0.13424    0.25138 
ScaleOperator(psi.rootAgeScale)               0.73972        571       3830    0.00450    0.12974 
ScaleOperator(psi.scale)                      0.92067       3958     130897    0.13424    0.02935 Try setting scaleFactor to about 0.96
SubtreeSlide(psi.subtreeSlide)                6.81331      12013     122157    0.13424    0.08954 Try decreasing size to about 3.407
Uniform(psi.uniform)                                -      72067      61492    0.13424    0.53959 
Exchange(psi.wideExchange)                          -        351     133668    0.13424    0.00262 
WilsonBalding(psi.wilsonBalding)                    -        701     133372    0.13424    0.00523 

     Tuning: The value of the operator's tuning parameter, or '-' if the operator can't be optimized.
    #accept: The total number of times a proposal by this operator has been accepted.
    #reject: The total number of times a proposal by this operator has been rejected.
      Pr(m): The probability this operator is chosen in a step of the MCMC (i.e. the normalized weight).
  Pr(acc|m): The acceptance probability (#accept as a fraction of the total proposals for this operator).


Total calculation time: 109.514 seconds
End likelihood: -6066.459203305355
```

## Analysing the BEAST output

Note that the effective sample sizes (ESSs) for many of the logged quantities are small 
(ESSs less than 100 will be highlighted in red by Tracer). This is not good. 
A low ESS means that the trace contains a lot of correlated samples and thus may not represent the posterior distribution well. 
In the bottom right of the window is a frequency plot of the samples which is expected given the low ESSs is extremely rough.

If we select the tab on the right-hand-side labelled Trace we can view the raw trace, that is, 
the sampled values against the step in the MCMC chain.

<figure class="image">
  <img src="short.png" alt="The trace of short run">
  <figcaption>A screenshot of Tracer.</figcaption>
</figure>


Here you can see how the samples are correlated. 
The default chain length of the MCMC is 1,000,000 in `LPhyBEAST`.
There are 1800 samples in the trace after removing 10% burnin (we ran the MCMC for steps sampling every 500) 
but adjacent samples often tend to have similar values. 
The ESS for the absolute rate of evolution (clockRate) is about 43 so we are only getting 1 independent sample 
to every 43 ~ 1800/42 actual samples). With a short run such as this one, 
it may also be the case that the default burn-in of 10% of the chain length is inadequate. 
Not excluding enough of the start of the chain as burn-in will render estimates of ESS unreliable.

The simple response to this situation is that we need to run the chain for longer. 
So let’s go for a chain length of 15,000,000 but keep logging the same number of sample (2,000). 

Question: what is the logging frequency (logEvery) now?


You could run `LPhyBEAST` with the `-l` argument again to create a new XML:

```
java -jar LPhyBEAST.jar -l 15000000 -o RSV2long.xml RSV2.lphy
```

or manually edit the XML at the following lines:

```
<run id="MCMC" spec="MCMC" chainLength="15000000" preBurnin="1480">

<logger id="Logger" spec="Logger" logEvery="750000">

<logger id="Logger1" spec="Logger" fileName="RSV2long.log" logEvery="7500">

<logger id="psi.treeLogger" spec="Logger" fileName="RSV2long.trees" logEvery="7500">
```

Now run BEAST and load the new log file into Tracer (you can leave the old one loaded for comparison).

Click on the Trace tab and look at the raw trace plot.

<figure class="image">
  <img src="long.png" alt="The trace of long run">
  <figcaption>A screenshot of Tracer.</figcaption>
</figure>

After running the analysis long enough in MCMC, we have the 1800 samples after removing 10% burnin, 
but with an ESS of each estimated parameter > 200. 
There is still auto-correlation between the samples, 
but > 200 effectively independent samples will now provide a very good estimate of the posterior distribution. 
There are no obvious trends in the plot which would suggest that the MCMC has not yet converged, 
and there are no significant long range fluctuations in the trace which would suggest poor mixing.

As we are satisfied with the mixing we can now move on to one of the parameters of interest: substitution rate. 
Select clockRate in the left-hand table. This is the average substitution rate across all sites in the alignment. 
Now choose the density plot by selecting the tab labeled Marginal Density. 
This shows a plot of the marginal posterior probability density of this parameter. 
You should see a plot similar to this:

<figure class="image">
  <img src="clockRate.png" alt="marginal density">
  <figcaption>The marginal density in Tracer.</figcaption>
</figure>


As you can see the posterior probability density is roughly bell-shaped. 
There is some sampling noise which would be reduced if we ran the chain for longer or 
sampled more often but we already have a good estimate of the mean and HPD interval. 
You can overlay the density plots of multiple traces in order to compare them 
(it is up to the user to determine whether they are comparable on the the same axis or not). 
Select the relative substitution rates for all three codon positions in the table to the left 
(labelled mu.0, mu.1 and mu.2). 
You will now see the posterior probability densities for the relative substitution rate at all three codon positions overlaid:

<figure class="image">
  <img src="mu.png" alt="relative substitution rates">
  <figcaption>The posterior probability densities for the relative substitution rates.</figcaption>
</figure>


## Summarising the trees

Use the program TreeAnnotator to summarise the tree. TreeAnnotator is an application that comes with BEAST.

<figure class="image">
  <img src="TreeAnnotator.png" alt="TreeAnnotator">
  <figcaption>TreeAnnotator for creating a summary tree from a posterior tree set.</figcaption>
</figure>


Summary trees can be viewed using FigTree (a program separate from BEAST) and DensiTree (distributed with BEAST).

<figure class="image">
  <img src="RSV2.tree.svg" alt="MCC tree">
  <figcaption>The Maximum clade credibility tree for the G gene of 129 RSVA-2 viral samples.</figcaption>
</figure>


Below a DensiTree with clade height bars for clades with over 50% support. Root canal tree represents maximum clade credibility tree.

<figure class="image">
  <img src="DensiTree.png" alt="MCC tree">
  <figcaption>The posterior tree set visualised in DensiTree.</figcaption>
</figure>


### Questions

In what year did the common ancestor of all RSVA viruses sampled live? What is the 95% HPD?


## Useful Links

Bayesian Evolutionary Analysis with BEAST 2 (Drummond & Bouckaert, 2014)
BEAST 2 website and documentation: http://www.beast2.org/
Join the BEAST user discussion: http://groups.google.com/group/beast-users

## Relevant References

* Zlateva, K. T., Lemey, P., Vandamme, A.-M., & Van Ranst, M. (2004). Molecular evolution and circulation patterns of human respiratory syncytial virus subgroup a: positively selected sites in the attachment g glycoprotein. J Virol, 78(9), 4675–4683.
* Zlateva, K. T., Lemey, P., Moës, E., Vandamme, A.-M., & Van Ranst, M. (2005). Genetic variability and molecular evolution of the human respiratory syncytial virus subgroup B attachment G protein. J Virol, 79(14), 9157–9167. https://doi.org/10.1128/JVI.79.14.9157-9167.2005
* Drummond, A. J., & Bouckaert, R. R. (2014). Bayesian evolutionary analysis with BEAST 2. Cambridge University Press.
