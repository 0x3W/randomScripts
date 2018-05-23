#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Oct 31 19:10:05 2017

@author: Dovla
"""
#from streamz import Stream
import pandas as pd
from streamz.dataframe import DataFrame
import websocket
import time
import json
from datetime import datetime
import time
import ssl

ssl._create_default_https_context = ssl._create_unverified_context

#source = Stream()
#source1 = Stream()
#source1.map(DataFrame).sink(print)
#example = pd.DataFrame({'rate': []})
#sdf = DataFrame(source1, example=example)

#source = Stream()
#source.sliding_window(10).sink(print)
#data = []

def fun1(dat):
    sdf = DataFrame(dat)
    return sdf

def fun2(dat):
    sdf.plot()

def on_error(ws, error):
    print(error)

def on_close(ws):
    print("### closed ###")
    connection.close()


def on_open(ws):
    print("ONOPEN")
        #ws.send(json.dumps({'command':'subscribe','channel':1001,1002,1003}))
   # ws.send(json.dumps({'command':'subscribe','channel':'BTC_ETH'}))

    ws.send(json.dumps({'command':'subscribe','channel':'BTC_XMR'}))
def on_message(ws, message):
    d1 = time.time()
    d2 = datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
    #source.map(json.loads).sink(data.append)
    message = json.loads(message)
    #print(message)
    if message[2]:
        seq = int(message[1])
        for k in message[2]:
            #print(k)
            if len(k) == 6:
                print(k[4])
#                source.map(fun1).sink(fun2)
#                source.emit(k[4])
websocket.enableTrace(True)
ws = websocket.WebSocketApp("wss://api2.poloniex.com",
                              on_message = on_message,
                              on_error = on_error,
                              on_close = on_close)
ws.on_open = on_open
ws.run_forever()
