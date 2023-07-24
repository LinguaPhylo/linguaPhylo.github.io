
To summarize the trees from the BEAST 2 analysis, follow these steps:

To summarize the trees logged during MCMC and create a maximum clade credibility (MCC) tree, 
launch the program TreeAnnotator and follow these steps:

1. Set 10% as the burn-in percentage;
2. Select "Maximum clade credibility tree" as the "Target tree type";
3. For "Node heights", choose "Mean heights";
4. Load the tree log file that BEAST 2 generated (it will end in ".trees" by default) 
   as "Input Tree File". For this tutorial, the tree log file is called {{ include.trees }}.
   If you select it from the file chooser, the parent path will automatically fill in and 
   "YOUR_PATH" in the screen shot will be that parent path.
5. Finally, for "Output File", copy and paste the input file path but replace 
   the {{ include.trees }} with {{ include.mcctree }}. 
   This will create the file containing the resulting maximum clade credibility tree.

The image below shows a screenshot of TreeAnnotator with the necessary settings to 
create the summary tree. "YOUR_PATH" will be replaced to the corresponding path.

<figure class="image">
  <img src="{{ include.fig }}" alt="TreeAnnotator">
  <figcaption>Figure {{ include.fignum }}: A screenshot of
  TreeAnnotator showing how to create a summary tree from a posterior
  tree set.</figcaption>
</figure>

The setup described above will take the set of trees in the tree log file 
and summarize it with a single MCC tree. 
The MCC tree is the tree that has the largest clade probability product across all nodes. 
Divergence times will reflect the mean ages of each node, 
and these times will be annotated with their 95% highest posterior density (HPD) intervals. 
TreeAnnotator will also display the posterior clade credibility of each node in the MCC tree. 
More details on summarizing trees can be found in
[beast2.org/summarizing-posterior-trees/](https://www.beast2.org/summarizing-posterior-trees/).

Note that TreeAnnotator only parses a tree log file into an output text file, 
but the visualization has to be done with other programs (see next section).
