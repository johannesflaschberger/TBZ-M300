# LB2 <!-- omit in toc -->
Seafile setup mit MySQL Datenbank

### Inhalt <!-- omit in toc -->
- [Installation](#installation)
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

### Installation
**Implementierungsdetails**  
Linux-Distribution: `Centos 7`  
Seafile Version: `7.0.0 Beta`

**Umgebungsvariablen festlegen**  
In dem Vagrantfile können diverse Variablen angepasst werden
| Variable      | Bedeutung                          | 
| ------------- |:----------------------------------:| 
| `fe01`        | IP-Adresse des Frontend Servers    | 
| `db01`        | IP-Adresse des Backend Servers     |
| `dbPassword`  | Datenbankpasswort des Seafile-Users|
| `serverName`  | Servername = Common name           |
| `seafileAdmin`| Email Adresse des Server Admins|
- IP-Adressen der Hosts `fe01` & `db01`
- Datenbankpasswort des Seafile-Users `dbPassword`

**Umgebung starten**  
Um die Umgebung mit Vagrant zu starten muss der folgende Befehl getätigt werden:  
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

### Dokumentation
#### Linux

#### Virtualisierung mit Virtualbox

#### Vagrant 
Da wir in meinem Geschäft auch Vagrant für unsere eigene lokale Test-Umgebung verwenden ist Vagrant für mich kein Fremdwort. Mir fiel das festlegen der Konfiguration leicht. Neu gelernt habe ich, dass man auch Variablen definieren kann innerhalb eines Vagrantfile. Dies bietet den Vorteil, dass man, wenn richtig implementiert, viel Zeit sparen kann wenn beispielsweise ein anderes Datenbank Passwort verwendet werden soll.

#### Versionsverwaltung / Git

#### Mark Down

#### Systemsicherheit

### Reflexion