
The `data { ... }` block is necessary when we use LPhy Studio to prepare
instruction input files for inference software (e.g., BEAST 2,
RevBayes, etc.).
The purpose of this block is to tell LPhy which nodes of our graphical
model are to be __treated as known constants__ (and __not to be
sampled__ by the inference software) __because they are observed
data__.
Elsewhere, this procedure has been dubbed "clamping" ([Höhna et al.,
2016](#references)).

In this block, we will either type strings representing values to be
directly assigned to scalar variables, or use LPhy's syntax to extract
such values from LPhy objects, which might be read from file paths
given by the user.

(Note that keyword `data` cannot be used to name variables because it
is reserved for defining scripting blocks as outlined above.)

In order to start specifying the `data { ... }` block, make sure you
type into the "data" tab of the command prompt, by clicking "data" at
the bottom of LPhy Studio's window.
