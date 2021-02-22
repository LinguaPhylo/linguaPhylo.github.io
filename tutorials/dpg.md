---
layout: page
title: Ancestral Reconstruction using Discrete Phylogeography
author: 'Walter Xie and Alexei Drummond'
permalink: /tutorials/dpg/
---

This tutorial is modified from the BEAST tutorial [Ancestral Reconstruction/Discrete
Phylogeography with BEAST](https://www.beast2.org/tutorials/).

This tutorial guides you through a discrete phylogeography analysis 
(developed by [Lemey et al., 2009](#references)) of a H5N1 epidemic in South China. 


## Programs used in this Exercise

{% include_relative programs-used.md %}
- BEAST classic package - Phylogeography is a part of the BEAST-CLASSIC package. 
BEAST-CLASSIC requires the BEASTlabs package.
You can install them from [BEAST 2 package manager](http://www.beast2.org/managing-packages/).
- Spread - summarysing the geographic spread in a KML file (available
from http://www.kuleuven.ac.be/aidslab/phylogeography/SPREAD.html.
- Google-earth - displaying the KML file (just Google for it, if you have
not already have it installed).


## The NEXUS alignment

{% include_relative download-data.md df='h5n1' df_link='https://raw.githubusercontent.com/BEAST2-Dev/beast-classic/master/examples/nexus/H5N1.nex' %}

The data is a subset of a larger set compiled
by [Wallace et al., 2007](#references). It consists of 43 sequences of 1698 nucleotides.


## Constructing the scripts in LPhy Studio

{% include_relative lphy-scripts.md %}

{::nomarkdown}
{% include_relative dpg/lphy.html %}
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

The function `extractTrait` creates an one-site alignment `trait_D` to store the locations. 
It is called as the discrete trait alignment. 
The graphical component `trait_D` (blue circle) on the bottom is the simulated locations from the priors and models.
Because we clamped the discrete trait alignment containing the actual locations to the `trait_D` in this analysis,
it will use the actual locations instead of simulated locations.


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

{% include_relative lphy-beast.md lphy="h5n1" nex="H5N1" %}

```
java -jar LPhyBEAST.jar h5n1.lphy
```


## Running BEAST

<figure class="image">
  <img src="outercore.png" alt="Package manager">
  <figcaption>Figure 2: A screenshot of Package Manager.</figcaption>
</figure>

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

Run the program called `Tracer` to analyze the output of BEAST. When the
main window has opened, choose `Import Trace File...` from the `File` menu
and select the file that BEAST has created called `h5n1.log`. You should now
see a window like in Figure 3.

<figure class="image">
  <img src="short.png" alt="The trace of short run">
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
Select the ‘generate` button to generate the KML file, and a world map
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
