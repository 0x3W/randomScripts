#!/usr/bin/env Rscript

library('quantmod')
library("reshape")
Sys.time()
#tickers list
tarSym <- c('META','AAPL','NVDA','GOOG','MSFT','AMZN','NFLX','TSLA')
#empty dataframe
dfTotal <- data.frame()
#loop through tickers
for(i in 1:length(tarSym)){
  #download OptionChain
  opts <- getOptionChain(tarSym[i], NULL)
  #create dataframe from a list
  x <- do.call(rbind, lapply(opts, function(x) do.call(rbind, x)))
  #create column from an index
  df <- cbind(Desc = rownames(x), x)
  #change index
  rownames(df) <- 1:nrow(df)
  #split dates
  df2 = transform(df, Desc = colsplit(Desc, split = "\\.", names = c('Month', 'Day', 'Year','Type','Code')))
  #add time
  df2$Download <- Sys.time()
  #combine df
  dfTotal <- rbind(dfTotal,df2)
}
Sys.time()
#write to file
write.csv(dfTotal,paste0("/Users/vladovukovic/Desktop/Dev/OptsChain/optsChain",format(Sys.time(), "-%Y%m%d-%H%M%S"),".csv"))
Sys.time()