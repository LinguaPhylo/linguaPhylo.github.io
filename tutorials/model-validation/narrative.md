
<div id="auto-generated" style="background-color: #DCDCDC; padding: 10px; border: 1px solid gray; margin: 0; ">
<h2>Data</h2>

The vector of integers, <i>L</i> are the number of characters of  each element in  vector of alignments, <i>codon</i>.
Vector of alignments, <i>codon</i> are the character sets ["3-629\3", "1-629\3", "2-629\3"] of  alignment, <i>D</i>.
The alignment, <i>D</i> is read from the Nexus file with a file name of "data/RSV2.nex" and <i>options</i>.
The <i>options</i> are ageDirection="forward" and ageRegex="s(\d+)$".
The integer, <i>n</i> is the length of vector of alignments, <i>codon</i>.
The <i>taxa</i> is the list of taxa of  alignment, <i>D</i>.



<h2>Model</h2>

The alignment, <i>sim<sub>i</sub></i> is assumed to have evolved under a phylogenetic continuous time Markov process <a href="https://doi.org/10.1007/BF01734359">(Felsenstein; 1981)</a> on  phylogenetic time tree, <i>ψ</i>, with  molecular clock rate, <i>μ</i>,  instantaneous rate matrix, <i>Q<sub>i</sub></i> and  length, <i>L<sub>i</sub></i>.
The instantaneous rate matrix, <i>Q<sub>0</sub></i> is the HKY model <a href="https://doi.org/10.1007/BF02101694">(Hasegawa <i>et al</i>; 1985)</a> with  transition bias parameter, <i>κ<sub>0</sub></i>,  base frequency vector, <i>π<sub>0</sub></i> and  rate, <i>r<sub>0</sub></i>.
The base frequency vector, <i>π<sub>i</sub></i> have a Dirichlet distribution prior with a concentration of [2.0, 2.0, 2.0, 2.0], for i in 0 to n - 1.
The transition bias parameter, <i>κ<sub>i</sub></i> has a log-normal prior with a mean in log space of 1.0 and a standard deviation in log space of 0.5, for i in 0 to n - 1.
The rate, <i>r</i> is assumed to come from a WeightedDirichlet with a concentration and weights, <i>L</i>.
A concentration is assumed to come from the rep with an element of 2.0 and times, <i>n</i>.
The molecular clock rate, <i>μ</i> has a log-normal prior with a mean in log space of -5.0 and a standard deviation in log space of 1.25.
The phylogenetic time tree, <i>ψ</i> is assumed to come from a Kingman's coalescent tree prior <a href="https://doi.org/10.1016/0304-4149(82)90011-4">(Kingman; 1982)</a> with  coalescent parameter, <i>Θ</i> and  <i>taxa</i>.
The coalescent parameter, <i>Θ</i> has a log-normal prior with a mean in log space of 3.0 and a standard deviation in log space of 2.0.


<h2>Posterior</h2>

$$
\begin{split}
P(\boldsymbol{\pi}, \boldsymbol{\kappa}, \boldsymbol{r}, \mu, \boldsymbol{\psi}, \Theta | \boldsymbol{\textbf{sim}}) \propto &\prod_{i=0}^{n - 1}P(\boldsymbol{\textbf{sim}_i} | \boldsymbol{\psi}, \mu, \boldsymbol{\textbf{Q}_i})\\& \prod_{i=0}^{n - 1}P(\boldsymbol{\pi\textbf{}_i})\prod_{i=0}^{n - 1}P(\kappa\textrm{}_i)\\& P(\boldsymbol{r})P(\mu)P(\boldsymbol{\psi} | \Theta)P(\Theta)\end{split}


$$


</div>
