import requests
import httplib2
import json
link = "https://www.wunderground.com/history/daily/"
loc = input("Please enter location as in sg/river-valley: ")
date = input("Please enter date as in 2018-01-31: ")
mid = "/WSAP/date/"
date1 = date.replace('-','')
link1 = link + loc + mid + date
try:
    r=requests.get(link1).text
    fir = r.find('"url":')
    end = r.find("conditions/labels")
    link2 = r[fir+7:end-1]+'/history_' + date1 + '/lang:EN/units:english/bestfct:1/v:2.0/q/WSAP.json?showObs=0&ttl=120'
    r2 = requests.get(link2).text
    r3 = json.loads(r2)
    print(json.dumps(r3['history']['days'][0]['summary'], indent=4, sort_keys=True))
except:
    print('Location or date not appropriate, please re-run!')
