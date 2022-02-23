---
layout: page
title:  "Implementing an extension"
author: Walter Xie
permalink: /developer/implement-ext/
---

We will use the [beast-phylonco](https://github.com/bioDS/beast-phylonco) project as an example
to demonstrate how to implement a LPhy or LPhyBEAST extension.
Before reading this tutorial, you should have setup your [development environment](/developer/setup-dev-env),
and learnt the [essential knowledge about Gradle](https://github.com/LinguaPhylo/linguaPhylo/blob/master/DEV_NOTE.md).


## Project structure

{% assign current_fig_num = 1 %}

<figure class="image">
  <img src="IntelliJSetting.png" alt="IntelliJ Setting">
  <figcaption>Figure {{ current_fig_num }}: Project structure and Gradle setting file.</figcaption>
</figure>

The "beast-phylonco" project contains 3 modules, also known as sub-projects in Gradle. 
Its project structure can be seen from the [Project tool window](https://www.jetbrains.com/help/idea/project-tool-window.html)
on the left side of Figure {{ current_fig_num }}. 
There is a file `settings.gradle.kts` in the project root to configure this structure, 
where the keyword `include` declares the sub-projects are included.

The project root also has a common build file, which is used to define some shared build logics between sub-projects. 
Each sub-project has its own build file to specify the building process and logics.
If a sub-project is included in the settings, IntelliJ will automatically create the modules,
and its build file will also run by default. 



### lphy

The sub-project "lphy" contains LPhy extension classes;

{% assign current_fig_num = current_fig_num | plus: 1 %}

<figure class="image">
  <img src="LPhy.png" alt="LPhy">
  <figcaption>Figure {{ current_fig_num }}: sub-project "lphy".</figcaption>
</figure>



### lphybeast

The sub-project "lphybeast" contains the mapping classes between BEAST 2 and LPhy.


### beast2

The sub-project "beast2" contains the BEAST 2 classes;



## Dependencies




## LPhy SPI and the extension's container provider class


## LPhyBEAST 


