---
layout: page
title: Bayesian Skyline Plots
author: 'LinguaPhylo core team'
permalink: /tutorials/skyline-plots/
---

This tutorial is modified from Taming the BEAST tutorial 
[Skyline plots](https://taming-the-beast.org/tutorials/Skyline-plots/).

If you haven't installed LPhy Studio and LPhyBEAST yet, please refer to the 
[User Manual](/setup) for their installation. 
Additionally, this tutorial requires other third-party programs, 
which are listed below under the section 
[Programs used in this tutorial](#programs-used-in-this-tutorial). 

Population dynamics influence the shape of the tree and consequently, 
the shape of the tree contains some information about past population dynamics. 
The so-called Skyline methods allow to extract this information from phylogenetic trees in a non-parametric manner. 
It is non-parametric since there is no underlying system of differential equations governing the inference of these dynamics. 

In this tutorial we will look at a popular coalescent method, 
the Coalescent Bayesian Skyline plot ([Drummond, Rambaut, Shapiro, & Pybus, 2005](https://academic.oup.com/mbe/article/22/5/1185/1066885)), to infer these dynamics from sequence data. 

## Background: Classic and Generalized Plots

[(Drummond, Rambaut, Shapiro, & Pybus, 2005)](https://academic.oup.com/mbe/article/22/5/1185/1066885) 
explained these concepts in the figure below:

[//]: # (Figure 1)
{% assign current_fig_num = 1 %} 

{% assign bs1_fig_num = "Figure " | append: current_fig_num  %}

<figure class="image" id="bs1_fig">
  <img src="BS1.png" alt="Bayesian Skyline">
  <figcaption>{{ bs1_fig_num }}: the classic and generalized Coalescent Bayesian Skyline plots</figcaption>
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

## The NEXUS alignment

{% include_relative templates/locate-data.md df='hcv' 
                    df_link='https://raw.githubusercontent.com/LinguaPhylo/linguaPhylo/master/tutorials/data/hcv.nexus' %}

The dataset consists of an alignment of 63 Hepatitis C sequences sampled in 1993 in Egypt ([Ray, Arthur, Carella, Bukh, & Thomas, 2000](#references)). 
This dataset has been used previously to test the performance of skyline methods ([Drummond, Rambaut, Shapiro, & Pybus, 2005, and Stadler, Kuhnert, Bonhoeffer, & Drummond, 2013](#references)).

{% assign current_fig_num = current_fig_num | plus: 1 %}

{% assign pop_fig_num = "Figure " | append: current_fig_num  %}

With an estimated 15-25%, Egypt has the highest Hepatits C prevalence in the world. 
In the mid 20th century, the prevalence of Hepatitis C increased drastically 
(see {{ pop_fig_num }} for estimates).
We will try to infer this increase from sequence data.

<figure class="image">
  <img src="Estimated_number_hcv.png" alt="The growth of the effective population size of the Hepatitis C epidemic in Egypt">
  <figcaption>{{ pop_fig_num }}: the growth of the effective population size of the Hepatitis C epidemic in Egypt (Pybus, Drummond, Nakano, Robertson, & Rambaut, 2003).</figcaption>
</figure>


## Inputting the script into LPhy Studio

{% include_relative templates/lphy-scripts.md %}

{% assign current_fig_num = current_fig_num | plus: 1 %}
{% assign lphy_fig = "Figure " | append: current_fig_num  %}

## Code

{% capture lphy_html %}
{% include_relative skyline-plots/lphy.html %}
{% endcapture %}

{::nomarkdown}
  {{ lphy_html }}
{:/}

[//]: # (## Graphical Model)
{% include_relative skyline-plots/lphy.md fignum=lphy_fig %}


### Data block

{% include_relative templates/lphy-data.md %}

In the script, `taxa` and `L` respectively stores the taxa from the alignment `D` and the length of `D`.
`numGroups = 4` sets the number of grouped intervals in the generalized Coalescent Bayesian Skyline plots, 
and `w` defines `n − 1` effective population sizes, which is the same number of times at which coalescent events occur. 

### Model block

{% include_relative templates/lphy-model.md %}

In this analysis, we will use the GTR model, 
which is the most general reversible model and estimates transition probabilities between individual nucleotides separately. 
That means that the transition probabilities between e.g. **A** and **T** will be inferred separately to the ones between **A** and **C**, 
however transition probabilities from **A** to **C** will be the same as **C** to **A** etc. 
The nucleotide equilibrium state frequencies _π_ are estimated here.

{% include_relative templates/rate-heterogeneity.md shape='shape' %}

As explained in (Yang, 2006), the shape parameter α is inversely related to the extent of rate variation at sites. 
If α > 1, the distribution is bell-shaped, meaning that most sites have intermediate rates around 1, while few sites have either very low or very high rates. 
In particular, when α → ∞, the distribution degenerates into the model of a single rate for all sites. 
If α ≤ 1, the distribution has a highly skewed L-shape, meaning that most sites have very low rates of substitution or are nearly 'invariable', 
but there are some substitution hotspots with high rates. 

{% assign current_fig_num = current_fig_num | plus: 1 %}

<figure class="image">
  <img src="DiscGamma.png" alt="discretized gamma">
  <figcaption>Figure {{ current_fig_num }}: (Yang 2006, Fig. 1.6) Probability density function of the gamma distribution for variable rates among sites. 
  The scale parameter of the distribution is fixed so that the mean is 1; 
  as a result, the density involves only the shape parameters α. 
  The x-axis is the substitution rate, while the y-axis is proportional to the number of sites with that rate.</figcaption>
</figure>


The sequences were all sampled in 1993 so we are dealing with a homochronous alignment and do not need to specify tip dates.

Because our sequences are contemporaneous (homochronous data), there is no information in our dataset to estimate the clock rate. 
We will use an estimate inferred in [Pybus et al., 2001](#references) to fix the clock rate. 
In this case all the samples were contemporaneous (sampled at the same time) and the clock rate is simply 
a scaling of the estimated tree branch lengths (in substitutions/site) into calendar time.

So, let's set the clock rate _$\mu$_ to 0.00079 s/s/y

In addition, we define the priors for the following parameters:
1. the vector of effective population sizes _Θ_;  
2. the relative rates of the GTR process _rates_; 
3. the base frequencies _π_;
4. the shape of the discretized gamma distribution _$\gamma$_.

Here we setup a Markov chain of effective population sizes using `ExpMarkovChain`, 
and apply a `LogNormal` distribution to the first value of the chain.
Please note that the first value _Θ1_ is measured from the tips according to 
([Drummond, Rambaut, Shapiro, & Pybus, 2005](https://academic.oup.com/mbe/article/22/5/1185/1066885)).
The vector of group sizes `A` are positive integers randomly sampled by the function `RandomComposition` 
where the vector's dimension equals to a constant `numGroups`, 
and they should sum to the number of coalescent events `w`.


### Questions


1. What are `numGroups` and `w` according to the [{{ bs1_fig_num }}](#bs1_fig)?
And how to compute the number of coalescent events given the number of taxa?

2. How to change the above LPhy scripts to use the classic Skyline coalescent?

Tips: by default all group sizes in SkylineCoalescent function are 1 which is equivalent to the classic skyline coalescent.



## Producing BEAST XML using LPhyBEAST

{% include_relative templates/lphy-beast.md args="-l 40000000 " lphy="hcv_coal" %}

The `-l` option allows you to modify the MCMC chain length in the XML, 
which is set to the default of 1 million.

## Running BEAST

{% include_relative templates/run-beast.md xml="hcv_coal.xml" %}

```
                        BEAST v2.7.8, 2002-2025
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

Random number seed: 1690761608289

    ...

    ...
       38000000     -6682.0050     -6201.7299      -480.2750         0.1921         0.3048         0.2408         0.2621         0.0571         0.3585         0.0448         0.0230         0.4713         0.0451         0.3280             11              2             37             12      9413.8662      4976.3181       227.2886       431.5181 1m23s/Msamples
       40000000     -6625.8487     -6178.0316      -447.8170         0.1904         0.3316         0.2480         0.2298         0.0579         0.3502         0.0629         0.0258         0.4559         0.0471         0.4004              9             47              4              2     11386.5587       188.1198       317.8618        48.4388 1m23s/Msamples

Operator                                                                                    Tuning    #accept    #reject      Pr(m)  Pr(acc|m)
beast.base.inference.operator.kernel.BactrianDeltaExchangeOperator(A.deltaExchange)        2.49956     263985     683360    0.02368    0.27866
kernel.BactrianScaleOperator(Theta.scale)                                                  0.66248     355150     801911    0.02896    0.30694
kernel.BactrianScaleOperator(gamma.scale)                                                  0.16866     129408     309379    0.01097    0.29492
beast.base.inference.operator.kernel.BactrianDeltaExchangeOperator(pi.deltaExchange)       0.04474     271745     674029    0.02368    0.28733
EpochFlexOperator(psi.BICEPSEpochAll)                                                      0.25113     280127     432406    0.01783    0.39314
EpochFlexOperator(psi.BICEPSEpochTop)                                                      0.25252     171950     266858    0.01097    0.39186
TreeStretchOperator(psi.BICEPSTreeFlex)                                                    0.09311    3149381    4743648    0.19725    0.39901
Exchange(psi.narrowExchange)                                                                     -    3173854    4718140    0.19725    0.40216
kernel.BactrianScaleOperator(psi.rootAgeScale)                                             0.26334      25933     412407    0.01097    0.05916 Try setting scale factor to about 0.132
kernel.BactrianSubtreeSlide(psi.subtreeSlide)                                             15.42851    1268695    6615536    0.19725    0.16092
kernel.BactrianNodeOperator(psi.uniform)                                                   1.94902    2462884    5429179    0.19725    0.31207
Exchange(psi.wideExchange)                                                                       -       8636     993577    0.02505    0.00862
WilsonBalding(psi.wilsonBalding)                                                                 -      14557     986842    0.02505    0.01454
beast.base.inference.operator.kernel.BactrianDeltaExchangeOperator(rates.deltaExchange)    0.19638       8125    1348299    0.03385    0.00599 Try setting delta to about 0.098

     Tuning: The value of the operator's tuning parameter, or '-' if the operator can't be optimized.
    #accept: The total number of times a proposal by this operator has been accepted.
    #reject: The total number of times a proposal by this operator has been rejected.
      Pr(m): The probability this operator is chosen in a step of the MCMC (i.e. the normalized weight).
  Pr(acc|m): The acceptance probability (#accept as a fraction of the total proposals for this operator).


Total calculation time: 3358.018 seconds
Done!

```

## Analysing the BEAST output

{% assign current_fig_num = current_fig_num | plus: 1 %}

{%- include_relative templates/tracer.md logfile="hcv_coal" fignum=current_fig_num -%}


For the reconstruction of the population dynamics, we need two files, the `hcv_coal.log` file and the `hcv_coal.trees` file. 
The log file contains the information about the group sizes and population sizes of each segment, 
while the trees file is needed for the times of the coalescent events.

Navigate to **Analysis > Bayesian Skyline Reconstruction**. 
From there open the tree log file. To get the correct dates in the analysis we should specify the `Age of the youngest tip`. 
In our case it is 1993, the year where all the samples were taken. 
If the sequences were sampled at different times (heterochronous data), 
the age of the youngest tip is the time when the most recent sample was collected.

Press **OK** to reconstruct the past population dynamics.

{% assign current_fig_num = current_fig_num | plus: 1 %}

<figure class="image">
  <img src="BSAnalysis.png" alt="Reconstructing the Bayesian Skyline plot">
  <figcaption>Figure {{ current_fig_num }}: reconstructing the Bayesian Skyline plot in Tracer.</figcaption>
</figure>

The output will have the years on the x-axis and the effective population size on the y-axis. 
By default, the y-axis is on a log-scale. 
If everything worked as it is supposed to work you will see a sharp increase in the effective population size in the mid 20th century, 
similar to what is seen below.

Note that the reconstruction will only work if the *.log and *.trees files contain the same number of states 
and both files were logged at the same frequency.

{% assign current_fig_num = current_fig_num | plus: 1 %}

<figure class="image">
  <img src="BSplot.png" alt="Coalescent Bayesian Skyline plot">
  <figcaption>Figure {{ current_fig_num }}: Bayesian Skyline analysis output. 
  The black line is the median estimate of the estimated effective population size (can be changed to the mean estimate). 
  The two blue lines are the upper and lower bounds of the 95% HPD interval. 
  The x-axis is the time in years and the y-axis is on a log-scale.</figcaption>
</figure>

There are two ways to save the analysis, it can either be saved as a PDF file for displaying purposes or as a tab delimited file.

Navigate to **File > Export Data Table**. Enter the filename as `hcv_coal.tsv` and save the file.
The exported file will have five rows, the time, the mean, median, lower and upper boundary of the 95% HPD interval of the estimates, 
which you can use to plot the data with other software (R, Matlab, etc).


### The parameterization and choosing the dimension

Please read the section of "The Coalescent Bayesian Skyline parameterization" and "Choosing the Dimension" from 
Taming the BEAST tutorial [Skyline plots](https://taming-the-beast.org/tutorials/Skyline-plots/).



### Questions

1. How to choose the dimension for the Bayesian skyline analysis? 
   How does the number of dimensions of effective population sizes affect the result?

2. What are the alternative models to deal with this dimension problem?

3. What does the Bayesian skyline plot in this analysis tell you? 


## Some considerations for using skyline plots

In the coalescent, the time is modeled to go backwards, from present to past.

The coalescent skylines assume that the population is well-mixed. 
That is, they assume that there is no significant population structure and that the sequences are a random sample from the population. 
However, if there is population structure, 
for instance sequences were sampled from two different villages and there is much more contact within than between villages, 
then the results will be biased (Heller, Chikhi, & Siegismund, 2013). 
Instead a structured model should then be used to account for these biases.


## Programs used in this tutorial

{% include_relative templates/programs-used.md %}
* BEAST SSM (standard substitution models) package - this BEAST 2 package contains 
  the following standard time-reversible substitution models: 
  JC, F81, K80, HKY, TrNf, TrN, TPM1, TPM1f, TPM2, TPM2f, TPM3, TPM3f, 
  TIM1, TIM1f, TIM2, TIM2f, TIM3 , TIM3f, TVMf, TVM, SYM, GTR.


[//]: # (## Data, Model, Posterior)
{% include_relative skyline-plots/narrative.md %}

## XML and log files

- [hcv_coal.xml](hcv/hcv_coal.xml)
- [hcv_coal.log](hcv/hcv_coal.log)
- [hcv_coal.trees](hcv/hcv_coal.trees)
- summarised tree [hcv_coal.tree](hcv/hcv_coal.tree)

## Useful Links

{% include_relative templates/links.md %}

## References

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
