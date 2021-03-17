
<div id="auto-generated" style="background-color: #DCDCDC; padding: 10px; border: 1px solid gray; margin: 0; ">
<h2>Data</h2>

The number of replicates, <i>L</i> is the number of characters of  alignment, <i>D</i>.
The alignment, <i>D</i> is read from the Nexus file with a file name of "tutorials/data/hcv.nexus".
numGroups = 4
The n, <i>w</i> is calculated by  taxa.length()-1.
The <i>taxa</i> is the list of taxa of  alignment, <i>D</i>.



<h2>Model</h2>

The alignment, <i>D</i> is assumed to have evolved under a phylogenetic continuous time Markov process <a href="https://doi.org/10.1007/BF01734359">(Felsenstein; 1981)</a> on  phylogenetic time tree, <i>ψ</i>, with a molecular clock rate of 7.9E-4,  instantaneous rate matrix, <i>Q</i> and siteRates, <i>r</i>.
The instantaneous rate matrix, <i>Q</i> is the general time-reversible rate matrix <a href="https://doi.org/10.1016/S0022-5193(05)80104-3">(Rodriguez <i>et al</i>; 1990)</a> with relative rates, <i>rates</i> and base frequencies, <i>π</i>.
The base frequencies, <i>π</i> have a Dirichlet distribution prior with a concentration of [3.0, 3.0, 3.0, 3.0].
The relative rates, <i>rates</i> have a Dirichlet distribution prior with a concentration of [1.0, 2.0, 1.0, 1.0, 2.0, 1.0].
The double, <i>r<sub>i</sub></i> is assumed to come from a DiscretizeGamma with  shape, <i>γ</i> and a ncat of 4, for i in 0 to L - 1.
The shape, <i>γ</i> has a log-normal prior with a mean in log space of 0.0 and a standard deviation in log space of 2.0.
The phylogenetic time tree, <i>ψ</i> has a skyline coalescent prior <a href="https://doi.org/10.1093/molbev/msi103">(Drummond <i>et al</i>; 2005)</a> with population sizes, <i>Θ</i>, group sizes, <i>A</i> and  <i>taxa</i>.
The group sizes, <i>A</i> is assumed to come from a RandomComposition with  n, <i>w</i> and  k, <i>numGroups</i> of 4.
The taxa.length() is the .length of  <i>taxa</i>.
The population sizes, <i>Θ</i> have a smoothing prior in which each element has an exponential prior with a mean of the previous element in the chain with  firstValue, <i>θ1</i> and number of steps, <i>numGroups</i> of 4.
The firstValue, <i>θ1</i> has a log-normal prior with a mean in log space of 9.0 and a standard deviation in log space of 2.0.


<h2>Posterior</h2>

$$
\begin{split}
P(\boldsymbol{\pi}, \boldsymbol{\textbf{rates}}, \boldsymbol{r}, \gamma, \boldsymbol{\psi}, \boldsymbol{A}, \boldsymbol{\Theta}, \theta1 | \boldsymbol{D}) \propto &P(\boldsymbol{D} | \boldsymbol{\psi}, \boldsymbol{Q}, \boldsymbol{r})P(\boldsymbol{\pi})\\& P(\boldsymbol{\textbf{rates}})\prod_{i=0}^{L - 1}P(\textrm{r}_i | \gamma)P(\gamma)\\& P(\boldsymbol{\psi} | \boldsymbol{\Theta}, \boldsymbol{A})P(\boldsymbol{A})P(\boldsymbol{\Theta} | \theta1)\\& P(\theta1)\end{split}


$$


</div>
