
The following software will be used in this tutorial. 
We also offer a [Tech Help](../tech-help) page to assist you 
in case you encounter any unexpected issues with certain third-party software tools.

{% assign lphy_version = "1.7.x" %}
{% assign beast_version = "2.7.x" %}
{% assign tracer_version = "1.7.x" %}
{% assign figtree_version = "1.4.x" %}

* Java 17 or a later version is required by LPhy Studio.

* LPhy Studio - This software will specify, visualize, and simulate data from models 
  defined in LPhy scripts.
  At the time of writing, the current version is v{{lphy_version}}. 
  It is available for download from [LPhy releases](https://github.com/LinguaPhylo/linguaPhylo/releases).

* LPhy BEAST - this BEAST 2 package will convert LPhy scripts into BEAST 2 XMLs.
  The installation guide and usage can be found from [User Manual](https://linguaphylo.github.io/setup/).

* BEAST 2 - the bundle includes the BEAST 2 program, BEAUti, DensiTree, TreeAnnotator, 
  and other utility programs. 
  This tutorial is written for BEAST v{{beast_version}} or higher version. 
  It is available for download from [http://www.beast2.org](http://www.beast2.org).
  Use `Package Manager` to install the required BEAST 2 packages.

* BEAST labs package - this contains some generally useful stuff used by other BEAST 2 packages.

* BEAST [feast](https://github.com/tgvaughan/feast) package - this is a small BEAST 2 package 
  which contains additions to the core functionality. 
  
* BEAST [CCD](https://github.com/CompEvol/CCD) package - Implementation of the conditional clade distribution (CCD), 
  such as, based on clade split frequencies (CCD1) and clade frequencies (CCD0). 
  Furthermore, point estimators based on the CCDs are implemented, 
  which allows TreeAnnotator to produce better summary trees than via MCC trees (which is restricted to the sample).

* Tracer - this program is used to explore the output of BEAST (and other Bayesian MCMC programs). 
  It graphically and quantitatively summarises the distributions of continuous parameters 
  and provides diagnostic information. 
  At the time of writing, the current version is v{{tracer_version}}. 
  It is available for download from [Tracer releases](https://github.com/beast-dev/tracer/releases).

* FigTree - this is an application for displaying and printing molecular phylogenies, 
  in particular those obtained using BEAST. 
  At the time of writing, the current version is v{{figtree_version}}. 
  It is available for download from [FigTree releases](https://github.com/rambaut/figtree/releases).
  