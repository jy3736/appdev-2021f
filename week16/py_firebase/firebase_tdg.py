from mylib import CoffeeRoasting
from firebase import firebase
from random import randrange, random
from time import sleep
import sys
import signal

def Exit_gracefully(signal, frame):
    print("\n>>>> Bye.\n")    
    sys.exit(0)

db_url = 'https://coffee-roaster-7b60c-default-rtdb.firebaseio.com/'
fdb = firebase.FirebaseApplication(db_url, None)

def main():
    temp = CoffeeRoasting(5)
    clk = 0   
    # fdb.delete('','/roaster1')
    while True:
        clk, k1, k2 = temp.next()
        print(f"{clk:5} {k1:6.1f} {k2:6.1f}")   
        # fdb.post('/roaster1',{'time':clk,'k1':k1,'k2':k2})
        fdb.put('/roasterRT', 'k1', k1)
        fdb.put('/roasterRT', 'k2', k2)

if __name__=="__main__":
    print("""
*********************************************
* Press CTRL+C to stop test data generation *
*********************************************
          """)
    signal.signal(signal.SIGINT, Exit_gracefully)
    main()