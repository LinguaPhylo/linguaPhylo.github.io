---
layout: page
title: Developer Note
permalink: /developer/
---

{% assign java_version = "17" %}

LPhy and LPhyBEAST are developed based on Java {{ java_version }},
which is the latest long-term support (LTS) version.
The LPhy extension mechanism is implemented using
the Service Provider Interface (SPI) and the Java Platform Module System (JPMS).

They are the Gradle projects, which benefit from Gradle's human-readable and fast build,
as well as the unified development environment settings in IntelliJ.
The dependency management in Gradle through the maven central repository makes
this critical job much easier for developers. 
All LPhy related projects are now published to the
[Maven central repo](https://search.maven.org/search?q=g:io.github.linguaphylo).


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

### Gradle project

Gradle is not only a build system (c.f. ANT), but also contains dependency management,
structuring project, and other advanced features.
When you are developing a project including extensions from these 3 groups,
we recommend you use Gradle.
An [model example](/developer/implement-ext) is available online. 

If you do not want migrate your existing BEAST 2 project to a Gradle project,
the alternative solution is to create a Gradle project only containing
LPhy and LPhyBEAST parts, and release your LPhyBEAST code as the 2nd BEAST 2 package
separated from your previous BEAST 2 package.  


## What should an extension developer know

* [LPhy](https://linguaphylo.github.io), and some [tutorials](/tutorials) to create analyses. 

* [Writing a BEAST 2 Package](https://www.beast2.org/writing-a-beast-2-package/),
if you are working on a LPhyBEAST extension.

* [Build, release, publish a Gradle project](https://github.com/LinguaPhylo/linguaPhylo/blob/master/DEV_NOTE.md)

## Step by step tutorial

* [A step-by-step tutorial to implement an extension](/developer/step-by-step)

## Advanced tutorials

* [Gradle project master - project structure](/developer/project-structure/)

* [Gradle project master - dependencies](/developer/dependencies/)

* [Java extension mechanism of LPhy and LPhyBEAST](/developer/java-dev/)

## Useful links

[//]: # (https://www.infoq.com/articles/java11-aware-service-module/)
* [SPI (Service Provider Interface)](https://www.baeldung.com/java-spi)

[//]: # (https://openjdk.java.net/jeps/261)
* [A Guide to Java 9 Modularity](https://www.baeldung.com/java-9-modularity)

* [Project Jigsaw: Module System Quick-Start Guide](https://openjdk.java.net/projects/jigsaw/quick-start)

* [Why Should I Use Dependency Management in Project Management Software?](https://www.wrike.com/project-management-guide/faq/why-should-i-use-dependency-management-in-project-management-software/)
