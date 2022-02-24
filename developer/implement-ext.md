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
If you have not decided to publish the extensions into the Maven central repository,
you can skip the 5th section "Publish to Maven central repository" and the 6th "Release deployment".


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

The sub-project "lphy" contains LPhy extension classes, 
which uses Java 17, Java module system, and the standardised extension mechanism using SPI.

{% assign current_fig_num = current_fig_num | plus: 1 %}

<figure class="image">
  <img src="LPhy.png" alt="LPhy">
  <figcaption>Figure {{ current_fig_num }}: The sub-project "lphy".</figcaption>
</figure>

On the left side of the figure it shows the required
[sub-project structure](https://docs.gradle.org/current/userguide/multi_project_builds.html). 
The `doc` folder contains automatically generated LPhy language reference.
The `examples` folder contains the example LPhy scripts (*.lphy).
It is important to keep the `examples` folder under the "lphy" sub-project,
LPhy studio will look for this path to list scripts under the working directory (`user.dir`)
when it starts.

The subfolder `src/main/resources/META-INF/services` has a provider configuration file,
which is used to register the LPhy extension
[service provider in Java 1.8](https://docs.oracle.com/javase/tutorial/ext/basics/spi.html).
This allows the LPhy and its extensions to be able to integrate with the non-module system,
such as BEAST 2 and its packages.  
But please note for the newer version of Java, the LPhy extension mechanism still
uses the `module-info` file to register the service provider.

Following Java package [naming conventions](https://docs.oracle.com/javase/tutorial/java/package/namingpkgs.html)
is critical. Though we are using the module system to avoid namespace collision,
it'd better to name your Java package by starting with your extension name but not the reserved core name,
such as lphy, lphybeast, beast2, etc. 
For example, here we have the package `phylonco.lphy.evolution` to contain the extended LPhy data types and models.
The package `phylonco.lphy.spi` includes the
[Container Provider class](https://linguaphylo.github.io/programming/2021/07/19/lphy-extension.html).

On the right side of figure it is the Gradle build file for this subproject.
The first block `plugins { }` lists [Gradle plugins](https://docs.gradle.org/current/userguide/plugin_reference.html),
where `platforms.lphy-java` and `platforms.lphy-publish` define the LPhy extension conventions and share the build logic.
Their source code and usage is avaiable at [LinguaPhylo/GradlePlugins](https://github.com/LinguaPhylo/GradlePlugins).

After the version and base name are defined, the second block declares the 
[dependencies](https://docs.gradle.org/current/userguide/declaring_dependencies.html).



### beast2

The sub-project "beast2" contains the BEAST 2 classes, which uses Java 1.8 and non-module system. 
The extension mechanism was developed by BEAST 2 core developers.

{% assign current_fig_num = current_fig_num | plus: 1 %}

<figure class="image">
  <img src="BEAST2.png" alt="BEAST2">
  <figcaption>Figure {{ current_fig_num }}: The sub-project "beast2".</figcaption>
</figure>

On the left side of the figure it shows


### lphybeast

The sub-project "lphybeast" contains the mapping classes between BEAST 2 and LPhy.

{% assign current_fig_num = current_fig_num | plus: 1 %}

<figure class="image">
  <img src="LPhyBEAST.png" alt="LPhyBEAST">
  <figcaption>Figure {{ current_fig_num }}: The sub-project "lphybeast".</figcaption>
</figure>









## Dependencies




## LPhy SPI and the extension's container provider class


## LPhyBEAST 


