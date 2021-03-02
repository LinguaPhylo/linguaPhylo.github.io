---
layout: page
title: Time-stamped data
author: 'Walter Xie and Alexei Drummond'
permalink: /tutorials/time-stamped-data/
---

This tutorial is modified from Taming the BEAST tutorial [Time-stamped data](https://taming-the-beast.org/tutorials/MEP-tutorial/).

This tutorial estimates the rate of evolution from a set of virus sequences which have been isolated 
at different points in time (heterochronous or time-stamped data). 
The data are 129 sequences from the G (attachment protein) gene of human respiratory syncytial virus 
subgroup A (RSVA) ([Zlateva et al., 2004; Zlateva et al., 2005](#references)), 
with isolation dates ranging from 1956-2002. 
RSVA causes infections of the lower respiratory tract causing symptoms that are often indistinguishable from the common cold. 
By age 3, nearly all children will be infected and a small percentage (<3%) will develop more serious inflammation 
of the bronchioles requiring hospitalisation.

The aim of this tutorial is to obtain estimates for:

* the rate of molecular evolution
* the date of the most recent common ancestor
* the phylogenetic relationships with measures of statistical support.

The programs used in this tutorial are listed in [the later section](#programs-used-in-this-exercise).

## The NEXUS alignment

{% include_relative download-data.md df='RSV2' df_link='https://raw.githubusercontent.com/CompEvol/beast2/master/examples/nexus/RSV2.nex' %}
It is also available in the examples/nexus folder where BEAST 2 was installed. 


### Multiple partitions

This file contains an alignment of 129 sequences from the G gene of RSVA virus, 629 nucleotides in length. 
Because this is a protein-coding gene we are going to split the alignment into three partitions representing 
each of the three codon positions. 

As it is fitting into the reading frame 3, we will use the charset expressions supported by Nexus format. 
For example, `"3-629\3"` means the 1st codon partition (codon0) starts from the 3rd site and takes every 3 sites until the last site 629.  


### Tip dates

{% include_relative tip-dates-forward.md  earliest='the 1950s' 
                    date_in_name='after the last little `s`' 
                    since='1900' regex='s(\d+)$' last='2002' %}

{% include_relative age-direction.md %}


## Constructing the scripts in LPhy Studio

{% include_relative lphy-scripts.md %}

{::nomarkdown}
{% include_relative time-stamped-data/lphy.html %}
{:/}

{% include_relative lphy-studio.md lphy="RSV2" fignum="Figure 1" %}


### Data block

{% include_relative lphy-data.md %}


### Model block

{% include_relative lphy-model.md %}

In this analysis, we will use three HKY models with estimated frequencies for each of three partitions, 
and share the strict clock model and a Kingman coalescent tree generative distribution across partitions. 
But we are also interested about the relative substitution rate for each of three partitions.

So, we define the priors for the following parameters:
1. the effective population size _Θ_;  
2. the general clock rate _clockRate_;
3. the relative substitution rates _mu_ which has 3 dimensions;
4. the transition/transversion ratio _kappa_ which also has 3 dimensions;
5. the base frequencies _pi_. 

The script `n=length(codon);` is equivalent to `n=3;`, since `codon` is a 3-partition alignment.
Here `rep(element=1.0, times=n)` will create an array of `n` 1.0, which is `[1.0, 1.0, 1.0]`.

The benefit of using 3 relative substitution rates here instead of 3 clock rates is that we could use the DeltaExchangeOperator
to these relative rates in the MCMC sampling to help the converagence.

Please note the tree here is already the time tree, the age direction will have been processed in `data` block.


## Producing BEAST XML using LPhyBEAST

{% include_relative lphy-beast.md lphy="RSV2" nex="RSV2" %}

```
java -jar LPhyBEAST.jar RSV2.lphy
```


## Running BEAST

<figure class="image">
  <img src="outercore.png" alt="Package manager">
  <figcaption>Figure 2: A screenshot of Package Manager.</figcaption>
</figure>

{% include_relative run-beast.md xml="RSV2.xml" %}

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

Random number seed: 1606877948587

Loading package outercore v0.0.2
Loading package BEAST v2.6.3
Loading package feast v7.4.1
Loading package BEASTLabs v1.9.5

    ...

    ...
         950000     -6094.1096     -5484.0922      -610.0174         0.5094         0.2442         0.0894         0.1568         0.3010         0.3966         0.1027         0.1995         0.2722         0.3886         0.0851         0.2539         9.7698         5.0391         4.2272         0.6469         0.8952         1.4562         0.0021        37.3474 1m36s/Msamples
        1000000     -6075.3591     -5478.9020      -596.4570         0.4658         0.2564         0.0861         0.1915         0.3125         0.4146         0.0913         0.1815         0.3025         0.4006         0.0855         0.2113         9.2114         3.1324         1.9866         0.6728         0.9698         1.3557         0.0022        36.6162 1m36s/Msamples

Operator                                       Tuning    #accept    #reject      Pr(m)  Pr(acc|m)
ScaleOperator(Theta.scale)                    0.58239       1207       3283    0.00450    0.26882 
ScaleOperator(clockRate.scale)                0.78079       1058       3397    0.00450    0.23749 
UpDownOperator(clockRateUppsiDownOperator)    0.96403       9317     125474    0.13497    0.06912 Try setting scaleFactor to about 0.982
ScaleOperator(kappa.scale)                    0.32448       3419       6453    0.00970    0.34633 
DeltaExchangeOperator(mu.deltaExchange)       0.28169       1805       5653    0.00730    0.24202 
DeltaExchangeOperator(pi.0.deltaExchange)     0.12426       1752       7956    0.00970    0.18047 
DeltaExchangeOperator(pi.1.deltaExchange)     0.11379       1793       7797    0.00970    0.18697 
DeltaExchangeOperator(pi.2.deltaExchange)     0.11328       1653       8173    0.00970    0.16823 
Exchange(psi.narrowExchange)                        -      33880     100180    0.13424    0.25272 
ScaleOperator(psi.rootAgeScale)               0.79310        740       3769    0.00450    0.16412 
ScaleOperator(psi.scale)                      0.91379       3512     130439    0.13424    0.02622 Try setting scaleFactor to about 0.956
SubtreeSlide(psi.subtreeSlide)               19.04414       4120     130833    0.13424    0.03053 Try decreasing size to about 9.522
Uniform(psi.uniform)                                -      72073      61925    0.13424    0.53787 
Exchange(psi.wideExchange)                          -        361     133824    0.13424    0.00269 
WilsonBalding(psi.wilsonBalding)                    -        816     133339    0.13424    0.00608 

     Tuning: The value of the operator's tuning parameter, or '-' if the operator can't be optimized.
    #accept: The total number of times a proposal by this operator has been accepted.
    #reject: The total number of times a proposal by this operator has been rejected.
      Pr(m): The probability this operator is chosen in a step of the MCMC (i.e. the normalized weight).
  Pr(acc|m): The acceptance probability (#accept as a fraction of the total proposals for this operator).


Total calculation time: 96.711 seconds
End likelihood: -6075.359137869203
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
  <figcaption>Figure 3: A screenshot of Tracer.</figcaption>
</figure>


Here you can see how the samples are correlated. 
The default chain length of the MCMC is 1,000,000 in `LPhyBEAST`.
There are 1800 samples in the trace after removing 10% burnin (we ran the MCMC for steps sampling every 500) 
but adjacent samples often tend to have similar values. 
The ESS for the absolute rate of evolution (clockRate) is about 17 so we are only getting 1 independent sample 
to every 105 ~ 1800/17 actual samples). With a short run such as this one, 
it may also be the case that the default burn-in of 10% of the chain length is inadequate. 
Not excluding enough of the start of the chain as burn-in will render estimates of ESS unreliable.

The simple response to this situation is that we need to run the chain for longer. 
So let’s go for a chain length of 15,000,000 but keep logging the same number of samples (2,000). 

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
  <figcaption>Figure 4: A screenshot of Tracer.</figcaption>
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
  <figcaption>Figure 5: The marginal density in Tracer.</figcaption>
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
  <figcaption>Figure 6: The posterior probability densities for the relative substitution rates.</figcaption>
</figure>


## Summarising the trees

{% include_relative tree-annotator.md fignum="Figure 7" %}


Summary trees can be viewed using FigTree (a program separate from BEAST) and DensiTree (distributed with BEAST).

<figure class="image">
  <img src="RSV2.tree.svg" alt="MCC tree">
  <figcaption>Figure 8: The Maximum clade credibility tree for the G gene of 129 RSVA-2 viral samples.</figcaption>
</figure>


Below a DensiTree with clade height bars for clades with over 50% support. Root canal tree represents maximum clade credibility tree.

<figure class="image">
  <img src="DensiTree.png" alt="MCC tree">
  <figcaption>Figure 9: The posterior tree set visualised in DensiTree.</figcaption>
</figure>


## Questions

In what year did the common ancestor of all RSVA viruses sampled live? What is the 95% HPD?


## Programs used in this Exercise

{% include_relative programs-used.md %}

## Useful Links

{% include_relative links.md %}


## References

* Zlateva, K. T., Lemey, P., Vandamme, A.-M., & Van Ranst, M. (2004). Molecular evolution and circulation patterns of human respiratory syncytial virus subgroup a: positively selected sites in the attachment g glycoprotein. J Virol, 78(9), 4675–4683.
* Zlateva, K. T., Lemey, P., Moës, E., Vandamme, A.-M., & Van Ranst, M. (2005). Genetic variability and molecular evolution of the human respiratory syncytial virus subgroup B attachment G protein. J Virol, 79(14), 9157–9167. https://doi.org/10.1128/JVI.79.14.9157-9167.2005
* Drummond, A. J., & Bouckaert, R. R. (2014). Bayesian evolutionary analysis with BEAST 2. Cambridge University Press.
