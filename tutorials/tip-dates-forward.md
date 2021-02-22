
By default all the taxa are assumed to have a date of zero 
(i.e. the sequences are assumed to be sampled at the same time). 
In this case, the sequences have been sampled at various dates going back to {{ include.earliest }}. 

The date of each sample is stored in the taxon name {{ include.date_in_name }}. 
The numbers are years since {{ include.since }}.
We will use the regular expression `"{{ include.regex }}"` to extract these numbers and turn to ages. 
In addition, the age direction should be set to the _forward_ in time for this analysis. 

If the setup is correct, the sequences sampled the most recently (i.e. {{ include.last }}) 
should have a `Age` of 0 while all other tips should be larger then 0.
