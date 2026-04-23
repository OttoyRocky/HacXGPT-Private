#!/bin/bash
# Módulo 14: Análisis de nmap con IA (Ollama)

analizar_con_nmap() {
    local target="$1"
    
    echo -e "${CYAN}🔍 Ejecutando nmap sigiloso contra $target...${NC}"
    echo ""
    
    # Ejecutar nmap y guardar output
    nmap -sS -sV -T2 -Pn -oA "scan_$target" "$target" > /tmp/nmap_raw_$$.txt 2>&1
    
    echo ""
    echo -e "${GREEN}✅ Escaneo completado. Resultados guardados en scan_$target.nmap${NC}"
    echo ""
    echo -e "${CYAN}🤖 Enviando resultados a IA para análisis (esto puede tomar unos segundos)...${NC}"
    echo ""
    
    # Leer output y enviar a Ollama
    local nmap_result=$(cat /tmp/nmap_raw_$$.txt)
    
    local prompt="Eres HacXGPT, experto en pentesting ofensivo. Analizá este escaneo nmap y respondé EXACTAMENTE en este formato:

    🔍 PUERTOS CRÍTICOS:
    [Lista de puertos abiertos y servicios relevantes]

    🎯 TÉCNICAS MITRE ATT&CK:
    [IDs y nombres de técnicas aplicables, ej: T1046 - Network Service Scanning]

    ⚡ PRÓXIMOS PASOS RECOMENDADOS:
    [Comandos o acciones concretas para explotar/enumerar más]

    Escaneo realizado:
    $nmap_result"
    
    # Llamar a Ollama (usando la IP/config del entorno)
    local response=$(curl -s http://$OLLAMA_HOST/api/generate -d "{
        \"model\": \"$OLLAMA_MODEL\",
        \"prompt\": \"$prompt\",
        \"stream\": false,
        \"options\": {\"temperature\": 0.5, \"max_tokens\": 800}
    }" 2>/dev/null | python3 -c "import sys, json; data=json.load(sys.stdin); print(data.get('response', 'Error: No se pudo analizar'))" 2>/dev/null)
    
    echo -e "${GREEN}══════════════════════════════════════════════${NC}"
    echo -e "${GREEN}🤖 ANÁLISIS DE IA (${OLLAMA_MODEL})${NC}"
    echo -e "${GREEN}══════════════════════════════════════════════${NC}"
    echo "$response"
    echo -e "${GREEN}══════════════════════════════════════════════${NC}"
    
    # Guardar análisis
    echo "$response" > "analisis_ia_$target.txt"
    echo -e "\n💾 Análisis guardado en analisis_ia_$target.txt"
    
    rm -f /tmp/nmap_raw_$$.txt
}
