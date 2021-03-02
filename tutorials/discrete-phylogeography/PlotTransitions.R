
# tonz <- parseTransCount(input="stc.out", pattern = "Histogram", NZ="NZ")
plotTransCount <- function(tonz) {
  require(ggplot2)
  require(tidyverse)
  z <- gather(as_tibble(tonz), 2:ncol(tonz), key = "n_transitions", value = "count") %>% 
    mutate(count = as.numeric(count), n_transitions = as.numeric(n_transitions)) %>% group_by(Transition) %>% 
    mutate(prob = count/sum(count))
  
  p<-ggplot(z, aes(x = n_transitions, y=prob, fill = Transition)) +
    geom_bar(stat="identity", position=position_dodge()) +
    xlab("estimated transitions") + ylab("probability") +
    theme_minimal() 
}

# 2 tables in file, split by "Histogram"
parseTransCount <- function(input="stc.out", pattern = "Histogram", target="Hunan") {
  require(tidyverse)
  con  <- file(input, open = "r")
  counts <- readLines(con)
  close(con)
  ###
  #Transition	mean	95%Low	95%High
  #Fujian=>Fujian	184.06113592852586	177.0	190.0
  ###
  #Histogram
  #Transition	0	1	2	3	4	5	6	7	8	9	10	...
  #Fujian=>Fujian	0	0	...	1	1	2	2	5	7	12	17	...
  ###
  flag.ln = grep(pattern = pattern, x = counts, ignore.case = T)
  stopifnot(length(flag.ln) == 1)
  
  stats.tb <- counts[1:(flag.ln-1)]
  stats.target <- stats.tb[grepl("=>", stats.tb) & grepl(target, stats.tb)]
  # rm target=>target
  stats.target <- stats.target[str_count(stats.target, target) == 1] 
  # add colnames
  stats.target <- c(stats.tb[1], stats.target)
  stats <- read_delim(stats.target, "\t", comment = "#", col_names = T)
  
  hist.tb <- counts[flag.ln:length(counts)]
  hist.tb <- hist.tb[grepl("=>", hist.tb) & grepl(target, hist.tb)]
  # rm target=>target
  hist.tb <- hist.tb[str_count(hist.tb, target) == 1] 
  # rotate
  hist.list = strsplit(hist.tb, "\t")
  n.obs <- sapply(hist.list, length)
  max.n <- seq_len(max(n.obs))
  hist <- t(sapply(hist.list, "[", i = max.n)) 
  hist[is.na(hist)] <- 0
  hist <- as.data.frame(hist) # as_tibble has problem here
  colnames(hist) = c("Transition", 0:(ncol(hist)-2))
  
  list(stats=stats,hist=as_tibble(hist))
}
