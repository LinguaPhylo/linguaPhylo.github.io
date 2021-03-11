
Whenever tip dates are __heterochronous__ and used as data, they can
be read in natural __forward__ time (here, we refer to them
simply as "__dates__") or __backward__ time (in which case we call
them "__ages__").

Whether we __treat__ the tip times as dates or ages internally in
the code, however, depends on how the models we want to use are
parameterized.
The same goes for how we output the internal node times when we
estimate them during phylogenetic inference.
Regardless, the times are first converted into scalar values from 0.0
to some value > 0.0 (in days, years, millions of years, etc.).

LPhy's behavior is to treat tip times __always as ages__.  
