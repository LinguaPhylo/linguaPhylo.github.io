---
layout: page
title: Ancestral Reconstruction using Discrete Phylogeography
author: 'Walter Xie, Remco Bouckaert, and Alexei Drummond'
permalink: /tutorials/dpg-test/
---

It guides you through a discrete phylogeography analysis of a H5N1 epidemic in South China. 
This analysis will use the model developed by [Lemey et al., 2009](#references) 
that implements ancestral reconstruction of discrete states (locations) in a Bayesian statistical framework, 
and employs the Bayesian stochastic search variable selection (BSSVS) to identify the most parsimonious description of 
the phylogeographic diffusion process.

The additional benefit using this model is that we can summarise the phylogeographic inferences from an analysis,
and use a virtual globe software to visualize the spatial and temporal information.

The programs used in this tutorial are listed [below](#programs-used-in-this-exercise).

## The NEXUS alignment

{% include_relative templates/download-data.md df='h5n1' 
                    df_link='https://raw.githubusercontent.com/BEAST2-Dev/beast-classic/master/examples/nexus/H5N1.nex' %}

The data is a subset of original dataset [Wallace et al., 2007](#references), 
and it consists of 43 influenza A H5N1 hemagglutinin and neuraminidase gene sequences 
isolated from a variety of hosts 1996 - 2005 across sample locations.


## Constructing the scripts in LPhy Studio

{% include_relative templates/lphy-studio-intro.md %}

The LPhy scripts to define this analysis is listed below.


[//]: # (## Code, Graphical Model)
{% include_relative discrete-phylogeography/lphy.md fignum="Figure 1" %}


## Geographic Model

In this analysis, we have two parts mixed in the model section: 
the first part is modeling evolutionary history and demographic structure based on a nucleotide alignment, 
and the second part is defining how to sample the discrete states (locations) from the phylogeny $\psi$ shared with the 1st part.

For the nucleotide alignment, We fix a strict molecular clock to 0.004, to make the analysis converge a bit quicker.

The next is the geographic model. 
In the discrete phylogeography, the probability of transitioning to a new location through the time is computed by 

$$ P(t) = e^{\Lambda t} $$ 

where $\Lambda$ is a $ K \times K $ infinitesimal rate matrix, 
and $K$ is the number of discrete locations (i.e. 5 locations here). Then, 

$$ \Lambda = \mu S \Pi $$

where $\mu$ is an overall rate scalar, $S$ is a $ K \times K $ matrix of relative migration rates,
and $\Pi = diag(\pi)$ where $\pi$ is the equilibrium trait frequencies.
After the normalization, $\mu$ measures the number of migration events per unit time $t$.
The detail is explained in [Lemey et al., 2009](#references).

So, assuming migration to be symmetric in this analysis, we define a vector variable `R_trait` with the length of $ \frac{K \times (K-1)}{2} $ to store the off-diagonal entries of the unnormalised $S$. Another boolean vector `I` with the same length determines which infinitesimal rates are zero, 
which is performed by the function `select`. 
This implements the Bayesian stochastic search variable selection (BSSVS).  


## Producing BEAST XML using LPhyBEAST

{% include_relative templates/lphy-beast.md lphy="h5n1" nex="H5N1" %}

```
java -jar LPhyBEAST.jar -l 30000000 h5n1.lphy
```


## Running BEAST

{% include_relative templates/run-beast.md xml="h5n1.xml" %}

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

Random number seed: 1614208278348

Loading package outercore v0.0.2
Loading package BEAST v2.6.3
Loading package feast v7.4.1
Loading package BEASTLabs v1.9.5
Loading package BEAST_CLASSIC v1.5.0

    ...

    ...
        2850000     -5958.0570     -5837.5606      -120.4963         0.3328         0.1859         0.2322         0.2489         8.2417         0.3507         7.7953         0.1249         0.2570         0.1683         0.3524         0.0971              1              1              1              1              1              1              1              1              1              0         0.1726         0.0857         0.0236         0.1984         0.1218         0.0099         0.1197         0.0946         0.0852         0.0879         0.2469 1m20s/Msamples
        3000000     -5953.5889     -5833.0862      -120.5027         0.3372         0.1973         0.2230         0.2423        10.0566         0.3012         7.9571         0.2938         0.1581         0.2429         0.2732         0.0317              1              0              0              0              1              1              1              1              1              1         0.1223         0.0255         0.0504         0.2905         0.1107         0.0093         0.0907         0.0157         0.2071         0.0775         0.2856 1m20s/Msamples

Operator                                             Tuning    #accept    #reject      Pr(m)  Pr(acc|m)
ScaleOperator(Theta.scale)                          0.47755       7889      18091    0.00866    0.30366 
ScaleOperator(kappa.scale)                          0.51553       6568      19129    0.00866    0.25559 
DeltaExchangeOperator(pi.deltaExchange)             0.08096       7617      48109    0.01868    0.13669 
Exchange(psi.narrowExchange)                              -      61125     294888    0.11850    0.17169 
ScaleOperator(psi.rootAgeScale)                     0.78835       4262      22126    0.00866    0.16151 
ScaleOperator(psi.scale)                            0.90464      35422     318780    0.11850    0.10001 
SubtreeSlide(psi.subtreeSlide)                      0.92028      67975     287756    0.11850    0.19109 
Uniform(psi.uniform)                                      -     149131     206729    0.11850    0.41907 
Exchange(psi.wideExchange)                                -       1648     354053    0.11850    0.00463 
WilsonBalding(psi.wilsonBalding)                          -       2031     353486    0.11850    0.00571 
ScaleOperator(shape.scale)                          0.41925       7340      18299    0.00866    0.28628 
ScaleOperator(mu_trait.scale)                 0.26742       7628      18202    0.00866    0.29532 
UpDownOperator(mu_traitUppsiDownOperator)     0.92616      49514     312158    0.12047    0.13690 
BitFlipOperator(I.bitFlip)                 -      40470      89769    0.04340    0.31074 
DeltaExchangeOperator(pi_trait.deltaExchange)       0.54731      10613      58216    0.02285    0.15419 
DeltaExchangeOperator(R_trait.deltaExchange)    0.56871      16443     104534    0.04031    0.13592 

     Tuning: The value of the operator's tuning parameter, or '-' if the operator can't be optimized.
    #accept: The total number of times a proposal by this operator has been accepted.
    #reject: The total number of times a proposal by this operator has been rejected.
      Pr(m): The probability this operator is chosen in a step of the MCMC (i.e. the normalized weight).
  Pr(acc|m): The acceptance probability (#accept as a fraction of the total proposals for this operator).


Total calculation time: 244.148 seconds
End likelihood: -5953.588976905855
```

## Analysing the BEAST output

{% include_relative templates/tracer.md logfile="h5n1" fignum="Figure 2" %}

Remember that MCMC is a stochastic algorithm so the actual numbers will
not be exactly the same.
On the left hand side is a list of the different quantities that BEAST has logged. 
There are traces for the posterior (this is the log of the product of
the tree likelihood and the prior probabilities), and the continuous parameters.
Selecting a trace on the left brings up analyses for this trace on the right hand
side depending on tab that is selected. When first opened, the "posterior"" trace
is selected and various statistics of this trace are shown under the `Estimates`
tab. In the top right of the window is a table of calculated statistics for the
selected trace.

Tracer will plot a (marginal posterior) distribution for the selected parameter
and also give you statistics such as the mean and median. The __95% HPD lower__
or __upper__ stands for _highest posterior density interval_ and represents the most
compact interval on the selected parameter that contains 95% of the posterior
probability. It can be thought of as a Bayesian analog to a confidence interval.


## Obtaining an estimate of the phylogenetic tree

{% include_relative templates/tree-annotator.md fig="TreeAnnotator.png" 
                    fignum=3 trees="h5n1_with_trait.trees" mcctree="h5n1_with_trait.tree"%}


## Distribution of root location

When you open the summary tree with locations `h5n1_with_trait.tree` in a text editor, 
and scroll to the most right and locate the end of the tree definition, 
you can see the set of meta data for the root. 
Looking for the last entries of `location.set` and `location.set.prob`, 
you might find something like this:
```
location.set = {Guangdong,HongKong,Hunan,Guangxi,Fujian}
location.set.prob = {0.1971127151582454,0.5885619100499723,0.0416435313714603,0.11715713492504164,0.0555247084952804}
```
This means that we have the following distribution for the root location:

| Location| Probability      |
|---------|------------------|
|Guangdong|0.1971127151582454|
|HongKong|0.5885619100499723|
|Hunan|0.0416435313714603|
|Guangxi|0.11715713492504164|
|Fujian|0.0555247084952804|

This distribution shows that the 95% HPD consists of all locations except Hunan, 
with a strong indication that HongKong might be the root with over 58% probability. 
It is quite typical that a lot of locations are part of the 95% HPD in discrete phylogeography.


## Viewing the Location Tree

We can visualise the tree in a program called _FigTree_. 
Run this program, and open the summary tree file `h5n1_with_trait.tree` by using the `Open` command in the `File` menu. 
The tree should appear. You can now try selecting some of the options in the control panel on the left. 
Try selecting `Appearance` to set the branch `Colour by` `location`. 
In addition, you can set the branch `Width by` `location.prob` according to the posterior support of estimated locations. Increasing the `Line Weight` can make the branch width more different regarding to its posterior support. Finally, tick `Legend` and select `location` in the drop list of `Attribute`. 
You should end up with something like Figure 4.

<figure class="image">
  <a href="../discrete-phylogeography/h5n1_with_trait.tree.png" target="_blank"><img src="../discrete-phylogeography/h5n1_with_trait.tree.png" alt="MCC tree"></a>
  <figcaption>Figure 4: Figtree representation of the summary tree. 
  Branch colours represent location and branch widths posterior support for the branch.</figcaption>
</figure>

Alternatively, you can load the posterior tree set `h5n1_with_trait.trees` (note this is NOT the summary tree, but the complete set) into _DensiTree_ and set it up as follows.
- Click `Show` to choose `Root Canal` tree to guide the eye.
- Click `Grid` to choose `Full grid` option, type year 2005 in the `Origin` text field and tick `Reverse` to show the correct time scale. You also can reduce the `Digits` to 0 which will rounding years in the x-axis (i.g. 2005, instead of 2005.22).
- Go to `Line Color`, you can colour branches by `location`.
The final image look like Figure 5.

<figure class="image">
  <a href="../discrete-phylogeography/DensiTree.png" target="_blank"><img src="../discrete-phylogeography/DensiTree.png" alt="DensiTree"></a>
  <figcaption>Figure 5: The posterior tree set visualised in DensiTree.</figcaption>
</figure>


## The number of estimated transitions

Sometime, we want to visualise how the location states are changed through the phylogeny. 
`StateTransitionCounter` can count the number of branches in a tree or a set of trees that have a certain state at the parent and another at the node. 

So, install the `Babel` package and run the `StateTransitionCounter` through BEAST application launcher. 
The command line below will generate the output file `stc.out` 
containing all counts from the logged posterior trees `h5n1_with_trait.trees`,
after removing 10% burn-in. 
Please make sure you install the latest version (Babel >= v0.3.2, BEASTLabs >= v1.9.6).

```
$BEAST2_PATH/bin/applauncher StateTransitionCounter -burnin 10 -in h5n1_with_trait.trees -tag location -out stc.out
```

Next, we need to use R to plot the histogram given the summary in `stc.out`. 
If you have a problem to generate it, you can download a prepared file [stc.out](h5n1Bernoulli/stc.out). 
You also need to download a script [PlotTransitions.R](discrete-phylogeography/PlotTransitions.R),
which contains the functions to parse the file and plot the histograms.
The script requires to install R package `ggplot2` and `tidyverse`.

Run the following scripts in R:

```R
#setwd(YOUR_WD)
source("PlotTransitions.R")

stc <- parseTransCount(input="stc.out", pattern = "Histogram", target="Hunan")
# only => Hunan
p <- plotTransCount(stc$hist[grepl("=>Hunan", stc$hist[["Transition"]]),])
ggsave( paste0("transition-distribution-hunan.png"), p, width = 6, height = 4) 
```

The `stc` contains a statistical summary of the estimated transition counts related to the target location, 
here is `Hunan`, and a table of the actual counts. 
To plot a simple graph, we only pick up the transitions to Hunan in the next command,
and then save the graph a PNG file. The counts are normalised into probabilities. 

<figure class="image">
  <a href="../discrete-phylogeography/transition-distribution-hunan.png" target="_blank"><img src="../discrete-phylogeography/transition-distribution-hunan.png" alt="DensiTree"></a>
  <figcaption>Figure 6: The probability distribution of estimated transitions into Hunan from other places.</figcaption>
</figure>

The x-axis presents the number of estimated transitions in all migration events from one particular location to another which is separated by "=>",
and y-axis is the probability which is normalised from the total counts.
As you can see, "Guangxi=>Hunan" (blue) has higher probability than other migration events. 
This type of visualisation will help you to quantify the uncertainty how the disease (H5N1) spread from/to the location(s) of interest, which is simulated from your model and given the data.    

Because the posterior trees in this analysis are scaled to time, also known as "time tree", 
we can convert this graph into daily transitions. More details and visualisations can be seen from [Douglas et. al. 2020](#references).

## Post processing geography

Start the application `spread`, which can be used to analyze and visualize phylogeographic reconstructions resulting from Bayesian inference of spatio-temporal diffusion [Bielejec et al., 2011](#references).  

Select the `Open` button in the panel under `Load tree file`, 
and select the summary tree file `h5n1_with_trait.tree`.
Change the `State attribute name` to the name of the trait,   
which is `location` in this analysis.
Click the `Setup` button. A dialog pops up where you can edit altitude and
longitude for the locations. Alternatively, you can load it from a tab-delimited
file. A file `locationCoordinates_H5N1.txt` is prepared in [Spread website](https://www.kuleuven.be/aidslab/phylogeography/SPREAD.html).

Tip: to find latitude and longitude of locations, you can use Google maps,
switch on photo's and select a photo at the location of the map. Click the
photo, then click `Show in Panoramio` and a new page opens that contains the
locations where the photo was taken. An alternative is to use `Google Earth`, and
point the mouse to the location. Google-Earth shows latitude and longitude of
the mouse location at the bottom of the screen.

Now, open the `Output` tab in the panel on the left hand side. Here, you
can choose where to save the KML file (default `output.kml`).
Select the `generate` button to generate the KML file, and a world map
appears with the tree superimposed onto the area where the rabies epidemic
occurred.

If you have a problem to generate KML file, 
you can download a prepared [output.kml](h5n1Bernoulli/output.kml).

The KML file can be read into `Google Earth`. Then, the spread of the epidemic
can be animated through time. The coloured areas represent the 95% HPD
regions of the locations of the internal nodes of the summary tree.


## Programs used in this Exercise

{% include_relative templates/programs-used.md %}
- BEAST classic package - Phylogeography is a part of the BEAST-CLASSIC package. 
BEAST-CLASSIC requires the BEASTlabs package.
You can install them from [BEAST 2 package manager](http://www.beast2.org/managing-packages/).
- Babel - A BEAST package containing tools for post-analysis. We will use `StateTransitionCounter`.
- Spread - summarising the geographic spread in a KML file (available
from [http://www.kuleuven.ac.be/aidslab/phylogeography/SPREAD.html](http://www.kuleuven.ac.be/aidslab/phylogeography/SPREAD.html).
- Google-earth - displaying the KML file (just Google for it, if you have
not already have it installed).


[//]: # (## Data, Model, Posterior)
{% include_relative discrete-phylogeography/narrative.md %}


## Useful Links

{% include_relative templates/links.md %}


[//]: # (## References)

{% include_relative discrete-phylogeography/references.md %}
* Lemey, P., Rambaut, A., Drummond, A. J. and Suchard,
M. A. (2009). Bayesian phylogeography finds its roots. PLoS Comput Biol
5, e1000520.
* Wallace, R., HoDac, H., Lathrop, R. and Fitch, W.
(2007). A statistical phylogeography of influenza A H5N1. Proceedings of
the National Academy of Sciences 104, 4473.
* Bielejec F., Rambaut A., Suchard M.A & Lemey P. (2011). 
SPREAD: Spatial Phylogenetic Reconstruction of Evolutionary Dynamics. 
Bioinformatics, 27(20):2910-2912. doi:10.1093.
* Douglas, J., Mendes, F. K., Bouckaert, R., Xie, D., Jimenez-Silva, C. L., Swanepoel, C., ... & Drummond, A. J. (2020). Phylodynamics reveals the role of human travel and contact tracing in controlling COVID-19 in four island nations. doi: https://doi.org/10.1101/2020.08.04.20168518 
