# 🛡️ HacXGPT v8.0 EXPERTO - MITRE ATT&CK Framework
# 🛡️ HacXGPT v8.0 EXPERTO - MITRE ATT&CK Framework

![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Kali](https://img.shields.io/badge/Kali_Linux-557C94?style=for-the-badge&logo=kali-linux&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)

⚠️ **REPOSITORIO PRIVADO** - Acceso restringido

## 📋 DESCRIPCIÓN
**HacXGPT v8.0 EXPERTO** es una herramienta educativa de ciberseguridad que implementa el **framework MITRE ATT&CK Enterprise** completo. Diseñada para profesionales de seguridad, estudiantes y equipos Red/Blue/Purple Team.

### 🎯 CARACTERÍSTICAS PRINCIPALES
- **MITRE ATT&CK Enterprise**: 14 tácticas con técnicas detalladas
- **Purple Team**: Ataque (🔴) + Defensa (🔵) + Detección (🟣) para 10+ técnicas
- **Post-Explotación**: Windows, Linux y técnicas de evasión
- **Simulación APT**: APT29, APT38, FIN7 con killchain completa
- **Gap Analysis**: Heat map visual de cobertura
- **Sistema TARGET**: Objetivo persistente en todos los módulos
- **Chat Libre**: Base de conocimiento con 200+ comandos

## ⚙️ REQUISITOS DEL SISTEMA

### Mínimos:
- **SO**: Linux (Kali Linux recomendado), macOS, o **WSL en Windows**
- **Shell**: Bash 4.0+ o ZSH
- **Permisos**: Ejecución de scripts (`chmod +x`)

### Recomendados (para funcionalidad completa):
```bash
# Herramientas de pentesting (opcionales pero recomendadas)
sudo apt update
sudo apt install -y nmap nikto gobuster whatweb wfuzz sqlmap hydra john aircrack-ng

# Frameworks adicionales
pip3 install impacket bloodhound
sudo gem install evil-winrm
🚀 INSTALACIÓN Y CONFIGURACIÓN
1. Clonar el repositorio
bash
git clone https://github.com/OttoyRocky/HacXGPT-Private.git
cd HacXGPT-Private
2. Dar permisos de ejecución
bash
chmod +x hacx_advanced.sh
chmod +x *.sh  # Para todos los scripts auxiliares
3. (Opcional) Verificar dependencias
bash
# El script verificará automáticamente las herramientas al ejecutarse
./hacx_advanced.sh --check-deps
🎮 USO BÁSICO
Ejecutar el script
bash
./hacx_advanced.sh
Flujo de trabajo típico
Establecer objetivo: Al entrar a cualquier módulo te pedirá IP/dominio

Explorar módulos:

1-8 → Módulos básicos (reconocimiento, escaneo, etc.)

9 → Matriz MITRE ATT&CK

10 → Purple Team (técnica por técnica)

11 → Post-Explotación

12 → Simulación APT

13 → Gap Analysis

Cambiar objetivo: Opción C en menú principal

Guardar resultados: Opción S en cualquier submenú

Ejemplo práctico con WSL
bash
./hacx_advanced.sh
# Menú > Opción 10 (Purple Team) > T1003 > objetivo: ejemplo.com
# Verás:
# 🔴 ATAQUE — Comandos de extracción de credenciales
# 🔵 DEFENSA — Medidas de protección
# 🟣 DETECCIÓN — Logs a monitorear
📁 ESTRUCTURA DEL PROYECTO
text
HacXGPT-Private/
├── hacx_advanced.sh          # Script principal (v8.0 EXPERTO)
├── mitre_data.sh             # Base de datos MITRE principal
├── mitre_extras_1.sh         # Datos MITRE adicionales (Reconnaissance)
├── mitre_extras_2.sh         # Datos MITRE adicionales (Execution/Persistence)
├── mitre_extras_3.sh         # Datos MITRE adicionales (Exfiltration/Impact)
├── .cursorrules              # Reglas para desarrollo con IA
├── docs/                      # Documentación detallada
│   ├── USO.md                # Guía de uso
│   └── MITRE_ATTACK.md       # Explicación del framework
└── README.md                  # Este archivo
🛡️ MÓDULOS DETALLADOS
Módulo 9 - Matriz MITRE ATT&CK
14 tácticas: Desde Reconnaissance (TA0043) hasta Impact (TA0040)

Técnicas clave: 5 técnicas por táctica con descripciones

Modo Purple: Ver técnica en modo completo (🔴🔵🟣)

Módulo 10 - Purple Team
Técnicas implementadas:

T1003: OS Credential Dumping (Mimikatz, LSASS)

T1027: Obfuscated Files/Info (Ofuscación)

T1055: Process Injection (Inyección de código)

T1059: Command and Scripting Interpreter (PowerShell, bash)

T1078: Valid Accounts (Cuentas válidas)

T1021: Remote Services (Psexec, WinRM, SSH)

T1053: Scheduled Task/Job (Tareas programadas)

T1190: Exploit Public-Facing Application (Exploits web)

T1566: Phishing (Ingeniería social)

T1562: Impair Defenses (Deshabilitar AV/EDR)

Módulo 11 - Post-Explotación
Windows: Mimikatz, extracción de hashes, persistencia

Linux: Bash history, sudo tokens, cron jobs

Evasión: Bypass UAC, AMSI bypass, process injection

Módulo 12 - Simulación APT
APT29 (Cozy Bear): Spear phishing, PowerShell Empire

APT38 (Lazarus): Ataques destructivos, ransomware

FIN7: Malware point-of-sale, harvesting

Módulo 13 - Gap Analysis
Heat map visual de técnicas probadas vs no probadas

Colores: ✅ Verde (probado), 🟡 Amarillo (parcial), ❌ Rojo (no probado)

⚠️ ADVERTENCIAS LEGALES
IMPORTANTE: Esta herramienta es EXCLUSIVAMENTE PARA FINES EDUCATIVOS Y PROFESIONALES AUTORIZADOS.

✅ REQUIERE autorización explícita por escrito para cualquier prueba

✅ SOLO usar contra sistemas propios o con permiso documentado

❌ NO usar contra sistemas sin consentimiento explícito

❌ NO usar para actividades ilegales o maliciosas

El usuario asume toda la responsabilidad legal y ética de su uso.

🔄 ACTUALIZACIONES
v8.0 EXPERTO (Marzo 2026): MITRE ATT&CK completo, Purple Team, Post-Explotación, APT Sims, Gap Analysis

v7.0 (Anterior): Chat libre, escaneo sigiloso

🐧 NOTA PARA USUARIOS DE WSL
Si estás usando WSL:

Los scripts funcionan perfectamente en el entorno Linux de WSL

Podés acceder a archivos de Windows desde /mnt/c/

Recomendación: mantener los scripts dentro del filesystem de Linux para mejor rendimiento

📚 RECURSOS ADICIONALES
MITRE ATT&CK Enterprise

OWASP Top 10

Kali Linux Documentation

📧 CONTACTO Y SOPORTE
Para uso autorizado, dudas o reportes:

Issues: Limitado a colaboradores autorizados

Documentación: Ver carpeta /docs

© 2026 OttoyRocky - Repositorio Privado - Todos los derechos reservados

