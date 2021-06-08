---
layout: page
title: Setup
permalink: /setup/
---

## Java 16

LPhy and LPhyBEAST are developed on Java 16. 
You can either install [Oracle JDK 16](https://www.oracle.com/java/technologies/javase-jdk16-downloads.html) 
or [OpenJDK 16](https://jdk.java.net/16/). Please make sure `JAVA_HOME` is setup properly.

Use the command line below to check your Java version:

```bash
java -version
```

## LPhy 

Go to [LPhy release page](https://github.com/LinguaPhylo/linguaPhylo/releases), 
download the latest released version (LPhy.v???.zip), and unzip the compressed file, 
then you will see a folder with same name (LPhy.v???). 
Finally, copy or move the folder with everything inside to your applications folder.

{% assign version = "0.0.4" %}

There should be a jar file named with version numbers (e.g. `LPhy.v{{ version }}.jar`) insider the folder.
You can either double-click the jar file, or use the following command line to start the LPhy Studio, 
which is a Java GUI to specify and visualise graphical models 
as well as simulate data from models defined in LPhy script.

```bash
LPHY_PATH = ~/WorkSpace/linguaPhylo/
cd $LPHY_PATH
java -jar LPhy.v{{ version }}.jar
```

You can also give a LPhy script file name with its absolute path. 
Here we use the script `RSV2.lphy` under the `tutorials` folder:

```bash
java -jar LPhy.v{{ version }}.jar $LPHY_PATH/tutorials/RSV2.lphy
```

Or work on the folder containing scripts:

```bash
cd $LPHY_PATH/tutorials/
java -jar $LPHY_PATH/LPhy.v{{ version }}.jar RSV2.lphy
```

The data is `$LPHY_PATH/tutorials/data/RSV2.nex`, which is loaded by a LPhy function
`readNexus(file="data/RSV2.nex", ...);` inside the script using the relative path.

If you are new to LPhy, we recommend you to read this [introduction](https://linguaphylo.github.io/about/) first, 
before you continue on any tutorials. 


## LPhyBEAST installation

[LPhyBEAST](https://github.com/LinguaPhylo/LPhyBeast/releases) is distributed as a [BEAST 2 package](https://www.beast2.org/managing-packages/),
you can use an application called `Package Manager`, which is distributed with BEAST 2 together.
Open `BEAUti`, and click the menu `File` => `Manage Packages`. 
The `Package Manager` will show all the available packages listed in alphabetical order.
Select `lphybeast` and click the `Install/Upgrade` button. 
The installation may take few minutes, since it is going to install all dependent packages as well, 
please wait until the dialog is poped up to confirm lphybeast installed successfully.

<figure class="image">
  <img src="/images/Installed.png" alt="Installed">
  <figcaption>Figure 1: The confirmation for lphybeast installed successfully.</figcaption>
</figure>
 

The `Package Manager` should show installed versions of lphybeast and its dependent packages as below. 

<figure class="image">
  <img src="/images/InstallLPhyBEAST.png" alt="Install LPhyBEAST">
  <figcaption>Figure 2: Package Manager shows installed packages.</figcaption>
</figure>

Alternatively, you can install it using the command line below, but please note the name of package is case-sensitive.

{% assign beastversion = "2.6.5" %}

```bash
# BEAST_DIR = "/Applications/BEAST{{ beastversion }}"
$BEAST_DIR/bin/packagemanager -add lphybeast 
```

Use the following command to check the installed packages in your local machine, 
and make sure the column `Installed Version` shows a version number not `NA`:

```bash
$BEAST_DIR/bin/packagemanager -list 
```

If you have installed LPhyBEAST previously, we recommend you remove the old version first,
using the command below, then install it.

```bash
$BEAST_DIR/bin/packagemanager -del lphybeast 
```


## LPhyBEAST usage

Though LPhyBEAST depends on LPhy, you will not find it in the list, because LPhy is not a BEAST 2 package. 
But it will be included in LPhyBEAST's libraries during the release. 
So you do not have to worry it as long as you install LPhyBEAST properly. 

To start LPhyBEAST, you can use BEAST 2 `applauncher`, which is also distributed with BEAST 2.
Here is some [details](https://www.beast2.org/2019/09/26/command-line-tricks.html) how to run it from the command line.

```bash
$BEAST_DIR/bin/applauncher LPhyBEAST $LPHY_PATH/tutorials/RSV2.lphy
```

Or work on the folder containing scripts:

```bash
cd $LPHY_PATH/tutorials/
$BEAST_DIR/bin/applauncher LPhyBEAST RSV2.lphy
```

**Note:** if your lphy script contains the relative path to load a file (e.g. alignment), 
e.g. `D = readNexus(file="data/RSV2.nex", ...);`, then that path will be relative to where the lphy file located. 
Please always check if your data path is correct, before you produce the XML.   
  

Alternatively, using `-wd`, you can work at another folder, but point out where the input and output are:

```bash
$BEAST_DIR/bin/applauncher LPhyBEAST -l 15000000 -wd $LPHY_PATH/tutorials/ -o RSV2long.xml RSV2.lphy
```

Using `-wd` can also allow you load lphy from a different path, 
but output XML file into the given folder (`$MY_XML_FOLDER`):

```bash
$BEAST_DIR/bin/applauncher LPhyBEAST -wd $MY_XML_FOLDER -l 15000000 $LPHY_PATH/tutorials/RSV2.lphy
```

Create 5 XML for simulations:
```bash
$BEAST_DIR/bin/applauncher LPhyBEAST -wd $LPHY_PATH/tutorials/ -r 5 RSV2.lphy
```

Please note: every time after loading a script file, LPhyBEAST (and LPhy Studio) will set the system environment variable `user.dir` to the folder containing this file. This folder will be used as the reference when the data path inside the scrips is a relative path. So, for a LPhy script, the relative path is always referring to the folder where it is. Then the data can be easily organized with the scripts together.
Please see the example scripts, such as `tutorials/RSV2.lphy` or `examples/fullDataExample.lphy`.

The usage can be seen by the command below:

```bash
$BEAST_DIR/bin/applauncher LPhyBEAST -h
```


### LPhyBEAST failed by Java version

If the `applauncher LPhyBEAST -h` failed with the following error message about Java version:

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
`unzip  ~/Downloads/LPhyBEAST.v{{ version }}.zip -d ~/.beast/2.6/lphybeast/`;

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