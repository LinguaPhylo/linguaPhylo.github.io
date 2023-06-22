---
layout: page
title: User Manual
permalink: /setup/
---

This page includes user manuals for two applications:

1. LPhy Studio - the GUI for LPhy language

2. LPhyBEAST - a BEAST 2 package that takes a LPhy script and produces a BEAST 2 XML file. 

This page will run through the basic setup for LPhy Studio and LPhyBEAST. 

For more advanced options, please refer to the [Advanced User Guide](https://linguaphylo.github.io/advanced/) 
and [LPhy Extensions](https://linguaphylo.github.io/extensions/) pages. 
Additionally, you can explore the features of the LPhy language [here](https://linguaphylo.github.io/features/).

## Java 17

LPhy and LPhyBEAST require Java 17. We recommend you install [OpenJDK 17](https://jdk.java.net/java-se-ri/17).

To check your Java version, use the command line below:

```bash
java -version
```

## LPhy Studio installation

{% assign lphy_version = "1.4.x" %}

Download the LPhy Studio version for your operating system:

- Mac [lphystudio-1.4.3-osx-installer.dmg](https://github.com/LinguaPhylo/linguaPhylo/releases/download/1.4.3/lphystudio-1.4.3-osx-installer.dmg)

- Windows [lphystudio-1.4.3-windows-x64-installer.exe](https://github.com/LinguaPhylo/linguaPhylo/releases/download/1.4.3/lphystudio-1.4.3-windows-x64-installer.exe)

- Linux [lphy-studio-1.4.3.zip](https://github.com/LinguaPhylo/linguaPhylo/releases/download/1.4.3/lphy-studio-1.4.3.zip)

Download links for LPhy Studio releases are also available on the LinguaPhylo GitHub release page, see [here](https://github.com/LinguaPhylo/linguaPhylo/releases/latest) for the latest version.
All release versions of the software are available on the [LPhy releases page](https://github.com/LinguaPhylo/linguaPhylo/releases).  


### Linux

To install LPhy Studio, unzip the `lphy-studio-{{lphy_version}}.zip` file to the target directory.

For compatibility with LPhyBeast, unzip `lphy-studio-{{lphy_version}}.zip` inside your BEAST 2.x.x directory. 

To launch LPhyStudio from the command line, use the following command, replacing "BEAST_PATH" with the path to your BEAST 2.x.x directory, where "x" is the version number:

```bash
cd /BEAST_PATH/lphy-studio-{{lphy_version}}/
./bin/lphystudio
```

### Mac and Windows

Double click the installer and follow the installation wizard to complete the install.

<figure class="image">
  <a href="/images/LPhyStudioInstaller.png">
    <img src="/images/LPhyStudioInstaller.png" alt="LPhy Studio installation wizard" style="width:600px;">
  </a>
  <figcaption>Figure 1: Installing LPhy Studio.</figcaption>
</figure>

To use LPhy with LPhyBEAST, LPhy Studio needs to be installed inside the BEAST 2.x.x folder. 
In macOS, a typical installation path for LPhy Studio is `/Applications/BEAST 2.x.x/lphy-studio-{{lphy_version}}`

<figure class="image">
  <a href="/images/LPhyStudioInstallerLocation.png">
    <img src="/images/LPhyStudioInstallerLocation.png" alt="LPhy Studio installation location" style="width:600px;">
  </a>
  <figcaption>Figure 2: Choosing the installation directory for LPhy Studio.</figcaption>
</figure>


#### Launching LPhy Studio

To run LPhy Studio click on `LPhyStudioLauncher` inside your LPhy install location.

<figure class="image">
  <a href="/images/LPhyStudioLauncher.png">
    <img src="/images/LPhyStudioLauncher.png" alt="LPhy Studio install location" style="width:700px;">
  </a>
  <figcaption>Figure 3: Launching LPhy Studio.</figcaption>
</figure>

LPhy example scripts are in the `examples` subdirectory, and libraries are in the `lib` subdirectory of your LPhy install location.

If you are new to LPhy, we recommend starting with this [introductory guide](https://linguaphylo.github.io/about/) before moving to the tutorials. 

## Running LPhy via command line

LPhy can be used to simulate data via command line inside your LPhy installation location. 
This location is your `lphy-studio-{{lphy_version}}` directory. 

To simulate data, replace `LPHY_PATH` with your LPhy installation path. 
```
cd LPHY_PATH
java -p lib -m lphystudio/lphystudio.app.simulator.SLPhy <LPhy script>
```

For example: 
```bash
cd /Applications/BEAST 2.7.4/lphy-studio-{{lphy_version}}
java -p lib -m lphystudio/lphystudio.app.simulator.SLPhy examples/coalescent/gtrCoalescent.lphy
```

## LPhy extensions

LPhy extensions can be installed following this guide [here](https://linguaphylo.github.io/extensions/). 

Current supported LPhy extensions are listed on the [homepage](https://linguaphylo.github.io/).

## LPhyBEAST installation

[LPhyBEAST](https://github.com/LinguaPhylo/LPhyBeast/releases) and LPhyBeast extensions 
require the latest version of [BEAST 2](https://www.beast2.org). 

First, we need to install two [BEAST 2 packages](https://www.beast2.org/managing-packages/) `lphybeast` and `LPhyBeastExt`.

1. To install LPhyBEAST, start `BEAUti` and from the menu go to `File` => `Manage Packages` to launch `Package Manager`. 
2. Click on `Package repositories` to open the "BEAST 2 Package Repository Manager".
3. Select `lphybeast` from the packages list, then use `Install/Upgrade` to install.

Installation may take few minutes to download and install. Please wait until a confirmation popup appears on the screen.

<figure class="image">
  <img src="/images/Installed.png" alt="Installed" style="width:600px;">
  <figcaption>Figure 4: Confirmation message for successful install of lphybeast.</figcaption>
</figure>

{:start="4"}
4. Restart `Package Manager`. Now `lphybeast` and dependent packages should appear as "installed". 
5. To install `LPhyBeastExt`, from `Package Manager`, select `LPhyBeastExt` and click `Install/Upgrade` to install.

Alternatively, the packages `lphybeast` and `LPhyBeastExt` can be installed using [command line](https://www.beast2.org/managing-packages/).

### Install LPhy libraries and download starting script 

The package `lphybeast` does not include LPhy, so we need to install LPhy separately.

1. Download the LPhy Studio installer. See the section of [LPhy Studio installation](#lphy-studio-installation).

Note: You may skip steps 1-2 if you have already installed LPhyStudio in your BEAST 2 directory. 

{:start="2"}
2. Install LPhy Studio inside your BEAST 2 installation folder - we will refer to this as your **BEAST_PATH**.

<figure class="image">
  <a href="/images/LPhyFolder.png">
    <img src="/images/LPhyFolder.png" alt="LPhyFolder" style="width:700px;">
  </a>
  <figcaption>Figure 5: The installation directory for LPhy and Studio.</figcaption>
</figure>  

{:start="3"}
3. Make sure there is __only one__ LPhy folder inside your BEAST 2 installation folder.

4. Download the bash script [lphybeast](https://github.com/LinguaPhylo/LPhyBeast/blob/master/lphybeast/bin/lphybeast),
and place it into the `bin` subfolder of your BEAST 2 installation. 
Note that you may need give the `lphybeast` file executable permissions using `chmod +x lphybeast`

The final folder structure looks like:
<figure class="image">
  <a href="/images/BeastBinFolder.png">
    <img src="/images/BeastBinFolder.png" alt="Beast bin folder" style="width:700px;">
  </a>
  <figcaption>Figure 6: Add lphybeast script.</figcaption>
</figure> 

We can start LPhyBEAST using the `lphybeast` script.

The `lphybeast` script will launch LPhyBEAST using the BEAST 2 [applauncher](https://www.beast2.org/2019/09/26/command-line-tricks.html),
and add `$LPHY_LIB` into the classpath. 


## LPhyBEAST usage

Now, we can run LPhyBEAST using the command line, where `BEAST_PATH` is your BEAST 2 install path, and `LPHY_PATH` is your LPhy install path

```bash
cd BEAST_PATH
./bin/lphybeast -h
```

To create "RSV2.xml" from the tutorial script "RSV2.lphy":

```bash
cd LPHY_PATH/tutorials/
BEAST_PATH/bin/lphybeast RSV2.lphy
```

Or using the absolute path and from a different folder:

```bash
cd MY_PATH
BEAST_PATH/bin/lphybeast LPHY_PATH/tutorials/RSV2.lphy
```

To create 5 XMLs with simulated data:

```bash
BEAST_PATH/bin/lphybeast -wd LPHY_PATH/tutorials/ -r 5 RSV2.lphy
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



