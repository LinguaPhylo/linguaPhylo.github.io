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

To check your Java version, use the command line in the terminal:

```bash
java -version
```

## LPhy Studio installation

{% assign lphy_version = "1.4.x" %}

Download the LPhy Studio version for your operating system:

- Mac [lphystudio-1.4.3-osx-installer.dmg](https://github.com/LinguaPhylo/linguaPhylo/releases/download/1.4.3/lphystudio-1.4.3-osx-installer.dmg)

- Windows [lphystudio-1.4.3-windows-x64-installer.exe](https://github.com/LinguaPhylo/linguaPhylo/releases/download/1.4.3/lphystudio-1.4.3-windows-x64-installer.exe)

- Linux [lphy-studio-1.4.3.zip](https://github.com/LinguaPhylo/linguaPhylo/releases/download/1.4.3/lphy-studio-1.4.3.zip)

All release versions of LPhy Studio are available on the [LPhy releases page](https://github.com/LinguaPhylo/linguaPhylo/releases).


### Linux

For Linux, we recommend unzipping the `lphy-studio-{{lphy_version}}.zip` 
file to the `/usr/local` directory. 
By doing so, the launch script for LPhyBeast will automatically detect the library path `$LPHY_LIB`. 
Alternatively, you have the option to manually assign the environment variable `$LPHY_LIB` 
to the location where LPhy Studio is installed if you choose to install it in a different directory.

To launch LPhyStudio from the command line, use the following command, 
replacing "x" to the version number:

```bash
cd /usr/local/lphy-studio-{{lphy_version}}/
./bin/lphystudio
```

### Mac

For Mac, an installer is available when you open the .dmg file.
Double click it and follow the installation wizard to complete the install.

<figure class="image">
  <a href="/images/LPhyStudioInstaller.png">
    <img src="/images/LPhyStudioInstaller.png" alt="LPhy Studio installation wizard" style="width:600px;">
  </a>
  <figcaption>Figure 1: Installing LPhy Studio.</figcaption>
</figure>

Please **keep the default** installation path, 
such as `/Applications/lphy-studio-{{lphy_version}}`, 
so that the launch script for LPhyBeast will automatically detect the library path `$LPHY_LIB`.

<figure class="image">
  <a href="/images/LPhyStudioInstallerLocation.png">
    <img src="/images/LPhyStudioInstallerLocation.png" alt="LPhy Studio installation location" style="width:600px;">
  </a>
  <figcaption>Figure 2: The installation directory for LPhy Studio.</figcaption>
</figure>

### Windows

The process is same to the Mac installation. 
Please **keep the default** installation path. But if it shows "C:\Program Files (x86)", 
we recommend to change to "C:\Program Files".

### The the default installation path

- Linux: `/usr/local/`
- Mac: `/Applications/`
- Windows: `C:\Program Files`


### Click and Launch LPhy Studio

For Mac and Windows, to launch LPhy Studio, click on `LPhyStudioLauncher` inside your LPhy install location.

<figure class="image">
  <a href="/images/LPhyStudioLauncher.png">
    <img src="/images/LPhyStudioLauncher.png" alt="LPhy Studio install location" style="width:700px;">
  </a>
  <figcaption>Figure 3: Launching LPhy Studio.</figcaption>
</figure>

LPhy example scripts are in the `examples` and `tutorials` subdirectory, 
and libraries are in the `lib` subdirectory of your LPhy install location.

If you are new to LPhy, we recommend starting with this [introductory guide](https://linguaphylo.github.io/about/) before moving to the tutorials. 

## SLPhy: simulate data via command line

SLPhy is an application to simulate data via command line given a file containing the LPhy script. 
The bash script [slphy](https://github.com/LinguaPhylo/linguaPhylo/blob/master/bin/slphy) 
can be found in the `bin` directory. For Windows, please use `lphybeast.bat`.

To simulate data at 5 replicates, replace `$LPHY` variable with your LPhy installation path. 

```bash
cd $LPHY/examples/coalescent
$LPHY/bin/slphy -r 5 <LPhy script>
```

For example: 
```bash
/Applications/lphy-studio-{{lphy_version}}/bin/slphy -r 5 jcCoalescent.lphy
```
The "x" is the version number.

The simulation will produce alignment(s) and saved them into one or many "*.nexus" files, 
and tree(s) into the "*.trees" file and all random number values into the "*.log" file.  


## LPhy extensions

LPhy extensions can be installed following this guide [here](https://linguaphylo.github.io/extensions/). 

Current supported LPhy extensions are listed on the [homepage](https://linguaphylo.github.io/#extensions).


## LPhyBEAST installation

[LPhyBEAST](https://github.com/LinguaPhylo/LPhyBeast/releases) and LPhyBeast extensions 
require the latest version of [BEAST 2](https://www.beast2.org). 

First, we need to install two [BEAST 2 packages](https://www.beast2.org/managing-packages/) 
[lphybeast](https://github.com/LinguaPhylo/LPhyBeast/) and [LPhyBeastExt](https://github.com/LinguaPhylo/LPhyBeastExt/).

1. To install LPhyBEAST, start `BEAUti` and from the menu go to `File` => `Manage Packages` to launch `Package Manager`. 
2. Select `lphybeast` from the packages list, then click `Install/Upgrade` button to install.
3. Select `LPhyBeastExt` from the list, then click `Install/Upgrade` to install.

Installation may take few minutes to download and install. Please wait until a confirmation popup appears on the screen.

<figure class="image">
  <img src="/images/Installed.png" alt="Installed" style="width:600px;">
  <figcaption>Figure 4: Confirmation message for successful install of lphybeast.</figcaption>
</figure>

{:start="4"}
4. Restart `Package Manager`. Now they and their dependent packages should appear as "installed". 

Alternatively, the packages `lphybeast` and `LPhyBeastExt` can be installed using [command line](https://www.beast2.org/managing-packages/).

### Install LPhy libraries and download starting script 

The package `lphybeast` does not include LPhy, so we need to install LPhy separately.
You may skip steps 1-2 if you have already installed LPhyStudio in your BEAST 2 directory. 

1. Download the LPhy Studio installer. See the section of [LPhy Studio installation](#lphy-studio-installation).

2. Install LPhy Studio inside your BEAST 2 installation folder - we will refer this BEAST 2 folder as your **BEAST_PATH**.

The folder structure is shown in Figure 3. See the section [Launching LPhy Studio](#launching-lphy-studio)

Note: make sure there is __only one__ LPhy folder inside your BEAST 2 installation folder.

{:start="3"}
3. Download the bash script [lphybeast](https://github.com/LinguaPhylo/LPhyBeast/blob/master/lphybeast/bin/lphybeast),
and place it into the `bin` subfolder of your BEAST 2 installation. For Windows, please download 
[lphybeast.bat](https://github.com/LinguaPhylo/LPhyBeast/blob/master/lphybeast/bin/lphybeast.bat)
Note that you may need give the `lphybeast` file executable permissions using `chmod +x lphybeast`

The final folder structure looks like:
<figure class="image">
  <a href="/images/BeastBinFolder.png">
    <img src="/images/BeastBinFolder.png" alt="Beast bin folder" style="width:700px;">
  </a>
  <figcaption>Figure 5: Add lphybeast script.</figcaption>
</figure> 


## LPhyBEAST usage

Now, we can run LPhyBEAST from the terminal. 
The `$BEAST_PATH` represents the installation path of BEAST 2, and `$LPHY_PATH` represents the installation path of LPhy.
For Windows, replace `lphybeast` as `lphybeast.bat`.

```bash
cd $BEAST_PATH
./bin/lphybeast -h
```

Create "RSV2.xml" from the tutorial script "RSV2.lphy":

```bash
cd $LPHY_PATH/tutorials/
$BEAST_PATH/bin/lphybeast RSV2.lphy
```

Or, create 5 XMLs at 5 replicates:

```bash
$BEAST_PATH/bin/lphybeast -r 5 RSV2.lphy
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



