
Whenever tip dates are __heterochronous__ and used as data, they can
be interpreted in natural __forward__ time (here, we refer to them
simply as "__dates__") or __backward__ time (in which case we call
them "__ages__").
Whether we read the tip times as dates or ages depends on how the
models we want to use are parameterized.
Regardless, the times are first converted into scalar values from 0.0
to some value > 0.0 (in days, years, millions of years, etc.).

It often makes sense to interpret tip times as ages because (i) we
usually have many observations from the present moment whose times we
do not try to estimate (i.e., we treat as constants), and (ii) we
routinely attempt to estimate tree root or origin times.
Put differently, it is natural to "anchor" the terminal nodes of our
tree to the present at time 0.0, and then estimate the height of all
internal nodes as values > 0.0.
