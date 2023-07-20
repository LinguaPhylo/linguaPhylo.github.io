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

The programs used in this tutorial are listed [below](#programs-used-in-this-tutorial).
In case you have not done it yet, please follow the installation
instructions [here](../setup.md) before moving on.

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

This .nex file can also be found in the ```examples/nexus``` folder,
where BEAST 2 was installed.

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

## Constructing the scripts in LPhy Studio

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
3. `r`, the relative substitution rates (with 3 dimensions, one for
   each partition);  
4. `μ`, the global (mean) clock rate;  
5. `Θ`, the effective population size (with as many dimensions as
   there are branches in the tree);  
6. `ψ`, the time-scaled (i.e., in absolute time) phylogenetic tree.

{::nomarkdown}
  {{ lphy_model | append: "<br>" }}
{:/}


Note that parameters `π`, `κ` and `r` are 3-dimensional vectors,
because they represent the nucleotide equilibrium frequencies,
(ts:tv)/2, and relative substitution rates of each of the three
partitions, respectively.
LPhy conveniently uses vectorization, so `PhyloCTMC` recognizes that
three parameters above are vectors, and automatically takes care of
building three separate HKY models, one per partition!

One final remark is that we use `rep(element=1.0, times=n)` (where `n`
evaluates to 3) to create three concentration vectors (one vector per
partition) for the `WeightedDirichlet` sampling distribution.

Again, if you want to double-check everything you have typed, click the
“Model” tab in the upper right panel.

### The whole script

Let us look at the whole thing:

{::nomarkdown}
  {{ lphy_html }}
{:/}

{% assign current_fig_num = 1 %}

{% include_relative templates/lphy-studio.md lphy="RSV2" fignum=current_fig_num %}

## Phylogenetic inference with BEAST 2

{% include_relative templates/lphy-inference-beast2.md software="BEAST 2" %}

### Producing a BEAST 2 .xml using LPhyBEAST

{% include_relative templates/lphy-beast.md lphy="RSV2" %}

```
# BEAST_DIR="/Applications/BEAST2"
$BEAST_DIR/bin/lphybeast RSV2.lphy 
```

### Running BEAST 2

{% include_relative templates/run-beast.md xml="RSV2.xml" %}

```
                         BEAST v2.6.7, 2002-2020
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

Random number seed: 1630288622480
    ...

    ...
         950000     -6090.8619     -5484.6314      -606.2305         0.4475         0.2692         0.1000         0.1831         0.3183         0.4213         0.0826         0.1776         0.3530         0.3155         0.0702         0.2611         8.2537         8.5243        10.1785         0.7057         0.9198         1.3729         0.0020        38.8407 2m34s/Msamples
        1000000     -6084.2226     -5480.6365      -603.5861         0.5015         0.2429         0.0847         0.1706         0.2456         0.4702         0.1013         0.1828         0.3366         0.3591         0.0873         0.2168         6.4508        10.1371         9.5392         0.6864         1.0965         1.2155         0.0022        35.9676 2m34s/Msamples

Operator                                      Tuning    #accept    #reject      Pr(m)  Pr(acc|m)
ScaleOperator(Theta.scale)                   0.61008       1298       3181    0.00450    0.28980 
ScaleOperator(kappa.scale)                   0.47919       2976       6630    0.00970    0.30981 
ScaleOperator(mu.scale)                      0.77528       1071       3560    0.00450    0.23127 
UpDownOperator(muUppsiDownOperator)          0.94041       5481     130154    0.13497    0.04041 Try setting scaleFactor to about 0.97
DeltaExchangeOperator(pi_0.deltaExchange)    0.12380       1763       7805    0.00970    0.18426 
DeltaExchangeOperator(pi_1.deltaExchange)    0.14501       1362       8290    0.00970    0.14111 
DeltaExchangeOperator(pi_2.deltaExchange)    0.10881       1757       8020    0.00970    0.17971 
Exchange(psi.narrowExchange)                       -      33869     100180    0.13424    0.25266 
ScaleOperator(psi.rootAgeScale)              0.76570        567       3843    0.00450    0.12857 
ScaleOperator(psi.scale)                     0.90191       3141     131241    0.13424    0.02337 Try setting scaleFactor to about 0.95
SubtreeSlide(psi.subtreeSlide)               4.50313      18248     116199    0.13424    0.13573 
Uniform(psi.uniform)                               -      72184      61788    0.13424    0.53880 
Exchange(psi.wideExchange)                         -        318     133559    0.13424    0.00238 
WilsonBalding(psi.wilsonBalding)                   -        764     133396    0.13424    0.00569 
DeltaExchangeOperator(r.deltaExchange)       0.30317       1619       5737    0.00730    0.22009 

     Tuning: The value of the operator's tuning parameter, or '-' if the operator can't be optimized.
    #accept: The total number of times a proposal by this operator has been accepted.
    #reject: The total number of times a proposal by this operator has been rejected.
      Pr(m): The probability this operator is chosen in a step of the MCMC (i.e. the normalized weight).
  Pr(acc|m): The acceptance probability (#accept as a fraction of the total proposals for this operator).


Total calculation time: 154.759 seconds
End likelihood: -6084.222697270579
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

The ESS for the mean molecular evolution rate (`μ`) is about {{ ess }} so we
are only getting 1 independent sample every {{ 1800 | divided_by: ess | round: 0 }} samples 
(to a total of ~1800/{{ ess }} "effective" samples).
With such a short run, it may also be the case that the default
burn-in of 10% of the chain length is inadequate.
Not excluding enough of the start of the chain as burn-in will render
estimates of ESS unreliable.

Let us try to fix this low ESS issue by running the MCMC chain for longer.
We will set the chain length to 20,000,000, but still log the same
number of samples (2,000).
You can now run _LPhyBEAST_ again, this time with the `-l` argument
to create a new .xml file:

```
# MY_SCRIPT_PATH=~/WorkSpace/linguaPhylo/tutorials/
$BEAST_DIR/bin/lphybeast -wd $MY_SCRIPT_PATH -l 20000000 -o RSV2long.xml RSV2.lphy
```

Now run BEAST 2 again. It may take about half an hour to complete using modern computers.  
If you do not want to wait, you can download the 
[RSV2long.log and RSV2long.trees](https://github.com/LinguaPhylo/linguaPhylo.github.io/tree/master/tutorials/time-stamped-data/RSV2)
completed by running the longer MCMC chain.

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

Now that we are satisfied with the length of the MCMC chain and its
mixing, we can move on to one of the parameters of interest: the
global substitution rate, `μ`.
This is the average substitution rate across all sites in the
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
  substitution rate, `μ`.</figcaption>
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
comparable on the the same axis or not).
For example: select the relative substitution rates for all three
codon positions (partitions) in the left-hand panel (labelled "r_0",
"r_1" and "r_2").  

You will now see the posterior probability densities for the relative
substitution rate at all three codon positions overlaid: 

{% assign current_fig_num = current_fig_num | plus: 1 %}

<figure class="image">
  <img src="relativeRates.png" alt="relative substitution rates">
  <figcaption>Figure {{ current_fig_num }}: A screenshot of Tracer
  showing the marginal posterior probability densities for the
  relative substitution rates, `r_0`, `r_1` and `r_2`.</figcaption> 
</figure>

### Summarising the trees

Because of how peculiar and discrete tree space is, it is a bit harder
to summarize and visualize the posterior distribution over
phylogenetic trees, as compared to the mean molecular rate `μ`, for
example.
We will use a special tool for that, TreeAnnotator.

{% assign current_fig_num = current_fig_num | plus: 1 %}

{% include_relative templates/tree-annotator.md fig="TreeAnnotator.png" 
                    fignum=current_fig_num trees="RSV2long.trees" mcctree="RSV2long.tree" %}

### Visualizing the trees

Summary trees can be viewed using FigTree and DensiTree, the latter
being distributed with BEAST 2.
In FigTree, just load TreeAnnotator's output file as the input (if you
were to load the entire tree log file, FigTree would show you each
tree in the posterior individually).

{% assign current_fig_num = current_fig_num | plus: 1 %}

{% assign figtree_fig_num = current_fig_num %}

After loading the MCC tree in FigTree, click on the "Trees" tab on the
left-hand side, then select "Order nodes" while keeping the default
ordering ("increasing").
In addition, check "Node Bars", choosing "height_95%_HPD" for
"Display".
This last step shows the estimated 95% HPD intervals for all node
heights.
You should end up with a tree like the one in Figure {{
figtree_fig_num }}.

<figure class="image">
  <a href="RSV2.tree.png" target="_blank"><img src="RSV2.tree.png" alt="MCC tree"></a>
  <figcaption>Figure {{ figtree_fig_num }}: The maximum clade credibility (MCC) tree for
  the G gene of 129 RSVA-2 viral samples.</figcaption>
</figure>

In DensiTree, load the tree log file as the input.
Here, the tree in blue is the MCC tree, where the green "fuzzy" trees
are all the other trees in the posterior set.

{% assign current_fig_num = current_fig_num | plus: 1 %}

<figure class="image">
  <img src="DensiTree.png" alt="MCC tree">
  <figcaption>Figure {{ current_fig_num }}: The posterior tree set visualised in DensiTree.</figcaption>
</figure>

## Questions

In what year did the common ancestor of all RSVA viruses sampled live? What is the 95% HPD?

## Programs used in this tutorial

{% include_relative templates/programs-used.md %}

## Useful Links

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
  
