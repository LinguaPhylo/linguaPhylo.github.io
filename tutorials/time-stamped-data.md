---
layout: page
title: Time-stamped data
author: 'Fábio K. Mendes, Walter Xie, Eva Li and Alexei J. Drummond'
permalink: /tutorials/time-stamped-data/
---

This tutorial is modified from Taming the BEAST material.
You can find the source tutorial, data and author information
[here](https://taming-the-beast.org/tutorials/MEP-tutorial/).

## Requirements

The programs used in this tutorial are listed [below](#programs-used-in-this-tutorial).
In case you have not done it yet, please follow the installation
instructions [here](/setup) before moving on.

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
protein ([Zlateva et al., 2004; Zlateva et al., 2005](#references)), a
glycoprotein that allows the virus to attach itself to the host cells'
membranes, starting the infection.
Importantly, our data is __time stamped__ (also referred to as
__heterochronous__ or __serial__ data) because it was collected at
multiple time points, from 1956--2002.

Below we further detail how we will treat our molecular data in our
analyses.

### The NEXUS alignment

{% include_relative templates/locate-data.md df='RSV2' 
                    df_link='https://raw.githubusercontent.com/LinguaPhylo/linguaPhylo/master/tutorials/data/RSV2.nex' %}

#### Multiple partitions

Our molecular alignment corresponds to a 629-bp coding sequence of
RSVA's G protein.
We are going to partition our alignment into three compartments
corresponding to the first, second and third codon positions.

### Tip dates

{% include_relative templates/tip-dates-forward.md  earliest='the 1950s' 
                    date_in_name='after the last lower-case `s`' 
                    since='1900' %}
					
{% include_relative templates/age-direction.md %}

### Non-identifiability of rate and time

The strict molecular clock parameterization must satisfies `genetic distance = rate × time`.
We can compute genetic distance from an alignment using an evolutionary model such as HKY. 
But we cannot determine whether the observed genetic distance is due to a fast rate over a short time 
or a slow rate over a long time. 
This problem is called the non-identifiability of rate and time. 
To estimate mutation rates, you need additional information about time, 
such as fossil ages or virus sample collection dates. 

{% assign current_fig_num = 1 %}

<figure class="image">
  <img src="Non-identifiability.png" alt="Non-identifiability">
  <figcaption>Figure {{ current_fig_num }}: Non-identifiability of rate and time.</figcaption>
</figure>

The detail is available in Prof. Alexei Drummond's [lecture slides](https://alexeidrummond.org/bayesian_phylo_lectures/lectureRelaxedPhylogenetics/).

## Inputting the script into LPhy Studio

{% include_relative templates/lphy-scripts.md %}

### Data block

{% capture lphy_html %}
{% include_relative time-stamped-data/lphy.html %}
{% endcapture %}

{% assign spans = lphy_html | split: "</span><br>" %}

{% capture lphy_data %}
   {% for i in (0..spans.size) %}
     {% if spans[i] contains "model" %}
       {% assign firstLineModel = forloop.index0 %}
       {% break %}
     {% else %} 
       {{ spans[i] | append: "</span><br>" }}       
     {% endif %}
   {% endfor %}
{% endcapture %}

{% capture lphy_model %}
  {% for i in (firstLineModel..spans.size) %}
    {{ spans[i] | append: "</span><br>" }}
    {% if spans[i] contains "}" %}
       {% break %}
    {% endif %}
  {% endfor %}
{% endcapture %}


{% include_relative templates/lphy-data.md %}

{::nomarkdown}
   {{ lphy_data }}
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

The alignment `D` is imported from a Nexus file "RSV2.nex". 
The argument `file="data/RSV2.nex"` is used to look for this file under the relative path "data", 
with its parent directory being the current working directory.
However, this could lead to the [issue](/setup/#troubleshooting-guide) 
if the working directory is not the parent directory of "data", 
especially when using the LPhy Studio console. 
To avoid potential issues with relative paths, 
a simple solution is to use the absolute path in the argument `file="..."`.

Then we must parse the molecular alignments by initializing the variable `D`.
Note that our open reading frame (ORF) starts at position 3. 
This must be reflected in the arguments we pass to the `charset()` function to define the codon positions: 

- first (`"3-629\3"`), 
- second (`"1-629\3"`), and 
- third (`"2-629\3"`).

The `charset()` function returns three alignments as a vector called `codon`.

Finally, we use the last three lines to set the number of loci `L`,
the number of taxa `n`, and the taxa themselves, `taxa`.
Note that `n=length(codon);` is equivalent to `n=3;` because
`length()` here is extracting the number of partitions in `codon`.

If you want to double-check everything you have typed, click the
"Model" tab in the upper right panel.

### Model block

{% include_relative templates/lphy-model.md %}

We will specify sampling distributions for the following parameters, in
this order:
1. `π`, the equilibrium nucleotide frequencies (with 4 dimensions, one
for each nucleotide);  
2. `κ`, twice the transition:transversion bias assuming equal
   nucleotide frequencies (with 3 dimensions,
   one for each partition);  
3. `r`, the relative rates (with 3 dimensions, one for
   each partition);  
4. `μ`, the global (mean) molecular clock rate;  
5. `Θ`, the effective population size;  
6. `ψ`, the time-scaled phylogenetic tree, where the time unit is years.

{::nomarkdown}
  {{ lphy_model | append: "<br>" }}
{:/}


The parameter `π` represents the nucleotide equilibrium frequencies.
`κ` (kappa) specifies the transition/transversion rate ratio. 
Both are defined as 3-dimensional vectors using the optional argument `replicates=n`, where `n=3` in this case. 

The parameter `r` defines the [relative substitution rates](https://beast2-dev.github.io/hmc/hmc/SiteModel/mutationRate/) 
for each of the three codon partitions.
LPhy makes use of vectorization, so when `WeightedDirichlet` receives 
a vector input (such as `L` being 3-dimensional), 
it automatically constructs three separate relative rate vectors, one for each partition.
This same behavior applies to `PhyloCTMC`, which also handles vectorised inputs internally.

One final remark is that we use `rep(element=1.0, times=n)` (where `n`
evaluates to 3) to create three concentration vectors (one vector per
partition) for the `WeightedDirichlet` sampling distribution.

You can click the graphical components to view their simulated values.
Again, if you want to double-check everything you have typed, click the
“Model” tab in the upper right panel.

### The whole script

Let us look at the whole thing:

{::nomarkdown}
  {{ lphy_html }}
{:/}

{% assign current_fig_num = current_fig_num | plus: 1 %}

{% include_relative templates/lphy-studio.md lphy="RSV2" fignum=current_fig_num %}

## Phylogenetic inference with BEAST 2

{% include_relative templates/lphy-inference-beast2.md software="BEAST 2" %}

### Producing a BEAST 2 .xml using LPhyBEAST

{% include_relative templates/lphy-beast.md args="" lphy="RSV2" %}

### Running BEAST 2

{% include_relative templates/run-beast.md xml="RSV2.xml" %}

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

Running file RSV2.xml
File: RSV2.xml seed: 2160030974204605245 threads: 1
    ...

    ...
         950000     -6093.6543     -5490.2432      -603.4110         0.4758         0.2259         0.0963         0.2018         0.2731         0.4117         0.1111         0.2038         0.3281         0.4085         0.0910         0.1722         8.1613         7.1496        11.6311         0.5955         1.0316         1.3709         0.0021        34.0876 55s/Msamples
        1000000     -6079.8549     -5484.0842      -595.7707         0.4530         0.2677         0.1107         0.1684         0.2896         0.4210         0.0976         0.1916         0.2989         0.3977         0.0739         0.2293         5.4948        10.4505        10.2371         0.6823         0.9759         1.3402         0.0024        37.4179 55s/Msamples

Operator                                                                                   Tuning    #accept    #reject      Pr(m)  Pr(acc|m)
kernel.BactrianScaleOperator(Theta.scale)                                                 0.21787       1449       4472    0.00586    0.24472 
kernel.BactrianScaleOperator(kappa.scale)                                                 0.34910       3621       8889    0.01265    0.28945 
kernel.BactrianScaleOperator(mu.scale)                                                    0.11193        918       4892    0.00586    0.15800 
beast.base.inference.operator.kernel.BactrianUpDownOperator(muUppsiDownOperator)          0.11188        705     175870    0.17596    0.00399 Try setting scale factor to about 0.056
beast.base.inference.operator.kernel.BactrianDeltaExchangeOperator(pi_0.deltaExchange)    0.08504       2193      10184    0.01265    0.17718 
beast.base.inference.operator.kernel.BactrianDeltaExchangeOperator(pi_1.deltaExchange)    0.06443       3476       9297    0.01265    0.27214 
beast.base.inference.operator.kernel.BactrianDeltaExchangeOperator(pi_2.deltaExchange)    0.06726       2513      10167    0.01265    0.19819 
EpochFlexOperator(psi.BICEPSEpochAll)                                                     0.07907       1002       8489    0.00952    0.10557 
EpochFlexOperator(psi.BICEPSEpochTop)                                                     0.07882        609       5258    0.00586    0.10380 
TreeStretchOperator(psi.BICEPSTreeFlex)                                                   0.02965      27125     147635    0.17501    0.15521 
Exchange(psi.narrowExchange)                                                                    -      44841     130153    0.17501    0.25624 
kernel.BactrianScaleOperator(psi.rootAgeScale)                                            0.33243         19       5817    0.00586    0.00326 Try setting scale factor to about 0.166
kernel.BactrianSubtreeSlide(psi.subtreeSlide)                                          1180.33719        190     175046    0.17501    0.00108 Try decreasing size to about 590.169
kernel.BactrianNodeOperator(psi.uniform)                                                  2.27178      60697     114054    0.17501    0.34733 
Exchange(psi.wideExchange)                                                                      -         53      15505    0.01547    0.00341 
WilsonBalding(psi.wilsonBalding)                                                                -        116      15178    0.01547    0.00758 
beast.base.inference.operator.kernel.BactrianDeltaExchangeOperator(r.deltaExchange)       0.20272       2699       6869    0.00952    0.28209 

     Tuning: The value of the operator's tuning parameter, or '-' if the operator can't be optimized.
    #accept: The total number of times a proposal by this operator has been accepted.
    #reject: The total number of times a proposal by this operator has been rejected.
      Pr(m): The probability this operator is chosen in a step of the MCMC (i.e. the normalized weight).
  Pr(acc|m): The acceptance probability (#accept as a fraction of the total proposals for this operator).


Total calculation time: 58.151 seconds
End likelihood: -6079.854960424774
```

### Analysing BEAST 2's output

We start by opening the Tracer program, and dropping the `RSV2.log`
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

{% assign current_fig_num = current_fig_num | plus: 1 %}

<figure class="image">
  <img src="short.png" alt="The posterior histogram of mu">
  <figcaption>Figure {{ current_fig_num }}: A screenshot of Tracer
  showing the sampling histogram of `μ` from a short run.</figcaption>
</figure>

{% assign current_fig_num = current_fig_num | plus: 1 %}

If you click the "Trace" tab in the upper-right corner, you will see
the raw trace, that is, the sampled values against the step in the
MCMC chain (Fig. {{ current_fig_num }}).

The trace shows the value of a given statistic for each sampled step
of the MCMC chain.
It will help you see if the chain is mixing well and to what extent
the samples are correlated. Here you can see how the samples are
correlated.

<figure class="image">
  <img src="short2.png" alt="The trace of short run">
  <figcaption>Figure {{ current_fig_num }}: A screenshot of Tracer
  showing the trace of a short run.</figcaption>
</figure>

In LPhyBEAST, the default MCMC chain length is 1,000,000.
After we remove the burn-in (set to 10%), there will be 1,800 samples in
the trace (we ran the MCMC for steps sampling every 500).
Note how adjacent samples often tend to have similar values – not
great.

{% assign ess = 25 %}

The ESS for the mean molecular clock rate (`μ`) is about {{ ess }} so we
are only getting 1 independent sample every {{ 1800 | divided_by: ess | round: 0 }} samples 
(to a total of ~1800/{{ ess }} "effective" samples).
With such a short run, it may also be the case that the default
burn-in of 10% of the chain length is inadequate.
Not excluding enough of the start of the chain as burn-in will render
estimates of ESS unreliable.

Let us try to fix this low ESS issue by running the MCMC chain for longer.
We will set the chain length to 20,000,000, but still log the same
number of samples (2,000).
You can now run _LPhyBEAST_ again create a new .xml file:

```
$BEAST_DIR/bin/lphybeast -l 20000000 -o RSV2long.xml RSV2.lphy
```

Two extra arguments: 
- `-l` changes the MCMC chain length (default to 1 million) in the XML;
- `-o` replaces the output file name (default to use the same file steam as the lphy input file).

Now run BEAST 2 with the new XML again. 
It may take about half an hour to complete using modern computers.  
If you do not want to wait, you can download the completed [log and tree files](#xml-and-log-files) 
by running the longer MCMC chain.

Load the new log file into Tracer after it is finished (you can leave the old one loaded for comparison).
Click on the "Trace" tab and look at the raw trace plot.

{% assign current_fig_num = current_fig_num | plus: 1 %}
{% assign posterior_fig_num = current_fig_num %}

<figure class="image">
  <img src="long.png" alt="The trace of long run">
  <figcaption>Figure {{ posterior_fig_num }}: A screenshot of Tracer
  showing the trace of a long run.</figcaption>
</figure>

With this much longer MCMC chain, we still have 1,800 samples after
removing the first 10% as burn-in, but our ESSs are all > 200.
A large ESS does not mean there is no auto-correlation between
samples overall, but instead that we have at least 200 effectively
independent samples.
More effective samples means we are approximating the posterior better
than before, when ESSs were less than 100.

(You should keep an eye for weird trends in the trace plot suggesting
that the MCMC chain has not yet converged, or is struggling to
converge, like different value "plateaus" attracting the chain for a
large number of steps.)

Empirically, the topology of posterior trees typically converges more slowly than other parameters 
because trees are multi-dimensional objects. 
To address this, we introduce a simple method to compute the
[Tree ESS using TreeStat2](https://linguaphylo.github.io/tutorials/tree-ess/).

Now that we are satisfied with the length of the MCMC chain and its
mixing, we can move on to one of the parameters of interest: the
global clock rate, `μ`.
This is the average molecular clock rate across all sites in the
alignment.  

First, select "mu" in the left-hand panel, and click the "Marginal
Density" tab in the upper-right corner to see the posterior density
plot for this parameter.
You should see a plot similar to this:

{% assign current_fig_num = current_fig_num | plus: 1 %}

<figure class="image">
  <img src="muDensity.png" alt="marginal density">
  <figcaption>Figure {{ current_fig_num }}: A screenshot of Tracer
  showing the marginal posterior probability density of the mean
  clock rate, `μ`.</figcaption>
</figure>

As we can see in Figure {{ posterior_fig_num }}, the marginal
posterior probability density of `μ` is roughly bell-shaped. 
If the curve does not look very smooth, it is because there is some
sampling noise: we could smooth it out more if we ran the MCMC chain
for longer or took more samples.
Regardless, our mean and highest posterior density interval (HPD; also
known as the credible interval) estimates should be good given the
ESSs.

Note that you can overlay the density plots of multiple traces in
order to compare them (it is up to you to determine whether they are
comparable on the same axis or not).
For example: select the relative rates for all three
codon positions (partitions) in the left-hand panel (labelled "r_0",
"r_1" and "r_2").  

You will now see the posterior probability densities for the relative rate at all three codon positions overlaid: 

{% assign current_fig_num = current_fig_num | plus: 1 %}

<figure class="image">
  <img src="relativeRates.png" alt="relative rates">
  <figcaption>Figure {{ current_fig_num }}: A screenshot of Tracer
  showing the marginal posterior probability densities for the
  relative rates, `r_0`, `r_1` and `r_2`.</figcaption> 
</figure>

### Summarising the trees

Because of how peculiar and discrete tree space is, it is a bit harder
to summarize and visualize the posterior distribution over
phylogenetic trees, as compared to the mean molecular clock rate `μ`, for
example.
We will use a special tool for that, TreeAnnotator.

{% assign current_fig_num = current_fig_num | plus: 1 %}

{% include_relative templates/tree-annotator.md fig="TreeAnnotator.png" 
                    fignum=current_fig_num trees="RSV2long.trees" mcctree="RSV2long.tree" %}


In TreeAnnotator, mean heights are calculated as the mean MRCA time for those trees in the set 
where the clade is monophyletic. 
This approach can result in negative branch lengths in the summarized tree, 
if there is very low posterior support for a clade.
Common ancestor heights for a clade are calculated as the average MRCA time for that clade over all trees in the set, 
and are not necessarily based on monophyletic clades.
If you're concerned about the differences between these two options, 
you can run both and compare the resulting trees.


### Visualizing the trees

Summary trees can be viewed using FigTree and DensiTree, the latter
being distributed with BEAST 2.
In FigTree, just load TreeAnnotator's output file as the input (if you
were to load the entire tree log file, FigTree would show you each
tree in the posterior individually).

{% assign current_fig_num = current_fig_num | plus: 1 %}

{% assign figtree_fig_num = current_fig_num %}

After loading the summarised tree in FigTree, click on the "Trees" tab on the
left-hand side, then select "Order nodes" while keeping the default
ordering ("increasing").
In addition, check "Node Bars", choosing "height_95%_HPD" for
"Display".
This last step shows the estimated 95% HPD intervals for all node
heights.
You should end up with a tree like the one in Figure {{
figtree_fig_num }}.

<figure class="image">
  <a href="RSV2.ccd0.tree.png" target="_blank"><img src="RSV2.ccd0.tree.png" alt="summarised tree"></a>
  <figcaption>Figure {{ figtree_fig_num }}: The summarised tree for
  the G gene of 129 RSVA-2 viral samples.</figcaption>
</figure>

In DensiTree, load the tree log file as the input.
Here, the tree in blue is the summarised tree, where the green "fuzzy" trees
are all the other trees in the posterior set.

{% assign current_fig_num = current_fig_num | plus: 1 %}

<figure class="image">
  <img src="DensiTree.png" alt="Densi tree">
  <figcaption>Figure {{ current_fig_num }}: The posterior tree set visualised in DensiTree.</figcaption>
</figure>

## Questions

1. How can I determine if my MCMC runs have converged ?

2. What is the 95% HPD ?

3. How to compute the absolute rates of each codon given their relative rates ?

4. What is the unit of branch lengths in the time tree for this analysis ?

5. In what year did the common ancestor of all RSVA viruses sampled live ? 


## Programs used in this tutorial

{% include_relative templates/programs-used.md %}


## XML and log files

- [RSV2.xml](RSV2short/RSV2.xml)
- [RSV2.log](RSV2short/RSV2.log)
- [RSV2.trees](RSV2short/RSV2.trees)
- [RSV2long.xml](RSV2/RSV2long.xml)
- [RSV2long.log](RSV2/RSV2long.log)
- [RSV2long.trees](RSV2/RSV2long.trees)
- summarised tree [RSV2long.ccd0.tree](RSV2/RSV2long.ccd0.tree)

## Useful links

{% include_relative templates/links.md %}


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
  
