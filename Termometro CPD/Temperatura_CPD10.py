#!/usr/bin/python3
from pyzabbix import ZabbixMetric, ZabbixSender
import requests
import time


while True:

# URL da API do ThingSpeak
    url = "https://api.thingspeak.com/channels/2236251/feeds.json?api_key=3D4SKVC1SB1QPIU3NC&results=2"

    # Faz a requisição GET à API
    response = requests.get(url)

    # Verifica se a requisição foi bem-sucedida
    if response.status_code == 200:
        data = response.json()  # Converte a resposta em um dicionário JSON
        
        # Acessa os feeds dentro do dicionário
        feeds = data.get('feeds', [])
        
        # Verifica se há pelo menos dois feeds
        if len(feeds) >= 2:
            segundo_feed = feeds[-1]  # Pega o último item da lista (segundo feed)
            
            # Acessa os campos específicos do feed
            temperatura = segundo_feed.get('field1')
            umidade = segundo_feed.get('field2')
            
            # Imprime os valores
            temperatura = float(temperatura)
            umidade = int(umidade)

            packet = [ ZabbixMetric('CPD Thermometer', 'temp10', temperatura), ZabbixMetric('CPD Thermometer', 'umid10', umidade)]
            result = ZabbixSender(zabbix_server='192.168.254.40', zabbix_port=10051, use_config=None, chunk_size=250, socket_wrapper=None, timeout=10).send(packet)
            

    time.sleep(30)
