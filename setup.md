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

There should be a jar file named with version numbers (e.g. `LPhy.v0.0.2.jar`) insider the folder.
You can either double-click the jar file, or use the following command line to start the LPhy Studio, 
which is a Java GUI to specify and visualise graphical models 
as well as simulate data from models defined in LPhy script.

```bash
java -jar LPhy.v0.0.2.jar
```

You can also give a LPhy script file name:

```bash
java -jar LPhy.v0.0.2.jar tutorials/RSV2.lphy
```


## LPhyBEAST

[LPhyBEAST](https://github.com/LinguaPhylo/LPhyBeast/releases) is distributed as a [BEAST 2 package](https://www.beast2.org/managing-packages/),
you can use an application called `Package Manager`, which is distributed with BEAST 2 together,
to install it and its dependent packages as below. 
Please note the name of package is case-sensitive.

```bash
# BEAST_DIR = "/Applications/BEAST2.6.3"
$BEAST_DIR/bin/packagemanager -add lphybeast 
```

Use the following command to check the installed packages in your local machine, 
and make sure the column `Installed Version` shows a version number not `NA`:

```bash
$BEAST_DIR/bin/packagemanager -list 
```

Though LPhyBEAST depends on LPhy, you will not find it in the list, because LPhy is not a BEAST 2 package. 
But it will be included in LPhyBEAST's libraries during the release. 
So you do not have to worry it as long as you install LPhyBEAST properly. 

To start LPhyBEAST, you can use BEAST 2 `applauncher`, which is also distributed with BEAST 2.
Here is some [details](https://www.beast2.org/2019/09/26/command-line-tricks.html) how to run it from the command line.

```bash
$BEAST_DIR/bin/applauncher LPhyBEAST tutorials/RSV2.lphy
```

The usage is available by the command below:

```bash
$BEAST_DIR/bin/applauncher LPhyBEAST -h
```


### Manual installation

The current version of `Package Manager` may download a corrupted zip file if it is big (~20MB),
due to the GitHub issue.

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
`unzip  ~/Downloads/LPhyBEAST.v0.0.2.zip -d ~/.beast/2.6/lphybeast/`;

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

### LPhyBEAST failed by Java version

If the `applauncher LPhyBEAST -h` failed with the following error message about Java version:

```
java.lang.UnsupportedClassVersionError: lphybeast/LPhyBEAST has been compiled by a more recent version of the Java Runtime (class file version 60.0), this version of the Java Runtime only recognizes class file versions up to 52.0
	at java.lang.ClassLoader.defineClass1(Native Method)
	at java.lang.ClassLoader.defineClass(ClassLoader.java:763)
	at java.security.SecureClassLoader.defineClass(SecureClassLoader.java:142)
	at java.net.URLClassLoader.defineClass(URLClassLoader.java:468)
```

First, check if your local Java is 16 using `java -version`. 
If yes, you need to download BEAST 2 without JRE, because with JRE, 
`applauncher` will be forced to use the provided JRE in BEAST 2 which currently is 1.8.


