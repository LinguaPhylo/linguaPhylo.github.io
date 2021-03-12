---
layout: page
title: Time-stamped data
author: 'Fábio K. Mendes, Walter Xie and Alexei J. Drummond'
permalink: /tutorials/time-stamped-data/
---

This tutorial is modified from Taming the BEAST material.
You can find the source tutorial, data and author information
[here](https://taming-the-beast.org/tutorials/MEP-tutorial/).

## Requirements

The programs used in this tutorial are listed [below](#programs-used-in-this-exercise).
In case you have not done it yet, please follow the installation
instructions [here]() before moving on.

## Background

In this tutorial, we will study the __phylodynamics of the Respiratory
syncytial virus subgroup A (RSVA)__.
RSVA infects the human lower respiratory tract, causing symptoms that
are often indistinguishable from the common cold.
By age 3, nearly all children will be infected, and a small percentage
(<3%) will develop a more serious inflammation of the bronchioles
requiring hospitalisation.

## Goals

The goal of our phylodynamic analysis is to estimate:

* the rate of molecular evolution (of RSVA's G gene);
* the date of the most recent common ancestor (MRCA) of all viral
  samples (i.e., the tree's __root__), interpreted as the first
  infection event with respect to the samples at hand; 
* the phylogenetic relationships among viral samples.

## Data

Our data is comprised of 129 molecular sequences coding for RSVA's G
protein ([Zlateva et al., 2004; Zlateva et al., 2005](#references), a
glycoprotein that allows the virus to attach itself to the host cells'
membranes, starting the infection.
Importantly, our data is __time stamped__ (also referred to as
__heterochronous__ or __serial__ data) because it was collected at
multiple time points, from 1956--2002.

Below we further detail how we will treat our molecular data in our
analyses.

### The NEXUS alignment

{% include_relative download-data.md df='RSV2' df_link='https://raw.githubusercontent.com/CompEvol/beast2/master/examples/nexus/RSV2.nex' %}

This .nex file can also be found in the ```examples/nexus``` folder,
where BEAST 2 was installed.

#### Multiple partitions

Our molecular alignment corresponds to a 629-bp coding sequence of
RSVA's G protein.
We are going to partition our alignment into three compartments
corresponding to the first, second and third codon positions.

### Tip dates

{% include_relative tip-dates-forward.md  earliest='the 1950s' 
                    date_in_name='after the last lower-case `s`' 
                    since='1900' %}
					
{% include_relative age-direction.md %}

## Constructing the scripts in LPhy Studio

{% include_relative lphy-scripts.md %}

### Data block

{% include_relative lphy-data.md %}

{::nomarkdown}
{% include_relative time-stamped-data/lphy_datablock.html %}
{:/}
  
Our data here consist of molecular alignments and the sample dates.

We start by parsing the latter with regular expression `"s(\d+)"` when
defining some options in `options={}`.
This tells LPhy how to extract the sample times from the NEXUS file,
and then we specify that we want to read those times as dates (i.e.,
__forward__ in time).
After all, our sample times are given to us in natural time.

In order to check if you have set the sample times correctly, click
the graphical component `taxa` and check the column "Age". 
The most recent sequences (i.e., from 2002 and that end with `s102`)
should have an age of 0.0, while all other tips should be > 0.0.
This is because, as mentioned above, LPhy __always__ treats sample
times as __ages__.

Then we must parse the molecular alignments, which we do when
initializing variable `D`.
Note that our open reading frame (ORF) starts in position 3, which
must be reflected by the arguments we pass on to the `charset()`
function: first (`"3-629\3"`), second (`"1-629\3"`) and third
(`"2-629\3"`) codon positions.
Finally, we use the last three lines to set the number of loci `L`,
the number of taxa `n`, and the taxa themselves, `taxa`.
Note that `n=length(codon);` is equivalent to `n=3;` because
`length()` here is extracting the number of partitions in `codon`.

If you want to double check everything you have typed, click the
"Model" tab in the upper right panel.

### Model block

{% include_relative lphy-model.md %}

We will specify sampling distributions for the following parameters, in
this order:
1. `π`, the equilibrium nucleotide frequencies (with 4 dimensions, one
for each nucleotide);  
2. `κ`, twice the transition:transversion bias assuming equal
   nucleotide frequencies (with 3 dimensions,
   one for each partition);  
3. `μ`, the relative substitution rates (with 3 dimensions, one for
   each partition);  
4. `r`, the global (mean) clock rate;  
5. `Θ`, the effective population size (with as many dimensions as
   there are branches in the tree);  
6. `φ`, the time-scaled (i.e., in absolute time) phylogenetic tree.

{::nomarkdown}
{% include_relative time-stamped-data/lphy_modelblock.html %}
{:/}

Note that parameters `π`, `κ` and `μ` are 3-dimensional vectors,
because they represent the nucleotide equilibrium frequencies,
(ts:tv)/2, and relative substitution rates of each of the three
partitions, respectively.
LPhy conveniently uses vectorization, so `PhyloCTMC` recognizes that
three parameters above are vectors, and automatically takes care of
building three separate HKY models, one per partition!

One final remark is that we use `rep(element=1.0, times=n)` (where `n`
evaluates to 3) to create three concentration vectors (one vector per
partition) for the `WeightedDirichlet` sampling distribution.

If you want to double check everything you have typed, click the
“Model” tab in the upper right panel.

### The whole script

Let us look at the whole thing:

{::nomarkdown}
{% include_relative time-stamped-data/lphy.html %}
{:/}

{% include_relative lphy-studio.md lphy="RSV2" fignum="Figure 1" %}

## Phylogenetic inference with BEAST 2

{% include_relative lphy-inference-beast2.md software="BEAST 2" %}

### Producing a BEAST 2 .xml using LPhyBEAST

{% include_relative lphy-beast.md lphy="RSV2" nex="RSV2" %}

```
java -jar LPhyBEAST.jar RSV2.lphy
```

### Running BEAST 2

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

### Analysing BEAST 2's output

We start by opening the Tracer program, and dropping the "RSV2.log"
file onto Tracer's window.
Alternatively you can load the trace (.log) file by clicking "File" > "Import
Trace File...".

Tracer will display several summary statistics computed from the trace
file in the left-hand and top-right panels.
Other summaries will be displayed graphically.
It is all pretty self-evident, just click around to familiarize
yourself with the program.

The first thing you will notice from this first run is that the
effective sample sizes (ESSs) for many of the logged quantities are small 
(ESSs less than 100 will be highlighted in red by Tracer).
__This is not good__. 
A low ESS means that the trace contains a lot of correlated samples
and thus may not represent the posterior distribution well.
In the bottom-right panel you will see a histogram that looks a bit
rough.
This is expected when ESSs are low.

<figure class="image">
  <img src="short.png" alt="The trace of short run">
  <figcaption>Figure 3: A screenshot of Tracer.</figcaption>
</figure>

If you click the "Trace" tab in the upper-right corner, you will see
the raw trace, that is, the sampled values against the step in the
MCMC chain.

The trace shows the value of a given statistic for each sampled step
of the MCMC chain.
It will help you see if the chain is mixing well and to what extent
the samples are correlated. Here you can see how the samples are
correlated.
In LPhyBEAST, the default MCMC chain length is 1,000,000.
After we remove the burn-in (set to 10%), there will be 1,800 samples in
the trace (we ran the MCMC for steps sampling every 500), 
Note how adjacent samples often tend to have similar values – not
great.

The ESS for the mean molecular evolution rate (`r`) is about 17 so we
are only getting 1 independent sample every 105 samples (to a total of
~1800/17 "effective" samples).
With such a short run, it may also be the case that the default
burn-in of 10% of the chain length is inadequate.
Not excluding enough of the start of the chain as burn-in will render
estimates of ESS unreliable.

Let us try to fix this low ESS issue by running the MCMC chain for longer.
We will set the chain length to 15,000,000, but still log the same
number of samples (2,000).
This means we should log 15,000,000/2,000 samples, which can be
manually specified in the .xml file with `logEvery=7500`.

```
<run id="MCMC" spec="MCMC" chainLength="15000000" preBurnin="1480">
<logger id="Logger" spec="Logger" logEvery="750000">
<logger id="Logger1" spec="Logger" fileName="RSV2long.log" logEvery="7500">
<logger id="psi.treeLogger" spec="Logger" fileName="RSV2long.trees" logEvery="7500">
```

You can now run _LPhyBEAST_ again, this time with the `-l` argument
to create a new XML:

```
java -jar LPhyBEAST.jar -l 15000000 -o RSV2long.xml RSV2.lphy
```

Now run BEAST 2 again and load the new log file into Tracer (you can
leave the old one loaded for comparison).

Click on the "Trace" tab and look at the raw trace plot.

<figure class="image">
  <img src="long.png" alt="The trace of long run">
  <figcaption>Figure 4: A screenshot of Tracer.</figcaption>
</figure>

With this much longer MCMC chain, we still have 1,800 samples after
removing the first 10% as burn-in, but our ESSs are all > 200.
A large ESS does not mean there is no auto-correlation between
samples overall, but that we have at least 200 effectively independent
samples.
More effective samples means we are approximating the posterior better
than before, with ESSs < 100.
You should also keep an eye for weird trends in the trace plot suggesting
that the MCMC chain has not yet converged (or is struggling to
converge), like different value "plateaus" attracting the chain for a
large number of steps.

Now that we are satisfied with the length of the MCMC chain and its
mixing, we can move on to one of the parameters of interest: the
global substitution rate, `r`.
This is the average substitution rate across all sites in the alignment. 
First, select "r" in the left-hand panel, and click the "Marginal
Density" tab in the upper-right corner to see the posterior density
plot for this parameter.
You should see a plot similar to this:

<figure class="image">
  <img src="clockRate.png" alt="marginal density">
  <figcaption>Figure 5: The marginal density in Tracer.</figcaption>
</figure>

As you can see the, posterior probability density is roughly
bell-shaped. 
If the curve does not look very smooth, it is because there is some
sampling noise: we could smooth it out more if we ran the MCMC chain
for longer or took more samples.
Regardless, our mean and highest posterior density interval (HPD; also
known as the credible interval) estimates should be good given the
ESSs.

Note that you can overlay the density plots of multiple traces in
order to compare them (it is up to you to determine whether they are
comparable on the the same axis or not).
For example: select the relative substitution rates for all three
codon positions (partitions) in the left-hand panel (labelled "mu.0",
"mu.1" and "mu.2").  
You will now see the posterior probability densities for the relative
substitution rate at all three codon positions overlaid: 

<figure class="image">
  <img src="mu.png" alt="relative substitution rates">
  <figcaption>Figure 6: The posterior probability densities for the relative substitution rates.</figcaption>
</figure>

## Summarising the trees

{% include_relative tree-annotator.md fignum="Figure 7" %}


Summary trees can be viewed using FigTree (a program separate from BEAST) and DensiTree (distributed with BEAST).

<figure class="image">
  <a href="RSV2.tree.png" target="_blank"><img src="RSV2.tree.png" alt="MCC tree"></a>
  <figcaption>Figure 8: The Maximum clade credibility tree for the G gene of 129 RSVA-2 viral samples.</figcaption>
</figure>


Below a DensiTree with clade height bars for clades with over 50% support. Root canal tree represents maximum clade credibility tree.

<figure class="image">
  <img src="DensiTree.png" alt="MCC tree">
  <figcaption>Figure 9: The posterior tree set visualised in DensiTree.</figcaption>
</figure>


## Questions

In what year did the common ancestor of all RSVA viruses sampled live? What is the 95% HPD?


## Programs used in this tutorial

{% include_relative programs-used.md %}

You will also need to make sure all required BEAST 2 packages
(e.g., outercore) have been installed on your local computer.  
The Package Manager can help you do that (see the screenshot below).  

<figure class="image">
  <img src="outercore.png" alt="Package manager">
  <figcaption>Figure 2: A screenshot of Package Manager.</figcaption>
</figure>

## Useful Links

{% include_relative links.md %}


## References

* Zlateva, K. T., Lemey, P., Vandamme, A.-M., & Van Ranst,
  M. (2004). Molecular evolution and circulation patterns of human
  respiratory syncytial virus subgroup a: positively selected sites in
  the attachment g glycoprotein. J. Virol., 78(9), 4675–4683.
* Zlateva, K. T., Lemey, P., Moës, E., Vandamme, A.-M., & Van Ranst,
  M. (2005). Genetic variability and molecular evolution of the human
  respiratory syncytial virus subgroup B attachment G protein. J.
  Virol., 79(14),
  9157–9167. https://doi.org/10.1128/JVI.79.14.9157-9167.2005
* Drummond, A. J., & Bouckaert, R. R. (2014). Bayesian evolutionary
  analysis with BEAST 2. Cambridge University Press.
* Höhna, S., Landis, M. J., Heath, T. A., Boussau, B., Lartillot, N.,
  Moore, B. R., Huelsenbeck, J. P., Ronquist, F. (2016). RevBayes:
  Bayesian phylogenetic inference using graphical models and an
  interactive model-specification language. Syst. Biol., 65(4),
  726-736.
  
