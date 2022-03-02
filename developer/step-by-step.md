---
layout: page
title:  "A step-by-step tutorial to implement an extension"
author: Walter Xie
permalink: /developer/step-by-step/
---


Welcome to the step-by-step tutorial to implement a LPhy or LPhyBEAST extension.
Before reading this tutorial, we suggest you learn some
[essential knowledges about Gradle](https://github.com/LinguaPhylo/linguaPhylo/blob/master/DEV_NOTE.md),
and know [how IntelliJ IDEA integrates with Gradle](https://www.jetbrains.com/idea/guide/tutorials/working-with-gradle/).
It is also helpful to understand the technial background, 
which is available in the [system integration](/developer) section.


## 1. Setup development environment

The development requires Java 17, Gradle, and IntelliJ.
If you are not familiar with this step, please follow the tutorial to
[setup development environment](/developer/setup-dev-env) and load your Gradle project into IntelliJ.

IntelliJ will automatically import modules and dependencies from the Gradle settings.
Please do __not__ try to change them through Project Structure in IntelliJ,
because these changes might be lost after reimporting. 
  

## 2. Establish a standard project structure

{% assign proj_stru_fig = 1 %}

The extension project must be set to the
[standard Gradle directory structure](https://www.jetbrains.com/idea/guide/tutorials/working-with-gradle/tour-of-a-gradle-project/).
You can either [create a Gradle project](https://www.jetbrains.com/help/idea/getting-started-with-gradle.html)
using IntelliJ, or simply copy the structure from an existing example, 
such as [Phylonco](https://github.com/bioDS/beast-phylonco), and then fill in your contents.

For example, in Figure {{ proj_stru_fig }}, you need to rename the 3 subprojects (subfolders) to your subprojects,
which are phylonco-beast, phylonco-lphy, and phylonco-lphybeast. 
Then replace their names inside `include` to yours, 
which are highlighted in the `settings.gradle.kts`.  

<figure class="image">
<a href="IntelliJSetting.png">
  <img src="IntelliJSetting.png" alt="IntelliJ Setting">
  </a>
  <figcaption>Figure {{ proj_stru_fig }}: Project structure and Gradle setting file in Phylonco.</figcaption>
</figure>


Please be aware that if you are migrating your existing projects, 
you need to use either IntelliJ or `git mv` to move files, otherwise the history of files will be lost.

## 3. Fill in your project metadata

We are using composite builds. 
In the project root, there is a `settings.gradle.kts` to configure this structure,
and a common build file `build.gradle.kts` to share build logics.
Furthermore, each subproject has its own build file. 
They have been pointed by a red arrow in Figure {{ proj_stru_fig }}.

You need to replace the project metadata in these files to your project information.
The main changes are:

- subprojects, please refer to section 2.

- [group, version and webpage](https://github.com/bioDS/beast-phylonco/blob/eab627fec2ce278ddc81403e75936dee431ecd4b/build.gradle.kts#L31-L33),
also the overwritten [version](https://github.com/bioDS/beast-phylonco/blob/eab627fec2ce278ddc81403e75936dee431ecd4b/phylonco-lphy/build.gradle.kts#L9-L10).

- manifest file in each jar, 
either the [shared attribute](https://github.com/bioDS/beast-phylonco/blob/eab627fec2ce278ddc81403e75936dee431ecd4b/build.gradle.kts#L60)
or individual attributes, such as [phylonco-beast build](https://github.com/bioDS/beast-phylonco/blob/eab627fec2ce278ddc81403e75936dee431ecd4b/phylonco-beast/build.gradle.kts#L32-L33),
[phylonco-lphy build](https://github.com/bioDS/beast-phylonco/blob/eab627fec2ce278ddc81403e75936dee431ecd4b/phylonco-lphy/build.gradle.kts#L36-L37),
and [phylonco-lphybeast build](https://github.com/bioDS/beast-phylonco/blob/eab627fec2ce278ddc81403e75936dee431ecd4b/phylonco-lphybeast/build.gradle.kts#L80-L81).

- [Maven publication metadata](/developer/project-structure/#maven-publication), 
if you will publish to the Maven central repo.

The advanced tutorial [Gradle project master - project structure](/developer/project-structure/)
will explain this in detail. 


## 4. Dependency management 

You also need to configure the dependencies for your project.

The advanced tutorial [Gradle project master - dependencies](/developer/dependencies/)
will introduce the details of these concepts. 


## 5. Java development 

* [For LPhy core developers]({% link _posts/2020-09-22-linguaphylo-for-developers.markdown %})

* [For LPhy extension developers]({% link _posts/2021-07-19-lphy-extension.markdown %})

* [For LPhyBEAST developers]({% link _posts/2021-07-15-lphybeast-developer-note.markdown %})


The Phylonco example

## 6. Build the project





