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

{% assign lphy_version = "1.3.*" %}

### LPhy studio installation

1. Go to the [LPhy release page](https://github.com/LinguaPhylo/linguaPhylo/releases), 
and download the [latest release](https://github.com/LinguaPhylo/linguaPhylo/releases/latest), e.g., `lphy-studio-{{ lphy_version }}.zip`. 

2. Unzip the compressed file, this will create a folder called `lphy-studio-{{ lphy_version }}`. 

This is the location of your LPhyStudio install. The `lphy-studio-{{ lphy_version }}` path will be your `$LPHY_PATH`. Its folder structure should look like:

```
LPHY_PATH
    ├── examples
    │    ├── data
    │    ...
    ├── lib
    │    ...
    │    ├── lphy-{{ lphy_version }}.jar
    │    ├── lphy-studio-{{ lphy_version }}.jar
    │    ...
    ├── LICENSE    
    ├── README.md
    ├── src
    └── tutorials
         ├── data
         ...
```

Example LPhy scripts are in the `examples` subdirectory, and libraries are in the `lib` subdirectory.

If you are using LPhyBEAST, we recommend you to copy or move the entire folder 
with everything under your BEAST 2.* folder, and rename it into `lphy`.
So you can skip the step installing LPhy during the LPhyBEAST installation. 


### Launching LPhy studio

To run LPhy studio use the commands below:
```bash
LPHY_PATH=~/WorkSpace/lphy-studio-{{lphy_version}}/
cd $LPHY_PATH
java -p lib -m lphystudio
```

(Optional) To use LPhy extensions, copy the extension jar file into the `lib` folder of your `$LPHY_PATH`.

To launch LPhy Studio with a script file use
```bash
java -p lib -m lphystudio tutorials/RSV2.lphy
```

Note that you can replace `tutorials/RSV2.lphy` with the path to another LPhy script file.

<!-- Move this to another tutorial or page? -->
__Please note__: the LPhy studio will set the working directory (also property `user.dir`) 
to the parent directory which the script sits inside.
For example, in the above command line, the working directory will change to 
the subfolder `tutorials` not the folder `$LPHY_PATH`.

This is to cooperate with any relative paths inside the LPhy script, 
such as `readNexus(file="data/RSV2.nex", ...);`, 
It is comparatively easy to organise all the LPhy scripts in a folder (e.g. tutorials/) 
and their required alignments (e.g. RSV2.nex) in the subfolder `data` under the folder.

If you are new to LPhy, we recommend reading this
[introduction](https://linguaphylo.github.io/about/),
before you try the tutorials. 


## LPhyBEAST installation

[LPhyBEAST](https://github.com/LinguaPhylo/LPhyBeast/releases) requires BEAST 2.6.7 or higher, 
and is installable as a [BEAST 2 package](https://www.beast2.org/managing-packages/) called lphybeast.

1. To install LPhyBEAST first start `Package Manager` by opening `BEAUti`, and from the menu select `File` => `Manage Packages`. 
2. Click on `Package repositories` to open the "BEAST 2 Package Repository Manager".
3. Click the `Add URL` button, add the URL "https://raw.githubusercontent.com/CompEvol/CBAN/master/packages-extra.xml", 
and click `OK`.

The packages-extra URL should now appear as shown below
<figure class="image">
  <a href="/images/PackagesExtra.png">
    <img src="/images/PackagesExtra.png" alt="PackagesExtra">
  </a>
  <figcaption>Figure 1: Adding packages-extra URL.</figcaption>
</figure>

{:start="4"}
4. Click the `Done` button.

5. Restart `Package Manager`.

6. The `lphybeast` package should now appear in the list of available packages.
Select `lphybeast` from the package list, then use `Install/Upgrade` to install.

Note: Installation may take few minutes to download and install. Please wait until a confirmation popup appears on the screen.

<figure class="image">
  <img src="/images/Installed.png" alt="Installed">
  <figcaption>Figure 2: Confirmation message for successful install of lphybeast.</figcaption>
</figure>

{:start="7"}
7. Restart `Package Manager` once more. Now `lphybeast` and dependent packages should appear as "installed". 

Alternatively, you can install it using command line following the [instruction](https://www.beast2.org/managing-packages/).

### Install LPhy libraries and download starting script 

The package `lphybeast` does not include LPhy, so we need to install LPhy libraries.

1. Download the LPhy studio from the [release page](https://github.com/LinguaPhylo/linguaPhylo/releases), 
such as `lphy-studio-{{ lphy_version }}.zip`. 

2. Unzip it under your `$BEAST_DIR` folder where you installed the BEAST 2.

<figure class="image">
  <a href="/images/LPhyLibFolder.png">
    <img src="/images/LPhyLibFolder.png" alt="LPhyLibFolder" style="width:700px;">
  </a>
  <figcaption>Figure 3: Set LPHY_LIB path.</figcaption>
</figure>  

{:start="3"}
3. Make sure there is __only one__ LPhy folder, such as `lphy-studio-{{ lphy_version }}`, inside your `$BEAST_DIR`.

4. Download the bash script `lphybeast` from 
[LPhyBEAST's repo](https://github.com/LinguaPhylo/LPhyBeast/blob/master/lphybeast/bin/lphybeast),
and put it into the `bin` folder under `$BEAST_DIR` with other scripts.


The final folder structure looks like:

```
BEAST_DIR
    ├── bin
    │    ...
    │    ├── lphybeast
    │    ...
    ├── examples
    ...
    ├── lib
    │    ├── beast.jar
    │    ...    
    ├── lphy-studio-{{ lphy_version }}
    │    ├── examples
    │    ├── lib
    │    │    ...
    │    │    └── lphy-{{ lphy_version }}.jar
    │    ...
    ├── templates
    ...
    └── VERSION HISTORY.txt
```

Eventually, we can start LPhyBEAST using the script `lphybeast`.
It will launch LPhyBEAST through another BEAST 2 application
called [applauncher](https://www.beast2.org/2019/09/26/command-line-tricks.html),
while adding the `$LPHY_LIB` folder into the classpath.


## LPhyBEAST usage

Make sure you have the script `lphybeast` ready and set `LPHY_LIB` path properly. 
Now, we can run the following command line to show the usage.

```bash
$BEAST_DIR/bin/lphybeast -h
```

Then, try to create "RSV2.xml" from the tutorial script "RSV2.lphy":

```bash
cd $LPHY_PATH/tutorials/
$BEAST_DIR/bin/lphybeast RSV2.lphy
```

Or use the absolute path and work from a different folder:

```bash
cd $MY_PATH
$BEAST_DIR/bin/lphybeast $LPHY_PATH/tutorials/RSV2.lphy
```

Create 5 XML for simulations:
```bash
$BEAST_DIR/bin/lphybeast -wd $LPHY_PATH/tutorials/ -r 5 RSV2.lphy
```

## Some conventions

1. If the input/output is a relative path, then concatenate `user.dir` to the front of the path.


2. Use `-wd` to set `user.dir`. But if `-wd` is not given, 
then `user.dir` will be set to the parent folder where the LPhy script sits inside.
For example:

```bash
$BEAST_DIR/bin/lphybeast -wd $LPHY_PATH/tutorials/ -l 15000000 -o RSV2long.xml RSV2.lphy
```

This also contains two extra arguments: 
- `-l` changes the MCMC chain length (default to 1 million) in the XML;
- `-o` replaces the output file name (default to use the same file steam as the lphy input file).

As this LPhy script uses the relative path to load data, 
`D = readNexus(file="data/RSV2.nex", ...);`, 
the `data` subfolder containing `RSV2.nex` has to be in the same folder where "RSV2.lphy" sits inside.

**Note:** please use `-wd` to simplify your input and output paths. 
Do not make them more complex, such as combining `-wd` with relative paths in either input or output.
For example, do not try `-wd $LPHY_PATH  tutorials/RSV2.lphy`, 
then you will mess up some relative paths inside the LPhy scripts, e.g. `readNexus`.


## If something goes wrong ...


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



