---
layout: page
title: Tech Help for LPhyBEAST workshop
author: 'Walter Xie'
permalink: /tutorials/tech-help/
---

Welcome to the "Tech Help" for LPhyBEAST workshop, 
a helpful resource designed to assist you in setting up and launching 
multiple required software packages released from different organizations, 
some are tailored to three major operating systems. 
In this page, we provide some solutions to help you,
including to solve the unexpected issues with certain third-party software tools.


## FigTree v1.4.4 bug to launch in Mac

There is a bug to launch FigTree v1.4.4 using application bundle in Mac, 
but you can follow the instruction below to start it from the terminal:

1. Download FigTree v1.4.4, and install it by copying and paste all folders and files 
   inside the .dmg into a new folder (e.g., FigTree1.4.4) in your `Applications` directory;
2. Create a new subfolder named `bin` inside the `FigTree1.4.4` folder;
3. Download the [figtree](https://linguaphylo.github.io/tutorials/tech-rescue/figtree) script 
   and save it into the `bin` subfolder;
4. Give the `figtree` script executable permission using the command `chmod u+x figtree` in the terminal.

After completing these steps, your folder structure should look like this:

<figure class="image">
  <a href="figtree.png" target="_blank">
  <img src="figtree.png" alt="FigTree"></a>
  <figcaption>Figure 1: the folder structure.</figcaption>
</figure>

To launch FigTree from the terminal, you can use the following command:

```bash
/Applications/FigTree1.4.4/bin/figtree
```

## Switch the Java version

Some tools may only work for Java 1.8, such as `spread`. 
If you have multiple versions of Java installed on your Linux or Mac,
you can use the following commands in the terminal:

```bash
# list all Java versions
/usr/libexec/java_home -V

# switch to Java 1.8
export JAVA_HOME=`/usr/libexec/java_home -v 1.8`
```

See also: 

- [Set JAVA_HOME on Windows 7, 8, 10, Mac OS X, Linux](https://www.baeldung.com/java-home-on-windows-7-8-10-mac-os-x-linux)

For Windows, the links below are helpful:

- [How to Change Java Versions in Windows (Sven Woltmann)](https://www.happycoders.eu/java/how-to-switch-multiple-java-versions-windows/)

- [How do I enable the latest Java version (java.com)](https://www.java.com/en/download/help/update_runtime_settings.html)


## Obtaining the valid file paths in the terminal

If you're not familiar with inputting valid paths in the command line, 
you can use the “Finder” (Mac) or “File Explorer” (Windows) to navigate to the folder 
containing the required files. 
Then, simply drag and drop the file or folder into the terminal. 
The full path will automatically appear in the command line, 
making it easier to proceed with your commands. 
This method ensures you obtain the correct file paths effortlessly without the need to manually type them.

In the Mac, Linux, or Windows command prompt, you can use auto-complete to assist 
with file and folder names or command names.
As you type a file or folder or command name, pressing the `Tab` key will automatically complete 
the name if there's a match. 
If there are multiple matches, pressing `Tab` twice will show all the options.


