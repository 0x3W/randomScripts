
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
