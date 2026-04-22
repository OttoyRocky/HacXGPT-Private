#!/usr/bin/env python3
import json
import os

# Técnicas MITRE completas (top 20 más comunes)
ALL_TECHNIQUES = {
    "T1046": "Network Service Scanning",
    "T1595": "Active Scanning",
    "T1040": "Network Sniffing",
    "T1057": "Process Discovery",
    "T1083": "File and Directory Discovery",
    "T1069": "Permission Groups Discovery",
    "T1087": "Account Discovery",
    "T1016": "System Network Configuration Discovery",
    "T1049": "Network Connections Discovery",
    "T1059": "Command and Scripting Interpreter",
    "T1204": "User Execution",
    "T1566": "Phishing",
    "T1190": "Exploit Public-Facing Application",
    "T1055": "Process Injection",
    "T1071": "Application Layer Protocol",
    "T1041": "Exfiltration Over C2 Channel",
    "T1567": "Exfiltration Over Web Service",
    "T1498": "Network Denial of Service",
    "T1486": "Data Encrypted for Impact",
    "T1530": "Data from Cloud Storage Object"
}

def main():
    # Leer técnicas ejecutadas
    if os.path.exists('/tmp/hacx_techniques.json'):
        with open('/tmp/hacx_techniques.json', 'r') as f:
            data = json.load(f)
            executed = {t['id']: t['name'] for t in data.get('executed', [])}
    else:
        executed = {}
    
    # Calcular gap
    total = len(ALL_TECHNIQUES)
    covered = len(executed)
    gap = total - covered
    percentage = (covered / total) * 100 if total > 0 else 0
    
    # Mostrar heat map
    print("\n" + "=" * 60)
    print("📊 GAP ANALYSIS DINÁMICO - MITRE ATT&CK")
    print("=" * 60)
    print(f"\n📈 Progreso: {covered}/{total} técnicas ({percentage:.1f}%)\n")
    
    # Mostrar técnicas ejecutadas (verde)
    print("✅ TÉCNICAS EJECUTADAS:")
    for tid, tname in executed.items():
        print(f"   🟢 {tid} - {tname}")
    
    # Mostrar técnicas pendientes (rojo)
    print("\n❌ TÉCNICAS PENDIENTES:")
    pending_count = 0
    for tid, tname in ALL_TECHNIQUES.items():
        if tid not in executed:
            print(f"   🔴 {tid} - {tname}")
            pending_count += 1
            if pending_count >= 10:
                remaining = len(ALL_TECHNIQUES) - len(executed) - 10
                if remaining > 0:
                    print(f"   ... y {remaining} técnicas más")
                break
    
    print("\n" + "=" * 60)
    print("💡 RECOMENDACIÓN:")
    if gap == 0:
        print("🎉 Excelente! Has cubierto todas las técnicas principales")
    else:
        print(f"📌 Prioriza las {gap} técnicas pendientes para mejorar tu cobertura")
    print("=" * 60)
    
    # Guardar reporte
    with open("gap_analysis_report.txt", "w") as f:
        f.write(f"Gap Analysis - {covered}/{total} técnicas ({percentage:.1f}%)\n")
        f.write(f"Ejecutadas: {', '.join(executed.keys())}\n")
        f.write(f"Pendientes: {', '.join([tid for tid in ALL_TECHNIQUES if tid not in executed])}\n")
    print("\n💾 Reporte guardado en gap_analysis_report.txt")

if __name__ == "__main__":
    main()
