
<div id="auto-generated" style="background-color: #DCDCDC; padding: 10px; border: 1px solid gray; margin: 0; ">
<h2>Data</h2>

Number of replicates, <i>L</i> is the number of characters of  alignment, <i>D</i>.
The alignment, <i>D</i> is read from the Nexus file with a file name of "tutorials/data/h3n2.nexus" and <i>options</i>.
The <i>options</i> are ageDirection="forward" and ageRegex=".*\|.*\|(\d*\.\d+|\d+\.\d*)\|.*$".
Number of replicates, <i>dim</i> comes from the S*(S-1).
The integer, <i>S</i> is the length of an object.
The string, <i>demes<sub>0</sub></i> is assumed to come from the split with  str, <i>null<sub>0</sub></i> of "A/New_York/402/2001|CY003088|2001.986301|New_York", a regex of "\|" and an i of 3.
The <i>taxa</i> is the list of taxa of  alignment, <i>D</i>.



<h2>Model</h2>

The alignment, <i>D</i> is assumed to have evolved under a phylogenetic continuous time Markov process <a href="https://doi.org/10.1007/BF01734359">(Felsenstein; 1981)</a> on  phylogenetic time tree, <i>tree</i>, with  molecular clock rate, <i>clockRate</i>, an instantaneous rate matrix and <i>siteRates</i>.
The instantaneous rate matrix is the HKY model <a href="https://doi.org/10.1007/BF02101694">(Hasegawa <i>et al</i>; 1985)</a> with  transition bias parameter, <i>κ</i> and  base frequency vector, <i>π</i>.
The base frequency vector, <i>π</i> have a Dirichlet distribution prior with a concentration of [2.0, 2.0, 2.0, 2.0].
The transition bias parameter, <i>κ</i> has a log-normal prior with a mean in log space of 1.0 and a standard deviation in log space of 1.25.
The molecular clock rate, <i>clockRate</i> has a log-normal prior with a mean in log space of -5.298 and a standard deviation in log space of 0.25.
The double, <i>siteRates<sub>i</sub></i> is assumed to come from a DiscretizeGamma with  <i>shape</i> and a ncat of 4, for i in 0 to L - 1.
The <i>shape</i> has a log-normal prior with a mean in log space of 0.0 and a standard deviation in log space of 2.0.
The time tree, <i>tree</i> is assumed to come from a StructuredCoalescent with  <i>M</i>,  <i>taxa</i>, <i>demes</i> and a sort of true.
The <i>M</i> is assumed to come from the migrationMatrix with  theta, <i>Θ</i> and  m, <i>b<sub>m</sub></i>.
The double, <i>b_m_0</i> has an exponential distribution prior with a mean of 1.0, for i in 0 to dim - 1.
The object provides the unique of  arg, <i>demes</i>.
The double, <i>Θ<sub>i</sub></i> has a log-normal prior with a mean in log space of 0.0 and a standard deviation in log space of 1.0, for i in 0 to S - 1.
The double, <i>rootAge</i> is the .rootAge of  time tree, <i>tree</i>.


<h2>Posterior</h2>

$$
\begin{split}
P(\boldsymbol{\pi}, \kappa, \textrm{clockRate}, \boldsymbol{\textbf{siteRates}}, \textrm{shape}, \boldsymbol{\textbf{tree}}, \boldsymbol{\textbf{b}_{m}}, \boldsymbol{\Theta} | \boldsymbol{D}, \textrm{rootAge}) \propto &P(\boldsymbol{D} | \boldsymbol{\textbf{tree}}, \textrm{clockRate}, Q, \boldsymbol{\textbf{siteRates}})\\& P(\boldsymbol{\pi})P(\kappa)P(\textrm{clockRate})\prod_{i=0}^{L - 1}P(\textrm{siteRates}_i | \textrm{shape})\\& P(\textrm{shape})P(\boldsymbol{\textbf{tree}} | \boldsymbol{M})\prod_{i=0}^{\textrm{dim} - 1}P(\textrm{b\_m}_i)\\& \prod_{i=0}^{S - 1}P(\Theta\textrm{}_i)\end{split}


$$


</div>
