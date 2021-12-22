from mylib import CoffeeRoasting
import paho.mqtt.client as mqtt
from time import sleep
import sys
import signal

def Exit_gracefully(signal, frame):
    print("\n>>>> Bye.\n")    
    sys.exit(0)

TOPIC  = f"stust2021/roaster1"
BROKER = "broker.emqx.io"
PORT   = 1883
Client = None

# MQTT-Connected call-back function 
def on_connect(client, userdata, flags, rc):
    print(f"Connected with result code {rc}")

# Create MQTT client and connect to the broker
def connect_broker():
    global Client, TOPIC, GROUP
    Client = mqtt.Client()
    Client.on_connect = on_connect
    Client.connect(BROKER, PORT, keepalive=60)
    # Clear the retained message send by Kittenblock
    Client.publish(topic=TOPIC, payload=None, retain=True)

# Send test commands with TOPIC to the broker
def pub_cmds(cmds):
    global Client, TOPIC
    for cmd in cmds:
        Client.publish(topic=TOPIC, payload=cmd, retain=False)
        print(f"send '{cmd}' to '{TOPIC}'")
        time.sleep(1)

def main():
    connect_broker()
    temp = CoffeeRoasting(5)
    clk = 0   
    while True:
        clk, k1, k2 = temp.next()
        cmd = f"{clk}:{k1:.1f}:{k2:.1f}"
        print(f"{clk:5} {k1:6.1f} {k2:6.1f}")   
        Client.publish(topic=TOPIC, payload=cmd, retain=False)
        sleep(0.5)

# Main Loop
# ------------------------------------------
if __name__=="__main__":
    print("""
*********************************************
* Press CTRL+C to stop test data generation *
*********************************************
          """)
    signal.signal(signal.SIGINT, Exit_gracefully)
    main()
    