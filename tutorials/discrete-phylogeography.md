---
layout: page
title: Ancestral Reconstruction using Discrete Phylogeography
author: 'Walter Xie, Remco Bouckaert, and Alexei Drummond'
permalink: /tutorials/discrete-phylogeography/
---


**If you haven't installed LPhy Studio and LPhyBEAST yet**, please refer to the 
[User Manual](/setup) for their installation. 
Additionally, this tutorial requires other third-party programs, 
which are listed below under the section 
[Programs used in this tutorial](#programs-used-in-this-tutorial).  

This tutorial guides you through a discrete phylogeography analysis of a H5N1 epidemic in South China. 
The analysis will use the model developed by [Lemey et al., 2009](https://doi.org/10.1371/journal.pcbi.1000520) 
that implements ancestral reconstruction of discrete states (locations) in a Bayesian statistical framework, 
and employs the Bayesian stochastic search variable selection (BSSVS) to identify the most plausible description of 
the phylogeographic diffusion process.

The additional benefit in using this model is that we can summarise the phylogeographic inferences from an analysis,
and use a virtual globe software to visualise the spatial and temporal information.

## The NEXUS alignment

{% include_relative templates/locate-data.md df='H5N1' 
                    df_link='https://raw.githubusercontent.com/LinguaPhylo/linguaPhylo/master/tutorials/data/H5N1.nex' %}

This alignment is a subset of original dataset [Wallace et al., 2007](https://doi.org/10.1073/pnas.0700435104), 
and it consists of 43 influenza A H5N1 hemagglutinin and neuraminidase gene sequences. 
These sequences were isolated from a diverse range of hosts over the period from 1996 to 2005 
across various sampling locations.


## Loading the script "h5n1" to LPhy Studio

{% include_relative templates/lphy-studio-intro.md script='h5n1'%}

[//]: # (## Code, Graphical Model)
{% include_relative discrete-phylogeography/lphy.md fignum="Figure 1" %}

## Data block

In the `data` block, we begin by defining an option to extract the sample times 
from the taxa labels using a regular expression `_(\d+)$`, 
and we treat those times as dates (i.e., moving `forward` in time). 
For instance, the taxon "A_chicken_Fujian_1042_2005" will yield the year 2005, 
making the age of this tip 0 since 2005 is the latest year among these samples.
Clicking on the orange diamond labeled "taxa", you can see all taxa along with their ages, 
which have been converted from the years extracted from their labels.
If it is not in the probabilistic graphical model, please select the checkbox `Show constants` 
to display the [full model](FullModel.png). 

Next, we read the file "H5N1.nex" and load it into an alignment `D`, 
using the previously defined options. 
Following that, we assign the constant `L` to represent the number of sites in alignment `D`, 
and we retrieve the vector of `taxa` names from the alignment `D`.

The line using the function `extractTrait` extracts the locations from the taxa names 
by splitting the string by "_" and taking the __3rd__ element (where `i` starts at 0). 
This code creates a trait alignment `D_trait` containing the locations mapped to each taxon. 
Then the method `canonicalStateCount()` counts the number of unique canonical states (locations) 
in the trait alignment `D_trait` and assigns this number to the constatnt `K`.
This method excluds ambiguous states.
The constant `dim` used as the dimension for sampling discrete traits is computed from `K`.


## Model block

In the `model` block, we have mixed two parts. 
The first part is modeling evolutionary history and demographic structure 
based on a nucleotide alignment, 
and the second part is defining how to sample the discrete states (locations) 
from the phylogeny shared with the 1st part.

### Coalescent based phylogenetic model

The canonical model in the first part of this analysis includes the following parameter distributions:

1. Dirichlet prior on, `π`, the equilibrium nucleotide frequencies 
   (with 4 dimensions, one for each nucleotide);
2. LogNormal prior on, `κ`, the transition/transversion ratio;
3. LogNormal prior on, `γ`, the shape parameter of discretize Gamma;
4. Discretized gamma prior on, `r`, the vector of site rates with a rate for each site in the alignment;
5. LogNormal prior on, `Θ`, the effective population size;
6. Coalescent (constant-size) prior on, `ψ`, 
   the time-scaled phylogenetic tree which is scaled according to the unit of sampling time 
   associated with taxa. The time unit in this data is years.

Finially, the phylogenetic continuous-time Markov chain distribution, `PhyloCTMC`, 
utilizes the instantaneous rate matrix `Q` retured from a deteminstic function `hky`,
the site rates `r`, and the simulated Coalescent tree `ψ` as inputs, 
along with a fixed value of `0.004` for the mutation rate, to generate the alignment `D`.   

For more details, please read the auto-generated [narrative](#auto-generated) from LPhy Studio.


### Geographic Model

The next part is the geographic model. In the discrete phylogeography, 
the probability of transitioning to a new location through the time is computed by 

$$ P(t) = e^{\Lambda t} $$ 

where $\Lambda$ is a $ K \times K $ infinitesimal rate matrix, 
and $K$ is the number of discrete locations (i.e. 5 locations here). Then, 

$$ \Lambda = \mu S \Pi $$

where $\mu$ is an overall rate scalar, $S$ is a $ K \times K $ matrix of relative migration rates,
and $\Pi = diag(\pi)$ where $\pi$ is the equilibrium trait frequencies.
After the normalization, $\mu$ measures the number of migration events per unit time $t$.
The detail is explained in [Lemey et al., 2009](#references).

So, assuming migration to be symmetric in this analysis:

{:start="7"}
7. We define a vector variable `R_trait` with the length of $ \frac{K \times (K-1)}{2} $ 
   to store the off-diagonal entries of the unnormalised $S$, which is sampled from 
   a Dirichlet distribution. 
8. A boolean vector `I` with the same length determines which infinitesimal rates are zero, 
   and it is sampled from the vectorized function `Bernoulli` using the keyword `replicates`. 
   This along with the deterministic function `select` implements 
   the Bayesian stochastic search variable selection (BSSVS). 
9. The base frequencies `π_trait` are sampled from a Dirichlet distribution. 
10. The deteminstic function `generalTimeReversible` takes relative rates filtered by `select`, 
    which selects a value if the indicator is true or returns 0 otherwise,
    along with base frequencies to produce the general time reversible rate matrix `Q_trait`.
11. The migration rate, `μ_trait`, is sampled from a LogNormal distribution.

In the end, the 2nd `PhyloCTMC` takes the instantaneous rate matrix `Q_trait`, 
the data type from the clamped alignment `D_trait` imported in the `data` block,
the migration rate `μ_trait`, the same tree `ψ` sampled from the 1st part of this model as inputs,
to simulate the location alignment `D_trait` whose supposes to have only one site.  

As you have noticed, there are two `D_trait` in this script, one is in the `data` block,
the other is in the `model` block. This is called data clamping. 
The detail can be refered to either the section "2.1.11 Inference and data clamping" 
in the [LPhy paper](https://doi.org/10.1371/journal.pcbi.1011226) 
or visit the [LPhy language features](https://linguaphylo.github.io/features/#data-clamping) page. 


## Producing BEAST XML using LPhyBEAST

{% include_relative templates/lphy-beast.md args="" lphy="h5n1" %}

If you want the longer chain length, you can use the `-l` option to modify the MCMC chain length in the XML. 
The default is 1 million.

After LPhyBEAST completes the run, it will print a location information for the BEAST 2 XML 
at the end of the message. 

## Running BEAST

{% include_relative templates/run-beast.md xml="h5n1.xml" %}

<figure class="image">
  <a href="BEAST.png" target="_blank">
  <img src="BEAST.png" alt="BEAST"></a>
  <figcaption>Figure 2: Provide the XML to BEAST 2.</figcaption>
</figure>

The [h5n1.xml](h5n1/h5n1.xml) 
is also provided as an additional resource, in case you need to use it for your analysis. 

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

Random number seed: 1751498377517

    ...

    ...
         950000     -5968.4116     -5843.2135      -125.1981         0.3346         0.1999         0.2202         0.2451         7.5688         0.3837         8.8686         0.1018         0.3061         0.2627         0.2301         0.0990              1              1              1              0              1              1              0              1              1              0         0.1446         0.2821         0.1248         0.1256         0.0406         0.0402         0.1349         0.0389         0.0421         0.0257         0.2660 1m25s/Msamples
        1000000     -5947.6786     -5828.5842      -119.0943         0.3356         0.2008         0.2158         0.2476         9.0574         0.2767         6.4146         0.1127         0.2849         0.1524         0.3138         0.1359              1              1              0              1              0              1              1              1              1              0         0.2870         0.2035         0.1539         0.0236         0.1138         0.0062         0.0249         0.0636         0.1174         0.0057         0.5793 1m25s/Msamples

Operator                                                                                       Tuning    #accept    #reject      Pr(m)  Pr(acc|m)
beast.base.inference.operator.BitFlipOperator(I.bitFlip)                                            -      16124      36683    0.05277    0.30534 
beast.base.inference.operator.kernel.BactrianDeltaExchangeOperator(R_trait.deltaExchange)     0.36270       6243      42499    0.04902    0.12808 
kernel.BactrianScaleOperator(Theta.scale)                                                     0.34135       3200       7426    0.01053    0.30115 
kernel.BactrianScaleOperator(gamma.scale)                                                     0.39153       3186       7382    0.01053    0.30148 
kernel.BactrianScaleOperator(kappa.scale)                                                     0.27344       2953       7609    0.01053    0.27959 
kernel.BactrianScaleOperator(mu_trait.scale)                                                  0.74609       3168       7339    0.01053    0.30151 
beast.base.inference.operator.kernel.BactrianUpDownOperator(mu_traitUppsiDownOperator)        0.29436        112     146071    0.14650    0.00077 Try setting scale factor to about 0.147
beast.base.inference.operator.kernel.BactrianDeltaExchangeOperator(pi.deltaExchange)          0.03844       5260      17677    0.02272    0.22932 
beast.base.inference.operator.kernel.BactrianDeltaExchangeOperator(pi_trait.deltaExchange)    0.25549       7346      20478    0.02779    0.26402 
EpochFlexOperator(psi.BICEPSEpochAll)                                                         0.05031       4892      12138    0.01711    0.28726 
EpochFlexOperator(psi.BICEPSEpochTop)                                                         0.05799       2496       8003    0.01053    0.23774 
TreeStretchOperator(psi.BICEPSTreeFlex)                                                       0.04849      45709      98680    0.14411    0.31657 
Exchange(psi.narrowExchange)                                                                        -      24785     119301    0.14411    0.17202 
kernel.BactrianScaleOperator(psi.rootAgeScale)                                                0.22159         98      10445    0.01053    0.00930 Try setting scale factor to about 0.111
kernel.BactrianSubtreeSlide(psi.subtreeSlide)                                                 0.48656      21723     122340    0.14411    0.15079 
kernel.BactrianNodeOperator(psi.uniform)                                                      1.78495      49685      94458    0.14411    0.34469 
Exchange(psi.wideExchange)                                                                          -        108      22148    0.02224    0.00485 
WilsonBalding(psi.wilsonBalding)                                                                    -        131      22105    0.02224    0.00589 

     Tuning: The value of the operator's tuning parameter, or '-' if the operator can't be optimized.
    #accept: The total number of times a proposal by this operator has been accepted.
    #reject: The total number of times a proposal by this operator has been rejected.
      Pr(m): The probability this operator is chosen in a step of the MCMC (i.e. the normalized weight).
  Pr(acc|m): The acceptance probability (#accept as a fraction of the total proposals for this operator).


Total calculation time: 87.253 seconds
End likelihood: -5947.678660781594
Done!

```

## Analysing the BEAST output

{% include_relative templates/tracer.md logfile="h5n1" fignum="Figure 3" %}

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
or __upper__ stands for the _highest posterior density interval_ and represents the most
compact interval on the selected parameter that contains 95% of the posterior
probability. It can be thought of as a Bayesian analog to a confidence interval.

In the implemented phylogeographic model, the rate matrix is symmetric, 
meaning that a relative migration rate between two locations solely represents 
a numerical value without implying any direction. 
Consequently, for 5 locations, there are only 10 relative migration rates, 
as illustrated in Figure 4.

<figure class="image">
  <a href="migRateMatrix.png" target="_blank">
  <img src="migRateMatrix.png" alt="DensiTree"></a>
  <figcaption>Figure 4: The posterior of relative migration rates between two locations.</figcaption>
</figure>

The [h5n1.log](h5n1/h5n1.log) 
is also provided as an additional resource, in case you need to use it for your analysis. 

## Summarizing posterior trees

{% include_relative templates/tree-annotator.md fig="TreeAnnotator.png" 
                    fignum=5 trees="h5n1_with_trait.trees" mcctree="h5n1_with_trait.tree"%}

Both [h5n1_with_trait.trees](h5n1/h5n1_with_trait.trees) and [h5n1_with_trait.tree](h5n1/h5n1_with_trait.tree) 
are provided as an additional resource, in case you need to use it for your analysis. 


## Distribution of root location

When you open the summary tree with locations `h5n1_with_trait.tree` in a text editor, 
and scroll to the most right and locate the end of the tree definition, 
you can see the set of meta data for the root. 
Looking for the last entries of `location.set` and `location.set.prob`, 
you might find something like this:
```
location.set = {Guangdong,HongKong,Hunan,Guangxi,Fujian}
location.set.prob = {0.1793448084397557,0.5985563575791227,0.03997779011660189,0.1265963353692393,0.0555247084952804}
```
This means that we have the following distribution for the root location:

| Location| Probability      |
|---------|------------------|
|Guangdong|0.1793448084397557|
|HongKong|0.5985563575791227|
|Hunan|0.03997779011660189|
|Guangxi|0.1265963353692393|
|Fujian|0.0555247084952804|

This distribution shows that the 95% HPD consists of all locations except Hunan, 
with a strong indication that HongKong might be the root with over 59% probability. 
It is quite typical that a lot of locations are part of the 95% HPD in discrete phylogeography.


## Viewing the Location Tree

We can visualise the tree in a program called _FigTree_. 
There is a bug to launch the Mac version of FigTree v1.4.4. 
Feel free to visit our [Tech Help](/tutorials/tech-help) page 
if you encounter any difficulties or need assistance.
  
Lauch the program, and follow the steps below:

1. Open the summary tree file `h5n1_with_trait.tree` by using the `Open...` option in the `File` menu;
2. After the tree appears, expend `Appearance` and choose `Colour` by `location`;
3. Additionally, you can adjust the branch width based on the posterior support of 
   estimated locations by selecting `Width by` `location.prob`. 
4. Gradually increasing the `Line Weight` can make the branch widths vary more significantly 
   based on their posterior supports.
5. To add a legend, tick `Legend` and choose `location` from the drop-down list of `Attribute`;
6. If you want to see the x-axis scale, you can tick `Scale Axis`, 
   expend it and uncheck the option `Show grid`. 

You should end up with something like Figure 6
<figure class="image">
  <a href="h5n1_with_trait.tree.svg" target="_blank">
  <img src="h5n1_with_trait.tree.svg" alt="Summarised tree"></a>
  <figcaption>Figure 6: Figtree representation of the summary tree. 
  Branch colours represent location and branch widths posterior support for the branch.</figcaption>
</figure>

Alternatively, you can use _DensiTree_ to visulize the set of posterior trees  
and set it up as follows:

1. Use the `Load` option in the `File` menu to load the trees from `h5n1_with_trait.trees` 
   (note this is NOT the summary tree, but the complete set);
2. Click `Show` to choose `Root Canal` tree to guide the eye;
3. Click `Grid` to choose `Full grid` option, type "2005" in the `Origin` text field which is the year,
   and tick `Reverse` to show the correct time scale; 
   You also can reduce the `Digits` to 0 which will rounding years in the x-axis 
   (i.g. 2005, instead of 2005.22);
4. Go to `Line Color`, you can colour branches by `location` and tick `Show legend`.

The final image look like Figure 7.

<figure class="image">
  <a href="DensiTree.png" target="_blank">
  <img src="DensiTree.png" alt="DensiTree"></a>
  <figcaption>Figure 7: The posterior tree set visualised in DensiTree.</figcaption>
</figure>

## Bonus sections

### The number of estimated transitions

To visualize how the location states change through the phylogeny, 
you can use the `StateTransitionCounter` tool, which counts the number of branches 
in a tree or a set of trees that have a certain state at the parent and another state at the node.

To use StateTransitionCounter, first, install the `Babel` package and then 
run the tool through the BEAST application launcher. 
The command below will generate the output file `stc.out` containing all counts 
from the logged posterior trees `h5n1_with_trait.trees`, after removing 10% burn-in.

```bash
$BEAST2_PATH/bin/applauncher StateTransitionCounter -burnin 10 -in h5n1_with_trait.trees -tag location -out stc.out
```

Make sure you have installed the latest versions of Babel (>= v0.4.x) and BEASTLabs (>= v2.0.x) 
to ensure smooth execution.

Next, we will use R to plot the histogram based on the summary in `stc.out`. 
If you encounter any issues generating it, you can download a prepared file 
[stc.out](h5n1/stc.out). 
Additionally, download the script [PlotTransitions.R](PlotTransitions.R), 
which contains functions to parse the file and plot the histograms. 
Before running the script, make sure you have installed the R packages `ggplot2` and `tidyverse`.

Run the following scripts in R, where `R_SRC_PATH` is the folder containing R code, 
and `YOUR_WD` is the folder containing the `stc.out` file:

```R
setwd(R_SRC_PATH)
source("PlotTransitions.R")
setwd(YOUR_WD)

# stc.out must be in YOUR_WD
stc <- parseTransCount(input="stc.out", pattern = "Histogram", target="Hunan")
# only => Hunan
p <- plotTransCount(stc$hist[grepl("=>Hunan", stc$hist[["Transition"]]),], 
        colours = c("Fujian=>Hunan" = "#D62728", "Guangdong=>Hunan" = "#C4C223", 
                    "Guangxi=>Hunan" = "#60BD68", "HongKong=>Hunan" = "#1F78B4"))
ggsave( paste0("transition-distribution-hunan.png"), p, width = 6, height = 4) 
```

The `stc` file contains a statistical summary of the estimated transition counts 
related to the target location, which is `Hunan`, and a table of the actual counts. 
To plot a simple graph, we will pick up the transitions to Hunan in the next command 
and then save the graph as a PNG file. The counts will be normalized into probabilities.

<figure class="image">
  <a href="transition-distribution-hunan.png" target="_blank">
  <img src="transition-distribution-hunan.png" alt="DensiTree">
  </a>
  <figcaption>Figure 8: The probability distribution of estimated transitions into Hunan from other places.</figcaption>
</figure>

The x-axis represents the number of estimated transitions in all migration events 
from one particular location to another, separated by "=>", 
and the y-axis represents the probability, which is normalized from the total counts. 
From the graph, we can observe that "Guangxi => Hunan" (in blue) has a higher probability 
than other migration events. 
This type of visualization quantifies the uncertainty in how the disease (H5N1) spreads 
between locations of interest, as simulated from your model and given the data.
For more details and visualizations, you can refer to the work of [Douglas et. al. 2020](#references).

### Visualizing phylogeographic diffusion

To analyze and visualize phylogeographic reconstructions resulting from Bayesian inference of 
spatio-temporal diffusion based on the [Bielejec et al., 2011](#references) method, 
we can use a software called `spread`. 

__Please note__ it requires Java 1.8. If you run into any issues or need support, 
don't hesitate to check out our [Tech Help](/tutorials/tech-help/#switch-the-java-version) page. 

We recommend to download the .jar file from the 
[Spread website](https://rega.kuleuven.be/cev/ecv/software/spread), and follow the steps below:

1. Start the `spread` application by using the command `java -jar SPREADv1.0.7.jar`.
2. Select the `Open` button in the panel under `Load tree file`.
3. Choose the summary tree file `h5n1_with_trait.tree``.
4. Change the `State attribute name` to the name of the trait, which is `location` in this analysis.
5. Click the `Setup` button to edit altitude and longitude for the locations. 
   You can also load this information from a tab-delimited file, and a prepared file 
   [locationCoordinates_H5N1.txt](locationCoordinates_H5N1.txt) 
   is also available. Remeber to click `Done` button to save the information into spread.
6. Change the `Most recent sampling date` to `2005`.
7. Open the `Output` tab in the left-hand side panel, 
   and then choose where to save the KML file (default is `output.kml`).
8. Click the `Generate` button to create the KML file.

The world map with the tree superimposed onto the area where the rabies epidemic occurred 
will be displayed.
If you encounter any issues generating the KML file, you can download a prepared 
[output.kml](h5n1/output.kml).

The KML file can be imported into Google Earth, 
allowing you to animate the spread of the epidemic through time. 
The colored areas on the map represent the 95% Highest Posterior Density (HPD) regions of 
the locations of the internal nodes of the summary tree.

<figure class="image">
  <a href="GoogleEarth.jpg" target="_blank">
  <img src="GoogleEarth.jpg" alt="GoogleEarth">
  </a>
  <figcaption>Figure 9: The screen shot from Google Earth.</figcaption>
</figure>


## Programs used in this tutorial

{% include_relative templates/programs-used.md %}
* BEAST classic package - a BEAST 2 package includes the discrete phylogeography model 
  introduced in this tutorial. 

* Babel - a BEAST 2 package contains tools for post-analysis. 
  We will use `StateTransitionCounter` to estimate the number of transitions among locations.

* Spread - it summarises the geographic spread and produces a KML file, which is available from
  [https://rega.kuleuven.be/cev/ecv/software/spread](https://rega.kuleuven.be/cev/ecv/software/spread).

* Spread requires Java 1.8.

* Google earth - it is used to display the KML file (just Google for it, if you have not already have it installed).


[//]: # (## Data, Model, Posterior)
{% include_relative discrete-phylogeography/narrative.md %}


## Useful Links

{% include_relative templates/links.md %}


## References

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
