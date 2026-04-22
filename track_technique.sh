#!/bin/bash
# Función para registrar técnicas MITRE ejecutadas
track_technique() {
    local technique_id="$1"
    local technique_name="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Crear archivo si no existe
    if [ ! -f /tmp/hacx_techniques.json ]; then
        echo '{"executed": []}' > /tmp/hacx_techniques.json
    fi
    
    # Verificar si ya existe
    if ! grep -q "\"$technique_id\"" /tmp/hacx_techniques.json; then
        # Agregar nueva técnica
        python3 -c "
import json
with open('/tmp/hacx_techniques.json', 'r') as f:
    data = json.load(f)
data['executed'].append({
    'id': '$technique_id',
    'name': '$technique_name',
    'timestamp': '$timestamp'
})
with open('/tmp/hacx_techniques.json', 'w') as f:
    json.dump(data, f, indent=2)
print('✅ Técnica registrada: $technique_id - $technique_name')
"
    else
        echo "ℹ️ Técnica ya registrada: $technique_id"
    fi
}

# Exportar función
export -f track_technique
