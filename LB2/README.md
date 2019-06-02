# LB2 <!-- omit in toc -->
### Inhalt <!-- omit in toc -->
- [Ziel](#ziel)
- [Übersicht](#%C3%BCbersicht)
- [Installation](#installation)
  - [Umgebung starten](#umgebung-starten)
    - [TODO](#todo)
    - [Testing](#testing)
- [Dokumentation](#dokumentation)
  - [Linux](#linux)
  - [Virtualisierung mit Virtualbox](#virtualisierung-mit-virtualbox)
  - [Vagrant](#vagrant)
  - [Versionsverwaltung / Git](#versionsverwaltung--git)
  - [Mark Down](#mark-down)
  - [Systemsicherheit](#systemsicherheit)
- [Reflexion](#reflexion)

## Ziel
Mein Ziel bei dieser LB ist es, automatisiert mithilfe von Bash-Skripts einen gesamten Dateien Cloud Dienst (Seafile) aufzusetzten. Dabei möchte ich die Datenbank auf einer seperaten Maschine haben. Damit man keine fest programmierten Werte hat, möchte ich zudem bei der Implementierung darauf achten, dass die wichtigsten Werte durch Variablen im Vagrantfile definiert werden. Die Cloud soll mit einem selbst signiertem Zertifikat über HTTPS erreichbar sein. Hierfür muss noch zusätzlich ein Reverse Proxy eingerichtet werden.

## Übersicht
```
+--------------------------------------------------------+                                  
|            Privates Netz: 192.168.120.0/24             |                                  
----------------------------------------------------------                                  
| +--------------------+          +--------------------+ |                                  
| | Frontend Server    |          | Datenbank Server   | |                                  
| | Host: fe01         |          | Host: db01         | |                                  
| | IP: 192.168.120.11 | <------> | IP: 192.168.120.10 | |                                  
| | Port: -            |          | Port: 3306         | |                                  
| | NAT: 80, 443       |          | NAT: -             | |                                  
| +--------------------+          +--------------------+ |                                  
+--------------------------------------------------------+
```
Verwendete Linux-Distribution: `Centos 7`  
Seafile Version: `7.0.0 Beta`  

## Installation
**Variablen festlegen**  
In dem oberen Abschnitt des Vagrantfile können diverse Variablen nach belieben angepasst werden.
```
# In diesem Abschnitt können Umgebungsvariablen definiert werden
db01 = "192.168.120.10"
fe01 = "192.168.120.11"
dbPassword = "seafile"
serverName = "seafilesrv"
seafileAdmin = "email@email.com"
```

| Variable | Bedeutung |
| --- | --- |
| `fe01` | IP-Adresse des Frontend Servers | 
| `db01` | IP-Adresse des Backend Servers |
| `dbPassword` | Datenbankpasswort des Seafile-Users |
| `serverName` | Servername = Common name |
| `seafileAdmin` | Email Adresse des Server Admins |

### Umgebung starten  
Um die Umgebung zu starten muss der folgende Befehl getätigt werden:  
```
vagrant up
```

> Hinweis: Am Ende der Installation wird das Admin Account Passwort für Seafile im stdout angezeigt

#### TODO
- [ ] Synched folder dbdirs und seahub-data
- [ ] Tabelle mit Vagrantbefehle
- [ ] Nach Bewertungsraster
- [ ] Dokumentation testfälle mit curl -> Bsp. Port aktiv
- [ ] Vagrant aus vagrantcloud dokumentieren up + init
- [ ] Allgemein Dokumentation + Vagrant + Virtualbox 
- [ ] Sicherheitsmassnahmen dokumentiert ufw + reverse proxy + evtl ngrok
- [ ] Reflexion über implementierung

#### Testing
```curl https://localhost -k```
- Verbindung über HTTPS möglich ✅
```
curl -vk https://localhost
```
Ergebnis:
```
* About to connect() to localhost port 443 (#0)
*   Trying ::1...
* Connection refused
*   Trying 127.0.0.1...
* Connected to localhost (127.0.0.1) port 443 (#0)
* Initializing NSS with certpath: sql:/etc/pki/nssdb
* skipping SSL peer certificate verification
* SSL connection using TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
* Server certificate:
* 	subject: CN=seafilesrv,O=IT,L=Zurich,ST=Zurich,C=CH
* 	start date: May 29 23:18:52 2019 GMT
* 	expire date: May 28 23:18:52 2020 GMT
* 	common name: seafilesrv
* 	issuer: CN=seafilesrv,O=IT,L=Zurich,ST=Zurich,C=CH
```
- Verbindung über HTTP wird auf HTTPS weitergeleitet ✅
```
curl -vk http://localhost
```
Ergebnis:
```
< HTTP/1.1 301 Moved Permanently
< Server: nginx
< Date: Wed, 29 May 2019 23:46:39 GMT
< Content-Type: text/html
< Content-Length: 162
< Connection: keep-alive
< Location: https://localhost/
```
## Dokumentation
### Linux

### Virtualisierung mit Virtualbox

### Vagrant 
Da wir in meinem Geschäft auch Vagrant für unsere eigene lokale Test-Umgebung verwenden ist Vagrant für mich kein Fremdwort. Mir fiel das festlegen der Konfiguration leicht. Neu gelernt habe ich, dass man auch Variablen definieren kann innerhalb eines Vagrantfile. Dies bietet den Vorteil, dass man, wenn richtig implementiert, viel Zeit sparen kann wenn beispielsweise ein anderes Datenbank Passwort verwendet werden soll.

Meine meist verwendeten Befehle erklärt: 

| Variable | Bedeutung |
| --- | --- |
| `vagrant up` | Dieser Befehl startet die im Vagrantfile definierten Umgebung Schritt für Schritt. | 
| `vagrant halt` | Mit diesem Befehl werden die Virtuellen Maschinen gestoppt |
| `vagrant reload` | Startet die Maschienen neu und lädt eine neue Vagrantfile konfiguration |
| `vagrant status` | Zeigt den status der VM's an |
| `vagrant ssh-config` | Dieser Befehl zeigt die SSH Konfigration der Virtuellen Maschine an, Port, Key u.v.m. |

### Versionsverwaltung / Git

### Mark Down

### Systemsicherheit

## Reflexion