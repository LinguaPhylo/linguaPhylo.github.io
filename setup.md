---
layout: page
title: Setup
permalink: /setup/
---

This page includes the instructions for two applications:

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

{% assign lphy_version = "1.0.0" %}

Go to [LPhy release page](https://github.com/LinguaPhylo/linguaPhylo/releases), 
and download the latest released version, for example, 
`LPhyStudio-{{ lphy_version }}.zip` at the time of writing. 
Unzip the compressed file, then you will see a folder containing
a jar file `lphy-studio-{{ lphy_version }}.jar` and other sub-folders
containing example scripts or libraries. 
This folder will be your `$LPHY_PATH`. 
You can copy or move the folder with everything to your working space.
The folder structure looks like:

```
LPHY_PATH
    ├── examples
    ├── lib
    │    ...
    │    ├── lphy-{{ lphy_version }}.jar
    │    ...    
    ├── lphy-studio-{{ lphy_version }}.jar
    ├── README.md
    └── tutorials
```

The following command line will launch LPhy studio,
where `-p` declares your module path including the LPhy studio jar 
and the sub-folder "lib" containing all required libraries. 
You can replace your own libraries folder to a different path. 
`-m` declares the module name and it should be always "lphystudio".

```bash
LPHY_PATH=~/WorkSpace/linguaPhylo/
cd $LPHY_PATH
java -p lib:lphy-studio-{{ lphy_version }}.jar -m lphystudio
```

If you are using any extensions, copy it into the "lib"" folder 
and then run this command to launch LPhy studio.

You can also give a LPhy script file name with its path. 
Here we use the relative script to load "RSV2.lphy":

```bash
java -p lib:lphy-studio-{{ lphy_version }}.jar -m lphystudio tutorials/RSV2.lphy
```

Please **note** both the module path and the LPhy script path are
the relative paths to your `$LPHY_PATH` folder.
But the working directory `user.dir` will be changed to the location of
the loaded script, here is the folder `$LPHY_PATH/tutorials`,
which is the parent folder of the relative path inside the LPhy script,
such as `readNexus(file="data/RSV2.nex", ...);`.
If you want to use a different setup,
please make sure every relative paths are defined correctly. 

If you are new to LPhy, we recommend you to read this 
[introduction](https://linguaphylo.github.io/about/),
before you continue on any tutorials. 


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

The `lphybeast` will appear in the list of available packages in `Package Manager`,
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

To complete this installation, you need to create the folder named exactly as
`lphy` under the `$BEAST_DIR` folder, and download the non-modular jar
`lphy-j8-{{ lphy_version }}.jar` and the script `lphybeast` into the `lphy` folder.

```
BEAST_DIR
    ├── bin
    ├── examples
    ├── images
    ├── lib
    │    ├── beast.jar
    │    ...    
    ├── lphy
    │    ├── lphybeast
    │    └── lphy-j8-{{ lphy_version }}.jar
    ├── templates
    ...
    └── VERSION HISTORY.txt
```

Eventually, we can start LPhyBEAST using the script `lphybeast`.
The bash script `lphybeast` will launch LPhyBEAST through another BEAST 2 
application called [applauncher](https://www.beast2.org/2019/09/26/command-line-tricks.html),
which is also distributed with BEAST 2 together.


## LPhyBEAST usage

Make sure you have `lphy-j8-{{ lphy_version }}.jar` and the script `lphybeast`
in the correct path. 
Now, we can run the following command line to show the usage, 
and also check if it is installed properly, 
where the `$BEAST_DIR` is the folder containing BEAST 2.

```bash
$BEAST_DIR/lphy/lphybeast -h
```

Then, try to create "RSV2.xml" from the tutorial script "RSV2.lphy":

```bash
cd $LPHY_PATH/tutorials/
$BEAST_DIR/lphy/lphybeast RSV2.lphy
```

Or use the absolute path and work from a different folder:

```bash
cd $MY_PATH
$BEAST_DIR/lphy/lphybeast $LPHY_PATH/tutorials/RSV2.lphy
```

**Note:** this script contains the relative path to load data, 
`D = readNexus(file="data/RSV2.nex", ...);`, 
which is always relative to the working directory.
Here is the folder where "RSV2.lphy" located. 
We recommend to use the absolute path in `readNexus` if the script is not shared.
Otherwise, please always check if the relative path is correct, 
before you generate the XML.   

To avoid the confusion and complexity of using the relative paths,
we provide `-wd` to define the working directory for all relative paths. 
You can organise everything in a folder, and use the following command below:

```bash
$BEAST_DIR/lphy/lphybeast -wd $LPHY_PATH/tutorials/ -l 15000000 -o RSV2long.xml RSV2.lphy
```

This also has two extra arguments: 
- `-l` changes the MCMC chain length (default to 1 million) in the XML;
- `-o` replaces the output file name (default to use the same file steam as the lphy input file).


Create 5 XML for simulations:
```bash
$BEAST_DIR/lphy/lphybeast -wd $LPHY_PATH/tutorials/ -r 5 RSV2.lphy
```

**Note:** please use `-wd` to simplify your paths according to 
your local folder structure, not make them more complex.
For example, if you use `-wd $LPHY_PATH  tutorials/RSV2.lphy` instead, 
then you have to update the corresponding line in the script to 
`readNexus(file="tutorials/data/RSV2.nex", ...);`.


### LPhyBEAST failed by an improper installation

If the lphy non-modular jar (e.g. `lphy-j8-{{ lphy_version }}.jar`) is not
in a correct path, you will see the following exceptions:

```
GenerativeDistribution : []
Functions : []
picocli.CommandLine$PicocliException: An unexpected exception from a static initializer : 
	at lphybeast.LPhyBEAST.toBEASTXML(Unknown Source)
	at lphybeast.LPhyBEAST.createXML(Unknown Source)
  ...
Caused by: java.lang.ExceptionInInitializerError
	at lphy.parser.SimulatorListenerImpl$SimulatorASTVisitor.visitMethodCall(SimulatorListenerImpl.java:723)
	... 
Caused by: java.lang.RuntimeException: LPhy core did not load properly using SPI mechanism !
	at lphy.LPhyExtensionFactory.registerExtensions(LPhyExtensionFactory.java:109)
	... 
Aug 27, 2021 12:00:42 PM lphybeast.LPhyBEAST main
SEVERE: LPhyBEAST does not exit normally !
```

The list of `GenerativeDistribution` and `Functions` implemented in the LPhy 
cannot be loaded properly according to the error message.
In the working case, the `[ ]` will contain the list of names of distributions or functions.


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