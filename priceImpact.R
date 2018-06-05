# Single Curve Collapse of the Price Impact Function for the New York Stock Exchange
# Fabrizio Lillo, J. Doyne Farmer and Rosario N. Mantegna
# 2002

# adjusted few lines by me to accomodate new TAQ structure

require(xts)
require(Hmisc)

path = "/Users/Dovla/Downloads/"
csv_mypath = function(file) {
  read.csv(paste(path,file,sep=""), stringsAsFactors=FALSE)
}

ge.t = csv_mypath("trades-Feb1.csv")

#ge.t = ge.t[-1]
ge.t$TIME = mapply(paste, as(ge.t$DATE,"character"), ge.t$TIME_M)
#ge.t$TIME = mapply(paste, as(ge.t$TIME_M,"character"), ge.t$TIME)

ge.t$TIME = as.POSIXct(ge.t$TIME,tz="EST",format="%Y%m%d %H:%M:%S")
require(xts)
ge.t = xts(ge.t[c(8,7)],order.by=ge.t$TIME)
colnames(ge.t) = c("price","size")

# Aggregate GE trades with the same timestamp
agg = coredata(ge.t)
dates = as.integer(index(ge.t))
for (i in 2:dim(agg)[1]) {
  if (dates[i]==dates[i-1]) {
    if (agg[i,1] == agg[i-1,1]) {
      agg[i,2] = agg[i-1,2] + agg[i,2]
    }
    else
    {
      agg[i,1] = (agg[i-1,1]*agg[i-1,2]+agg[i,1]*agg[i,2])/(agg[i-1,2]+agg[i,2])
      agg[i,2] = agg[i-1,2] + agg[i,2]
    }
    agg[i-1,2] = -1
  }
}
ge.t1 <- xts(agg[,c(1,2)],order.by=index(ge.t))
ge.t = xts(agg[,c(1,2)],order.by=index(ge.t))
ge.t = ge.t[ge.t$size!=-1]


# Load GE Quote Data
#ge.q = rbind(csv_mypath("ge_quote_1995_JanJun.csv"),
#             csv_mypath("ge_quote_1995_JulDec.csv"))
ge.q = csv_mypath("quotes-Feb1.csv")
ge.q <- q1AAPL
#ge.q = ge.q[-1]
ge.q$TIME = mapply(paste, as(ge.q$DATE,"character"), ge.q$TIME_M)
ge.q$TIME = as.POSIXct(ge.q$TIME,tz="EST",format="%Y%m%d %H:%M:%S")
ge.q = xts(ge.q[c(4,6)],order.by=ge.q$TIME)
colnames(ge.q) = c("bid","ofr")

# Clean GE Quote Data
ge.q = ge.q[!(ge.q$bid==0 | ge.q$ofr==0),] # Bid/Offer of 0 is a data error
ge = merge(ge.t, ge.q)
# Final Result: variable "ge" is an xts with NA"s showing trades / quotes
#ge.t = NULL
#ge.q = NULL

# Classify the direction of trades according to Lee-Ready (1991)
ge$mid = (ge$bid+ge$ofr)/2
ge$dir = matrix(NA,dim(ge)[1],1)
d = coredata(ge) # data.frame(coredata(ge)) is insanely slower
p1 = d[1,1]
d[1,6] = 1 # Assume the first trade was up
dir1 = d[1,6]
q1 = d[2,5]
for (i in 3:dim(d)[1]){
  p2 = d[i,1] # current price
  if (!is.na(p2)){ # Trade
    # Quote Rule
    if (p2 > q1){
      d[i,6] = 1 # Direction
    }
    else if (p2 < q1) {
      d[i,6] = -1
    }
  #}
    else # p == midpoint
    {
      # Tick Rule
      if (p2 > p1) {
        d[i,6] = 1
      }
      if (p2 < p1) {
        d[i,6] = -1
      }
      else{
        d[i,6] = dir1
      }
    }
  p1 = p2
  dir1 = d[i,6]
  }
  else # Quote
  {
    q1 = d[i,5] # Update most recent midpoint
  }
}

# Measure impact per trade
d2 = cbind(d[,6],d[,2],log(d[,5]),matrix(NA,dim(d)[1],1))
colnames(d2) = c("dir","size","logmid","impact")
trade_i1 = 1
quote_i1 = 2
for (i2 in 3:dim(d2)[1]){
  dir_i2 = d2[i2,1]
  if (!is.na(dir_i2)) # Trade
  {
    if (i2-trade_i1 == 1) # Following another a trade
    {
      d2[trade_i1,4] = 0 # \delta p = 0
    }
    trade_i1 = i2
  }
  else # Quote
  {
    if (i2-trade_i1 == 1) # Following a trade
    {
      d2[trade_i1,4] = d2[i2,3]-d2[quote_i1,3] # diff(logmids)
    }
    quote_i1 = i2
  }
}

# Look only at buyer initiated trades
buy = d2[!is.na(d2[,4]) & d2[,1]==1,]
buy = buy[,c(2,4)]
buy[,1] = buy[,1]/mean(buy[,1])
require(Hmisc)
max_bins = 50
sizes = as.double(levels(cut2(buy[,1],g=max_bins,levels.mean=TRUE)))
buy[,1] = cut2(buy[,1],g=max_bins,levels.mean=TRUE)
ge_imp = aggregate(buy[,2], list(buy[,1]), mean)
plot(sizes,ge_imp[,2],log="xy",type="p",pch=15,ylab="price shift",
     xlab="normalized volume",main="GE")

# Find how the price impact increases with volume
imp_fit = function(pow){summary(lm(ge_imp[,2] ~ I(sizes^pow)))$r.squared}
fits = sapply(seq(0,1,.01), imp_fit)
print(paste("R^2 minimizing beta in volume^beta=impact: ",which.max(fits)/100))
print("Difference is likely because of Lee-Ready flat trade/quote ambiguity")
print("and timestamp aggregation ambiguity.")
print("A huge number of trades were labeled as having 0 impact.")
