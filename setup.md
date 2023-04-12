---
layout: page
title: User Manual
permalink: /setup/
---

This page includes user manuals for two applications:

1. LPhy studio - the GUI for LPhy language

2. LPhyBEAST - a BEAST 2 package that takes a LPhy script and produces a BEAST 2 XML file.


## Java 17

LPhy and LPhyBEAST require Java 17. We recommend you install [OpenJDK 17](https://jdk.java.net/17/).

To check your Java version, use the command line below:

```bash
java -version
```

## LPhy Studio

{% assign lphy_version = "1.4.*" %}

### LPhy Studio installation

Go to the [LPhy releases page](https://github.com/LinguaPhylo/linguaPhylo/releases), 
and download the [latest installer](https://github.com/LinguaPhylo/linguaPhylo/releases/latest) for your operating system. 

- Mac [lphystudio-1.4.1-osx-installer.dmg](https://github.com/LinguaPhylo/linguaPhylo/releases/download/1.4.1/lphystudio-1.4.1-osx-installer.dmg)

- Windows [lphystudio-1.4.1-windows-x64-installer.exe](https://github.com/LinguaPhylo/linguaPhylo/releases/download/1.4.1/lphystudio-1.4.1-windows-x64-installer.exe)

- Linux [lphy-studio-1.4.1.zip](https://github.com/LinguaPhylo/linguaPhylo/releases/download/1.4.1/lphy-studio-1.4.1.zip)

Double click the installer and follow the install wizard to complete the install.

<figure class="image">
  <a href="/images/LPhyStudioInstaller.png">
    <img src="/images/LPhyStudioInstaller.png" alt="LPhy Studio installation wizard">
  </a>
  <figcaption>Figure 1: Installing LPhy Studio.</figcaption>
</figure>

To use LPhy with LPhyBEAST, we recommend that you install LPhy Studio inside your BEAST 2.* folder, and name the install directory `lphy`. 

Example LPhy scripts are in the `examples` subdirectory, and libraries are in the `lib` subdirectory of your LPhy install location.


### Launching LPhy Studio

To run LPhy Studio click on `LPhyStudioLauncher` inside your LPhy install location.

<figure class="image">
  <a href="/images/LPhyStudioLauncher.png">
    <img src="/images/LPhyStudioLauncher.png" alt="LPhy Studio install location">
  </a>
  <figcaption>Figure 2: Launching LPhy Studio.</figcaption>
</figure>

If you are new to LPhy, we recommend starting with the [introductory guide](https://linguaphylo.github.io/about/) before moving to the tutorial pages. 


## LPhyBEAST installation

[LPhyBEAST](https://github.com/LinguaPhylo/LPhyBeast/releases) requires BEAST 2.7.4 or higher, 
and is installable as a [BEAST 2 package](https://www.beast2.org/managing-packages/) called lphybeast.

1. To install LPhyBEAST, start `BEAUti` and open `Package Manager` from the menu `File` => `Manage Packages`. 
2. Click on `Package repositories` to open the "BEAST 2 Package Repository Manager".
3. Select `lphybeast` from the package list, then use `Install/Upgrade` to install.

Note: Installation may take few minutes to download and install. Please wait until a confirmation popup appears on the screen.

<figure class="image">
  <img src="/images/Installed.png" alt="Installed">
  <figcaption>Figure 3: Confirmation message for successful install of lphybeast.</figcaption>
</figure>

{:start="4"}
4. Restart `Package Manager`. Now `lphybeast` and dependent packages should appear as "installed". 

Alternatively, you can install the `lphybeast` package using [command line](https://www.beast2.org/managing-packages/).

### Install LPhy libraries and download starting script 

The package `lphybeast` does not include LPhy, so we need to install LPhy separately.

1. Download the LPhy Studio installer from the [release page](https://github.com/LinguaPhylo/linguaPhylo/releases)
- Windows `lphy-studio-{{ lphy_version }}-windows-x64-installer.exe`
- Mac `lphy-studio-{{ lphy_version }}-osx-installer.dmg`
- Linux `lphy-studio-{{ lphy_version }}.zip`

2. Install LPhy Studio inside the BEAST 2 installation folder `$BEAST_DIR`.

<figure class="image">
  <a href="/images/LPhyLibFolder.png">
    <img src="/images/LPhyLibFolder.png" alt="LPhyLibFolder" style="width:700px;">
  </a>
  <figcaption>Figure 4: Set LPHY_LIB path.</figcaption>
</figure>  

{:start="3"}
3. Make sure there is __only one__ LPhy folder, such as `lphy-studio-{{ lphy_version }}`, inside your `$BEAST_DIR`.

4. Download the bash script `lphybeast` from 
[LPhyBEAST's repo](https://github.com/LinguaPhylo/LPhyBeast/blob/master/lphybeast/bin/lphybeast),
and put it into the `bin` folder under `$BEAST_DIR` with other scripts.

The final folder structure looks like:

We can start LPhyBEAST using the `lphybeast` script.
It will launch LPhyBEAST through the BEAST 2 [applauncher](https://www.beast2.org/2019/09/26/command-line-tricks.html),
and add the `$LPHY_LIB` folder into the classpath.


## LPhyBEAST usage

Now, we can run LPhyBEAST using the command line

```bash
$BEAST_DIR/bin/lphybeast -h
```

To create "RSV2.xml" from the tutorial script "RSV2.lphy":

```bash
cd $LPHY_PATH/tutorials/
$BEAST_DIR/bin/lphybeast RSV2.lphy
```

Or using the absolute path and from a different folder:

```bash
cd $MY_PATH
$BEAST_DIR/bin/lphybeast $LPHY_PATH/tutorials/RSV2.lphy
```

To create 5 XMLs with simulated data:

```bash
$BEAST_DIR/bin/lphybeast -wd $LPHY_PATH/tutorials/ -r 5 RSV2.lphy
```


## Troubleshooting


### IOException

The most cases are caused by the inconsistent relative path between the input file 
and the data inside the LPhy script. Please see the subsection "Relative file path".


```
SEVERE: java.io.IOException: Cannot find Nexus file ! .../data/RSV2.nex, user.dir = ...
	at lphy.evolution.io.NexusParser.getReader(NexusParser.java:85)
	at lphy.evolution.io.NexusParser.<init>(NexusParser.java:64)
	at lphy.core.functions.ReadNexus.apply(ReadNexus.java:66)
	at lphy.graphicalModel.DeterministicFunction.generate(DeterministicFunction.java:8)
	at lphy.parser.SimulatorListenerImpl$SimulatorASTVisitor.visitMethodCall(SimulatorListenerImpl.java:856)
```


### LPhyBEAST failed by an improper installation

If the LPhy library folder is not in a correct path, you will see the following exceptions:

```
java.lang.NoClassDefFoundError: lphy/core/LPhyParser
	at java.base/java.lang.Class.getDeclaredMethods0(Native Method)
	at java.base/java.lang.Class.privateGetDeclaredMethods(Class.java:3334)
	at java.base/java.lang.Class.getMethodsRecursive(Class.java:3475)
	at java.base/java.lang.Class.getMethod0(Class.java:3461)
	at java.base/java.lang.Class.getMethod(Class.java:2193)
	at beast.app.tools.AppLauncher.runAppFromCMD(Unknown Source)
	at beast.app.tools.AppLauncher.main(Unknown Source)
...
Caused by: java.lang.ClassNotFoundException: lphy.core.LPhyParser
	at java.base/java.net.URLClassLoader.findClass(URLClassLoader.java:433)
	at java.base/java.lang.ClassLoader.loadClass(ClassLoader.java:586)
	at java.base/java.lang.ClassLoader.loadClass(ClassLoader.java:519)
	... 13 more
```


### LPhyBEAST failed by Java version

If the `lphybeast -h` failed with the following error message about Java version:

```
java.lang.UnsupportedClassVersionError: 
lphybeast/LPhyBEAST has been compiled by a more recent version 
of the Java Runtime (class file version 61.0), this version of 
the Java Runtime only recognizes class file versions up to 52.0
	at java.lang.ClassLoader.defineClass1(Native Method)
	at java.lang.ClassLoader.defineClass(ClassLoader.java:763)
	at java.security.SecureClassLoader.defineClass(SecureClassLoader.java:142)
	at java.net.URLClassLoader.defineClass(URLClassLoader.java:468)
```

First, check if your local Java is 17 using `java -version`. 
If yes, you need to download and use BEAST 2 without JRE, because with JRE, 
`applauncher` will be forced to use the provided JRE in BEAST 2 which currently is 1.8.



