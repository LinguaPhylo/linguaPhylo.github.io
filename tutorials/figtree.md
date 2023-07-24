---
layout: page
title: Launch FigTree v1.4.4 in Mac
author: 'Walter Xie'
permalink: /tutorials/figtree/
---

There is a bug to launch FigTree v1.4.4 using application bundle in Mac, 
but you can follow the instruction below to start it from the terminal:

1. Download FigTree v1.4.4, and install it by copying and paste all folders and files 
   inside the .dmg into a new folder (e.g., FigTree1.4.4) in your `Applications` directory;
2. Create a new subfolder named `bin` inside the `FigTree1.4.4` folder;
3. Download the [figtree](https://linguaphylo.github.io/tutorials/figtree/figtree) script 
   and save it into the `bin` subfolder;
4. Give the `figtree` script executable permission using the command `chmod u+x figtree` in the terminal.

After completing these steps, your folder structure should look like this:

<figure class="image">
  <a href="../figtree/figtree.png" target="_blank">
  <img src="../figtree/figtree.png" alt="FigTree"></a>
  <figcaption>Figure 1: the folder structure.</figcaption>
</figure>

To launch FigTree from the terminal, you can use the following command:

```bash
/Applications/FigTree1.4.4/bin/figtree
```

