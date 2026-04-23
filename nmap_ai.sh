#!/bin/bash
# Módulo 14: Análisis de nmap con IA

source "$(dirname "$0")/core/platform.sh"
source "$(dirname "$0")/core/guarden.sh"

resolve_ollama_host
validate_target
require_tool nmap curl

OLLAMA_MODEL="mistral:7b"

echo "🔍 Análisis de nmap con IA"
echo "=========================="
read -p "🎯 Ingresa IP/dominio para escanear: " TARGET

echo ""
echo "🔍 Ejecutando nmap sigiloso contra $TARGET..."
nmap -sS -sV -T2 -Pn "$TARGET" > /tmp/nmap_scan.txt 2>&1

echo ""
echo "✅ Escaneo completado"
echo "🤖 Enviando a IA para análisis (usando $OLLAMA_MODEL)..."
echo ""

# Leer el resultado del escaneo
SCAN_RESULT=$(cat /tmp/nmap_scan.txt)

# Enviar a Ollama y guardar respuesta completa
RESPONSE=$(curl -s http://$OLLAMA_HOST/api/generate -d "{
    \"model\": \"$OLLAMA_MODEL\",
    \"prompt\": \"Analizá este escaneo nmap. Respondé en español: 1) Puertos críticos abiertos, 2) Técnicas MITRE ATT&CK aplicables, 3) Próximos pasos:\n\n$SCAN_RESULT\",
    \"stream\": false
}")

# Extraer el campo 'response' usando grep y cut
RESPONSE_TEXT=$(echo "$RESPONSE" | grep -o '"response":"[^"]*"' | cut -d'"' -f4)

# Si no se extrajo nada, mostrar el error
if [ -z "$RESPONSE_TEXT" ]; then
    RESPONSE_TEXT="Error: No se pudo obtener respuesta de Ollama. Verifica que el modelo $OLLAMA_MODEL esté disponible."
fi

echo "══════════════════════════════════════════════"
echo "🤖 ANÁLISIS DE IA ($OLLAMA_MODEL)"
echo "══════════════════════════════════════════════"
echo "$RESPONSE_TEXT"
echo "══════════════════════════════════════════════"

# Guardar resultado
echo "$RESPONSE_TEXT" > "analisis_ia_$TARGET.txt"
echo ""
echo "💾 Análisis guardado en analisis_ia_$TARGET.txt"

rm -f /tmp/nmap_scan.txt
