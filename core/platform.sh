#!/bin/bash
# core/platform.sh — Detección multiplataforma WSL / Kali / Raspberry Pi

detect_platform() {
    if grep -qi microsoft /proc/version 2>/dev/null; then
        echo "WSL"
    elif [[ -f /proc/device-tree/model ]] && grep -qi "raspberry pi" /proc/device-tree/model 2>/dev/null; then
        echo "RASPBERRY_PI"
    elif uname -r | grep -qi "kali"; then
        echo "KALI"
    else
        echo "LINUX"
    fi
}

resolve_ollama_host() {
    local platform
    platform=$(detect_platform)

    case "$platform" in
        WSL)
            OLLAMA_HOST="$(ip route | grep default | awk '{print $3}'):11435"
            ;;
        RASPBERRY_PI|KALI|LINUX)
            OLLAMA_HOST="localhost:11435"
            ;;
    esac

    export OLLAMA_HOST
    echo "🖥️  $platform → Ollama en $OLLAMA_HOST"
}
