import unittest
import pybbg
import datetime
from dateutil.relativedelta import relativedelta

class TestPybbg(unittest.TestCase):
     def test_bdh_single_field(self):
        tester = pybbg.Pybbg()
        ticks = ['AAPL US Equity', 'SPX Index']
        tip = ['PX_LAST', 'PX_OPEN', 'PX_HIGH', 'PX_LOW','PX_VOLUME','PX_BID', 'PX_ASK']
        for tick in ticks:
            for ti in tip:
                data = tester.bdh(tick, ti,
                    datetime.datetime.today() + datetime.timedelta(days=-100), datetime.datetime.today())
                print(data)
                data['tick'] = tick
                data['field'] = ti
                with open('first.csv','a') as f:
                    data.to_csv(f, header=True)

if __name__ == '__main__':
    unittest.main()

#data = tester.bdp('SPX Index', 'INDX_MWEIGHT_HIST', overrides={'END_DATE_OVERRIDE': '20170620'})