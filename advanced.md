---
layout: page
title: Advanced User Guide
permalink: /advanced/
---



### Running LPhy Studio via command line

To run LPhy studio use the commands:
```bash
LPHY_PATH=/yourpath/lphy-studio-{{lphy_version}}/
cd $LPHY_PATH
java -p lib -m lphystudio
```

### Using LPhy extensions
To use LPhy extensions, copy the extension jar file into the `lib` folder of your `$LPHY_PATH`.

Also see this page on [LPhy extensions](https://linguaphylo.github.io/extensions/).

To launch LPhy Studio with a script file use
```bash
java -p lib -m lphystudio tutorials/RSV2.lphy
```

Note that you can replace `tutorials/RSV2.lphy` with the path to another LPhy script file.

__Please note__: the LPhy studio will set the working directory (also property `user.dir`) 
to the parent directory which the script sits inside.
For example, in the above command line, the working directory will change to 
the subfolder `tutorials` not the folder `$LPHY_PATH`.

This is to cooperate with any relative paths inside the LPhy script, 
such as `readNexus(file="data/RSV2.nex", ...);`, 
It is comparatively easy to organise all the LPhy scripts in a folder (e.g. tutorials/) 
and their required alignments (e.g. RSV2.nex) in the subfolder `data` under the folder.


## LPhyBEAST command line options

The `lphybeast` script will launch LPhyBEAST using the 
BEAST 2 [applauncher](https://www.beast2.org/2019/09/26/command-line-tricks.html),
and add `$LPHY_LIB` into the classpath. 

1. When working with files located in different folders, 
   it is recommended to use the absolute path, 
   which provides the complete file or directory path on the file system:

```bash
cd $MY_PATH
$BEAST_PATH/bin/lphybeast $LPHY_PATH/tutorials/RSV2.lphy
```

__Please note__: the path should not contain any whitespaces. 
The LPhyBEAST launcher, which utilizes [picocli](https://picocli.info), 
automatically parses string arguments with whitespaces into arrays, 
even if the string is enclosed in single or double quotes. 
To avoid any parsing issues, ensure that your file paths do not include whitespaces. 

{:start="2"}
2. When dealing with relative paths for input/output, LPhyBEAST will concatenate `user.dir` 
   to the beginning of the path. 
   In case you want to explicitly set the `user.dir`, you can use the `-wd` option as follows.
   However, if you don't provide the `-wd` option, 
   the `user.dir` will be automatically set to the parent folder where the LPhy script is located.

```bash
$BEAST_DIR/bin/lphybeast -wd $LPHY_PATH/tutorials/ -l 15000000 -o RSV2long.xml RSV2.lphy
```

This also contains two extra arguments: 
- `-l` changes the MCMC chain length (default to 1 million) in the XML;
- `-o` replaces the output file name (default to use the same file steam as the lphy input file).

If a LPhy script uses the relative path to load data, 
e.g., `D = readNexus(file="data/RSV2.nex", ...);`, 
the `data` subfolder containing `RSV2.nex` has to be in the same folder where "RSV2.lphy" sits inside.

**Note:** please use `-wd` to simplify your input and output paths. 
Do not make them more complex, such as combining `-wd` with relative paths in either input or output.
For example, do not try `-wd $LPHY_PATH  tutorials/RSV2.lphy`, 
then you will mess up some relative paths inside the LPhy scripts, e.g. `readNexus`.
