ExpMarkovChain distribution
===========================
ExpMarkovChain([Double](../types/Double.md) **initialMean**, [Double](../types/Double.md) **firstValue**, [Integer](../types/Integer.md) **n**)
-----------------------------------------------------------------------------------------------------------------------------------------------

A chain of random variables. X[0] ~ Exp(mean=initialMean) or X[0] ~ LogNormal(meanlog, sdlog); X[i+1] ~ Exp(mean=X[i])

### Parameters

- [Double](../types/Double.md) **initialMean** - This is the mean of the exponential from which the first value of the chain is drawn.
- [Double](../types/Double.md) **firstValue** - This is the value of the 1st element of the chain (X[0]).
- [Integer](../types/Integer.md) **n** - the dimension of the return. Use either X[0] ~ Exp(mean=initialMean); or X[0] ~ LogNormal(meanlog, sdlog); Then X[i+1] ~ Exp(mean=X[i])

### Return type

[Double[]](../types/Double[].md)


### Examples

- skylineCoalescent.lphy
- https://linguaphylo.github.io/tutorials/skyline-plots/



