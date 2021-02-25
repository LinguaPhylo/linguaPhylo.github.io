
Run the program _TreeAnnotator_ (an application that comes with BEAST) to summarise the tree. 

<figure class="image">
  <img src="TreeAnnotator.png" alt="TreeAnnotator">
  <figcaption>{{ include.fignum }}: TreeAnnotator for creating a summary tree from a posterior tree set.</figcaption>
</figure>

This will take the set of trees and identify a single tree that best represents the posterior distribution, 
and then annotate the selected tree topology with the mean ages of all the nodes as well as 
the 95% HPD interval of divergence times for each clade. 
It will also calculate the posterior clade probability for each node in the selected tree. 

For `Target tree type`, we usually keep the default option `Maximum clade credibility tree`, 
which finds the tree with the highest product of the posterior probability of all its nodes.
For `Node heights`, we choose either `Mean heights for node heights`. 
This sets the heights (ages) of each node in the tree to the mean height across the entire sample of trees for that clade.
Some details are described in [beast2.org/summarizing-posterior-trees/](https://www.beast2.org/summarizing-posterior-trees/).
