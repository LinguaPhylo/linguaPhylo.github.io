
LPhy Studio implements a GUI for users to specify and visualize
probabilistic graphical models, as well as for simulating data 
under those models.
These tasks are executed according to an LPhy script the user types
(or loads) on LPhy Studio's interactive terminal.
If you are not familiar with LPhy language, we recommend reading the 
[language features](https://linguaphylo.github.io/features/) before getting started.

You can input a script into LPhy Studio either by using the `File` menu 
or by directly typing or pasting the script code into the console in LPhy Studio.
Please note if you are working in the console, 
you __do not__ need to add `data` and `model` keywords and curly brackets to define the code blocks.
We are supposed to add the lines without the `data {  }` and `model {  }` to the command line console 
at the bottom of the window, where the `data` and `model` tabs in the GUI are used to specify 
which block we are working on.

Below, we will build an LPhy script in two parts, the `data` and
the `model` blocks.
