---
layout: page
title: Structured coalescent
subtitle: Population structure using MultiTypeTree
author: 'Walter Xie and Alexei Drummond'
permalink: /tutorials/structured-coalescent/
---

This tutorial is modified from Taming the BEAST tutorial [Structured coalescent](https://taming-the-beast.org/tutorials/Structured-coalescent/).

# Background

Population dynamics can influence the shape of a tree. 
Another thing that has strong influence on the shape of the tree is structure in a population. 
This is the case as soon as sequences do not mix well, i.e. they cluster together. 
One cause of this clustering is due to geography. Samples may not have been taken from the same geographic region, 
leading to clustering of samples from the same region. This clustering of samples can bias the estimation of parameters. 
The extension of the classic coalescent to the structured coalescent by allowing for migration between regions is trying 
to circumvent this by allowing individual regions to have distinct coalescent rates and by allowing migration between those regions.

# Programs used in this Exercise

The following software will be used in this tutorial:

* LPhyBEAST - this software will construct an input file for BEAST
* BEAST - this package contains the BEAST program, BEAUti, DensiTree, TreeAnnotator and other utility programs. 
  This tutorial is written for BEAST v2.6.x, which has support for multiple partitions. 
  It is available for download from [http://www.beast2.org](http://www.beast2.org).
* BEAST outercore package - this package of BEAST 2 has core features, but not in the core.
  You can install and use it following the instruction of [managing BEAST 2 packages](http://www.beast2.org/managing-packages/).
* BEAST labs package - containing some generally useful stuff used by other packages.
* BEAST feast package - this is a small BEAST 2 package which contains additions to the core functionality. 
  You need install it separately following the instruction of [feast website](https://github.com/tgvaughan/feast).  
* Tracer - this program is used to explore the output of BEAST (and other Bayesian MCMC programs). 
  It graphically and quantitively summarises the distributions of continuous parameters and provides diagnostic information. 
  At the time of writing, the current version is v1.7. It is available for download from [http://beast.community/tracer](http://beast.community/tracer).
* FigTree - this is an application for displaying and printing molecular phylogenies, in particular those obtained using BEAST. 
  At the time of writing, the current version is v1.4.3. It is available for download from [http://beast.community/figtree](http://beast.community/figtree).

# Practical: MultiTypeTree

In this tutorial we will estimate migration rates, effective population sizes and locations of internal nodes 
using the structured coalescent implemented in BEAST2, MultiTypeTree (Vaughan, Kühnert, Popinga, Welch, & Drummond, 2014).

The aim is to:

- Learn how to infer structure from trees with sampling location
- Get to know how to choose the set-up of such an analysis
- Get to know the advantages and disadvantages of working with structured trees

# The Data

The dataset [h3n2_2deme.fna](https://github.com/taming-the-beast/Structured-coalescent/raw/master/data/h3n2_2deme.fna) 
consists of 60 Influenza A/H3N2 sequences sampled in Hong Kong and in New Zealand between 2001 and 2005. 
South-East Asia has been hypothesized to be a global source location of seasonal Influenza, 
while more temperate regions such as New Zealand are assumed to be global sinks (missing reference), 
meaning that Influenza strains are more likely to migrate from the tropic to the temperate regions then vice versa. 
We want to see if we can infer this source-sink dynamic from sequence data using the structured coalescent.


### Tip dates

Since the sequences were sampled through time, we have to specify the sampling dates. 
These are included in the sequence names after the last `_`. 
To set the sampling dates, We will use the regular expression `"_(\d*\.\d+|\d+\.\d*)$"` to extract these decimal numbers and turn to ages. 

There are two different ways in how LPhy can interpret sampling dates, which are controlled by the age direction. 
If the sampling dates are __since some time in the past__, then we set `ageDirection="forward"` or `"dates"`.
This is usually used for virus data. 
If the sampling dates are __before the present__, then we set `ageDirection="backward"` or `"ages"`. 
This is usually used for fossils data. 
The easiest way to check if you have used the correct one is by clicking the graphical component `taxa` and checking the column `Age`. 
If the setup is correct, the sequences sampled the most recently (i.e. 2005.66) 
should have a `Age` of 0 while all other tips should be larger then 0.

```
Question: what should the age direction be in this analysis?
```

<figure class="image">
  <img src="ages.png" alt="ages">
  <figcaption>The ages of tips</figcaption>
</figure>


### Tip locations

The main contrast in the setup to previous analyses is that we include additional information about the sampling location of sequences. 
Sequences were taken from patients in Hong Kong and New Zealand. 
We can specify these sampling locations by extracting them from taxa labels. 
Use `split` to split the taxa names by the separator "_", and take the second group given `i=1` 
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
  options = {ageDirection="forward", ageRegex="_(\d*\.\d+|\d+\.\d*)$"};
  D = readFasta(file="examples/h3n2_2deme.fna", options=options);
  taxa = taxa(D);
  L = nchar(D);
  demes = split(str=D.getTaxaNames(), regex="_", i=1);
}
```

When you write your LPhy scripts, please be aware that `data` and `model` have been reserved 
and cannot be used as the variable name.


## Models

This block is to define and also describe your models and parameters used in the Bayesian phylogenetic analysis.
Therefore, your results could be reproduced by other researchers using the same model. 

In this analysis, we will use three HKY models with estimated frequencies for each of three partitions, 
and share the strict clock model and a Kingman coalescent tree generative distribution across partitions. 
But we are also interested about the relative substitution rate for each of three partitions.

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
  κ ~ LogNormal(meanlog=1.0, sdlog=0.5);
  π ~ Dirichlet(conc=[2.0,2.0,2.0,2.0]);

  shape ~ LogNormal(meanlog=0.0, sdlog=2.0);
  siteRates ~ DiscretizeGamma(shape=shape, ncat=4, reps=L);

  // 0.005 substitutions * site-1 * year-1 is closer to the truth
  clockRate ~ LogNormal(meanlog=-5.3, sdlog=0.25);

  // two population sizes
  Θ ~ LogNormal(meanlog=-3.0, sdlog=1.0, n=2);
  // m01 and m10 migration rates backwards in time
  m ~ LogNormal(meanlog=0.0, sdlog=1.0, n=2);
  M = migrationMatrix(theta=Θ, m=m);
  ψ ~ StructuredCoalescent(M=M, taxa=taxa, demes=demes);
  C = countMigrations(tree=ψ);

  D ~ PhyloCTMC(siteRates=siteRates, Q=hky(kappa=κ, freq=π), mu=clockRate, tree=ψ);
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
