
The LPhy `TimeTree` always take the ages. 
But there are two different ways in how the meta data (e.g. in the Nexus file) can interpret sampling dates, 
which are controlled by the age direction defined in LPhy `readNexus`. 
If the sampling dates are __since some time in the past__, then we set `ageDirection="forward"` or `"dates"`.
This is usually used for virus data. 
If the sampling dates are __before the present__, then we set `ageDirection="backward"` or `"ages"`. 
This is usually used for fossils data. 
The easiest way to check if you have used the correct one is by clicking the graphical component `taxa` and checking the column `Age`. 
