---
layout: page
title: Advanced User Guide
permalink: /advanced/
---

### Relative paths

The LPhy studio will set the working directory (also property `user.dir`) 
to the parent directory which the script sits inside.

This should cooperate with any relative paths inside the LPhy script, 
such as `readNexus(file="data/RSV2.nex", ...);`, 
It is comparatively easy to organise all the LPhy scripts in a folder (e.g. tutorials/) 
and their required alignments (e.g. RSV2.nex) in the subfolder `data` under the folder.

We recommend you to use absolute path if you can.

### Using LPhy extensions

To install LPhy extensions, download the extension .jar files you need. 
Then, copy these files into the `lib` subfolder of your LPhy installation directory 
(i.e., `$LPHY_PATH`). Once the .jar file are placed in the LPhy `lib` folder, 
the will automatically register the extensions, making it available for use within LPhy.

Here is the folder structure after the LPhy extension, Phylonco, is installed.

<figure class="image">
  <a href="/images/LPhyLibPhylonco.png" target="_blank">
  <img src="/images/LPhyLibPhylonco.png" alt="LPhyLibPhylonco"></a>
  <figcaption>Figure 1: LPhy extension, Phylonco.</figcaption>
</figure>

Also see this page on [LPhy extensions](https://linguaphylo.github.io/extensions/).


## LPhyBEAST command line options

The `lphybeast` script will launch LPhyBEAST using the 
BEAST 2 [applauncher](https://www.beast2.org/2019/09/26/command-line-tricks.html).
It requires `$LPHY_LIB` to load all LPhy's libraries. 

1. When dealing with files situated in various directories, 
   it is advisable to employ the absolute path. 
   This method offers the entire path of the file or folder on the file system, 
   ensuring accurate referencing and access:

```bash
cd $MY_PATH
$BEAST_PATH/bin/lphybeast $LPHY_PATH/tutorials/RSV2.lphy
```

__Please note__: In case the path contains whitespaces, 
it must be enclosed within quotation marks to ensure that the whitespace is interpreted 
correctly by [picocli](https://picocli.info). 
This will help avoid any issues related to file path parsing.


{:start="2"}
2. When dealing with relative paths for input/output, LPhyBEAST will automatically append `user.dir` 
   to the beginning of the path. 
   If you wish to explicitly define the `user.dir` from the LPhyBEAST command line, 
   you can use the `-wd` option as shown below.
   However, if you omit the `-wd` option, 
   the `user.dir` will be automatically set to the parent folder where the input LPhy script is located.

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
