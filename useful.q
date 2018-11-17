#read json file
\l json.k
t: .j.k each read0`:/Users/Dovla/Desktop/Charts2.json

#Poloniex websocket in kdb
q ws.q
.polo.upd:{.polo.x,:enlist x}
.polo.h:.ws.open["wss://api2.poloniex.com";`.polo.upd]
.polo.h .j.j `command`channel!`subscribe`BTC_ETH
.z.ws:{show .j.k x}
#.polo.upd:{show .j.k x}

#Option Pricing in k - cdf not corrent
pdf:{[x] (1.0%( exp 0.5 * log (2*3.141592653589793))) * (exp(-0.5*x*x))}  
#pdf[1]
#0.2419707
cdf:{[x] k:1%(1.0+0.2316419*x); ksum:(k * (0.319381530 + k * (-0.356563782 + k * (1.781477937 + k * (-1.821255978 + 1.330274429 * k)))));$[x > 0;(1.0 - ((1.0%( exp 0.5 * log (2*3.141592653589793) )) * (exp(-0.5*1*1)) * ksum)); 1.0 - cdf[abs x]]}        
#cdf[1]
#0.8413447
#cdf[-1]
0.1586553
dj:{[j; s; k; r; v; t] ((log (s%k)) + (r + (j) *0.5*v*v)*t) % (v* exp 0.5 * log t)}
dj[1;950;1000;0.03;0.1;2]
0.1322764
dj[-1;950;1000;0.03;0.1;2]
-0.009144972
sb: 950 1000 1100
kk: 1000 1050 1200
dj[-1;sb;kk;0.03;0.1;2]
-0.009144972 0.008554831 -0.26171
call:{[s;k;r;v;t] (s * cdf[dj[1;s;k;r;v;t]]) - (k * (exp (- r*t)) * cdf[dj[-1;s;k;r;v;t]])}
call[950;1000;0.03;0.1;2]



