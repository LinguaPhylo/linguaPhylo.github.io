---
layout: page
title: Bayesian Skyline Plots
author: 'Walter Xie and Alexei Drummond'
permalink: /tutorials/skyline-plots/
---

This tutorial is modified from Taming the BEAST tutorial [Skyline plots](https://taming-the-beast.org/tutorials/Skyline-plots/).

Population dynamics influence the shape of the tree and consequently, 
the shape of the tree contains some information about past population dynamics. 
The so-called Skyline methods allow to extract this information from phylogenetic trees in a non-parametric manner. 
It is non-parametric since there is no underlying system of differential equations governing the inference of these dynamics. 

In this tutorial we will look at a popular coalescent method, 
the Coalescent Bayesian Skyline plot (Drummond, Rambaut, Shapiro, & Pybus, 2005), to infer these dynamics from sequence data. 

## Programs used in this Exercise

{% include_relative programs-used.md %}
* BEAST SSM (standard substitution models) package - containing the following standard time-reversible substitution models: 
  JC, F81, K80, HKY, TrNf, TrN, TPM1, TPM1f, TPM2, TPM2f, TPM3, TPM3f, TIM1, TIM1f, TIM2, TIM2f, TIM3 , TIM3f, TVMf, TVM, SYM, GTR.


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
  <figcaption>Figure 1: the growth of the effective population size of the Hepatitis C epidemic in Egypt (Pybus, Drummond, Nakano, Robertson, & Rambaut, 2003).</figcaption>
</figure>


### Constructing the data block in LinguaPhylo

{% include_relative lphy-data.md %}

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
  <figcaption>Figure 2: the classic and generalized Coalescent Bayesian Skyline plots</figcaption>
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


### Constructing the model block in LinguaPhylo

In this analysis, we will use the GTR model, 
which is the most general reversible model and estimates transition probabilities between individual nucleotides separately. 
That means that the transition probabilities between e.g. **A** and **T** will be inferred separately to the ones between **A** and **C**, 
however transition probabilities from **A** to **C** will be the same as **C** to **A** etc. 
The nucleotide equilibrium state frequencies _π_ are estimated here.

Additionally, we allow for rate heterogeneity among sites. 
We do this by approximating the continuous rate distribution (for each site in the alignment) with a discretized gamma probability distribution (mean = 1), 
where the number of bins in the discretization `ncat = 4` (normally between 4 and 6).
We are going to estimate the _shape_ parameter in this analysis.

As explained in (Yang, 2006), the shape parameter α is inversely related to the extent of rate variation at sites. 
If α > 1, the distribution is bell-shaped, meaning that most sites have intermediate rates around 1, while few sites have either very low or very high rates. 
In particular, when α → ∞, the distribution degenerates into the model of a single rate for all sites. 
If α ≤ 1, the distribution has a highly skewed L-shape, meaning that most sites have very low rates of substitution or are nearly 'invariable', 
but there are some substitution hotspots with high rates. 

<figure class="image">
  <img src="DiscGamma.png" alt="discretized gamma">
  <figcaption>Figure 3: (Yang 2006, Fig. 1.6) Probability density function of the gamma distribution for variable rates among sites. 
  The scale parameter of the distribution is fixed so that the mean is 1; 
  as a result, the density involves only the shape parameters α. 
  The x-axis is the substitution rate, while the y-axis is proportional to the number of sites with that rate.</figcaption>
</figure>


The sequences were all sampled in 1993 so we are dealing with a homochronous alignment and do not need to specify tip dates.

Because our sequences are contemporaneous (homochronous data), there is no information in our dataset to estimate the clock rate. 
We will use an estimate inferred in (Pybus et al., 2001) to fix the clock rate. 
In this case all the samples were contemporaneous (sampled at the same time) and the clock rate is simply 
a scaling of the estimated tree branch lengths (in substitutions/site) into calendar time.

So, let's set the clock rate _mu_ to 0.00079 s/s/y

In addition, we define the priors for the following parameters:
1. the vector of effective population sizes _Θ_;  
2. the relative rates of the GTR process _rates_; 
3. the base frequencies _π_;
4. the shape of the discretized gamma distribution _shape_.

Here we setup a Markov chain of effective population sizes using `ExpMarkovChain`, 
and apply a `LogNormal` distribution to the mean of the exponential from which the first value of the chain is drawn.
The `groupSizes` are positive integers randomly sampled by `RandomComposition` with the dimension of `numGroups`, 
and they should sum to the number of coalescent intervals.

{% include_relative lphy-model.md %}

```
model {
  π ~ Dirichlet(conc=[3.0,3.0,3.0,3.0]);
  rates ~ Dirichlet(conc=[1.0, 2.0, 1.0, 1.0, 2.0, 1.0]);
  Q = gtr(freq=π, rates=rates);

  firstValue ~ LogNormal(meanlog=9.0, sdlog=2.0);
  Θ ~ ExpMarkovChain(firstValue=firstValue, n=numGroups);
  groupSizes ~ RandomComposition(n=w, k=numGroups);
  ψ ~ SkylineCoalescent(theta=Θ, taxa=taxa, groupSizes=groupSizes);

  shape ~ LogNormal(meanlog=0.0, sdlog=2.0);
  siteRates ~ DiscretizeGamma(shape=shape, ncat=4, reps=L);
  D ~ PhyloCTMC(siteRates=siteRates, Q=Q, tree=ψ, mu=0.00079);
}
```

### Questions

```
1. what does `numGroups = 4` and `w` define according to the Figure 2 (the classic and generalized Coalescent Bayesian Skyline plots)?

2. how to change the above LPhy scripts to use the classic Skyline coalescent?

Tips: by default all group sizes in SkylineCoalescent function are 1 which is equivalent to the classic skyline coalescent.
```

### LinguaPhylo Studio

{% include_relative lphy-studio.md lphy="hcv_coal" fignum="Figure 4" %}


## Producing BEAST XML using LPhyBEAST

{% include_relative lphy-beast.md lphy="hcv_coal" nex="hcv" %}

```
java -jar LPhyBEAST.jar -l 40000000 hcv_coal.lphy
```


## Running BEAST

{% include_relative run-beast.md xml="hcv_coal.xml" %}

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


File: hcv_coal.xml seed: 1605149965228 threads: 2
Loading package SSM v1.1.0
Loading package outercore v0.0.4
Loading package BEAST v2.6.3
Loading package feast v7.5.0
Loading package BEASTLabs v1.9.5

    ...

    ...
       38000000         0.1869         0.3096         0.2329         0.2704         0.0507         0.3462         0.0686         0.0216         0.4753         0.0372         0.3565              9             22             22              9      3378.5678       854.0057       142.1376       311.4791     -6642.4068     -6163.8252      -478.5815 1m18s/Msamples
       40000000         0.2025         0.3337         0.2202         0.2434         0.0474         0.3398         0.0639         0.0267         0.4794         0.0426         0.3401             10             11             30             11     10123.8192      1084.3743       109.4661       180.0131     -6639.6725     -6173.3816      -466.2909 1m18s/Msamples

Operator                                            Tuning    #accept    #reject      Pr(m)  Pr(acc|m)
ScaleOperator(Theta.scale)                         0.28866     231949     650369    0.02201    0.26289 
DeltaExchangeOperator(groupSizes.deltaExchange)    3.56191     156224     563888    0.01800    0.21694 
DeltaExchangeOperator(pi.deltaExchange)            0.07410     141834     578582    0.01800    0.19688 
Exchange(psi.narrowExchange)                             -    2445602    3550044    0.14993    0.40790 
ScaleOperator(psi.rootAgeScale)                    0.61922      52494     281016    0.00834    0.15740 
ScaleOperator(psi.scale)                           0.71280    1395832    4600588    0.14993    0.23278 
SubtreeSlide(psi.subtreeSlide)                    39.30440     848596    5144516    0.14993    0.14160 
Uniform(psi.uniform)                                     -    2404299    3592791    0.14993    0.40091 
Exchange(psi.wideExchange)                               -      51825    5945086    0.14993    0.00864 
WilsonBalding(psi.wilsonBalding)                         -      86203    5914844    0.14993    0.01436 
DeltaExchangeOperator(rates.deltaExchange)         0.07831     132447     897292    0.02573    0.12862 
ScaleOperator(shape.scale)                         0.63566      82106     251574    0.00834    0.24606 

     Tuning: The value of the operator's tuning parameter, or '-' if the operator can't be optimized.
    #accept: The total number of times a proposal by this operator has been accepted.
    #reject: The total number of times a proposal by this operator has been rejected.
      Pr(m): The probability this operator is chosen in a step of the MCMC (i.e. the normalized weight).
  Pr(acc|m): The acceptance probability (#accept as a fraction of the total proposals for this operator).


Total calculation time: 3112.102 seconds
End likelihood: -6639.672594349279
```

## Analysing the BEAST output

Because we shortened the chain most parameters have very low ESS values. 
If you like, you can compare your results with the example results we obtained with identical settings and 
a chain of 40,000,000 (hcv\_coal\.log).

<figure class="image">
  <img src="TreeHeight.png" alt="Tracer">
  <figcaption>Figure 5: a screenshot of Tracer.</figcaption>
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
  <img src="BSAnalysis.png" alt="Reconstructing the Bayesian Skyline plot">
  <figcaption>Figure 6: reconstructing the Bayesian Skyline plot in Tracer.</figcaption>
</figure>

The output will have the years on the x-axis and the effective population size on the y-axis. 
By default, the y-axis is on a log-scale. 
If everything worked as it is supposed to work you will see a sharp increase in the effective population size in the mid 20th century, 
similar to what is seen below.

Note that the reconstruction will only work if the *.log and *.trees files contain the same number of states 
and both files were logged at the same frequency.

<figure class="image">
  <img src="BSplot.png" alt="Coalescent Bayesian Skyline plot">
  <figcaption>Figure 7: Bayesian Skyline analysis output. 
  The black line is the median estimate of the estimated effective population size (can be changed to the mean estimate). 
  The two blue lines are the upper and lower bounds of the 95% HPD interval. 
  The x-axis is the time in years and the y-axis is on a log-scale.</figcaption>
</figure>

There are two ways to save the analysis, it can either be saved as a *.pdf for display purposes or as a tab delimited file.

Navigate to **File > Export Data Table**. Enter the filename as `hcv_coal.tsv` and save the file.
The exported file will have five rows, the time, the mean, median, lower and upper boundary of the 95% HPD interval of the estimates, 
which you can use to plot the data with other software (R, Matlab, etc).


### The parameterization and choosing the dimension

Please read the section of "The Coalescent Bayesian Skyline parameterization" and "Choosing the Dimension" from 
Taming the BEAST tutorial [Skyline plots](https://taming-the-beast.org/tutorials/Skyline-plots/).



### Questions

```
1. How to choose the dimension for the Coalescent Bayesian Skyline? 
   How does the number of dimensions of effective population sizes affect the result?

2. What are the alternative models to deal with this dimension problem?

3. What does the Bayesian Skyline plot in this analysis tell you? 

```

## Some considerations for using skyline plots

In the coalescent, the time is modeled to go backwards, from present to past.

The coalescent skylines assume that the population is well-mixed. 
That is, they assume that there is no significant population structure and that the sequences are a random sample from the population. 
However, if there is population structure, 
for instance sequences were sampled from two different villages and there is much more contact within than between villages, 
then the results will be biased (Heller, Chikhi, & Siegismund, 2013). 
Instead a structured model should then be used to account for these biases.

## Useful Links

{% include_relative links.md %}

## Relevant References

* Drummond, A. J., Rambaut, A., Shapiro, B., & Pybus, O. G. (2005). Bayesian coalescent inference of past population dynamics from molecular sequences. Molecular Biology and Evolution, 22(5), 1185–1192. https://doi.org/10.1093/molbev/msi103
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
