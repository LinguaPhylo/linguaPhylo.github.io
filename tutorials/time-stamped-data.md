---
layout: page
title: Time-stamped data
permalink: /tutorials/time-stamped-data/
---

This tutorial estimates the rate of evolution from a set of virus sequences which have been isolated 
at different points in time (heterochronous or time-stamped data). 
The data are 129 sequences from the G (attachment protein) gene of human respiratory syncytial virus 
subgroup A (RSVA) (Zlateva, Lemey, Vandamme, & Van Ranst, 2004; Zlateva, Lemey, Moës, Vandamme, & Van Ranst, 2005), 
with isolation dates ranging from 1956-2002. 
RSVA causes infections of the lower respiratory tract causing symptoms that are often indistinguishable from the common cold. 
By age 3, nearly all children will be infected and a small percentage (<3%) will develop more serious inflammation 
of the bronchioles requiring hospitalisation.

The aim of this tutorial is to obtain estimates for:

* the rate of molecular evolution
* the date of the most recent common ancestor
* the phylogenetic relationships with measures of statistical support.

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


## The NEXUS alignment

The data is in a file called [RSV2.nex](https://raw.githubusercontent.com/CompEvol/beast2/master/examples/nexus/RSV2.nex). 
You can find it in the examples/nexus directory in the directory where BEAST was installed. 
Or click the link to download the data. 
After the data is opened in your web browser, right click mouse and save it in as `RSV2.nex` in a new folder.

### Multiple partitions

This file contains an alignment of 129 sequences from the G gene of RSVA virus, 629 nucleotides in length. 
Because this is a protein-coding gene we are going to split the alignment into three partitions representing 
each of the three codon positions. 

As it is fitting into the reading frame 3, we will use the charset expressions supported by Nexus format. 
For example, `"3-629\3"` means this partition starts from the 3rd site and takes every 3 sites until the last site 629.  


### Tip dates

By default all the taxa are assumed to have a date of zero (i.e. the sequences are assumed to be sampled at the same time). 
In this case, the RSVA sequences have been sampled at various dates going back to the 1950s. 

The date of each sample is stored in the taxon name after the last little `s`. The numbers are years since 1900.
We will use the regular expression `"s(\d+)$"` to extract these numbers and turn to ages. 
In addition, the age direction should be set to the _forward_ in time for this analysis. 


### Constructing the data block in LinguaPhylo

The LPhy data block is used to input and store the data, 
which will be processed by the models defined later. 
The data concepts here include the alignment loaded from a NEXUS file, 
and the meta data regarding to the information of taxa that we have known. 

Please make sure the tab above the command console is set to `data`, 
and type or copy and paste the following scripts into the console.

```
data {
  options = {ageDirection="forward", ageRegex="s(\d+)$"};
  D = readNexus(file="examples/RSV2.nex", options=options);
  taxa = taxa(D);
  codon0 = D.charset("3-629\3");
  codon1 = D.charset("4-629\3");
  codon2 = D.charset("5-629\3");
  weights = [codon0.nchar(), codon1.nchar(), codon2.nchar()]
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
5. the base frequencies _pi0_, _pi1_, and _pi2_. 

The benefit of using 3 relative substitution rates here instead of 3 clock rates is that we could use the DeltaExchangeOperator
to these relative rates in the MCMC sampling to help the converagence.

Please note the tree here is already the time tree, the age direction will have been processed in `data` block.


### Constructing the model block in LinguaPhylo

Please switch the tab to `model`, 
and type or copy and paste the following scripts into the console.

```
model {
  Θ ~ LogNormal(meanlog=3.0, sdlog=2.0);
  ψ ~ Coalescent(taxa=taxa, theta=Θ);
  kappa ~ LogNormal(meanlog=1.0, sdlog=0.5, n=3);

  mu ~ WeightedDirichlet(conc=[1.0,1.0,1.0], weights=weights);
  clockRate ~ LogNormal(meanlog=-5.0, sdlog=1.25);

  pi0 ~ Dirichlet(conc=[2.0,2.0,2.0,2.0]);
  codon0 ~ PhyloCTMC(L=codon0.nchar(), Q=hky(kappa=kappa[0], freq=pi0, meanRate=mu[0]), mu=clockRate, tree=ψ);
  pi1 ~ Dirichlet(conc=[2.0,2.0,2.0,2.0]);
  codon1 ~ PhyloCTMC(L=codon1.nchar(), Q=hky(kappa=kappa[1], freq=pi1, meanRate=mu[1]), mu=clockRate, tree=ψ);
  pi2 ~ Dirichlet(conc=[2.0,2.0,2.0,2.0]);
  codon2 ~ PhyloCTMC(L=codon2.nchar(), Q=hky(kappa=kappa[2], freq=pi2, meanRate=mu[2]), mu=clockRate, tree=ψ);
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

Random number seed: 1603419667128

File: RSV2.xml seed: 1603419667128 threads: 1

    ...

    ...
         950000         0.5249         0.2566         0.0795         0.1389        10.3895         ...     -5475.6236 2m25s/Msamples
        1000000         0.5088         0.2166         0.0977         0.1767        10.0793         ...     -5469.0172 2m25s/Msamples

Operator                                       Tuning    #accept    #reject      Pr(m)  Pr(acc|m)
ScaleOperator(Theta.scale)                    0.58529       1342       3890    0.00519    0.25650 
ScaleOperator(clockRate.scale)                0.74669       1064       4178    0.00519    0.20298 
UpDownOperator(clockRateUppsiDownOperator)    0.92667       5075     151107    0.15590    0.03249 Try setting scaleFactor to about 0.963
ScaleOperator(kappa.scale)                    0.29583       3522       7700    0.01121    0.31385 
DeltaExchangeOperator(mu.deltaExchange)       0.33461       1733       6774    0.00844    0.20371 
DeltaExchangeOperator(pi0.deltaExchange)      0.15065       1642       9480    0.01121    0.14764 
DeltaExchangeOperator(pi1.deltaExchange)      0.11862       1962       9280    0.01121    0.17452 
DeltaExchangeOperator(pi2.deltaExchange)      0.12935       1665       9605    0.01121    0.14774 
Exchange(psi.narrowExchange)                        -      38340     116847    0.15505    0.24706 
ScaleOperator(psi.rootAgeScale)               0.74434        651       4438    0.00519    0.12792 
ScaleOperator(psi.scale)                      0.91815       4401     150074    0.15505    0.02849 Try setting scaleFactor to about 0.958
SubtreeSlide(psi.subtreeSlide)                5.17988      17843     137532    0.15505    0.11484 
Uniform(psi.uniform)                                -      83348      71204    0.15505    0.53929 
Exchange(psi.wideExchange)                          -        370     154934    0.15505    0.00238 

     Tuning: The value of the operator's tuning parameter, or '-' if the operator can't be optimized.
    #accept: The total number of times a proposal by this operator has been accepted.
    #reject: The total number of times a proposal by this operator has been rejected.
      Pr(m): The probability this operator is chosen in a step of the MCMC (i.e. the normalized weight).
  Pr(acc|m): The acceptance probability (#accept as a fraction of the total proposals for this operator).


Total calculation time: 147.245 seconds
End likelihood: -6074.526170858627
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
So let’s go for a chain length of 6,000,000 and log every 3,000. 

You could run `LPhyBEAST` with the `-l` argument again to create a new XML:

```
java -jar LPhyBEAST.jar -l 6000000 -o RSV2long.xml RSV2.lphy
```
 
or manually edit the XML at the following lines:

```
<run id="MCMC" spec="MCMC" chainLength="6000000" preBurnin="1480">

<logger id="Logger" spec="Logger" logEvery="500000">

<logger id="Logger1" spec="Logger" fileName="RSV2long.log" logEvery="3000">

<logger id="psi.treeLogger" spec="Logger" fileName="RSV2long.trees" logEvery="3000">
```

Now run BEAST and load the new log file into Tracer (you can leave the old one loaded for comparison).

Click on the Trace tab and look at the raw trace plot.

<figure class="image">
  <img src="long.png" alt="The trace of long run">
  <figcaption>A screenshot of Tracer.</figcaption>
</figure>

We have chosen options that produce 12000 samples and with an ESS of about 239 there is still auto-correlation 
between the samples but >239 effectively independent samples will now provide a very good estimate of the posterior distribution. 
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
