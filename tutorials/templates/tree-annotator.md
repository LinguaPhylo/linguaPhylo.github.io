
To summarize the trees logged during MCMC, we will use the [CCD methods](https://doi.org/10.1101/2024.02.20.581316) 
implemented in the program TreeAnnotator to create the maximum a posteriori (MAP) tree. 
The implementation of the conditional clade distribution (CCD) offers different parameterizations, 
such as CCD1, which is based on clade split frequencies, and CCD0, which is based on clade frequencies. 
The MAP tree topology represents the tree topology with the highest posterior probability, 
averaged over all branch lengths and substitution parameter values.

You need to install [CCD package](https://github.com/CompEvol/CCD) to make the options 
available in TreeAnnotator. 

Please follow these steps after launching TreeAnnotator:

1. Set 10% as the burn-in percentage;
2. Select "MAP (CCD0)" as the "Target tree type";
3. For "Node heights", choose "Mean heights";
4. Load the tree log file that BEAST 2 generated (it will end in ".trees" by default) 
   as "Input Tree File". For this tutorial, the tree log file is called {{ include.trees }}.
   If you select it from the file chooser, the parent path will automatically fill in and 
   "YOUR_PATH" in the screen shot will be that parent path.
5. Finally, for "Output File", copy and paste the input file path but replace 
   the {{ include.trees }} with {{ include.mcctree }}. 
   This will create the file containing the resulting MAP tree.

The image below shows a screenshot of TreeAnnotator with the necessary settings to 
create the summary tree. "YOUR_PATH" will be replaced to the corresponding path.

<figure class="image">
  <img src="{{ include.fig }}" alt="TreeAnnotator">
  <figcaption>Figure {{ include.fignum }}: A screenshot of
  TreeAnnotator showing how to create a summary tree from a posterior
  tree set.</figcaption>
</figure>

The setup described above will take the set of trees in the tree log file 
and summarize it with a single MAP tree using the CCD0 method.
Divergence times will reflect the mean ages of each node, 
and these times will be annotated with their 95% highest posterior density (HPD) intervals. 
TreeAnnotator will also display the posterior clade credibility of each node in the MAP tree. 
More details on summarizing trees can be found in
[beast2.org/summarizing-posterior-trees/](https://www.beast2.org/summarizing-posterior-trees/).

If you see any [negative branch lengths](https://www.beast2.org/summarizing-posterior-trees/) 
in the summarised tree, 
you can change the "Node heights" option to use "Common Ancestor heights".
If you're concerned about the differences between these two options, 
you can run both and compare the resulting trees.

Note that TreeAnnotator only parses a tree log file into an output text file, 
but the visualization has to be done with other programs (see next section).
