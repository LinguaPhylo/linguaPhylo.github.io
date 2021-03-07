Additionally, we allow for rate heterogeneity among sites. 
We do this by approximating the continuous rate distribution (for each site in the alignment) 
with a discretized gamma probability distribution (mean = 1), 
where the number of bins in the discretization `ncat = 4` (normally between 4 and 6).
The _{{ include.shape }}_ parameter will be estimated in this analysis. 