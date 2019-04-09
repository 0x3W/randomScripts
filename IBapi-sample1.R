library(IBrokers)
tws <- twsConnect()
twsFuture("YM","ECBOT","200809")
reqContractDetails(tws, twsEquity("QQQQ"))

if(Sys.getenv("IBCON")=="1") {
  tws <- twsConnect(999, port=Sys.getenv("IBPORT"))
  twsFuture("YM","ECBOT","200809")
  reqContractDetails(tws, twsEquity("QQQQ"))
  }
reqMktData(tws, twsEquity("QQQQ"))

if(Sys.getenv("IBCON")=="1") {
  IBrokers:::.reqMktData.vignette(tws, twsEquity("QQQQ"))
  twsDisconnect(tws)
}
