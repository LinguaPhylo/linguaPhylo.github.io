---
layout: page
title: Skyline plots
author: Walter
permalink: /tutorials/skyline-plots/
---

This tutorial is modified from Taming the BEAST tutorial [Skyline plots](https://taming-the-beast.org/tutorials/Skyline-plots/).

Population dynamics influence the shape of the tree and consequently, 
the shape of the tree contains some information about past population dynamics. 
The so-called Skyline methods allow to extract this information from phylogenetic trees in a non-parametric manner. 
It is non-parametric since there is no underlying system of differential equations governing the inference of these dynamics. 

In this tutorial we will look at two different methods to infer these dynamics from sequence data. 
The first one is the Coalescent Bayesian Skyline plot (Drummond, Rambaut, Shapiro, & Pybus, 2005), 
which is based on the coalescent model, and the second one is the Birth-Death Skyline plot (Stadler, Kuhnert, Bonhoeffer, & Drummond, 2013) based on the birth-death model. 
The conceptual difference between coalescent and birth-death approaches lies in the direction of the flow of time. 
In the coalescent, the time is modeled to go backwards, from present to past, while in the birth-death approach it is modeled to go forwards. 
Two other fundamental differences are the parameters that are inferred and the way sampling is treated.

The following software will be used in this tutorial:

* LPhyBEAST - this software will construct an input file for BEAST
* BEAST - this package contains the BEAST program, BEAUti, DensiTree, TreeAnnotator and other utility programs. 
  This tutorial is written for BEAST v2.6.x, which has support for multiple partitions. 
  It is available for download from [http://www.beast2.org](http://www.beast2.org).
* BEAST outercore package - this package of BEAST 2 has core features, but not in the core.
  You can install and use it following the instruction of [managing BEAST 2 packages](http://www.beast2.org/managing-packages/).
* BEAST labs package - containing some generally useful stuff used by other packages.
* SSM (standard substitution models) package - containing the following standard time-reversible substitution models: 
  JC, F81, K80, HKY, TrNf, TrN, TPM1, TPM1f, TPM2, TPM2f, TPM3, TPM3f, TIM1, TIM1f, TIM2, TIM2f, TIM3 , TIM3f, TVMf, TVM, SYM, GTR.
* BEAST feast package - this is a small BEAST 2 package which contains additions to the core functionality. 
  You need install it separately following the instruction of [feast website](https://github.com/tgvaughan/feast).  
* Tracer - this program is used to explore the output of BEAST (and other Bayesian MCMC programs). 
  It graphically and quantitively summarises the distributions of continuous parameters and provides diagnostic information. 
  At the time of writing, the current version is v1.7. It is available for download from [http://beast.community/tracer](http://beast.community/tracer).
* FigTree - this is an application for displaying and printing molecular phylogenies, in particular those obtained using BEAST. 
  At the time of writing, the current version is v1.4.3. It is available for download from [http://beast.community/figtree](http://beast.community/figtree).
* R / RStudio - We will be using [R](https://www.r-project.org) to analyze the output of the Birth-Death Skyline plot. 
  [RStudio](https://www.rstudio.com/) provides a user-friendly graphical user interface to R that makes it easier to edit and run scripts. 
  (It is not necessary to use RStudio for this tutorial).


## The NEXUS alignment

The data is in a file called [hcv.nex](https://github.com/taming-the-beast/Skyline-plots/raw/master/data/hcv.nexus). 
You can download the data from the link, after the data is opened in your web browser, 
right click mouse and save it in as `hcv.nex` in a new folder.

The dataset consists of an alignment of 63 Hepatitis C sequences sampled in 1993 in Egypt (Ray, Arthur, Carella, Bukh, & Thomas, 2000). 
This dataset has been used previously to test the performance of skyline methods (Drummond, Rambaut, Shapiro, & Pybus, 2005) (Stadler, Kuhnert, Bonhoeffer, & Drummond, 2013).

With an estimated 15-25%, Egypt has the highest Hepatits C prevalence in the world. In the mid 20th century, 
the prevalence of Hepatitis C increased drastically (see Figure 1 for estimates). 
We will try to infer this increase from sequence data.

<figure class="image">
  <img src="Estimated_number_hcv.png" alt="The growth of the effective population size of the Hepatitis C epidemic in Egypt">
  <figcaption>Figure 1: The growth of the effective population size of the Hepatitis C epidemic in Egypt (Pybus, Drummond, Nakano, Robertson, & Rambaut, 2003).</figcaption>
</figure>


### Constructing the data block in LinguaPhylo

The LPhy data block is used to input and store the data, 
which will be processed by the models defined later. 
The data concepts here include the alignment loaded from a NEXUS file, 
and the meta data regarding to the information of taxa that we have known. 

Please make sure the tab above the command console is set to `data`, 
and type or copy and paste the following scripts into the console.

```
data {
  D = readNexus(file="examples/hcv.nexus");
  taxa = taxa(D);
  L = nchar(D);
  numGroups = 4;
  w = ntaxa(taxa)-1;
}
```

`taxa` and `L` respectively stores the taxa from the alignment `D` and the length of `D`.
`numGroups = 4` sets the number of grouped intervals in the generalized Coalescent Bayesian Skyline plots, 
and `w` defines `n − 1` effective population sizes, which is the same number of times at which coalescent events occur. 

## Setting up the Coalescent Bayesian Skyline analysis

### Background: Classic and Generalized Plots

[(Drummond, Rambaut, Shapiro, & Pybus, 2005)](https://academic.oup.com/mbe/article/22/5/1185/1066885) explained 
these concepts in the figure below:

<figure class="image">
  <img src="BS1.png" alt="Bayesian Skyline">
  <figcaption>The classic and generalized Coalescent Bayesian Skyline plots</figcaption>
</figure>

<ol type="a">
  <li>A genealogy of five individuals sampled contemporaneously (top) together with its associated classic (middle) and generalized (bottom) skyline plots.</li>
  <li>A genealogy of five individuals sampled at three different times (top) along with its associated classic (middle) and generalized (bottom) skyline plots. </li>
</ol>

In the classic skyline plots, the changes in effective population size coincide with coalescent events, 
resulting in a stepwise function with `n − 2` change points and `n − 1` population sizes, 
where `n` is the number of sampled individuals. 
In the generalized skyline plot, changes in effective population size coincide with some, but not necessarily all, coalescent events. 
The resulting stepwise function has `m − 1` change points (`1 ≤ m ≤ n−1`) and `m` effective population sizes.

```
Question: what does `numGroups = 4` and `w` define according to the figure above?
```

### Constructing the model block in LinguaPhylo

In this analysis, we will use the GTR model, 
which is the most general reversible model and estimates transition probabilities between individual nucleotides separately. 
That means that the transition probabilities between e.g. **A** and **T** will be inferred separately to the ones between **A** and **C**, 
however transition probabilities from **A** to **C** will be the same as **C** to **A** etc. 
The nucleotide equilibrium state frequencies _π_ are estimated here.

TODO how to map rates dimension to A C G T? by integer?


The sequences were all sampled in 1993 so we are dealing with a homochronous alignment and do not need to specify tip dates.

Because our sequences are contemporaneous (homochronous data), there is no information in our dataset to estimate the clock rate. 
We will use an estimate inferred in (Pybus et al., 2001) to fix the clock rate. 
In this case all the samples were contemporaneous (sampled at the same time) and the clock rate is simply 
a scaling of the estimated tree branch lengths (in substitutions/site) into calendar time.

So, let's set the clock rate _mu_ to 0.00079 s/s/y

In addition, we define the priors for the following parameters:
1. the vector of effective population sizes _Θ_;  
2. the relative rates of the GTR process _rates_; 
3. the base frequencies _π_. 

Here we setup a Markov chain of effective population sizes using `ExpMarkovChain`, 
and apply a `LogNormal` distribution to the mean of the exponential from which the first value of the chain is drawn.
The `groupSizes` are positive integers randomly sampled by `RandomComposition` with the dimension of `numGroups`, 
and they should sum to the number of coalescent intervals.

Please switch the tab to `model`, and type or copy and paste the following scripts into the console.

```
model {
  π ~ Dirichlet(conc=[3.0,3.0,3.0,3.0]);
  rates ~ Dirichlet(conc=[1.0, 2.0, 1.0, 1.0, 2.0, 1.0]);
  Q = gtr(freq=π, rates=rates);

  initialMean ~ LogNormal(meanlog=-3.0, sdlog=1.0);
  Θ ~ ExpMarkovChain(initialMean=initialMean, n=numGroups);
  groupSizes ~ RandomComposition(n=w, k=numGroups);
  ψ ~ SkylineCoalescent(theta=Θ, taxa=taxa, groupSizes=groupSizes);

  D ~ PhyloCTMC(L=L, Q=Q, tree=ψ, mu=0.00079);
}
```

```
Question: how to change the above LPhy scripts to use the classic Skyline coalescent?

Tips: by default all group sizes in SkylineCoalescent function are 1 which is equivalent to the classic skyline coalescent.
```

### The parameterization

Please read the section of "The Coalescent Bayesian Skyline parameterization" and "Choosing the Dimension" from 
Taming the BEAST tutorial [Skyline plots](https://taming-the-beast.org/tutorials/Skyline-plots/).

```
Question: 

1. how to choose the dimension for the Coalescent Bayesian Skyline?

2. what are the alternative models to deal with this dimension problem?

3. how does the number of dimensions of effective population sizes affect the result?
```

### LinguaPhylo

After the data and model are successfully loaded, you can view the probability graph for this analysis. 
You can also look at the value, including alignment or tree, by simply clicking the component in the graph.  

<figure class="image">
  <img src="LinguaPhyloStudio.png" alt="LinguaPhyloStudio">
  <figcaption>The Screenshot of LinguaPhylo Studio</figcaption>
</figure>

Tips: the example file `hcv_coal.lphy` is also available. Looking for the menu `File` and then `Examples`, 
you can find it and load the scripts after clicking. 


## Producing BEAST XML using LPhyBEAST

When we are happy with the analysis defined by this set of LPhy scripts, we save them into a file named `hcv_coal.lphy`.  
Then, we can use another software called `LPhyBEAST` to produce BEAST XML from these scripts, 
which is released as a Java jar file.
After you make sure both the data file `hcv.nex` and the LPhy scripts `hcv_coal.lphy` are ready, 
preferred in the same folder, you can run the following command line in your terminal.

```
java -jar LPhyBEAST.jar hcv_coal.lphy
```


## Running BEAST

Once the BEAST file (e.g. hcv_coal.xml) is generated, the next step is to run it in BEAST.
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

File: hcv_coal.xml seed: 1604462460351 threads: 2
Loading package SSM v1.1.0
Loading package outercore v0.0.3
Loading package BEAST v2.6.3
Loading package feast v7.5.0
Loading package BEASTLabs v1.9.5

    ...

    ...
       47500000         0.2026         0.3099         0.2335         0.2538         0.0622         0.3509         0.0581         0.0379         0.4294         0.0613              1              1             12             48        24.4728       224.6929      1397.2524      4954.6297       191.0069     -6762.8167      -495.8627     -7258.6795 39s/Msamples
       50000000         0.2051         0.3011         0.2264         0.2673         0.0594         0.3462         0.0603         0.0444         0.4277         0.0618              1              2             13             46        62.6926       491.7482      3243.8585      4914.8743       164.3254     -6773.3078      -497.8963     -7271.2042 39s/Msamples

Operator                                            Tuning    #accept    #reject      Pr(m)  Pr(acc|m)
ScaleOperator(Theta.scale)                         0.31726     262086     840119    0.02201    0.23778 
DeltaExchangeOperator(groupSizes.deltaExchange)    3.43966      52572     847160    0.01800    0.05843 Try setting delta to about 1
ScaleOperator(initialMean.scale)                   0.26446     117537     299482    0.00834    0.28185 
DeltaExchangeOperator(pi.deltaExchange)            0.07929     146944     752809    0.01800    0.16332 
Exchange(psi.narrowExchange)                             -    2051891    5446150    0.14993    0.27366 
ScaleOperator(psi.rootAgeScale)                    0.71734      64469     352913    0.00834    0.15446 
ScaleOperator(psi.scale)                           0.82721    1740768    5759278    0.14993    0.23210 
SubtreeSlide(psi.subtreeSlide)                     6.92260    3844937    3649605    0.14993    0.51303 Try increasing size to about 13.845
Uniform(psi.uniform)                                     -    2729289    4766356    0.14993    0.36412 
Exchange(psi.wideExchange)                               -      31183    7464073    0.14993    0.00416 
WilsonBalding(psi.wilsonBalding)                         -      42916    7450467    0.14993    0.00573 
DeltaExchangeOperator(rates.deltaExchange)         0.13496      92018    1194979    0.02573    0.07150 Try setting delta to about 0.067

     Tuning: The value of the operator's tuning parameter, or '-' if the operator can't be optimized.
    #accept: The total number of times a proposal by this operator has been accepted.
    #reject: The total number of times a proposal by this operator has been rejected.
      Pr(m): The probability this operator is chosen in a step of the MCMC (i.e. the normalized weight).
  Pr(acc|m): The acceptance probability (#accept as a fraction of the total proposals for this operator).


Total calculation time: 2004.832 seconds
End likelihood: -7271.20424761115
```

## Analysing the BEAST output

Because we shortened the chain most parameters have very low ESS values. 
If you like, you can compare your results with the example results we obtained with identical settings and 
a chain of 30,000,000 (hcv\_coal\_30M.log).

<figure class="image">
  <img src="short.png" alt="The trace of short run">
  <figcaption>A screenshot of Tracer.</figcaption>
</figure>


For the reconstruction of the population dynamics, we need two files, the *.log file and the *.trees file. 
The log file contains the information about the group sizes and population sizes of each segment, 
while the trees file is needed for the times of the coalescent events.

Navigate to **Analysis > Bayesian Skyline Reconstruction**. 
From there open the *.trees file. To get the correct dates in the analysis we should specify the Age of the youngest tip. 
In our case it is 1993, the year where all the samples were taken. 
If the sequences were sampled at different times (heterochronous data), 
the age of the youngest tip is the time when the most recent sample was collected.

Press **OK** to reconstruct the past population dynamics.

<figure class="image">
  <img src="BSA.png" alt="Reconstructing the Bayesian Skyline plot">
  <figcaption>Reconstructing the Bayesian Skyline plot in Tracer.</figcaption>
</figure>

The output will have the years on the x-axis and the effective population size on the y-axis. 
By default, the y-axis is on a log-scale. 
If everything worked as it is supposed to work you will see a sharp increase in the effective population size in the mid 20th century, 
similar to what is seen below.

Note that the reconstruction will only work if the *.log and *.trees files contain the same number of states and both files were logged at the same frequency.

<figure class="image">
  <img src="BSplot.png" alt="Coalescent Bayesian Skyline plot">
  <figcaption>Coalescent Bayesian Skyline analysis output. 
  The black line is the median estimate of the estimated effective population size (can be changed to the mean estimate). 
  The two blue lines are the upper and lower bounds of the 95% HPD interval. 
  The x-axis is the time in years and the y-axis is on a log-scale.</figcaption>
</figure>

There are two ways to save the analysis, it can either be saved as a *.pdf for display purposes or as a tab delimited file.

Navigate to **File > Export Data Table**. Enter the filename as `hcv_coal.tsv` and save the file.
The exported file will have five rows, the time, the mean, median, lower and upper boundary of the 95% HPD interval of the estimates, 
which you can use to plot the data with other software (R, Matlab, etc).


### Choosing the Dimension

If we compare the estimates of the population dynamics using different dimensions, 
we see that most of the dynamics are already captured with having only 2 dimensions, as shown in Figure 13. 
Adding more dimensions only changes the inferred effective population size before 1900. 
Note that adding more dimensions adds a slight dip before the increase in the effective population size (around 1900). 
When comparing to the HPD intervals (Figure 12) we see that this dip is not significant and 
may not be indicative of a real decrease in the effective population size before the subsequent increase.

<figure class="image">
  <img src="popsizes.png" alt="Package manager">
  <figcaption>Estimated mean effective population sizes using different dimensions.</figcaption>
</figure>



The choice of the number of dimensions can also have a direct effect on how fast the MCMC converges (Figure 14). 
The slower convergence with increasing dimension can be caused by e.g. less information in intervals. 
To some extent it is simply caused by the need to estimate more parameters though.

<figure class="image">
  <img src="posteriorESS.png" alt="Package manager">
  <figcaption>The ESS value of the posterior after running an MCMC chain with 10<sup>7</sup> samples, 
logged every 1,000 steps and a burnin of 10% for using different dimensions of the Coalescent Bayesian Skyline.</figcaption>
</figure>



## Setting up the Birth-Death Skyline analysis

TODO

### Questions

Do the Birth-Death Skyline results agree with the Coalescent Bayesian Skyline results? 
How would your conclusions from the two analyses differ? (Hint: Use R to plot the results from both analyses).

## Some considerations for using skyline plots

Both the coalescent and the birth-death skylines assume that the population is well-mixed. 
That is, they assume that there is no significant population structure and that the sequences are a random sample from the population. 
However, if there is population structure, 
for instance sequences were sampled from two different villages and there is much more contact within than between villages, 
then the results will be biased (Heller, Chikhi, & Siegismund, 2013). 
Instead a structured model should then be used to account for these biases.

## Useful Links

Bayesian Evolutionary Analysis with BEAST 2 (Drummond & Bouckaert, 2014)
BEAST 2 website and documentation: http://www.beast2.org/
Join the BEAST user discussion: http://groups.google.com/group/beast-users
[bdskytools](https://github.com/laduplessis/bdskytools): An R-package for post-processing Birth-Death Skyline analyses
[TreeSlicer](https://github.com/laduplessis/skylinetools/wiki/TreeSlicer): A BEAST2 package (in development) that makes it easier to specify complex change-point times using BDSKY

## Relevant References

* Drummond, A. J., Rambaut, A., Shapiro, B., & Pybus, O. G. (2005). Bayesian coalescent inference of past population dynamics from molecular sequences. Molecular Biology and Evolution, 22(5), 1185–1192. https://doi.org/10.1093/molbev/msi103
* Stadler, T., Kuhnert, D., Bonhoeffer, S., & Drummond, A. J. (2013). Birth-death skyline plot reveals temporal changes of epidemic spread in HIV and hepatitis C virus (HCV). Proceedings of the National Academy of Sciences, 110(1), 228–233. https://doi.org/10.1073/pnas.1207965110
* Bouckaert, R., Heled, J., Kühnert, D., Vaughan, T., Wu, C.-H., Xie, D., … Drummond, A. J. (2014). BEAST 2: a software platform for Bayesian evolutionary analysis. PLoS Computational Biology, 10(4), e1003537. https://doi.org/10.1371/journal.pcbi.1003537
* Bouckaert, R., Vaughan, T. G., Barido-Sottani, J., Duchêne, S., Fourment, M., Gavryushkina, A., … Drummond, A. J. (2019). BEAST 2.5: An advanced software platform for Bayesian evolutionary analysis. PLOS Computational Biology, 15(4).
* Ray, S. Ê. C., Arthur, R. Ê. R., Carella, A., Bukh, J., & Thomas, D. Ê. L. (2000). Genetic Epidemiology of Hepatitis C Virus throughout Egypt. The Journal of Infectious Diseases, 182(3), 698–707. https://doi.org/10.1086/315786
* Pybus, O. G., Drummond, A. J., Nakano, T., Robertson, B. H., & Rambaut, A. (2003). The Epidemiology and Iatrogenic Transmission of Hepatitis C Virus in Egypt: A Bayesian Coalescent Approach. Molecular Biology and Evolution, 20(3), 381–387. https://doi.org/10.1093/molbev/msg043
* Pybus, O. G., Charleston, M. A., Gupta, S., Rambaut, A., Holmes, E. C., Harvey, P. H., … Felsenstein, J. (2001). The epidemic behavior of the hepatitis C virus. Science (New York, N.Y.), 292(5525), 2323–2325. https://doi.org/10.1126/science.1058321
* Rosenberg, N. A., & Nordborg, M. (2002). Genealogical trees, coalescent theory and the analysis of genetic polymorphisms. Nature Reviews Genetics, 3(5).
* Pybus, O. G., Rambaut, A., & Harvey, P. H. (2000). An Integrated Framework for the Inference of Viral Population History From Reconstructed Genealogies. Genetics, 155(3).
* Heled, J., & Drummond, A. J. (2008). Bayesian inference of population size history from multiple loci. BMC Evolutionary Biology, 8(1), 289. https://doi.org/10.1186/1471-2148-8-289
* Minin, V. N., Bloomquist, E. W., & Suchard, M. A. (2008). Smooth skyride through a rough skyline: Bayesian coalescent-based inference of population dynamics. Molecular Biology and Evolution, 25(7), 1459–1471. https://doi.org/10.1093/molbev/msn090
* Heller, R., Chikhi, L., & Siegismund, H. R. (2013). The confounding effect of population structure on Bayesian skyline plot inferences of demographic history. PloS One, 8(5), e62992. https://doi.org/10.1371/journal.pone.0062992
* Drummond, A. J., & Bouckaert, R. R. (2014). Bayesian evolutionary analysis with BEAST 2. Cambridge University Press.
