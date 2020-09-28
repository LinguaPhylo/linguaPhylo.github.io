---
layout: page
title: Time-stamped data
permalink: /tutorials/time-stamped-data/
---

This tutorial estimates the rate of evolution from a set of virus sequences which have been isolated at different points in time (heterochronous or time-stamped data). 
The data are 129 sequences from the G (attachment protein) gene of human respiratory syncytial virus subgroup A (RSVA) (Zlateva, Lemey, Vandamme, & Van Ranst, 2004; Zlateva, Lemey, Moës, Vandamme, & Van Ranst, 2005), 
with isolation dates ranging from 1956-2002. 
RSVA causes infections of the lower respiratory tract causing symptoms that are often indistinguishable from the common cold. 
By age 3, nearly all children will be infected and a small percentage (<3%) will develop more serious inflammation of the bronchioles requiring hospitalisation.

The aim of this tutorial is to obtain estimates for:

* the rate of molecular evolution
* the date of the most recent common ancestor
* the phylogenetic relationships with measures of statistical support.

The following software will be used in this tutorial:

* LPhyBEAST - this software will construct an input file for BEAST
* BEAST - this package contains the BEAST program, BEAUti, DensiTree, TreeAnnotator and other utility programs. 
  This tutorial is written for BEAST v2.6.x, which has support for multiple partitions. It is available for download from [http://www.beast2.org](http://www.beast2.org).
* Tracer - this program is used to explore the output of BEAST (and other Bayesian MCMC programs). 
  It graphically and quantitively summarises the distributions of continuous parameters and provides diagnostic information. 
  At the time of writing, the current version is v1.7. It is available for download from [http://beast.community/tracer](http://beast.community/tracer).
* FigTree - this is an application for displaying and printing molecular phylogenies, in particular those obtained using BEAST. 
  At the time of writing, the current version is v1.4.3. It is available for download from [http://beast.community/figtree](http://beast.community/figtree).

## The NEXUS alignment

The data is in a file called [RSV2.nex](https://raw.githubusercontent.com/CompEvol/beast2/master/examples/nexus/RSV2.nex). 
You can find it in the examples/nexus directory in the directory where BEAST was installed. 
Or click the link to download the data. 
After the data is opened in your web browser, right click mouse and save it in as `RSV2.nex` in a new folder.


### Multiple partitions

This file contains an alignment of 129 sequences from the G gene of RSVA virus, 629 nucleotides in length. 
Because this is a protein-coding gene we are going to split the alignment into three partitions representing each of the three codon positions. 
As it is fitting into the reading frame 3, we will use the charset expressions supported by Nexus format. 

For example, "3-629\3" means this partition starts from the 3rd site and takes every 3 sites until the last site 629.  


### Tip dates

The date of each sample is stored in the taxon name after the last little s. The numbers are years since 1900.
We will use the regular expression `"s(\d+)$"` to extract these numbers. 
In addition, the age direction should be set to the _forward_ in time for this analysis. 


### Constructing the data block in LinguaPhylo

```
data {
  codon = nexus(file="examples/RSV2.nex", charset=["3-629\3", "4-629\3", "5-629\3"], ageDirection="forward", ageRegex="s(\d+)$");
  L1 = nchar(partition(codon, "1"));
  L2 = nchar(partition(codon, "2"));
  L3 = nchar(partition(codon, "3"));
}
```

## Models

We will use the F81 model with estimated frequencies for all three partitions, 
and share the strict clock model and a Kingman coalescent tree generative distribution across partitions. 

We also define the priors for the following parameters:
1. the clock rate _mu_; 
2. the effective population size _Θ_;
3. the base frequencies _π_ 

### Constructing the model block in LinguaPhylo

```
model {
  mu ~ LogNormal(meanlog=-4.5, sdlog=0.5);
  Θ ~ LogNormal(meanlog=3, sdlog=1);
  ψ ~ Coalescent(theta=Θ, taxa=taxa(codon));
  π ~ Dirichlet(conc=[2.0,2.0,2.0,2.0]);
  Q=f81(freq=π);
  codon1 ~ PhyloCTMC(tree=ψ, L=L1, Q=Q, mu=mu);
  codon2 ~ PhyloCTMC(tree=ψ, L=L2, Q=Q, mu=mu);
  codon3 ~ PhyloCTMC(tree=ψ, L=L3, Q=Q, mu=mu);
}
```

<figure class="image">
  <img src="LinguaPhyloStudio.png" alt="LinguaPhyloStudio">
  <figcaption>The Screenshot of LinguaPhylo Studio</figcaption>
</figure>


## Running BEAST

Once you have generated the BEAST file (e.g. RSV2.xml) the next step is to run it in BEAST.


Now run BEAST and when it asks for an input file, provide your newly created XML file as input. 
BEAST will then run until it has finished reporting information to the screen. 
The actual results files are save to the disk in the same location as your input file. 
The output to the screen will look something like this:

```
                        BEAST v2.5.2, 2002-2019
             Bayesian Evolutionary Analysis Sampling Trees
                       Designed and developed by
 Remco Bouckaert, Alexei J. Drummond, Andrew Rambaut & Marc A. Suchard

                     Department of Computer Science
                         University of Auckland
                        remco@cs.auckland.ac.nz
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
    ...

    ...
         990000     -6108.0939     -5503.4454      -604.6484 1m45s/Msamples
        1000000     -6102.6691     -5505.1198      -597.5493 1m44s/Msamples

Operator                                                   Tuning    #accept    #reject      Pr(m)  Pr(acc|m)
ScaleOperator(StrictClockRateScaler.c:clock)              0.78157       8218      27756    0.03601    0.22844 
UpDownOperator(strictClockUpDownOperator.c:clock)         0.84475        551      35258    0.03601    0.01539 Try setting scaleFactor to about 0.919
ScaleOperator(KappaScaler.s:RSV2_1)                       0.38916        323        934    0.00120    0.25696 
DeltaExchangeOperator(FixMeanMutationRatesOperator)       0.33840       4766      19363    0.02401    0.19752 
ScaleOperator(KappaScaler.s:RSV2_2)                       0.39201        288        901    0.00120    0.24222 
ScaleOperator(KappaScaler.s:RSV2_3)                       0.41649        271        964    0.00120    0.21943 
ScaleOperator(CoalescentConstantTreeScaler.t:tree)        0.71887        273      35495    0.03601    0.00763 Try setting scaleFactor to about 0.848
ScaleOperator(CoalescentConstantTreeRootScaler.t:tree)    0.64576       3140      33308    0.03601    0.08615 Try setting scaleFactor to about 0.804
Uniform(CoalescentConstantUniformOperator.t:tree)               -     193184     166770    0.36014    0.53669 
SubtreeSlide(CoalescentConstantSubtreeSlide.t:tree)       4.11043      28087     152489    0.18007    0.15554 
Exchange(CoalescentConstantNarrow.t:tree)                       -      44602     135445    0.18007    0.24772 
Exchange(CoalescentConstantWide.t:tree)                         -         84      35705    0.03601    0.00235 
WilsonBalding(CoalescentConstantWilsonBalding.t:tree)           -        205      35530    0.03601    0.00574 
ScaleOperator(PopSizeScaler.t:tree)                       0.60390      10084      26007    0.03601    0.27940 

     Tuning: The value of the operator's tuning parameter, or '-' if the operator can't be optimized.
    #accept: The total number of times a proposal by this operator has been accepted.
    #reject: The total number of times a proposal by this operator has been rejected.
      Pr(m): The probability this operator is chosen in a step of the MCMC (i.e. the normalized weight).
  Pr(acc|m): The acceptance probability (#accept as a fraction of the total proposals for this operator).


Total calculation time: 106.096 seconds
End likelihood: -6102.669168760964
```

## Analysing the BEAST output

Note that the effective sample sizes (ESSs) for many of the logged quantities are small (ESSs less than 100 will be highlighted in red by Tracer). This is not good. A low ESS means that the trace contains a lot of correlated samples and thus may not represent the posterior distribution well. In the bottom right of the window is a frequency plot of the samples which is expected given the low ESSs is extremely rough.

If we select the tab on the right-hand-side labelled Trace we can view the raw trace, that is, the sampled values against the step in the MCMC chain.


Figure: A screenshot of Tracer.


Here you can see how the samples are correlated. There are 2500 samples in the trace (we ran the MCMC for steps sampling every 400) but adjacent samples often tend to have similar values. The ESS for the absolute rate of evolution (clockRate) is about 65 so we are only getting 1 independent sample to every 65 ~ 2500/38 actual samples). With a short run such as this one, it may also be the case that the default burn-in of 10% of the chain length is inadequate. Not excluding enough of the start of the chain as burn-in will render estimates of ESS unreliable.

The simple response to this situation is that we need to run the chain for longer. Given the lowest ESS (for the constant coalescent) is 50, it would suggest that we have to run the chain for at least 4 times the length to get reasonable ESSs that are >200. So let’s go for a chain length of 6000000 and log every 5000. Go back to the MCMC options section in BEAUti, and create a new BEAST XML file with a longer chain length. Now run BEAST and load the new log file into Tracer (you can leave the old one loaded for comparison).

Click on the Trace tab and look at the raw trace plot.


Figure: tracer


We have chosen options that produce 12000 samples and with an ESS of about 239 there is still auto-correlation between the samples but >239 effectively independent samples will now provide a very good estimate of the posterior distribution. There are no obvious trends in the plot which would suggest that the MCMC has not yet converged, and there are no significant long range fluctuations in the trace which would suggest poor mixing.

As we are satisfied with the mixing we can now move on to one of the parameters of interest: substitution rate. Select clockRate in the left-hand table. This is the average substitution rate across all sites in the alignment. Now choose the density plot by selecting the tab labeled Marginal Density. This shows a plot of the marginal posterior probability density of this parameter. You should see a plot similar to this:


Figure 12: marginal density in tracer


As you can see the posterior probability density is roughly bell-shaped. There is some sampling noise which would be reduced if we ran the chain for longer or sampled more often but we already have a good estimate of the mean and HPD interval. You can overlay the density plots of multiple traces in order to compare them (it is up to the user to determine whether they are comparable on the the same axis or not). Select the relative substitution rates for all three codon positions in the table to the left (labelled mutationRate.1, mutationRate.2 and mutationRate.3). You will now see the posterior probability densities for the relative substitution rate at all three codon positions overlaid:


Figure 13: The posterior probability densities for the relative substitution rates


## Summarising the trees

Use the program TreeAnnotator to summarise the tree. TreeAnnotator is an application that comes with BEAST.


Figure 14: TreeAnnotator for creating a summary tree from a posterior tree set.


Summary trees can be viewed using FigTree (a program separate from BEAST) and DensiTree (distributed with BEAST).


Figure 15: The Maximum clade credibility tree for the G gene of 129 RSVA-2 viral samples.


Below a DensiTree with clade height bars for clades with over 50% support. Root canal tree represents maximum clade credibility tree.


Figure 16: The posterior tree set visualised in DensiTree.


### Questions

In what year did the common ancestor of all RSVA viruses sampled live? What is the 95% HPD?

Bonus section: Bayesian Skyline plot
We can reconstruct the population history using the Bayesian Skyline plot. 
In order to do so, load the XML file into BEAUti, select the priors-tab and change the tree prior from coalescent with constant population size to coalescent with Bayesian skyline. 
Note that an extra item is added to the priors called Markov chained population sizes which is a prior that ensures dependence between population sizes.

Figure 17: Priors

By default the number of groups used in the skyline analysis is set to 5, To change this, select menu View/Show Initialization panel and a list of parameters is shown. 
Select bPopSizes.t:tree and change the dimension to 3. Likewise, selection bGroupSizes.t:tree and change its dimension to 3. 
The dimensions of the two parameters should be the same. 
More groups mean more population changes can be detected, but it also means more parameters need to be estimated and the chain runs longer. 
The extended Bayesian skyline plot automatically detects the number of changes, so it could be used as an alternative tree prior.

Figure 18: Initialization panel

This analysis requires a bit longer to converge, so change the MCMC chain length to 10 million, and the log intervals for the trace-log and tree-log to 10 thousand. 
Then, save the file and run BEAST. 
You can also download the log (RSV2-bsp.log) and tree (tree-bsp.trees) files from the precooked-runs directory.

To plot the population history, load the log file in tracer and select the menu Analysis/Bayesian Skyline Reconstruction.


Figure 19: Bayesian Skyline Reconstruction in Tracer


A dialog is shown where you can specify the tree file associated with the log file. 
Also, since the youngest sample is from 2002, change the entry for age of youngest tip to 2002.


Figure 20: Bayesian Skyline Reconstruction dialog in Tracer


After some calculation, a graph appears showing population history where the median and 95% HPD intervals are plotted. 
After selecting the solid interval checkbox, the graph should look something like this.


Figure 21: Bayesian Skyline Reconstruction


### Questions

* By what amount did the effective population size of RSVA grow from 1970 to 2002 according to the BSP?

* What are the underlying assumptions of the BSP? Are the violated by this data set?

## Exercise

Change the Bayesian skyline prior to extended Bayesian skyline plot (EBSP) prior and run till convergence. 
EBSP produces an extra log file, called EBSP.$(seed).log where $(seed) is replaced by the seed you used to run BEAST. 
A plot can be created by running the EBSPAnalyser utility, and loading the output file in a spreadsheet.

* How many groups are indicated by the EBSP analysis? 
* This is much lower than for BSP. 
* How does this affect the population history plots?

## Useful Links

Bayesian Evolutionary Analysis with BEAST 2 (Drummond & Bouckaert, 2014)
BEAST 2 website and documentation: http://www.beast2.org/
Join the BEAST user discussion: http://groups.google.com/group/beast-users

## Relevant References

* Zlateva, K. T., Lemey, P., Vandamme, A.-M., & Van Ranst, M. (2004). Molecular evolution and circulation patterns of human respiratory syncytial virus subgroup a: positively selected sites in the attachment g glycoprotein. J Virol, 78(9), 4675–4683.
* Zlateva, K. T., Lemey, P., Moës, E., Vandamme, A.-M., & Van Ranst, M. (2005). Genetic variability and molecular evolution of the human respiratory syncytial virus subgroup B attachment G protein. J Virol, 79(14), 9157–9167. https://doi.org/10.1128/JVI.79.14.9157-9167.2005
* Drummond, A. J., & Bouckaert, R. R. (2014). Bayesian evolutionary analysis with BEAST 2. Cambridge University Press.
