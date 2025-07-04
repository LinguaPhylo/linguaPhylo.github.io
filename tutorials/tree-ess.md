---
layout: page
title: Simple Tree ESS using TreeStat2
author: 'Walter Xie on 3 July 2025'
permalink: /tutorials/tree-ess/
date: 2025-07-03
---

To date, BEAST tutorials have not covered methods for assessing convergence of posterior trees. 
The updated [TreeStat2](https://github.com/alexeid/TreeStat2/) package introduces RF distances in CCD, 
enabling users to generate log files compatible with Tracer. 
These, along with other tree statistics (e.g., tree shape metrics), 
can be used to compute ESS values and evaluate whether tree topologies have converged. 

This tutorial will demonstrate how to use these features in practice.


## TreeStat2

TreeStat 2 is a [BEAST 2 package](https://compevol.github.io/CBAN/) designed for 
calculating statistical summaries from phylogenetic tree samples. 
It takes as input a posterior tree file produced by BEAST 2 runs, or any file in the same format.
TreeStat2 computes a wide range of statistics, including tree length, tree balance, 
conditional clade distribution (CCD), and root-to-tip distances, etc.
All statistics are saved to log files that are compatible with downstream analysis tools such as Tracer.

Follow these steps to create a log file compatible with Tracer:

1. Install TreeStat2 if you haven’t done so already.

<figure class="image">
  <a href="PackageManager.png" target="_blank">
  <img src="PackageManager.png" alt="PackageManager"></a>
</figure>

{:start="2"}
2. Start TreeStat2 using the AppLauncher that comes bundled with BEAST 2.

<figure class="image">
  <a href="AppLauncher.png" target="_blank">
  <img src="AppLauncher.png" alt="AppLauncher"></a>
</figure>

{:start="3"}
3. Select the tree statistics.

Select one or more **scalar** summary statistics from the left panel, 
then click the green arrow to move them to the right panel.
A scalar statistic is a single numeric value that summarizes a property of the tree.
You can click any statistic to view its description in the bottom panel.

**Please note:** `Tree Length` is a scalar statistic representing the total sum of all branch lengths. 
In contrast, `Branch Lengths` provide a vector of individual branch lengths for each tree.

<figure class="image">
  <a href="TreeStat2.png" target="_blank">
  <img src="TreeStat2.png" alt="TreeStat2"></a>
</figure>

The six statistics based on CCD are recommended. 
You can also include additional ones if there is interest.  

{:start="4"}
4. Click `Process Tree File` to input the tree file. 

Click the `Process Tree File` button. A file explorer will open. 
Select your posterior tree file and click `Open`.

<figure class="image">
  <a href="Open.png" target="_blank">
  <img src="Open.png" alt="Open"></a>
</figure>

{:start="5"}
5. Then output the log file. 

Wait for the next file explorer to open, then enter your desired output file name 
(it’s recommended to end it with `.log`). Click `Save` to process the trees.

<figure class="image">
  <a href="SaveAs.png" target="_blank">
  <img src="SaveAs.png" alt="SaveAs"></a>
</figure>

The software will also generate a summary statistic for the CCD, as well as MAP trees for CCD0 and CCD1.

<figure class="image">
  <a href="Outputs.png" target="_blank">
  <img src="Outputs.png" alt="Outputs"></a>
</figure>

## Load the log file to Tracer

Load the generated (`.log`) file to Tracer. 
You can either use all ESS values or the minimum ESS to assess whether the topology has likely converged. 

<figure class="image">
  <a href="Tracer.png" target="_blank">
  <img src="Tracer.png" alt="Tracer"></a>
</figure>
