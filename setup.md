---
layout: page
title: User Manual
permalink: /setup/
---

This page includes the user manuals for two applications:

1. LPhy studio - the GUI for LPhy language

2. LPhyBEAST - a BEAST 2 package that takes a LPhy script and produces a BEAST 2 XML file.


## Java 17

LPhy and LPhyBEAST are developed on Java 17. We recommend you install [OpenJDK 17](https://jdk.java.net/17/).
Please use the command line below to check your Java version:

```bash
java -version
```

## LPhy Studio

{% assign lphy_version = "1.2.0" %}

Go to [LPhy release page](https://github.com/LinguaPhylo/linguaPhylo/releases), 
and download the latest released version, such as `lphy-studio-{{ lphy_version }}.zip`. 
Unzip the compressed file, then you will see files, e.g. README and LICENSE, 
and several subfolders containing LPhy example scripts or libraries. 
This folder will be your `$LPHY_PATH`, and its folder structure should look like:

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

We recommend you can copy or move the entire folder with everything under your BEAST 2.* folder,
and rename it into `lphy`. So you can skip the step installing LPhy during the LPhyBEAST installation. 


### Launching LPhy studio

The following command line will launch LPhy studio,
where `-p` declares your module path the sub-folder "lib" 
which contains all required libraries (jar files). 
If necessary, you can replace the module path to your own library path, 
or add extra paths separated by colon ':'. 
The second option `-m` declares the module name and it should be always "lphystudio".

```bash
LPHY_PATH=~/WorkSpace/linguaPhylo/
cd $LPHY_PATH
java -p lib -m lphystudio
```

If you are using any extensions, copy it into the "lib" folder, 
and then run this command to launch LPhy studio.

You can also provide a LPhy script file name with its path. 
Here is an example that we use the relative script to load "RSV2.lphy":

```bash
java -p lib -m lphystudio tutorials/RSV2.lphy
```

__Please note__: the LPhy studio will set the working directory (also property `user.dir`) 
to the parent directory which the script sits inside.
For example, in the above command line, the working directory will change to 
the subfolder `tutorials` not the folder `$LPHY_PATH`.

This is to cooperate with any relative paths inside the LPhy script, 
such as `readNexus(file="data/RSV2.nex", ...);`, 
It is comparatively easy to organise all the LPhy scripts in a folder (e.g. tutorials/) 
and their required alignments (e.g. RSV2.nex) in the subfolder `data` under the folder.

If you are new to LPhy, we recommend you to read this 
[introduction](https://linguaphylo.github.io/about/),
before you continue on any tutorials. 


## LPhyBEAST installation

[LPhyBEAST](https://github.com/LinguaPhylo/LPhyBeast/releases) depends on BEAST 2.6.6 or higher version, 
and is distributed as a [BEAST 2 package](https://www.beast2.org/managing-packages/) named as `lphybeast`.
You can install it using another application called `Package Manager` also distributed
with BEAST 2 together.
Open `BEAUti`, and click the menu `File` => `Manage Packages`. 

However, `Package Manager` will not show `lphybeast` by default, so you need to
add the extra repository link "https://raw.githubusercontent.com/CompEvol/CBAN/master/packages-extra.xml"
to the `Package Manager`.
To do so, click the button `Package repositories` to open the dialog 
"BEAST 2 Package Repository Manager", and click the button `Add URL` to fill in
that extra repository link and click `OK`.
You will see the link is appeared in the dialog as shown in the screen shot below.
Remember to click the button `Done` to complete.

<figure class="image">
  <a href="/images/PackagesExtra.png">
    <img src="/images/PackagesExtra.png" alt="PackagesExtra">
  </a>
  <figcaption>Figure 1: Adding the extra package repository link.</figcaption>
</figure>

Restart `Package Manager`. If you add the extra repository correctly, 
the `lphybeast` will appear in the list of available packages,
which are sorted by alphabetical orders. 
Select it and click the `Install/Upgrade` button. 
The installation may take few minutes, since it is going to install all dependent packages as well, 
please wait until the dialog is popped up to confirm `lphybeast` installed successfully.

<figure class="image">
  <img src="/images/Installed.png" alt="Installed">
  <figcaption>Figure 2: The confirmation for lphybeast installed successfully.</figcaption>
</figure>
 
Restart the `Package Manager`, `lphybeast` should show its installed version
as well as its dependent packages. 

Alternatively, you can install it using the command line below, 
but please note the name of package is case-sensitive.

{% assign beastversion = "2.6.6" %}

```bash
# BEAST_DIR="/Applications/BEAST{{ beastversion }}"
$BEAST_DIR/bin/packagemanager -add lphybeast 
```

Use the following command to check the installed packages in your local machine, 
and make sure the column `Installed Version` shows a version number not `NA`:

```bash
$BEAST_DIR/bin/packagemanager -list 
```

If you have installed lphybeast previously, we recommend you remove the old version first,
using the command below, then install it.

```bash
$BEAST_DIR/bin/packagemanager -del lphybeast 
```

### Install LPhy libraries and download launcher 

The package `lphybeast` does not include LPhy, so we need to install LPhy libraries.
First, download the LPhy studio from the [release page](https://github.com/LinguaPhylo/linguaPhylo/releases), 
such as `lphy-studio-{{ lphy_version }}.zip`. 
Then unzip it under your `$BEAST_DIR` folder where you installed the BEAST 2.
The folder `lphy-studio-{{ lphy_version }}` should appear inside your `$BEAST_DIR`.
In the end, rename this folder into `lphy`. 

<figure class="image">
  <a href="/images/LPhyLibFolder.png">
    <img src="/images/LPhyLibFolder.png" alt="LPhyLibFolder" style="width:350px;">
  </a>
  <figcaption>Figure 3: Set LPHY_LIB path.</figcaption>
</figure>  

Secondly, we need to use the script `lphybeast` to launch LPhyBEAST.
Download the bash script `lphybeast` from 
[LPhyBEAST's repo](https://github.com/LinguaPhylo/LPhyBeast/blob/master/lphybeast/bin/lphybeast),
and put it into the `bin` folder under `$BEAST_DIR` with other scripts.
It will launch LPhyBEAST through another BEAST 2 
application called [applauncher](https://www.beast2.org/2019/09/26/command-line-tricks.html),
while adding the `$LPHY_LIB` folder into the classpath.

Here, you may double-check whether your `$LPHY_LIB` in the script is same as 
the subfolder `lib` containing LPhy libraries, namely `LPHY_LIB="$BEAST_DIR/lphy/lib"`.

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
    ├── lphy
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

### Conventions

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



