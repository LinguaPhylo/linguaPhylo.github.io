---
layout: page
title: User Manual
permalink: /setup/
---

This page includes the user manuals for two applications:

1. LPhy studio - the GUI for LPhy language

2. LPhyBEAST - a BEAST 2 package that takes a LPhy script and produces a BEAST 2 XML file.


## Java 16

LPhy and LPhyBEAST are developed on Java 16. 
You can either install [Oracle JDK 16](https://www.oracle.com/java/technologies/javase-jdk16-downloads.html) 
or [OpenJDK 16](https://jdk.java.net/16/). Please make sure `JAVA_HOME` is setup properly.

Use the command line below to check your Java version:

```bash
java -version
```

## LPhy Studio

From the version 1.0.0, an extension mechanism is implemented 
using the latest technologies known as 
the [Service Provider Interface (SPI)](https://www.baeldung.com/java-spi) and
the [Java Platform Module System (JPMS)](https://openjdk.java.net/jeps/261). 
It works differently to the Java ($\leq$1.8) non-modular mechanism. 

If you are interested in our design, please look at this [post](https://linguaphylo.github.io/programming/2021/07/19/lphy-extension.html).

{% assign lphy_version = "1.1.0" %}

Go to [LPhy release page](https://github.com/LinguaPhylo/linguaPhylo/releases), 
and download the latest released version, for example, 
`lphy-studio-{{ lphy_version }}.zip` at the time of writing. 
Unzip the compressed file, then you will see files, e.g. README and LICENSE, 
and several subfolders containing LPhy example scripts or libraries. 
This folder will be your `$LPHY_PATH`. 
You can copy or move the folder with everything to your working space.
The folder structure looks like:

```
LPHY_PATH
    ├── examples
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

If you are new to LPhy, we recommend you to read this 
[introduction](https://linguaphylo.github.io/about/),
before you continue on any tutorials. 

### Relative file path

Please **note**: in above command line, the LPhy input file path is 
the relative paths to your current folder `$LPHY_PATH`.
In order to cooperate with any relative paths inside the LPhy script, 
such as `readNexus(file="data/RSV2.nex", ...);`, the LPhy studio will 
set the property `user.dir` to the path where the script is.
It is comparatively easy to organise all the LPhy scripts in a folder (e.g. tutorials/) 
and their required alignments (e.g. RSV2.nex) in the subfolder `data` under the folder.
If you want to use a different setup,
please make sure every relative paths are defined correctly. 


## LPhyBEAST installation

[LPhyBEAST](https://github.com/LinguaPhylo/LPhyBeast/releases) is distributed
as a [BEAST 2 package](https://www.beast2.org/managing-packages/) named as `lphybeast`.
You can install it using another application called `Package Manager` distributed
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

{% assign beastversion = "2.6.x" %}

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

### LPhy non-modular jar 

Unfortunately, BEAST 2.6.x is not using the Java module system.
To compromise with non-modular applications, we separately release 
a non-modular jar for LPhy but using META-INF to trigger SPI. 
This jar also includes all required libraries from LPhy.

To complete this installation, you need to create the folder named exactly as
`lphy` under the `$BEAST_DIR` folder, and download the non-modular jar
`lphy-{{ lphy_version }}-all.jar` from LPhy's Github
[release](https://github.com/LinguaPhylo/linguaPhylo/releases) page into the `lphy` folder. 
Secondly, download the script `lphybeast` from 
[LPhyBEAST's repo](https://github.com/LinguaPhylo/LPhyBeast/blob/master/lphybeast/bin/lphybeast),
and put it into the `bin` folder under `$BEAST_DIR` with other scripts.


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
    │    └── lphy-{{ lphy_version }}-all.jar
    ├── templates
    ...
    └── VERSION HISTORY.txt
```

Eventually, we can start LPhyBEAST using the script `lphybeast`.
The bash script `lphybeast` will launch LPhyBEAST through another BEAST 2 
application called [applauncher](https://www.beast2.org/2019/09/26/command-line-tricks.html),
but add the `lphy` folder into the classpath.


## LPhyBEAST usage

Make sure you have `lphy-{{ lphy_version }}-all.jar` in the correct path
as well as the script `lphybeast`. 
Now, we can run the following command line to show the usage, 
and also check if it is installed properly, 
where the `$BEAST_DIR` is the folder containing BEAST 2.

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

### Relative file path

1. If the input/output is a relative path, then concatenate `user.dir` to the front of the path.


2. Use `-wd` to set `user.dir`. But if `-wd` is **not** given, 
the `user.dir` will be set to the path where the LPhy script is.


As it is explained in the previous section, this script uses the relative path to load data, 
`D = readNexus(file="data/RSV2.nex", ...);`. 
So the `data` subfolder has to be under the folder where "RSV2.lphy" is.

Alternatively, you can use `-wd` to set the working directory, such as:

```bash
$BEAST_DIR/bin/lphybeast -wd $LPHY_PATH/tutorials/ -l 15000000 -o RSV2long.xml RSV2.lphy
```

This contains two extra arguments: 
- `-l` changes the MCMC chain length (default to 1 million) in the XML;
- `-o` replaces the output file name (default to use the same file steam as the lphy input file).

**Note:** please use `-wd` to simplify your paths according to 
your local folder structure, not make them more complex.
For example, if you use `-wd $LPHY_PATH  tutorials/RSV2.lphy` instead, 
then you have to update the corresponding line in the script to 
`readNexus(file="tutorials/data/RSV2.nex", ...);`.


### IOException

The most cases are caused the inconsistent relative path between the input file 
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

If the lphy non-modular jar (e.g. `lphy-{{ lphy_version }}-all.jar`) is not
in a correct path, you will see the following exceptions:

```
java.lang.NoClassDefFoundError: lphy/core/LPhyParser
	at java.base/java.lang.Class.getDeclaredMethods0(Native Method)
	at java.base/java.lang.Class.privateGetDeclaredMethods(Class.java:3334)
	at java.base/java.lang.Class.getMethodsRecursive(Class.java:3475)
	at java.base/java.lang.Class.getMethod0(Class.java:3461)
	at java.base/java.lang.Class.getMethod(Class.java:2193)
	at beast.app.tools.AppLauncher.runAppFromCMD(Unknown Source)
	at beast.app.tools.AppLauncher.main(Unknown Source)
	at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:78)
	at java.base/jdk.internal.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	at java.base/java.lang.reflect.Method.invoke(Method.java:567)
	at beast.app.beastapp.BeastLauncher.run(Unknown Source)
	at beast.app.tools.AppLauncherLauncher.main(Unknown Source)
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
of the Java Runtime (class file version 60.0), this version of 
the Java Runtime only recognizes class file versions up to 52.0
	at java.lang.ClassLoader.defineClass1(Native Method)
	at java.lang.ClassLoader.defineClass(ClassLoader.java:763)
	at java.security.SecureClassLoader.defineClass(SecureClassLoader.java:142)
	at java.net.URLClassLoader.defineClass(URLClassLoader.java:468)
```

First, check if your local Java is 16 using `java -version`. 
If yes, you need to download BEAST 2 without JRE, because with JRE, 
`applauncher` will be forced to use the provided JRE in BEAST 2 which currently is 1.8.



### Manual installation

The `Package Manager` version 2.6.3 has a size-limit for downloading files. 
LPhyBEAST package is over that limit, so the zip file will be corrupted.
This issue has been solved at the higher version > 2.6.3.

If you are getting the following error message, when you install `lphybeast` package:

```
java.util.zip.ZipException: error in opening zip file
	at java.util.zip.ZipFile.open(Native Method)
	at java.util.zip.ZipFile.<init>(ZipFile.java:225)
	at java.util.zip.ZipFile.<init>(ZipFile.java:155)
	at beast.util.PackageManager.doUnzip(Unknown Source)
	at beast.util.PackageManager.installPackages(Unknown Source)
	at beast.util.PackageManager.main(Unknown Source)
```

then please install it manually following the steps below:

1. Go to the [LPhyBEAST release page](https://github.com/LinguaPhylo/LPhyBeast/releases)
download the latest version (LPhyBEAST.v???.zip);

2. Locate your local [BEAST 2 packages installation directories](https://www.beast2.org/managing-packages/) 
and delete everything (corrupted zip file) under the `lphybeast` folder.
If it does not exist, then create the sub-directory `lphybeast` under the folder containing all packages;

3. Unzip the compressed LPhyBEAST.v???.zip file to the BEAST 2 package `lphybeast` folder. 
The example command line in Linux is 
`unzip  ~/Downloads/LPhyBEAST.v???.zip -d ~/.beast/2.6/lphybeast/`;

4. Check if there is the `lib` sub-folder under the `lphybeast` folder and if it contains any .jar files, 
and then run `packagemanager -list` to ensure it is installed;

5. The dependent BEAST 2 packages are list in the release page. Make sure all of them are installed. 

__Tips:__ you can run `packagemanager -add lphybeast` first to install all dependent packages, 
and follow the above steps to re-install `lphybeast` package manually.
Then run `applauncher LPhyBEAST -h`, if any dependent packages are missing, there will be a pop-up error message to show what they are one by one. You would therefore install them manually following the above steps.


More details about [managing BEAST 2 packages](https://www.beast2.org/managing-packages/) are available.

If the LPhyBEAST and its dependencies are installed properly, the command below will print the expected usage information: 

```bash
$BEAST_DIR/bin/applauncher LPhyBEAST -h
```