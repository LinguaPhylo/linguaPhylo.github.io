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
you can skip the section "5. Publish to Maven central repository" and "6. Release deployment".

You also need to understand the [technological difference](/developer) among the tree groups of projects:
lphy, beast2, and lphybeast, before starting this tutorial.

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

### Sharing build between subprojects

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

{% assign phylonco_version = "0.0.6" %}

For example, Figure {{ current_fig_num }} assigns version to "{{ phylonco_version }}" and
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

### lphy dependencies

{% assign lphy_version = "1.2.0" %}

After the version and base name are defined, the second block declares the 
[dependencies](https://docs.gradle.org/current/userguide/declaring_dependencies.html).
The first dependency is lphy jar. 
The `implementation` is a Gradle pre-defined
[configuration](https://docs.gradle.org/current/userguide/java_plugin.html#sec:java_plugin_and_dependency_management)
to resolve dependencies.
The string inside implementation defines GAV coordinate (Group, Artifact, Version), 
which will map to a unique corresponding version of a software from all releases.
It also can be used as a keyword to search in the Maven central repo, for example,
the group [io.github.linguaphylo](https://search.maven.org/search?q=g:io.github.linguaphylo).
Here the Phylonco Lphy extension depends on the version {{ lphy_version }} exactly.
We do not recommend to use version range, unless you fully understand the development history
and future plan of that project.

The second dependency is lphy-studio jar, because we want to run the studio from this project.
But it certainly should not be required by the code, which has no GUI extension.
So, the `runtimeOnly` configuration is used.
The third dependency is only used for unit tests.

Using the GAV and Maven central repo, you do not have to worry about loading the dependencies of lphy.
They will be automatically downloaded into your
[Gradle local repository](https://stackoverflow.com/questions/10834111/gradle-store-on-local-file-system)
when you first build, according to the dependencies declared in the 
[pom.xml](https://maven.apache.org/guides/introduction/introduction-to-dependency-mechanism.html)
created by [publishing](https://github.com/LinguaPhylo/linguaPhylo/blob/master/DEV_NOTE.md).

Updating your dependencies is important. 
IntelliJ provides a nice UI for the Gradle project to manage the dependencies.

<figure class="image">
<a href="DependencyManager.png">
  <img src="DependencyManager.png" alt="DependencyManager" style="width: 70%; height: 70%">
  </a>
  <figcaption>Figure {{ current_fig_num }}: Dependency manager in IntelliJ.</figcaption>
</figure>


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
The BEAST 2 and its packages are not using the GAV and Maven central repo mechanism, 
so that we have to use the
[file dependencies](https://docs.gradle.org/current/userguide/declaring_dependencies.html#sub:file_dependencies)
to host their dependencies in Gradle. 
In order to recognise the version, we rename the released BEAST 2 jars into a format
similar with GAV, where the package name follows the version. 



### lphybeast

The subproject "lphybeast" contains the mapping classes between BEAST 2 and LPhy.

{% assign current_fig_num = current_fig_num | plus: 1 %}

<figure class="image">
<a href="LPhyBEAST.png">
  <img src="LPhyBEAST.png" alt="LPhyBEAST">
  </a>
  <figcaption>Figure {{ current_fig_num }}: The subproject "lphybeast".</figcaption>
</figure>









## Dependency management

The section [Dependency management](https://docs.gradle.org/current/userguide/java_plugin.html#sec:java_plugin_and_dependency_management)
in the Java Plugin doc page is precisely explained the configurations.  



## Extending LPhy classes




## Extending LPhyBEAST classes


