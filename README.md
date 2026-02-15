🛡️ AppLogGuardian – Mein PowerShell-Mini-Support-Buddy 💻🦸‍♀️

Ich bin vor 1,5 Jahren quer in die IT eingestiegen – und vor ein paar Wochen habe ich mich in PowerShell verliebt ❤️.
Weil ich PowerShell richtig verstehen wollte, habe ich dieses kleine Tool gebaut – mein Mini-Support-Buddy, der mir (und hoffentlich anderen) das Leben erleichtert.

„Kein Plan, was passiert ist, aber vorhin ging es noch…“ – kennt das nicht jeder Supporter? 😅

Mit AppLogGuardian musst du nicht mehr verzweifelt suchen – es zeigt alles auf einen Blick und legt die Infos direkt in einer Datei ab, die du ins Ticket packen kannst.

⚡ Was AppLogGuardian kann

🔍 Versionsprüfung von Office, Defender & und Chrome und Edge

⚠️ Eventlog-Auswertung (Critical, Error, Warning)

🎨 Farbige Konsole + Export-Datei

🛠️ MaxEvents & EventLevels über JSON konfigurierbar

💾 Alles automatisch im gleichen Ordner speichern – fertig für’s Ticket

🛠️ Installation & Nutzung

Ordner anlegen, z. B.:

V:\PowerShell\AppLogGuardian


Dateien reinlegen:

AppLogGuardian.ps1

config.json

PowerShell öffnen & zum Ordner wechseln:

cd V:\PowerShell\AppLogGuardian


Skript starten:

.\AppLogGuardian.ps1


Ergebnis:

🎨 Schöne, farbige Ausgabe auf Konsole

💾 Automatische Export-Datei im gleichen Ordner

🦸‍♀️ Tipp: Die Export-Datei kannst du direkt ins Ticket hängen – Support leicht gemacht!

🔧 JSON-Konfiguration
{
  "MonitoredApplications": [
    "Microsoft Word",
    "Microsoft Excel",
    "Microsoft Edge",
    "Google Chrome",
    "Microsoft Defender"
  ],
  "MaxEvents": 10,
  "EventLevels": ["Critical","Error","Warning"]
}


MonitoredApplications: Apps, die überprüft werden sollen

MaxEvents: Anzahl Events pro App

EventLevels: Eventtypen, die angezeigt werden

💡 Du kannst jederzeit neue Apps hinzufügen oder EventLevels ändern – ganz flexibel.

👀 Beispielausgabe
=== Versionsprüfung ===
App: Microsoft Word
  Version: 2302.14026.20336
App: Microsoft Defender
  Version (Engine): 1.1.24010.3

=== Eventlog-Auswertung ===
Events für Microsoft Word
[12.02.2026 10:14:33] Error
  Quelle: Application Error
  EventID: 1000
  Nachricht: Faulting application name: WINWORD.EXE ...

✨ Persönlicher Hinweis

Dieses Projekt habe ich gebaut, um PowerShell zu lernen und zu verstehen.
Jeder Schritt, jede Funktion, jede Fehlermeldung – alles habe ich getestet und selbst nachvollzogen.

Wenn du gerade in der IT unterwegs bist: Stell dir AppLogGuardian als kleinen Helfer im Hintergrund vor, der die nervige Suche übernimmt, damit du dich aufs Wichtige konzentrieren kannst. 💪