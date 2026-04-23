#!/bin/bash
# Ollama Integration - HacXGPT IA Real

source "$(dirname "$0")/core/platform.sh"
source "$(dirname "$0")/ollama_config.sh" 2>/dev/null

_chat_with_ollama() {
    local pregunta="$1"
    local target="${CHAT_TARGET:-[OBJETIVO_NO_DEFINIDO]}"
    local response=""

    local GREEN='\033[0;32m'
    local CYAN='\033[0;36m'
    local YELLOW='\033[1;33m'
    local RED='\033[0;31m'
    local NC='\033[0m'

    resolve_ollama_host

    # Detectar modelo: Pi usa tinyllama, WSL/Linux usa config o mistral:7b
    local model="${OLLAMA_MODEL:-mistral:7b}"
    local platform
    platform=$(detect_platform)
    if [[ "$platform" == "RASPBERRY_PI" ]]; then
        model="tinyllama"
    fi
    
    echo -e "${CYAN}🤖 Consultando IA local (${model})...${NC}"
    
    local system_prompt="Eres HacXGPT, experto en ciberseguridad ofensiva y pentesting. Contexto: El objetivo actual es $target. Responde de forma técnica, práctica y directa. Sé conciso."
    
    # Llamar a Ollama con contexto limitado para mayor velocidad
    response=$(curl -s $ollama_host/api/generate -d "{
        \"model\": \"$model\",
        \"prompt\": \"$system_prompt\n\nPregunta del usuario: $pregunta\",
        \"stream\": false,
        \"options\": {
            \"temperature\": 0.7,
            \"max_tokens\": 300,
            \"num_ctx\": 1024
        }
    }" 2>/dev/null | python3 -c "import sys, json; data=json.load(sys.stdin); print(data.get('response', ''))" 2>/dev/null)
    
    if [[ -n "$response" && "$response" != "null" ]]; then
        echo -e "${GREEN}🤖 HacXGPT (IA):${NC}"
        echo "══════════════════════════════════════════════"
        echo "$response"
        echo "══════════════════════════════════════════════"
        if declare -f save_output > /dev/null; then
            save_output "[IA] $pregunta -> $response"
        fi
    else
        _chat_default_fallback "$pregunta"
    fi
}

_chat_default_fallback() {
    local pregunta="$1"
    local YELLOW='\033[1;33m'
    local GREEN='\033[0;32m'
    local NC='\033[0m'
    
    echo -e "${YELLOW}📚 [Modo offline] No tengo una respuesta específica para esa pregunta.${NC}"
    echo ""
    echo -e "${GREEN}💡 Preguntas que puedo ayudarte:${NC}"
    echo "   • Técnicas MITRE ATT&CK (TA0001 a TA0040)"
    echo "   • Comandos de nmap, metasploit, hydra"
    echo "   • Reverse shells, bind shells"
    echo "   • Escaneo sigiloso, evasión de WAF"
    echo ""
    echo "📝 Ejemplos:"
    echo "   • 'cómo hacer un escaneo SYN con nmap'"
    echo "   • 'explica T1059.001'"
    
    if declare -f save_output > /dev/null; then
        save_output "[Sin match] $pregunta -> Respuesta genérica"
    fi
}
