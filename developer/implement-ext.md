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

The "beast-phylonco" project contains 3 modules, also known as
[subprojects](https://docs.gradle.org/current/userguide/multi_project_builds.html) in Gradle. 
Its project structure can be seen from the
[Project tool window](https://www.jetbrains.com/help/idea/project-tool-window.html)
on the left side of Figure {{ current_fig_num }}. 
There is a file `settings.gradle.kts` in the project root to configure this structure, 
where the keyword `include` declares the subprojects are included.

The project root also has a common build file, which is used to define some shared build logics between subprojects. 
Each subproject has its own build file to specify the building process and logics.
If a subproject is included in the settings, IntelliJ will automatically create the modules,
and its build file will also run by default. 

{% assign current_fig_num = current_fig_num | plus: 1 %}

<figure class="image">
<a href="RootBuild.png">
  <img src="RootBuild.png" alt="RootBuild" style="width: 60%; height: 60%">
  </a>
  <figcaption>Figure {{ current_fig_num }}: The common build file in the project root.</figcaption>
</figure>


For example, Figure {{ current_fig_num }} assigns version to "0.0.6" and
group to "io.github.bioDS" for all subprojects.
But you can overwrite the version in a subproject's build to use a different number.
The `manifest` block on the bottom defines the common meta information
shared in all released jar files from 3 subprojects. 

There are more details about how to
[organise Gradle projects](https://docs.gradle.org/current/userguide/organizing_gradle_projects.html). 
But some articles suggest to
[stop using buildSrc, to use composite builds instead](https://proandroiddev.com/stop-using-gradle-buildsrc-use-composite-builds-instead-3c38ac7a2ab3).
Therefore, we configure these 3 subprojects to use composite builds.


### lphy

The subproject "lphy" contains LPhy extension classes, 
which uses Java 17, Java module system, and the standardised extension mechanism using SPI.

{% assign current_fig_num = current_fig_num | plus: 1 %}

<figure class="image">
<a href="LPhy.png">
  <img src="LPhy.png" alt="LPhy" style="width: 80%; height: 80%">
  </a>
  <figcaption>Figure {{ current_fig_num }}: The subproject "lphy".</figcaption>
</figure>

On the left side of the figure, it shows the required subproject structure.
The `doc` folder contains automatically generated LPhy language reference.
The `examples` folder contains the example LPhy scripts (*.lphy).
It is important to keep the `examples` folder under the "lphy" subproject,
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

On the right side of figure, it is the Gradle build file for this subproject.
The first block `plugins { }` lists [Gradle plugins](https://docs.gradle.org/current/userguide/plugin_reference.html),
where `platforms.lphy-java` and `platforms.lphy-publish` define the LPhy extension conventions,
such as using Java 17, and share the build logic, such as using module path to launch application.
Their source code and usage is avaiable at [LinguaPhylo/GradlePlugins](https://github.com/LinguaPhylo/GradlePlugins).

After the version and base name are defined, the second block declares the 
[dependencies](https://docs.gradle.org/current/userguide/declaring_dependencies.html).



### beast2

The subproject "beast2" contains the BEAST 2 classes, which uses Java 1.8 and non-module system. 
The extension mechanism was developed by BEAST 2 core developers.

{% assign current_fig_num = current_fig_num | plus: 1 %}

<figure class="image">
<a href="BEAST2.png">
  <img src="BEAST2.png" alt="BEAST2" style="width: 70%; height: 70%">
  </a>
  <figcaption>Figure {{ current_fig_num }}: The subproject "beast2".</figcaption>
</figure>

On the left side of the figure, it shows the same structure as the subproject "lphy".
But the additional `lib` folder is used to contain the required BEAST 2 libraries.


### lphybeast

The subproject "lphybeast" contains the mapping classes between BEAST 2 and LPhy.

{% assign current_fig_num = current_fig_num | plus: 1 %}

<figure class="image">
<a href="LPhyBEAST.png">
  <img src="LPhyBEAST.png" alt="LPhyBEAST">
  </a>
  <figcaption>Figure {{ current_fig_num }}: The subproject "lphybeast".</figcaption>
</figure>









## Dependencies




## Extending LPhy classes




## Extending LPhyBEAST classes


