---
layout: page
title: Developers
permalink: /developer/
---

{% assign java_version = "17" %}

LPhy and LPhyBEAST are developed based on Java {{ java_version }},
which is the latest long-term support (LTS) version.
The LPhy extension mechanism is implemented using
the Service Provider Interface (SPI) and the Java Platform Module System (JPMS).

They are the Maven projects, where the Maven "pom.xml" is used to automatically 
configure the modules and their dependencies in the IntelliJ project.

## System integration 

First, to be an extension developer, you should be aware that there are 3 groups of projects,
which are using very different technologies:

### 1. LPhy and LPhy extensions. 

This group is using the latest technologies, 
such as Java {{ java_version }}, JPMS, and the standardised extension mechanism using SPI.

### 2. BEAST 2 and its packages.

This group is currently using Java 1.8, so it is not using JPMS. 
The extension mechanism was developed by BEAST 2 core developers.

### 3. LPhyBEAST and its extensions.

This group contains the mapping Java classes between LPhy group and BEAST 2 group.
LPhy does not have any inference engines at the moment, 
so that LPhyBEAST takes the role to convert LPhy model specification and data block into BEAST 2 XML.

It requires an integration between two different systems. 
This group still uses Java {{ java_version }}, but not JPMS. 
The extension mechanism is similar to the BEAST 2 group,
and LPhyBEAST and its extensions are released as BEAST 2 packages.
Therefore, they can be installed and managed by BEAST 2 _Package Manager_.
However, to be able to trigger SPI, the corresponding LPhy libraries have to be loaded into Java classpath.


## What should an extension developer know

* [LPhy](https://linguaphylo.github.io), and some [tutorials](/tutorials) to create analyses. 

* [Writing a BEAST 2 Package](https://www.beast2.org/writing-a-beast-2-package/),
if you are working on a LPhyBEAST extension.

* LPhy developer guides:
    * [Guide 101 (Development Environment)](https://github.com/LinguaPhylo/linguaPhylo/blob/master/DEV_NOTE.md)
    * Guide 102 (LPhy in Java)    coming soon ...
    * Guide 103 (Maven project)   coming soon ...

* [LPhyBEAST developer note]()  coming soon ...


## Writing a user tutorial

We strongly recommend the developers to create a corresponding user tutorial 
to explain the model and demonstrate how to make an analysis.
This [post]({% link _posts/2021-03-25-tips-to-write-tutorials.markdown %}) 
gives you several tips how to write a LPhyBEAST tutorial.
More details and examples are also available in the [Tutorials](/tutorials) page.   


## Useful links

* [Why do we need dependencies?](/developer/why-modules/)

[//]: # (https://www.infoq.com/articles/java11-aware-service-module/)
* [SPI (Service Provider Interface)](https://www.baeldung.com/java-spi)

[//]: # (https://openjdk.java.net/jeps/261)
* [A Guide to Java 9 Modularity](https://www.baeldung.com/java-9-modularity)

* [Project Jigsaw: Module System Quick-Start Guide](https://openjdk.java.net/projects/jigsaw/quick-start)
