---
layout: page
title:  "Setup Development Environment"
author: Walter Xie
permalink: /developer/setup-dev-env/
---

This page will introduce how to setup the development environment for working on the LPhy or LPhyBEAST extensions. 

## Loading the existing project

You can [load a Gradle project](https://www.jetbrains.com/idea/guide/tutorials/working-with-gradle/opening-a-gradle-project/)
from IntelliJ, by choosing the project folder,
after you click `Open` button from the "Welcome to IntelliJ" window.
It may take several minutes for indexing when the project is loaded first time.
You can look at the progress bar to see whether the loading is completed. 

For example, assuming LinguaPhylo does not exist, then after you click `Open`,
you need to choose the "linguaPhylo" folder.

<figure class="image">
  <img src="Welcome.png" alt="Welcome to IntelliJ">
  <figcaption>Figure 1: Open the existing project.</figcaption>
</figure>

We recommend you run the Gradle build from the terminal once, before opening a new Gradle project.


### Java

The LPhy and LPhyBEAST is developed on Java 17
([LTS](https://www.oracle.com/java/technologies/java-se-support-roadmap.html)). 
We recommend you install [OpenJDK 17](https://jdk.java.net/17/).

Please configure your IntelliJ project SDK to 17, and also set language level to 17.

<figure class="image">
  <img src="ProjectSDK.png" alt="ProjectSDK">
  <figcaption>Figure 2: Project SDK.</figcaption>
</figure>

### Gradle

They are also the Gradle projects. Please install [Gradle 7.x](https://gradle.org/install/) before you start.

Please configure your IntelliJ Gradle JVM to 17. You can go to "Preferences", 
and expand `Build, Execution, Deployment` => `Build Tools` => `Gradle`:  

<figure class="image">
  <img src="GradleJVM.png" alt="GradleJVM">
  <figcaption>Figure 3: Gradle JVM.</figcaption>
</figure>

Alternative, you can use the terminal to run the Gradle tasks.
Please alos see [LPhy developer note](https://github.com/LinguaPhylo/linguaPhylo/blob/master/DEV_NOTE.md) 


### IntelliJ

In addition, you need to download the latest version of IntelliJ,
and [Kotlin plugin](https://plugins.jetbrains.com/plugin/6954-kotlin).

<figure class="image">
  <img src="KotlinPlugin.png" alt="KotlinPlugin">
  <figcaption>Figure 4: Kotlin plugin.</figcaption>
</figure>


### Common problem

If your build failed and there was the red text showing "an API of a component compatible with Java 17 ...",
then you need to check if your Java version is 17. In the screenshot below, the Java version was 1.8.

<figure class="image">
  <img src="BuildFailJava.png" alt="BuildFailJava">
  <figcaption>Figure 5: Build fail because of Java version.</figcaption>
</figure>



## Project structure

The extension project supposes to contain 3 modules, also known as sub-projects in Gradle. 
They are located in the subfolders under the project root folder. 

1. `beast2` contains the BEAST 2 classes;
2. `lphy` contains LPhy extension classes; 
3. `lphybeast` contains the mapping classes between BEAST 2 and LPhy.

The project folder structure looks like:

```
mypackage
    ├── build.gradle.kts
    ├── examples
    ├── beast2
    │    ├── build.gradle.kts
    │    ├── lib
    │    └── src
    │         ├── main
    │         │    └── java
    │         │          └── mypackage.beast.*
    │         └── test
    ├── lphy
    │    ├── build.gradle.kts
    │    ├── doc
    │    ├── lib
    │    └── src
    │         ├── main
    │         │    ├── java
    │         │    │     ├── mypackage.lphy.*
    │         │    │     └── module-info.java
    │         │    └── resources
    │         │          └── META-INF
    │         │                 └── services
    │         │                        └── lphy.spi.LPhyExtension
    │         └── test
    │    
    ├── lphybeast
    │    ├── build.gradle.kts
    │    ├── lib
    │    └── src
    │         ├── main
    │         │    └── java
    │         │          ├── mypackage.lphybeast.*
    │         │          └── module-info.java
    │         └── test
    ├──settings.gradle.kts
    └──...
```
