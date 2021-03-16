The software LPhy Studio is used to specify and visualise models 
as well as simulate data from models defined in LPhy scripts. 

The `data` block is used to input and store the data, which will be processed by the models defined later, and which also allows you to reuse the another dataset by simply replacing the current data.
In this block, we normally include the constants for models, the alignment loaded from a NEXUS file, and the meta data regarding to the information of taxa that we have known.

The `model` block is to define and also describe your models and parameters
in the Bayesian phylogenetic analysis.
Therefore, your result could be easily reproduced by other researchers. 

Please make sure the tab above the command console is set to `data`, 
when you intend to type or copy and paste the data block scripts into the console.
In addition, make sure to switch the tab to `model`, 
when you intend to type or copy and paste the model block scripts into the console.

When you write your LPhy scripts, please be aware that `data` and `model` 
have been reserved and cannot be used as the variable name.
