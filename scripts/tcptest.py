import requests
import time
import json
from sys import argv
import socket
# import rel

ADDRESS = '127.0.0.1'
PORT = 9090

class TcpConnection:
    def __init__(self):
        self.config_received = False
        self.first_state_received = False
        self.open = False

        self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        print((ADDRESS, PORT))
        self.socket.connect((ADDRESS, PORT))
        self.socket.settimeout(.2)
        self.on_connect()
        self.run_loop()

    def force_close(self):
        self.socket.close()
        self.open = False

    def on_connect(self):
        self.open = True
        # name = input('Enter name: ')
        # name = 'player1'
        # deck = 'dev::Mana Drill#3|dev::Brute#3|dev::Mage Initiate#3|dev::Warrior Initiate#3|dev::Rogue Initiate#3|dev::Urakshi Shaman#3|dev::Urakshi Raider#3|dev::Give Strength#3|dev::Blood for Knowledge#3|dev::Dragotha Mage#3|dev::Prophecy Scholar#3|dev::Trained Knight#3|dev::Cast Armor#3|dev::Druid Outcast#3|starters::Knowledge Tower#3|dev::Elven Idealist#3|dev::Elven Outcast#3|dev::Barracks#3|dev::Shieldmate#3|dev::Healer Initiate#3|dev::Archdemon Priest#3|dev::Kobold Warrior#3|dev::Kobold Mage#3|dev::Kobold Rogue#3|starters::Dragotha Student#3|starters::Tutoring Sphinx#3|starters::Dragotha Battlemage#3|starters::Inspiration#3'
        # self.write(
        #     json.dumps({
        #         'name': name,
        #         'deck': deck,
        #     })
        # )

    def write(self, msg: str):
        message_length = len(msg)
        message_length_bytes = message_length.to_bytes(4, byteorder='little')
        message_bytes = msg.encode('utf-8')
        message_with_length = message_length_bytes + message_bytes
        self.socket.sendall(message_with_length)

    def read(self):
        message = ''
        try :
            message_length_bytes = self.socket.recv(4)
            message_length = int.from_bytes(message_length_bytes, byteorder='little')

            # Receive the message itself
            while len(message) < message_length:
                message_bytes = self.socket.recv(message_length)
                message += message_bytes.decode('utf-8')

        except socket.timeout:
            message = ''
        except socket.error:
            self.open = False

        return message
    
    def run_loop(self):
        while self.open:
            msg = self.read()
            if msg == '': continue
            self.respond(msg)

    def respond(self, msg: str):
        data = json.loads(msg)
        print(json.dumps(data, indent=4))
        if not 'Request' in data:
            return
        request = data['Request']
        if request == 'Update':
            return
        if request == 'PromptLandscapePlacement':
            resp = 'Cornfield Cornfield Cornfield Cornfield'
            self.write(resp)
            return
        print(data['Hint'] + ': ',end='')
        result = input()
        self.write(result)

conn = TcpConnection()