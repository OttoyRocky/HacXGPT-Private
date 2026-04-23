#!/usr/bin/env python3
import subprocess
import json
import urllib.request

def main():
    target = input("🎯 Ingresa IP/dominio para escanear: ")
    
    print(f"\n🔍 Ejecutando nmap sigiloso contra {target}...")
    result = subprocess.run(
        ["nmap", "-sS", "-sV", "-T2", "-Pn", target],
        capture_output=True, text=True
    )
    scan_output = result.stdout
    print("✅ Escaneo completado")
    print("🤖 Enviando a IA para análisis...\n")
    
    prompt = f"""Analizá este escaneo nmap. Respondé en español:
1) Puertos críticos abiertos
2) Técnicas MITRE ATT&CK aplicables
3) Próximos pasos

Escaneo:
{scan_output}"""
    
    data = {
        "model": "mistral:7b",
        "prompt": prompt,
        "stream": False
    }
    
    req = urllib.request.Request(
        "http://172.20.160.1:11435/api/generate",
        data=json.dumps(data).encode(),
        headers={"Content-Type": "application/json"}
    )
    
    print("⏳ Analizando... (puede tomar 30-60 segundos)")
    try:
        with urllib.request.urlopen(req, timeout=120) as response:
            response_data = json.loads(response.read().decode())
            ai_response = response_data.get("response", "Error: Respuesta vacía")
    except Exception as e:
        ai_response = f"Error al conectar con Ollama: {e}"
    
    print("\n" + "=" * 50)
    print("🤖 ANÁLISIS DE IA (mistral:7b)")
    print("=" * 50)
    print(ai_response)
    print("=" * 50)
    
    with open(f"analisis_ia_{target}.txt", "w") as f:
        f.write(ai_response)
    print(f"\n💾 Análisis guardado en analisis_ia_{target}.txt")
    
    input("\nPresiona Enter para volver al menú...")

if __name__ == "__main__":
    main()
