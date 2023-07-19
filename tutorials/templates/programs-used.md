
The following software will be used in this tutorial:

{% assign beast_version = "2.7.5" %}
{% assign tracer_version = "1.7.2" %}
{% assign figtree_version = "1.4.3" %}

* LPhy Studio - this software will specify and visualise models 
  as well as simulate data from models defined in LPhy scripts.
  It is available for download from [LPhy releases](https://github.com/LinguaPhylo/linguaPhylo/releases).

* LPhy BEAST - this software will construct an input file for BEAST.
  The installation guide and usage can be found from [here](https://linguaphylo.github.io/setup/).

* BEAST - this package contains the BEAST program, BEAUti, DensiTree, TreeAnnotator 
  and other utility programs. 
  This tutorial is written for BEAST v{{beast_version}} or higher version, 
  which has support for multiple partitions. 
  It is available for download from [http://www.beast2.org](http://www.beast2.org).

* BEAST labs package - containing some generally useful stuff used by other packages.

* BEAST [feast](https://github.com/tgvaughan/feast) package - this is a small BEAST 2 package 
  which contains additions to the core functionality. 

* Tracer - this program is used to explore the output of BEAST (and other Bayesian MCMC programs). 
  It graphically and quantitatively summarises the distributions of continuous parameters 
  and provides diagnostic information. 
  At the time of writing, the current version is v{{tracer_version}}. 
  It is available for download from [https://github.com/beast-dev/tracer/releases](https://github.com/beast-dev/tracer/releases/latest).

* FigTree - this is an application for displaying and printing molecular phylogenies, 
  in particular those obtained using BEAST. 
  At the time of writing, the current version is v{{figtree_version}}. 
  It is available for download from [https://github.com/rambaut/figtree/releases](https://github.com/rambaut/figtree/releases/latest).