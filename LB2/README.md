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
- [ ] UFW implementieren -> Kapitel 25
- [ ] Synched folder dbdirs und seahub-data
- [ ] Answer to skript "Y Y N N Y N Y Y N" | ./your_script 
- [ ] Tabelle mit Vagrantbefehle
- [ ] Netzwerkplan in ASCII Grafik -> Übersicht Server /vagrant/fwrp
- [ ] Nach Bewertungsraster
- [ ] Dokumentation testfälle mit curl -> Bsp. Port aktiv
- [ ] Vagrant aus vagrantcloud dokumentieren up + init
- [ ] Allgemein Dokumentation + Vagrant + Virtualbox 
- [ ] Reverse Proxy einrichten /vagrant/fwrp
- [ ] Sicherheitsmassnahmen dokumentiert ufw + reverse proxy + evtl ngrok
- [ ] Reflexion über implementierung
- [ ] Root MySQL Password festlegen
- [ ] Setup Seafile 7.0 Newest version

#### Testing
```curl https://localhost -k```

## Dokumentation
### Linux

### Virtualisierung mit Virtualbox

### Vagrant 
Da wir in meinem Geschäft auch Vagrant für unsere eigene lokale Test-Umgebung verwenden ist Vagrant für mich kein Fremdwort. Mir fiel das festlegen der Konfiguration leicht. Neu gelernt habe ich, dass man auch Variablen definieren kann innerhalb eines Vagrantfile. Dies bietet den Vorteil, dass man, wenn richtig implementiert, viel Zeit sparen kann wenn beispielsweise ein anderes Datenbank Passwort verwendet werden soll.

Meine meist verwendeten Befehle erklärt:
| Befehl | Erklärung |
| --- | --- |
| `vagrant up` | Dieser Befehl startet die im Vagrantfile definierten Umgebung Schritt für Schritt. | 
| `db01` | IP-Adresse des Backend Servers |
| `dbPassword` | Datenbankpasswort des Seafile-Users |
| `serverName` | Servername = Common name |
| `seafileAdmin` | Email Adresse des Server Admins |

### Versionsverwaltung / Git

### Mark Down

### Systemsicherheit

## Reflexion