---
layout: page
title: User Manual
permalink: /setup/
---

This page includes user manuals for two applications:

1. LPhy Studio - the GUI for LPhy language

2. LPhyBEAST - a BEAST 2 package that takes a LPhy script and produces a BEAST 2 XML file. 

This page will run through the basic setup for LPhy Studio and LPhyBEAST. 

For more advanced options, please refer to the [Advanced User Guide](/advanced) 
and [LPhy Extensions](/extensions) pages. 
You can also visit our [Tech Help](/tutorials/tech-help) page and [FAQ](#troubleshooting-guide) section, 
where you can find helpful assistance and solutions to common issues. 
Additionally, you can learn more about the [features](/features) of the LPhy language.

## Java 17

LPhy requires Java 17. We recommend you install [OpenJDK 17](https://jdk.java.net/java-se-ri/17).

To check your Java version, use the command line in the terminal:

```bash
java -version
```

## LPhy Studio installation

{% assign lphy_version = "1.7.x" %}

Download the LPhy Studio version for your operating system:

- Mac [lphystudio-1.7.0-osx-installer.dmg](https://github.com/LinguaPhylo/linguaPhylo/releases/download/1.7.0/lphystudio-1.7.0-osx-installer.dmg)

- Windows [lphystudio-1.7.0-windows-x64-installer.exe](https://github.com/LinguaPhylo/linguaPhylo/releases/download/1.7.0/lphystudio-1.7.0-windows-x64-installer.exe)

- Linux [lphy-studio-1.7.0.zip](https://github.com/LinguaPhylo/linguaPhylo/releases/download/1.7.0/lphy-studio-1.7.0.zip)

All release versions of LPhy Studio are available on the [LPhy releases page](https://github.com/LinguaPhylo/linguaPhylo/releases).

### The default installation path

- Linux: `~/` which is your home folder
- Mac: `/Applications/`
- Windows: `C:\Program Files\`


### Linux

For Linux, we recommend unzipping the `lphy-studio-{{lphy_version}}.zip` 
file to your home directory. 
By doing so, the launch script for LPhyBeast will automatically detect the library path `$LPHY_LIB`. 
Alternatively, you have the option to manually assign the environment variable `$LPHY_LIB` 
to the location where LPhy Studio is installed if you choose to install it in a different directory.

To launch LPhyStudio from the command line, use the following command, 
replacing "x" to the version number:

```bash
cd ~/lphy-studio-{{lphy_version}}/
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

**Please note** that "C:\Program Files" is usually a protected directory. 
To avoid any permission issues while using programs that produce output files, 
we recommend copying the "examples" and "tutorials" folders, along with the "data" folder, 
into your "Documents" directory and working from there. 
This will ensure that the programs (e.g., `slphy` and `lphybeast`) have the necessary write permissions 
to create and overwrite files as needed.


### Launching LPhy Studio

For Linux users, please refer to the [Linux](#linux) section.
For Mac and Windows users, to launch LPhy Studio, 
click on `LPhyStudioLauncher` inside your LPhy install location.

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
can be found in the `bin` directory. 
For Windows, please use `slphy.bat` and copy the LPhy script with "data" to the "Documents" folder.

To run SLPhy, navigate to the folder containing the LPhy scripts and 
execute the following commands. 
Please ensure that you have the necessary write permissions in the working directory.

To simulate data at 5 replicates, after replacing `$LPHY` variable with your LPhy installation path. 

```bash
cd $LPHY/examples/coalescent
$LPHY/bin/slphy -r 5 <LPhy script>
```

For example: 
```bash
/Applications/lphy-studio-{{lphy_version}}/bin/slphy -r 5 hkyCoalescent.lphy
```
The "x" is the version number.

The simulation will produce alignment(s) and saved them into one or many "*.nexus" files, 
and tree(s) into the "*.trees" file and all random number values into the "*.log" file.  

SLPhy supports Macro language to replace values in a lphy script by command line, 
and then the simulation is done using those new values:

```bash
cd $LPHY/examples/macro
YOUR_PATH/slphy -D "n=5;L=50" MacroLanguage.lphy
```

In the MacroLanguage.lphy, the L has a default value 100, and n has 10.

{% raw %}
```lphy
L = {{L = 100}};
taxa = taxa(names=1:{{n = 10}});
```
{% endraw %}

Given the command line argument `-D "n=5;L=50"`, 
the simulation will be done using 50 as the new value of L and 5 to the value of n.


## LPhy extensions and installation

LPhy extensions can be installed following this [guide](/extensions/). 
Current supported LPhy extensions are also listed on that page.


## LPhyBEAST installation

[LPhyBEAST](https://github.com/LinguaPhylo/LPhyBeast/) and its extensions
are [BEAST 2 packages](https://compevol.github.io/CBAN/).
It requires the latest version of [BEAST 2](https://www.beast2.org) and [LPhy](#lphy-studio-installation).

Please install them following the instructions below: 

1. To install LPhyBEAST core, start `BEAUti` and from the menu go to `File` => `Manage Packages` 
to launch `Package Manager`. More details are [here](https://www.beast2.org/managing-packages/)

2. Select `lphybeast` from the packages list, then click `Install/Upgrade` button to install.

3. If you want to use the extended [models](https://github.com/LinguaPhylo/LPhyBeast/blob/master/lphybeast-ext-dist/README.md), 
select `LPhyBeastExt` from the list, then click `Install/Upgrade` to install.

Installation may take few minutes to download and install, including all dependent packages. 
Please wait until a confirmation popup appears on the screen.

<figure class="image">
  <img src="/images/Installed.png" alt="Installed" style="width:600px;">
  <figcaption>Figure 4: Confirmation message for successful install of lphybeast.</figcaption>
</figure>

{:start="4"}
4. Restart `Package Manager`. Now they and their dependent packages should appear as "installed". 

Alternatively, these BEAST 2 packages can be installed 
using [command line](https://www.beast2.org/managing-packages/).

The package `lphybeast` does not include LPhy, so we need to install LPhy separately.
You may skip steps 5-6 if you have already installed LPhyStudio in the [default directory](#the-default-installation-path). 

{:start="5"}
5. Download the LPhy Studio installer. 
See the section of [LPhy Studio installation](#lphy-studio-installation).

6. Install LPhy Studio to the [default path](#the-default-installation-path). 
In addition, if you are using any LPhyBeast extensions except of `LPhyBeastExt`, 
you need to have their LPhy extension ready. Please see [listed extensions](/extensions/).

7. Download the latest version of the script below to launch LPhyBEAST. 
Right-click the corresponding link, and select "Download Linked File" from the context menu. 
Then, move `lphybeast` into the `bin` subfolder of your BEAST 2 installation on macOS and Linux. 
For Windows, move `lphybeast.bat` into the `bat` subfolder instead.
   - [lphybeast](https://raw.githubusercontent.com/LinguaPhylo/LPhyBeast/master/lphybeast/bin/lphybeast), for Linux and Mac.
   - [lphybeast.bat](https://raw.githubusercontent.com/LinguaPhylo/LPhyBeast/master/lphybeast/bin/lphybeast.bat), for Windows.

More versions are available in the [release page](https://github.com/LinguaPhylo/LPhyBeast/releases).
Note that on macOS and Linux, you may need to give the `lphybeast` file executable permissions 
using the `chmod +x lphybeast` command.

The final folder structure looks like:
<figure class="image">
  <a href="/images/BeastBinFolder.png">
    <img src="/images/BeastBinFolder.png" alt="Beast bin folder" style="width:700px;">
  </a>
  <figcaption>Figure 5: Add lphybeast script.</figcaption>
</figure> 


## LPhyBEAST usage

Now, we can use `lphybeast` to run LPhyBEAST from the terminal. 
The `$BEAST_PATH` represents the installation path of BEAST 2, 
and `$LPHY_PATH` represents the installation path of LPhy.
For Windows, please use `$BEAST_PATH/bin/lphybeast.bat` instead of `$BEAST_PATH\bat\lphybeast`,
and also copy the LPhy script with "data" to the "Documents" folder.

```bash
$BEAST_PATH/bin/lphybeast -h
```

We recommend to navigate to the folder containing the LPhy scripts and run LPhyBEAST.
The following commands will create "RSV2.xml" from the tutorial script 
[RSV2.lphy](https://linguaphylo.github.io/tutorials/time-stamped-data/). 
Please ensure that you have the necessary write permissions in the working directory.

```bash
cd $LPHY_PATH/tutorials/
$BEAST_PATH/bin/lphybeast RSV2.lphy
```

The `lphybeast` script will generate the "RSV2.xml" file based on the model and parameters 
specified in the "RSV2.lphy" script. 
Additionally, the alignment is imported from a Nexus file "RSV2.nex" 
located in the "data" subfolder.

LPhyBEAST can be used to simulate alignments from the given model. 
The following command will create 5 XMLs, 
and each XML will contain a different simulated alignment at each replicate, 
where the `-r` option specifies the number of replicates.

```bash
cd $LPHY_PATH/examples/coalescent/
$BEAST_PATH/bin/lphybeast -r 5 hkyCoalescent.lphy
```

## Legacy dependencies

There are significant changes about SPI and APIs among LPhy 1.4.x, 1.5.x, and 1.6.x (where x >= 0).
So there is no backward compatibility for extensions.
If you want to use the old version extensions, please install the required versions of LPhy and LPhyBEAST.

- LPhyBEAST v1.3.x requires LPhy 1.7.x;
- LPhyBEAST v1.2.x requires LPhy 1.6.x;
- LPhyBEAST v1.1.x requires LPhy 1.5.x;
- LPhyBEAST v1.0.x requires LPhy 1.4.x;
- LPhyBEASTExt 1.0.x requires LPhyBEAST v1.2.x;
- LPhyBEASTExt 0.3.x requires LPhyBEAST v1.1.x;
- LPhyBEASTExt 0.2.x requires LPhyBEAST v1.0.x;
- Phylonco-lphy 1.2.x (LPhy extension) requires LPhy 1.6.x;
- Phylonco-lphybeast 1.2.x requires LPhyBEAST v1.2.x, and Phylonco-lphy 1.2.x;
- Phylonco-lphy 0.0.3 (LPhy extension) requires LPhy 1.4.x;
- Phylonco-lphybeast 1.0.x requires LPhyBEAST v1.0.x, and Phylonco-lphy 0.0.3;


## Troubleshooting guide

### LPhyBEAST failed with "NoClassDefFoundError: phylonco.lphy.evolution.datatype.PhasedGenotype"
The error message looks like:
```
Registering extension from phylonco.lphybeast.spi.LBPhylonco
java.lang.reflect.InvocationTargetException
	at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke(Unknown Source)
	at java.base/jdk.internal.reflect.DelegatingMethodAccessorImpl.invoke(Unknown Source)
	at java.base/java.lang.reflect.Method.invoke(Unknown Source)
	at beastfx.app.tools.AppLauncher.runAppFromCMD(Unknown Source)
	at beastfx.app.tools.AppLauncher.main(Unknown Source)
	at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke(Unknown Source)
	at java.base/jdk.internal.reflect.DelegatingMethodAccessorImpl.invoke(Unknown Source)
	at java.base/java.lang.reflect.Method.invoke(Unknown Source)
	at beast.pkgmgmt.launcher.BeastLauncher.run(Unknown Source)
	at beast.pkgmgmt.launcher.AppLauncherLauncher.main(Unknown Source)
Caused by: java.lang.NoClassDefFoundError: phylonco.lphy.evolution.datatype.PhasedGenotype
	at beast.pkgmgmt.MultiParentURLClassLoader.loadClass(Unknown Source)
...
```

Follow one the solutions below.

**Solution A: My LPhy script does not contain any [phylonco functions](https://github.com/bioDS/beast-phylonco/blob/v1.2.1/phylonco-lphy/doc/index.md)**

* Open Beauti, go to package manager, and uninstall `phylonco.lphybeast`.

**Solution B: My LPhy script uses one or more [phylonco functions](https://github.com/bioDS/beast-phylonco/blob/v1.2.1/phylonco-lphy/doc/index.md)**

* Open Beauti, got to package manager, and install/upgrade `phylonco`. 
* Open Beauti, got to package manager, and install/upgrade `phylonco.lphybeast`. 
* Go to the [LPhy Extensions](https://linguaphylo.github.io/extensions/) page. Choose the phylonco-lphy extension corresponding to your current LPhy version (when more than one phylonco-lphy is available for your LPhy version, select the phylonco-lphy that has the highest version number).
* Follow the steps in the [Manual installation](https://linguaphylo.github.io/extensions/#manual-installation) section.

### LPhyBEAST failed with "java.lang.NoClassDefFoundError: `*.lphy.*.AClass`"

This error indicates LPhyBEAST cannot find the LPhy class `AClass`. 
First, please check if your `LPHY_LIB` is pointed to the correct location, 
which will be printed in the output message, for example,

```bash
LPHY_LIB = /home/user/lphy-studio-1.6.0/lib
```

If it is not correct, make you install LPhy in the default directory. 
Please read the LPhy installation section. 

If `AClass` is from a LPhy extension, then check if you put the LPhy extension jar into the `lib` folder.

If all of these checks have passed, you can then verify that the dependencies are correctly configured.
Some extensions are only working with their required major versions of LPhy or LPhyBEAST.
Please see [legacy dependencies](#legacy-dependencies)


### IOException: Cannot find Nexus file !

In most cases, the issues arise from inconsistent relative paths between 
the input file and the data inside the LPhy script, such as `D = readNexus(file="data/RSV2.nex");`.
It lead to an incorrect location for the Nexus file, 
when the working directory is not the parent directory of the subfolder "data".
One simple solution to address this issue is to use the absolute path.
For more details, please refer to the [Advanced User Guide](/advanced).

Alternatively, check if you copy the data with the script file together to the target location. 

The error message look like this:

```java
SEVERE: java.io.IOException: Cannot find Nexus file ! .../data/RSV2.nex, user.dir = ...
	at lphy.evolution.io.NexusParser.getReader(NexusParser.java:85)
	at lphy.evolution.io.NexusParser.<init>(NexusParser.java:64)
	at lphy.core.functions.ReadNexus.apply(ReadNexus.java:66)
	at lphy.graphicalModel.DeterministicFunction.generate(DeterministicFunction.java:8)
	at lphy.parser.SimulatorListenerImpl$SimulatorASTVisitor.visitMethodCall(SimulatorListenerImpl.java:856)
```

### LPhyBEAST failed with LPhyBeastExt not installed

If you are using Mascot (e.g. structured coalescent), you need to install the 
[LPhyBeastExt](https://github.com/LinguaPhylo/LPhyBeastExt/) package.

The error message "Please ensure you have installed the required ..." indicates 
missing BEAST2 packages necessary for the analysis. 

```java
Cannot find the mapping for given LPhy code to BEAST2 classes! 
Input file = h3n2.lphy
Please ensure you have installed the required LPhyBEAST extensions and BEAST2 packages : 

Unhandled generator in generatorToBEAST(): class lphy.evolution.coalescent.StructuredCoalescent
	at lphybeast.LPhyBeastCMD.call(LPhyBeastCMD.java:135)
	at lphybeast.LPhyBeastCMD.call(LPhyBeastCMD.java:13)
	at picocli.CommandLine.executeUserObject(CommandLine.java:2041)
	at picocli.CommandLine.access$1500(CommandLine.java:148)
	at picocli.CommandLine$RunLast.executeUserObjectOfLastSubcommandWithSameParent(CommandLine.java:2461)
	at picocli.CommandLine$RunLast.handle(CommandLine.java:2453)
	at picocli.CommandLine$RunLast.handle(CommandLine.java:2415)
	at picocli.CommandLine$AbstractParseResultHandler.execute(CommandLine.java:2273)
	at picocli.CommandLine$RunLast.execute(CommandLine.java:2417)
	at picocli.CommandLine.execute(CommandLine.java:2170)
	at lphybeast.LPhyBeastCMD.main(LPhyBeastCMD.java:89)
```


### LPhyBEAST failed by an improper installation

If the LPhy library folder is not in a correct path, you will see the following exceptions:

```java
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

### SLPhy or LPhyBEAST failed by "Access is denied"

On Windows system, "C:\Program Files" is usually a protected directory. For example, 

```bash
cd "C:\Program Files\lphystudio-1.4.3\tutorials"
"C:\Program Files\lphystudio-1.4.3\bin\slphy" h5n1.lphy
```

If you are working within a directory without write permissions, 
the program may encounter an error message like this:

```java
java.io.FileNotFoundException: h5n1_D_0.nexus (Access is denied)
        at java.base/java.io.FileOutputStream.open0(Native Method)
        at java.base/java.io.FileOutputStream.open(FileOutputStream.java:293)
        at java.base/java.io.FileOutputStream.<init>(FileOutputStream.java:235)
        at java.base/java.io.FileOutputStream.<init>(FileOutputStream.java:184)
        at java.base/java.io.PrintStream.<init>(PrintStream.java:332)
        at lphy@1.4.3/lphy.graphicalModel.logger.AlignmentFileLogger.logAlignment(AlignmentFileLogger.java:83)
        at lphy@1.4.3/lphy.graphicalModel.logger.AlignmentFileLogger.log(AlignmentFileLogger.java:38)
        at lphy@1.4.3/lphy.core.Sampler.sample(Sampler.java:51)
        at lphystudio@1.4.3/lphystudio.app.simulator.SLPhy.call(SLPhy.java:113)
        at lphystudio@1.4.3/lphystudio.app.simulator.SLPhy.call(SLPhy.java:32)
```

The simple solution is to copy the "examples" and "tutorials" folders with "data" 
into your "Documents" folder, and work in that location to avoid any permission issues.


### LPhyBEAST failed by Java version

If the `lphybeast -h` failed with the following error message about Java version:

```java
java.lang.UnsupportedClassVersionError: 
lphybeast/LPhyBEAST has been compiled by a more recent version 
of the Java Runtime (class file version 61.0), this version of 
the Java Runtime only recognizes class file versions up to 52.0
	at java.lang.ClassLoader.defineClass1(Native Method)
	at java.lang.ClassLoader.defineClass(ClassLoader.java:763)
	at java.security.SecureClassLoader.defineClass(SecureClassLoader.java:142)
	at java.net.URLClassLoader.defineClass(URLClassLoader.java:468)
```

The script lphybeast utilizes the BEAST 2 applauncher to run the LPhyBEAST application, 
which requires Zulu 17 with JavaFX bundled in BEAST 2.7.x.
More details are available in [beast2.org](https://www.beast2.org).


### LPhyBEAST failed with `java.lang.ClassNotFoundException`

If the `$BEAST` environment variable is not set correctly, the following error message might occur:

```java
Error: Could not find or load main class beast.pkgmgmt.launcher.AppLauncherLauncher
Caused by: java.lang.ClassNotFoundException: beast.pkgmgmt.launcher.AppLauncherLauncher
```

The `$BEAST` environment variable should point to the directory where BEAST 2 is installed (e.g. `/Applications/BEAST 2.7.7` on MacOS).
