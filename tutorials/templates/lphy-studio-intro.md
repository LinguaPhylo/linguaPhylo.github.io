There are two methods for constructing models using LPhy scripts:

1. Write valid LPhy scripts using any text editor and save them in a file. 
   Then, load the file into LPhy Studio to visualise the model.

2. Alternatively, you can input LPhy script lines one at a time directly 
   into the console located at the bottom of LPhy Studio.

In this tutorial, we will proceed with scripts using the console, 
which allows you to create and work with LPhy models interactively.

To get started, launch LPhy Studio, and you will find the tabs labeled "data" and "model" 
near the bottom of the interface.
Two distinct code blocks are used to differentiate between the part of the script 
describing the data (the `data` block), and part describing the model (the `model` block). 
If you are not familiar with LPhy language, we recommend reading the 
[language features](https://linguaphylo.github.io/features/) before getting started.

Before entering or copying the data block scripts into the console, 
make sure the tab is set to `data`. By default, the tab is set to `model`. 
Similarly, when you intend to type or copy the model block scripts, 
ensure that the tab is switched to `model`. 
This will help prevent any accidental errors or confusion while working with LPhy Studio.

Please be aware that when using the console, 
you do not need to write the `data` and `model` keywords enclosed by curly braces.  

Now, simply type or copy and paste the provided LPhy script below into the console, 
executing each line one at a time by pressing the "return" or "enter" key on your keyboard 
after entering each line.

__Please note:__ the file path in the 2nd line of the LPhy script below uses the relative path,
which assumes its parent path is the working directory. 
This will be not the correct path to access the data, when you just launch the studio.
So, to avoid the error, we recommend you replace the relative path into the absolute path
of that alignment file. For example,    

```
D = readNexus(file="/Applications/BEAST 2.7.5/lphystudio-1.4.3/tutorials/data/H5N1.nex", options=options);
``` 

The corresponding components of the probabilistic graphical model will be added into 
the visualisation panel.
By clicking on the graphical components, you can view their current values 
displayed in the right-side panel titled `Current`.
Analyze the model utilized in this analysis and provide your own description of 
its components and parameters. 
