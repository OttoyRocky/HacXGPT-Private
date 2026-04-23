#!/bin/bash
# core/guarden.sh — Validaciones de seguridad

set -euo pipefail

validate_target() {
    if [[ -z "${TARGET:-}" ]]; then
        echo "❌ [ERROR] TARGET no definido. Usá opción C para configurar."
        exit 1
    fi
    if ! echo "$TARGET" | grep -qP '^(\d{1,3}\.){3}\d{1,3}$|^[a-zA-Z0-9][-a-zA-Z0-9]*\.[a-zA-Z]{2,}'; then
        echo "❌ [ERROR] TARGET inválido: '$TARGET'"
        exit 1
    fi
}

require_tool() {
    local missing=()
    for tool in "$@"; do
        command -v "$tool" >/dev/null 2>&1 || missing+=("$tool")
    done
    if [[ ${#missing[@]} -gt 0 ]]; then
        echo "❌ Faltan herramientas: ${missing[*]}"
        exit 1
    fi
}

confirm_risk() {
    local module="$1"
    local level="${2:-MEDIO}"
    echo "⚠️  [RIESGO: $level] Módulo: $module | Target: ${TARGET:-NO DEFINIDO}"
    [[ -t 0 ]] && read -r -p "¿Continuar? (s/N): " answer && [[ "${answer,,}" =~ ^s ]] || exit 0
}
