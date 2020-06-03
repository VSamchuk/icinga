#!/usr/bin/env python3

import requests, json, sys, urllib3

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

online_nodes = 0
offline_nodes = 0
login, password ='user', 'pass'
url = "https://jenkins_url/computer/api/json"
headers = {
	'Accept': 'application/json',
	'Content-type': 'application/json'
	}

request = requests.get(url,
    headers = headers,
    auth = (login, password),
    verify = False)

nodes = request.json()

for node in nodes['computer']:
    if node['offline'] == False:
        online_nodes += 1
    else:
        offline_nodes += 1
print('ONLINE - ' + str(online_nodes) + ', OFFLINE - ' + str(offline_nodes) + '\n')

FORMAT = '%-36s  %-10s'
print(FORMAT % ('NAME', 'STATE'))
for node in nodes['computer']:
    name = node['displayName']
    if node['offline'] == False:
        state = 'ONLINE'
    else:
        state = 'OFFLINE'
    print(FORMAT % (name, state))

if offline_nodes > 0:
    sys.exit(1)
else:
    sys.exit(0)