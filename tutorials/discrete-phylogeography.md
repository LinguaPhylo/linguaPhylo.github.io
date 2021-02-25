---
layout: page
title: Ancestral Reconstruction using Discrete Phylogeography
author: 'Walter Xie, Remco Bouckaert, and Alexei Drummond'
permalink: /tutorials/discrete-phylogeography/
---

It guides you through a discrete phylogeography analysis of a H5N1 epidemic in South China. 
This analysis will use the model developed by [Lemey et al., 2009](#references) 
that implements ancestral reconstruction of discrete states (locations) in a Bayesian statistical framework, 
and employs the Bayesian stochastic search variable selection (BSSVS) to identify the most parsimonious description of 
the phylogeographic diffusion process.

The additional benefit using this model is that we can summarise the phylogeographic inferences from an analysis,
and use a virtual globe software to visualize the spatial and temporal information.


## Programs used in this Exercise

{% include_relative programs-used.md %}
- BEAST classic package - Phylogeography is a part of the BEAST-CLASSIC package. 
BEAST-CLASSIC requires the BEASTlabs package.
You can install them from [BEAST 2 package manager](http://www.beast2.org/managing-packages/).
- Spread - summarising the geographic spread in a KML file (available
from http://www.kuleuven.ac.be/aidslab/phylogeography/SPREAD.html.
- Google-earth - displaying the KML file (just Google for it, if you have
not already have it installed).


## The NEXUS alignment

{% include_relative download-data.md df='h5n1' 
                    df_link='https://raw.githubusercontent.com/BEAST2-Dev/beast-classic/master/examples/nexus/H5N1.nex' %}

The data is a subset of original dataset [Wallace et al., 2007](#references), 
and it consists of 43 influenza A H5N1 hemagglutinin and neuraminidase gene sequences 
isolated from a variety of hosts 1996 - 2005 across sample locations.


## Constructing the scripts in LPhy Studio

{% include_relative lphy-scripts.md %}

{% capture lphy_html %}
{% include_relative discrete-phylogeography/lphy.html %}
{% endcapture %}

{::nomarkdown}
{{ lphy_html | replace: "11pt", "10pt" }}
{:/}


{% include_relative lphy-studio.md lphy="h5n1" fignum="Figure 1" %}


### Data block

{% include_relative lphy-data.md %}

### Tip dates

{% include_relative tip-dates-forward.md  earliest='1997' 
                    date_in_name='after the last `_`' 
                    since='1900' regex='_(\d+)$' last='2005' %}

### Tip locations

{% include_relative discrete-traits.md  locations='Fujian, HongKong, Hunan, Guangxi, and Guangdong' 
                    using='`extractTrait` given the separator `_`, and taking the 3rd element given `i=2`' 
                    traits='trait_D' %}

The function `extractTrait` creates an one-site alignment `trait_D` to store the locations which map to taxa. 
It is called as the discrete trait alignment. 
The 2nd graphical component `trait_D` (blue circle) on the bottom is the random variable containing the discrete trait alignment simulated by the defined priors and models.
Because we clamped the discrete trait alignment containing the actual locations to the `trait_D` in this analysis,
it will use the actual locations instead of simulated locations.


### Model block

{% include_relative lphy-model.md %}

In this analysis, we have two parts mixed in the `model` section: 
the first part is modeling evolutionary history and demographic structure based on a nucleotide alignment, 
and the second part is defining how to sample the discrete states (locations) from the phylogeny $\psi$ shared with the 1st part.

For the nucleotide alignment, we use the HKY model with estimated frequencies. 
{% include_relative rate-heterogeneity.md %}
More details can be seen in the [Bayesian Skyline Plots](/tutorials/skyline-plots/#constructing-the-model-block-in-linguaphylo) tutorial. 

We use a strict molecular clock, but to make the analysis converge a bit quicker, 
it is fixed to 0.004. 
We choose a Kingman coalescent tree generative distribution as the tree prior. 

Then we define the priors for the following parameters:
1. the effective population size _$\theta$_;  
2. the transition/transversion ratio _$\kappa$_;
3. the base frequencies _$\pi$_.
4. the shape of the discretized gamma distribution _shape_. 

The next step is the geographic model. 
In the discrete phylogeography, the probability of transitioning to a new location through the time is computed by 

$$ P(t) = e^{\Lambda t} $$ 

where $\Lambda$ is a $ K \times K $ infinitesimal rate matrix, 
and $K$ is the number of discrete locations (i.e. 5 locations here). Then, 

$$ \Lambda = \mu S \Pi $$

where $\mu$ is an overall rate scalar, $S$ is a $ K \times K $ matrix of relative migration rates,
and $\Pi = diag(\pi)$ where $\pi$ is the equilibrium trait frequencies.
After the normalization, $\mu$ measures the number of migration events per unit time $t$.
The detail is explained in [Lemey et al., 2009](#references).

So, assuming migration to be symmetric in this analysis, we define a vector variable `trait_rates` with the length of $ \frac{K \times (K-1)}{2} $ to store the off-diagonal entries of the unnormalised $S$. Another boolean vector `trait_indicators` with the same length determines which infinitesimal rates are zero, 
which is performed by the function `select`. 
This implements the Bayesian stochastic search variable selection (BSSVS).  

In addition, we define the priors for the following parameters:
5. the trait clock rate _traitClockRate_;
6. the relative migration rates *trait_indicators*;
7. the trait frequencies *trait_$\pi$*. 


## Producing BEAST XML using LPhyBEAST

{% include_relative lphy-beast.md lphy="h5n1" nex="H5N1" %}

```
java -jar LPhyBEAST.jar -l 30000000 h5n1.lphy
```


## Running BEAST

{% include_relative run-beast.md xml="h5n1.xml" %}

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
ScaleOperator(traitClockRate.scale)                 0.26742       7628      18202    0.00866    0.29532 
UpDownOperator(traitClockRateUppsiDownOperator)     0.92616      49514     312158    0.12047    0.13690 
BitFlipOperator(trait_indicators.bitFlip)                 -      40470      89769    0.04340    0.31074 
DeltaExchangeOperator(trait_pi.deltaExchange)       0.54731      10613      58216    0.02285    0.15419 
DeltaExchangeOperator(trait_rates.deltaExchange)    0.56871      16443     104534    0.04031    0.13592 

     Tuning: The value of the operator's tuning parameter, or '-' if the operator can't be optimized.
    #accept: The total number of times a proposal by this operator has been accepted.
    #reject: The total number of times a proposal by this operator has been rejected.
      Pr(m): The probability this operator is chosen in a step of the MCMC (i.e. the normalized weight).
  Pr(acc|m): The acceptance probability (#accept as a fraction of the total proposals for this operator).


Total calculation time: 244.148 seconds
End likelihood: -5953.588976905855
```

## Analysing the BEAST output

Run the program called `Tracer` to analyze the output of BEAST. When the
main window has opened, choose `Import Trace File...` from the `File` menu
and select the file that BEAST has created called `h5n1.log`. You should now
see a window like in Figure 3.

<figure class="image">
  <img src="Tracer.png" alt="The trace of short run">
  <figcaption>Figure 3: A screenshot of Tracer.</figcaption>
</figure>

Remember that MCMC is a stochastic algorithm so the actual numbers will
not be exactly the same.
On the left hand side is a list of the different quantities that BEAST has logged. 
There are traces for the posterior (this is the log of the product of
the tree likelihood and the prior probabilities), and the continuous parameters.
Selecting a trace on the left brings up analyses for this trace on the right hand
side depending on tab that is selected. When first opened, the "posterior"" trace
is selected and various statistics of this trace are shown under the Estimates
tab. In the top right of the window is a table of calculated statistics for the
selected trace.

Tracer will plot a (marginal posterior) distribution for the selected parameter
and also give you statistics such as the mean and median. The 95% HPD lower
or upper stands for highest posterior density interval and represents the most
compact interval on the selected parameter that contains 95% of the posterior
probability. It can be thought of as a Bayesian analog to a confidence interval.


## Obtaining an estimate of the phylogenetic tree

{% include_relative tree-annotator.md fignum="Figure 4" %}


Summary trees can be viewed using FigTree (a program separate from BEAST) and DensiTree (distributed with BEAST).

<figure class="image">
  <img src="RSV2.tree.svg" alt="MCC tree">
  <figcaption>Figure 5: The Maximum clade credibility tree for the G gene of 129 RSVA-2 viral samples.</figcaption>
</figure>


BEAST also produces a sample of plausible trees. These can be summarized
using the program TreeAnnotator. This will take the set of trees and identify
a single tree that best represents the posterior distribution. It will then anno-
tate this selected tree topology with the mean ages of all the nodes as well as
the 95% HPD interval of divergence times for each clade in the selected tree.
It will also calculate the posterior clade probability for each node. Run the
TreeAnnotator program and set it up to look like in Figure 4.

The burnin is the number of trees to remove from the start of the sample.
Unlike Tracer which specifies the number of steps as a burnin, in TreeAnno-
tator you need to specify the actual number of trees. For this run, we use the
14default setting 0.
The Posterior probability limit option specifies a limit such that if a
node is found at less than this frequency in the sample of trees (i.e., has a
posterior probability less than this limit), it will not be annotated. Set this to
0 to annotate all nodes.
For Target tree type you can either choose a specific tree from a file or ask
TreeAnnotator to find a tree in your sample. The default option, Maximum
clade credibility tree, finds the tree with the highest product of the posterior
probability of all its nodes.
Choose Mean heights for node heights. This sets the heights (ages) of each
node in the tree to the mean height across the entire sample of trees for that
clade.
For the input file, select the trees file that BEAST created (by default this
will be called location tree with trait.trees) and select a file for the output
(here we called it location tree with trait.tree).
Now press Run and wait for the program to finish.



## Distribution of root location

When you open the summary tree location tree with trait.tree in a text
editor, and look at the end of the tree definition, grab the last entry for loca-
tion.set and location.set.prob. They might look something like this:
location.set = {"Hunan","Guangxi","Fujian","HongKong","Guangdong"}
location.set.prob = {0.024983344437041973, 0.16822118587608262, 0.05463024650233178,
0.6085942704863424, 0.1435709526982012}
This means that we have the following distribution for the root location:


This distribution shows that the 95% HPD consists of all locations except
Hunan, with a strong indication that Hong-Kong might be the root with over
60% probability. It is quite typical that a lot of locations are part of the 95%
HPD in discrete phylogeography.


## Viewing the Location Tree

We can look at the tree in another program called FigTree. Run this program,
and open the location tree with trait.tree file by using the Open command
in the File menu. The tree should appear. You can now try selecting some
of the options in the control panel on the left. Try selecting Appearance to
get colour on the branches by location. Also, you can set the branch width
according to posterior support. You should end up with something like Figure
5.


Alternatively, you can load the species tree set (note this is NOT the sum-
mary tree, but the complete set) into DensiTree and set it up as follows.
- Set burn-in to 300. The tree should not be collapsed any more.
- Show a root-canal tree to guide the eye.
- Show a grid, and play with the grid options to only show lines at 2 year
intervals covering round numbers (that is, 2000, instead of 2001.22).
The image should look something like Figure 4.
You can colour branches by location to get something like Figure 6.

<figure class="image">
  <img src="DensiTree.png" alt="MCC tree">
  <figcaption>Figure 6: The posterior tree set visualised in DensiTree.</figcaption>
</figure>

## Post processing geography

Start spread by double clicking the `spread.jar` file.

Select the `Open` button in the panel under `Load tree file`, and select the
summary tree file.
Change the `State attribute name` to the name of the trait. 
We used `location` so change it to location.
Click the set-up button. A dialog pops up where you can edit altitude and
longitude for the locations. Alternatively, you can load it from a tab-delimited
file. A file named `H5N1locations.dat` is prepared already.
Tip: to find latitude and longitude of locations, you can use Google maps,
switch on photo's and select a photo at the location of the map. Click the
photo, then click `Show in Panoramio` and a new page opens that contains the
locations where the photo was taken. An alternative is to use Google-earth, and
point the mouse to the location. Google earth shows latitude and longitude of
the mouse location at the bottom of the screen.
Now, open the `Output` tab in the panel on the left hand side. Here, you
can choose where to save the KML file (default `output.kml`).
Select the `generate` button to generate the KML file, and a world map
appears with the tree superimposed onto the area where the rabies epidemic
occurred.
The KML file can be read into Google earth. Here, the spread of the epidemic
can be animated through time. The coloured areas represent the 95% HPD
regions of the locations of the internal nodes of the summary tree.


## Questions



## Useful Links

{% include_relative links.md %}


## References

* Lemey, P., Rambaut, A., Drummond, A. J. and Suchard,
M. A. (2009). Bayesian phylogeography finds its roots. PLoS Comput Biol
5, e1000520.
* Wallace, R., HoDac, H., Lathrop, R. and Fitch, W.
(2007). A statistical phylogeography of influenza A H5N1. Proceedings of
the National Academy of Sciences 104, 4473.
