---
layout: home
---

A new paradigm for scientific computing and data science has begun to emerged in the last decade. A recent example is the publication of the first "computationally reproducible article" using eLife's Reproducible Document Stack which blends features of a traditional manuscript with live code, data and interactive figures.

Although standard tools for statistical phylogenetics provide a degree of reproducibility and reusability through popular open-source software and computer-readable data file formats, there is still much to do. The ability to construct and accurately communicate probabilistic models in phylogenetics is frustratingly underdeveloped. There is low interoperability between different inference packages (e.g. BEAST1, BEAST2, MrBayes, RevBayes), and the file formats that these software use have low readability for researchers.

## LinguaPhylo (LPhy for short - pronounced el-fee)

LinguaPhylo (LPhy for short - pronounced el-fee) is a probabilistic model specification language to concisely and precisely define phylogenetic models.
The aim is to provide a language (work towards a _lingua franca_) for probabilistic models of phylogenetic evolution that is independent of the method to perform inference.
This language is readable by both humans and computers. Here is a full example:

{::nomarkdown}
{% include_relative yule.html %}
{:/}

Each of the lines in this model block expresses how a random variable (to the left of the tilde) is generated from a generative distribution.

The first line creates a random variable, λ, that is log-normally distributed.
The second line creates a tree, ψ, with 16 taxa from the Yule process with a lineage birth rate equal to λ.
The third line produces a multiple sequence alignment with a length of 200, by simulating a Jukes Cantor model of sequence evolution down the branchs of the tree ψ.
As you can see, each of the random variables depends on the last, so this is a hierarchical model that ultimately defines a probability distribution of sequence alignments of size 16 x 200.

LinguaPhylo is an open source project. 
The source is hosted at [https://github.com/LinguaPhylo/linguaPhylo](https://github.com/LinguaPhylo/linguaPhylo).

### LinguaPhylo Studio

Along with the language definition, we also provide software to specify and visualise models as well as simulate data from models defined in LPhy.

This software will also provide the ability for models specified in the LPhy language to be applied to data using standard inference tools such as MrBayes, RevBayes, BEAST1 and BEAST2.
This will require software that can convert an LPhy specification into an input file that these inference engines understand.
The first such software converter is LPhyBEAST described below.

### Download LPhy and Studio

Download the [latest release](https://github.com/LinguaPhylo/linguaPhylo/releases/latest) of LPhy core and Studio, and previous releases are available from the [release page](https://github.com/LinguaPhylo/linguaPhylo/releases). 

## LPhyBEAST (pronounced el-fee-beast)

[LPhyBEAST](https://github.com/LinguaPhylo/LPhyBeast) is a command-line program that takes an LPhy model specification, and some data and produces a BEAST 2 XML input file.
It is therefore an alternative way to succinctly express and communicate BEAST analyses.

LPhyBEAST is installable as a BEAST2 package. 
The detail is available in the [user manual](https://linguaphylo.github.io/setup/#lphybeast-installation).

## Citation

Alexei J. Drummond, Kylie Chen, Fábio K. Mendes, Dong Xie (2023),
LinguaPhylo: A probabilistic model specification language for reproducible phylogenetic analyses,
PLOS Computational Biology, [doi:10.1371/journal.pcbi.1011226](https://doi.org/10.1371/journal.pcbi.1011226).

## Extensions

LPhy extensions are listed [here](extensions). LPhyBEAST extensions can be seen from BEAST 2
[Package Viewer](https://compevol.github.io/CBAN/) or [Package Manager](https://www.beast2.org/managing-packages/).
