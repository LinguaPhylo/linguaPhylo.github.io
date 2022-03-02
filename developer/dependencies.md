---
layout: page
title:  "Gradle project master --- dependencies"
author: Walter Xie
permalink: /developer/dependencies/
---

We will use the [Phylonco](https://github.com/bioDS/beast-phylonco) project as an example,
to learn how to setup project dependencies, 
and understand the difference between consumers and producers.

## 1. phylonco-lphy

{% assign current_fig_num = 1 %}

<figure class="image">
<a href="/developer/project-structure/LPhy.png">
  <img src="/developer/project-structure/LPhy.png" alt="LPhy">
  </a>
  <figcaption>Figure {{ current_fig_num }}: The subproject "phylonco-lphy".</figcaption>
</figure>

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
Here the "phylonco-lphy" extension depends on the version {{ lphy_version }} exactly.
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

{% assign current_fig_num = current_fig_num | plus: 1 %}

<figure class="image">
<a href="DependencyManager.png">
  <img src="DependencyManager.png" alt="DependencyManager" style="width: 70%; height: 70%">
  </a>
  <figcaption>Figure {{ current_fig_num }}: Dependency manager in IntelliJ.</figcaption>
</figure>


## 2. phylonco-beast 

The BEAST 2 and its packages are not using the GAV and Maven central repo mechanism, 
so that we have to use the
[file dependencies](https://docs.gradle.org/current/userguide/declaring_dependencies.html#sub:file_dependencies)
to host their dependencies in Gradle. 
In order to recognise the version, we rename the released BEAST 2 jars into a format
similar with GAV, where the package name follows the version. 

As you can see in Figure {{ current_fig_num }}, this BEAST 2 extension depends on 
BEAST 2 core and [BEASTLabs](https://github.com/BEAST2-Dev/BEASTLabs).
The list of available BEAST 2 packages can be seen from [Package Viewer](https://compevol.github.io/CBAN/).
If you change the drop-down list from the default XML into "packages-extra.xml",
you can find the webpage to list both "lphybeast" package and "Phylonco" package.

The `api` [configuration](https://docs.gradle.org/current/userguide/java_library_plugin.html#sec:java_library_separation)
is declared for BEAST 2 and BEASTLabs, which means these 2 jars will be exposed to consumers,
which means, for instance, the dependencies of subproject "phylonco-lphybeast" has already included these 2 jars,
because it depends on this subproject.
So, we do not have to replicate jars in the "phylonco-lphybeast" `lib` folder.
But please use `api` wisely and respect to your consumers.


## 3. phylonco-lphybeast 




## 4. Understanding your role

Producers vs consumers


## Further readings

- [Declaring repositories](https://docs.gradle.org/current/userguide/declaring_repositories.html)

- [Declaring dependencies](https://docs.gradle.org/current/userguide/declaring_dependencies.html)

- [Viewing and debugging dependencies](https://docs.gradle.org/current/userguide/viewing_debugging_dependencies.html)

- [Declaring Versions and Ranges](https://docs.gradle.org/current/userguide/single_versions.html)


