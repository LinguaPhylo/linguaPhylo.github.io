
Because of how peculiar and discrete tree space is, it is a bit harder
to summarize and visualize the posterior distribution over
phylogenetic trees, as compared to the mean molecular rate `μ`, for
example.
We will use a special tool for that, TreeAnnotator.

Run the program TreeAnnotator, and then choose 10% as the burn-in
percentage, while keeping "Maximum clade credibility tree" as the 
"Target tree type".
For "Node heights", choose "Mean heights".
Then load the tree log file that BEAST 2 generated (it will end in
".trees" by default) as "Input Tree File".
For this tutorial, the tree log file is called "RSV2long.trees".
Finally, for "Output File", type "RSV2long.tree".

<figure class="image">
  <img src="TreeAnnotator.png" alt="TreeAnnotator">
  <figcaption>{{ include.fignum }}: TreeAnnotator for creating a summary tree from a posterior tree set.</figcaption>
</figure>

This setup will take the set of trees in the tree log file, and
summarize it with a single maximum clade credibility (MCC) tree.
The MCC tree is the tree that has the largest clade probability
product across all nodes.
Divergence times will reflect the mean ages of each node, and those
times will be annotated with their 95% HPD intervals.
TreeAnnotator will also display the posterior clade credibility of
each node in the MCC tree.

More details on summarizing trees can be found in
[beast2.org/summarizing-posterior-trees/](https://www.beast2.org/summarizing-posterior-trees/).

Note that TreeAnnotator only parses a tree log file into an output
text file, but it will not allow you to visualize summary trees.
Visualization has to be done with other programs (see next section).
