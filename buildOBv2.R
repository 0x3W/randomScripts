library(RMySQL)
library(dplyr) #data munging
library(rkdb)


mydb = dbConnect(MySQL(), user='necesvise', password='123Dubovica+', dbname='poloniex', host='34.216.81.75', port=3306)
bookProd1 <- fetch(dbSendQuery(mydb, "select * from BTCETH2412OB"), n=-1)
min(bookProd1$seq)
max(bookProd1$seq)
orders <- fetch(dbSendQuery(mydb, "select * FROM BTCETH2412"), n=-1)
min(orders$seq)
max(orders$seq)
index <- dat$typeOT == "t"
dat$typeSB[index] <- 7
orders10 <- select(dat, c("typeSB","rate","amount","seq","timeDateOTe","timeDateOTh"))
orders10 <- filter(orders10, seq > 460957938)
index1 <- orders10$typeSB == "7"
index1p <- which(index1 %in% TRUE)
knt <- sum(index1[1:500000])


# ob ----------------------------------------------------------------------
realBook <- filter(bookProd1, seq == 460957938)
colnames(realBook) <- c("typeSB","rate","amount","seq","timeDateOTe","timeDateOTh")

realBook[realBook=="asks"] <- 0
realBook[realBook=="bids"] <- 1
realBook2 <- realBook[1:200,]

simple <- function(orders1,knt,r,bookData2){
  iOld <- 1
  var1 <- character(r) 
  var2 <- character(r) 
  var3 <- character(r) 
  var4 <- character(r) 
  var5 <- character(r) 
  var6 <- character(r) 
  var7 <- character(r) 
  var8 <- character(r)
  var9 <- character(r)
  var10 <- character(r)
  var11 <- character(r)
  var12 <- character(r)
  var13 <- character(r)
  var14 <- character(r)
  
  indexD <- orders1[,1] == "7"
  indexB <- orders1[,1] == "1"
  
  for(i in 1:knt) {
      cnt <- index1p[i]
      run <- orders1[iOld:cnt,]
      opBook <- rbind(realBook2, run)
      var1[cnt] <- orders1[cnt,2]
      var2[cnt] <- orders1[cnt,3]
      var3[cnt] <- sum(run$typeSB==0)
      var4[cnt] <- sum(run$typeSB==1)
      var5[cnt] <- sum(run[run$typeSB==0,3])
      var6[cnt] <- sum(run[run$typeSB==0,3])
      
      var7[cnt] <- orders1[i,5]
      var8[cnt] <- orders1[i,6]
      
      opBook1 <- opBook[!(opBook$amount==0),]
      temp1 <- opBook1 %>% filter(typeSB == 1) %>% arrange(desc(rate))
      var9[cnt] <- max(temp1$rate)
      var10[cnt] <- temp1$amount[1]
      
      temp2 <- opBook1 %>% filter(typeSB == 0) %>% arrange(rate)
      var11[cnt] <- min(temp2$rate)
      var12[cnt] <- temp2$amount[1]
      var13[cnt] <- 
      var14[cnt] <- 
      iOld <- cnt
  }
  df <- data.frame(var1,var2,var3,var4,var5,var6,var7,var8,var9,var10,var11,var12)
  return(df)
}

a <- Sys.time();df1 <- simple(orders10, knt,1,bookData2);Sys.time() - a

df2 <- df1[complete.cases(df1), ];df2 <- df2[-1,]
names(df2) <- c("price","amount","nrAsks", "nrBids", "amountAsks", "amountBids","tim", "tim1", "bestAsk", "bestAskAmount","bestBid", "bestBidAmount")
head(df2)
#df2$var7 <- as.numeric(levels(df2$var7))[df2$var7]


match(c(2,3,3), c(1:4))


dat <- read.csv("/Users/Dovla/Desktop/poloTest.csv")


a <- set()
