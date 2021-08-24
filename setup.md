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

## LPhy Studio

LPhy studio is the GUI for LPhy language. 
From the version 1.0.0, the extension mechanism using the latest technology 
known as the Java Platform Module System (JPMS) is implemented. 
It works differently to the previous Java (1.8) mechanism. 
The [module system](https://openjdk.java.net/jeps/261) page from OpenJDK 
provides a full introduction to the technical details.
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

The following command line will launch LPhy studio,
where `-p` declares your module path including the LPhy studio jar 
and the sub-folder "lib" containing all required libraries. 
You can replace your own libraries folder to a different path. 
`-m` declares the module name and it should be always "lphystudio".

```bash
LPHY_PATH = ~/WorkSpace/linguaPhylo/
cd $LPHY_PATH
java -p lib:lphy-studio-{{ lphy_version }}.jar -m lphystudio
```

If you are using any extensions, copy it into the "lib"" folder 
and then run this command to launch LPhy studio.

You can also give a LPhy script file name with its path. 
Here we use the relative script to load `RSV2.lphy`:

```bash
java -p lib:lphy-studio-{{ lphy_version }}.jar -m lphystudio tutorials/RSV2.lphy
```

Please note both the module path and the LPhy script path are the relative paths,
as well as `readNexus(file="data/RSV2.nex", ...);` inside the LPhy script.
If you want to use the absolute path, please make sure every paths are defined correctly. 

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

{% assign beastversion = "2.6.6" %}

```bash
# BEAST_DIR = "/Applications/BEAST{{ beastversion }}"
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

The LPhy will be included in LPhyBEAST's libraries, as long as you install it successfully. 

## LPhyBEAST usage

To use the `lphybeast` package, you need to start it through BEAST 2 `applauncher`,
which is also distributed with BEAST 2 together.
Here is some [details](https://www.beast2.org/2019/09/26/command-line-tricks.html)
how to run it from the command line.

Now, we can run the following command line to show the usage, 
and also check if it is installed properly:

```bash
$BEAST_DIR/bin/applauncher lphybeast -h
```
where the `$BEAST_DIR` is the folder containing BEAST 2.

Then, try to create "RSV2.xml" from the tutorial script "RSV2.lphy":

```bash
cd $LPHY_PATH/tutorials/
$BEAST_DIR/bin/applauncher lphybeast RSV2.lphy
```

Or use the absolute path and work from a different folder:

```bash
cd $MY_PATH
$BEAST_DIR/bin/applauncher lphybeast $LPHY_PATH/tutorials/RSV2.lphy
```

**Note:** this script contains the relative path to load data, 
`D = readNexus(file="data/RSV2.nex", ...);`, 
which is always relative to the working directory.
Here is the folder where "RSV2.lphy" located. 
We recommend to change the absolute path in `readNexus` if the script is not shared.
Otherwise, please always check if the relative path is correct, 
before you generate the XML.   

To avoid the confusion and complexity of using the relative paths,
we provide `-wd` to define the working directory for all relative paths. 
You can organise everything in a folder, and use the following command below:

```bash
$BEAST_DIR/bin/applauncher lphybeast -wd $LPHY_PATH/tutorials/ -l 15000000 -o RSV2long.xml RSV2.lphy
```

This also has two extra arguments: 
- `-l` changes the MCMC chain length (default to 1 million) in the XML;
- `-o` replaces the output file name (default to use the same file steam as the lphy input file).


Create 5 XML for simulations:
```bash
$BEAST_DIR/bin/applauncher lphybeast -wd $LPHY_PATH/tutorials/ -r 5 RSV2.lphy
```

Please note: every time after loading a script file, 
LPhyBEAST (and LPhy Studio) will set the system environment variable `user.dir` 
to the folder containing this file. 
This folder will be used as the reference when the data path inside the scrips is a relative path. 
So, for a LPhy script, the relative path is always referring to the folder where it is. 
Then the data can be easily organized with the scripts together.
Please see the example scripts, such as `tutorials/RSV2.lphy` or `examples/fullDataExample.lphy`.



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