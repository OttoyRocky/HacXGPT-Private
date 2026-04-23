#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m'

echo "Prueba directa de Ollama con mistral:7b"
echo ""

response=$(curl -s http://localhost:11434/api/generate -d '{
  "model": "mistral:7b",
  "prompt": "Respondé en 2 lineas: como enumerar usuarios en un dominio Windows",
  "stream": false
}' | python3 -c "import sys, json; data=json.load(sys.stdin); print(data.get('response', 'Error'))" 2>/dev/null)

echo -e "${GREEN}Respuesta de Mistral:${NC}"
echo "$response"
