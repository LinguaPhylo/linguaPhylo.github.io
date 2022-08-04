#setwd(YOUR_WD)
WD="~/WorkSpace/linguaPhylo.github.io/tutorials/discrete-phylogeography"
# it is in the same directory
source(file.path(WD, "PlotTransitions.R"))

stc <- parseTransCount(input="stc.out", pattern = "Histogram", target="Hunan")
# only => Hunan
p <- plotTransCount(stc$hist[grepl("=>Hunan", stc$hist[["Transition"]]),])
ggsave( paste0("transition-distribution-hunan.png"), p, width = 6, height = 4) 
