
<div id="auto-generated" style="background-color: #DCDCDC; padding: 10px; border: 1px solid gray; margin: 0; ">
<h2>Data</h2>

The number of replicates, <i>L</i> is the number of characters of  alignment, <i>D</i>.
The alignment, <i>D</i> is read from the Nexus file with a file name of "examples/H5N1.nex" and <i>options</i>.
The <i>options</i> are ageDirection="forward" and ageRegex="_(\d+)$".
The <i>taxa</i> is the list of taxa of  alignment, <i>D</i>.
The int, <i>K</i> is the number of states of  alignment, <i>D<sub>trait</sub></i>.
The alignment, <i>D<sub>trait</sub></i> extracts the trait from  <i>taxa</i>, with a sep of "_" and an i of 2.
The object, <i>dim</i> comes from the K*(K-1)/2.



<h2>Model</h2>

The alignment, <i>D</i> is assumed to have evolved under a phylogenetic continuous time Markov process <a href="https://doi.org/10.1007/BF01734359">(Felsenstein; 1981)</a> on  phylogenetic time tree, <i>ψ</i>, with a molecular clock rate of 0.004, an instantaneous rate matrix and siteRates, <i>r</i>.
An instantaneous rate matrix is the HKY model <a href="https://doi.org/10.1007/BF02101694">(Hasegawa <i>et al</i>; 1985)</a> with  transition bias parameter, <i>κ</i> and  base frequency vector, <i>π</i>.
The base frequency vector, <i>π</i> have a Dirichlet distribution prior with a concentration of [2.0, 2.0, 2.0, 2.0].
The transition bias parameter, <i>κ</i> has a log-normal prior with a mean in log space of 1.0 and a standard deviation in log space of 1.25.
The double, <i>r<sub>i</sub></i> is assumed to come from a DiscretizeGamma with  shape, <i>γ</i> and a ncat of 4, for i in 0 to L - 1.
The shape, <i>γ</i> has a log-normal prior with a mean in log space of 0.0 and a standard deviation in log space of 2.0.
The time tree, <i>ψ</i> is assumed to come from a Kingman's coalescent tree prior <a href="https://doi.org/10.1016/0304-4149(82)90011-4">(Kingman; 1982)</a> with  coalescent parameter, <i>Θ</i> and  <i>taxa</i>.
The coalescent parameter, <i>Θ</i> has a log-normal prior with a mean in log space of 0.0 and a standard deviation in log space of 1.0.
The alignment, <i>D<sub>trait</sub></i> is assumed to have evolved under a phylogenetic continuous time Markov process <a href="https://doi.org/10.1007/BF01734359">(Felsenstein; 1981)</a> on  phylogenetic time tree, <i>ψ</i>, with  molecular clock rate, <i>μ<sub>trait</sub></i>,  instantaneous rate matrix, <i>Q<sub>trait</sub></i>, a length of 1 and a dataType of "standard".
The instantaneous rate matrix, <i>Q<sub>trait</sub></i> is assumed to come from the generalTimeReversible with rates and  freq, <i>π<sub>trait</sub></i>.
The freq, <i>π<sub>trait</sub></i> have a Dirichlet distribution prior with a concentration.
A concentration is assumed to come from the rep with an element of 3.0 and times, <i>K</i>.
The number is assumed to come from the select with  x, <i>R_trait<sub>i</sub></i> and  indicator, <i>I<sub>0</sub></i>.
The indicator, <i>I</i> is assumed to come from a Bernoulli with a p of 0.5, replicates, <i>dim</i> and minSuccesses.
The minSuccesses is calculated by  dim-2.
The x, <i>R<sub>trait</sub></i> have a Dirichlet distribution prior with a concentration.
A concentration is assumed to come from the rep with an element of 1.0 and times, <i>dim</i>.
The molecular clock rate, <i>μ<sub>trait</sub></i> has a log-normal prior with a mean in log space of 0 and a standard deviation in log space of 1.25.


<h2>Posterior</h2>

$$
\begin{split}
P(\boldsymbol{\pi}, \kappa, \boldsymbol{r}, \gamma, \boldsymbol{\psi}, \Theta, \boldsymbol{\pi\textbf{}_{trait}}, \boldsymbol{I}, \boldsymbol{\textbf{R}_{trait}}, \mu\textrm{}_{trait} | \boldsymbol{D}, \boldsymbol{\textbf{D}_{trait}}) \propto &P(\boldsymbol{D} | \boldsymbol{\psi}, Q, \boldsymbol{r})P(\boldsymbol{\pi})P(\kappa)\\& \prod_{i=0}^{L - 1}P(\textrm{r}_i | \gamma)P(\gamma)P(\boldsymbol{\psi} | \Theta)\\& P(\Theta)P(\boldsymbol{\textbf{D}_{trait}} | \boldsymbol{\psi}, \mu\textrm{}_{trait}, \boldsymbol{\textbf{Q}_{trait}})\\& P(\boldsymbol{\pi\textbf{}_{trait}})P(\boldsymbol{I})P(\boldsymbol{\textbf{R}_{trait}})\\& P(\mu\textrm{}_{trait})\end{split}


$$


</div>
