# Cargar configuración si existe
if [ -f "$(dirname "$0")/ollama_config.sh" ]; then
    source "$(dirname "$0")/ollama_config.sh"
fi

# ============================================
# OLLAMA INTEGRATION - HacXGPT IA Real (Optimizado)
# ============================================

_chat_with_ollama() {
    local pregunta="$1"
    local target="${CHAT_TARGET:-[OBJETIVO_NO_DEFINIDO]}"
    local response=""
    
    local GREEN='\033[0;32m'
    local CYAN='\033[0;36m'
    local YELLOW='\033[1;33m'
    local RED='\033[0;31m'
    local NC='\033[0m'
    
    if ! command -v ollama &> /dev/null; then
        _chat_default_fallback "$pregunta"
        return
    fi
    
    # Priorizar modelos livianos para Raspberry Pi
    local model=$(ollama list 2>/dev/null | grep -E "tinyllama|gemma:2b|phi3:mini" | head -1 | awk '{print $1}')
    if [[ -z "$model" ]]; then
        model=$(ollama list 2>/dev/null | grep -v "NAME" | head -1 | awk '{print $1}')
    fi
    
    if [[ -z "$model" ]]; then
        _chat_default_fallback "$pregunta"
        return
    fi
    
    echo -e "${CYAN}🤖 Consultando IA local (${model})...${NC}"
    
    local system_prompt="Eres HacXGPT, experto en ciberseguridad ofensiva y pentesting. Contexto: El objetivo actual es $target. Responde de forma técnica, práctica y directa. Sé conciso."
    
    # Llamar a Ollama con contexto limitado para mayor velocidad
    response=$(curl -s http://localhost:11434/api/generate -d "{
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
