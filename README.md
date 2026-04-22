# 🛡️ HacXGPT v8.1 - MITRE ATT&CK Framework + IA Local

![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Kali](https://img.shields.io/badge/Kali_Linux-557C94?style=for-the-badge&logo=kali-linux&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Ollama](https://img.shields.io/badge/Ollama-000000?style=for-the-badge&logo=ollama&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)

## 📋 DESCRIPCIÓN

**HacXGPT v8.1** es una herramienta educativa de ciberseguridad que combina el **framework MITRE ATT&CK Enterprise** completo con **IA local via Ollama**. Sin dependencias de APIs externas. Todo corre localmente.

## 🎯 CARACTERÍSTICAS PRINCIPALES

- **IA Local (Ollama)**: Chat libre con LLM real — responde cualquier pregunta de ciberseguridad
- **Detección automática de entorno**: `mistral:7b` en Windows/WSL, `tinyllama` en Raspberry Pi
- **MITRE ATT&CK Enterprise**: 14 tácticas con técnicas detalladas
- **Purple Team**: Ataque (🔴) + Defensa (🔵) + Detección (🟣) para 10+ técnicas
- **Post-Explotación**: Windows, Linux y técnicas de evasión
- **Simulación APT**: APT29, APT38, FIN7 con killchain completa
- **Gap Analysis**: Heat map visual de cobertura
- **Sistema TARGET**: Objetivo persistente en todos los módulos

## ⚙️ REQUISITOS

- Linux / Kali / macOS / WSL en Windows
- Bash 4.0+
- Ollama instalado con al menos un modelo

\`\`\`bash
curl -fsSL https://ollama.com/install.sh | sh
ollama pull mistral:7b    # Windows/WSL
ollama pull tinyllama     # Raspberry Pi
\`\`\`

Herramientas de pentesting (opcionales):

\`\`\`bash
sudo apt install -y nmap nikto gobuster sqlmap hydra john aircrack-ng
\`\`\`

## 🚀 INSTALACIÓN

\`\`\`bash
git clone https://github.com/OttoyRocky/HacXGPT-Private.git
cd HacXGPT-Private
chmod +x *.sh
./hacx_advanced.sh
\`\`\`

## 🤖 IA LOCAL — CÓMO FUNCIONA

El Módulo 7 (Chat Libre) combina respuestas estructuradas con IA real:

| Modo | Cuándo | Qué hace |
|------|--------|----------|
| Keywords | Pregunta con tema conocido | Respuesta estructurada MITRE |
| IA (Ollama) | Pregunta libre sin match | LLM responde en tiempo real |

Detección automática de entorno:
- **Windows/WSL** → conecta a `172.20.160.1:11434` con `mistral:7b`
- **Raspberry Pi / Linux nativo** → conecta a `localhost:11434` con `tinyllama`

> **Nota WSL**: Ollama debe correr con `$env:OLLAMA_HOST="0.0.0.0:11434"; ollama serve`

## 🎮 USO

\`\`\`bash
./hacx_advanced.sh
\`\`\`

| Opción | Módulo |
|--------|--------|
| 1-8 | Reconocimiento, escaneo, explotación |
| 7 | Chat libre con IA local |
| 9 | Matriz MITRE ATT&CK completa |
| 10 | Purple Team por técnica |
| 11 | Post-Explotación |
| 12 | Simulación APT |
| 13 | Gap Analysis |
| C | Cambiar objetivo |
| S | Guardar resultados |

## 📁 ESTRUCTURA

\`\`\`
HacXGPT-Private/
├── hacx_advanced.sh       # Script principal
├── ollama_integration.sh  # Módulo IA local
├── mitre_data.sh          # Base de datos MITRE principal
├── mitre_extras_1.sh      # MITRE: Reconnaissance
├── mitre_extras_2.sh      # MITRE: Execution/Persistence
├── mitre_extras_3.sh      # MITRE: Exfiltration/Impact
└── docs/
    ├── USO.md
    └── MITRE_ATTACK.md
\`\`\`

## 🔄 CHANGELOG

| Versión | Fecha | Cambios |
|---------|-------|---------|
| v8.1 | Abril 2026 | IA local Ollama, detección automática Pi vs Windows/WSL |
| v8.0 | Marzo 2026 | MITRE completo, Purple Team, APT Sims, Gap Analysis |
| v7.0 | Anterior | Chat libre, escaneo sigiloso |

## ⚠️ AVISO LEGAL

Uso exclusivo para fines educativos y auditorías autorizadas.

- ✅ Solo contra sistemas propios o con permiso documentado
- ❌ Prohibido sin autorización explícita
- El usuario asume toda responsabilidad legal y ética

## 📚 RECURSOS

- [MITRE ATT&CK Enterprise](https://attack.mitre.org/)
- [Ollama](https://ollama.com/)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Kali Linux Docs](https://www.kali.org/docs/)

## 📧 CONTACTO

Issues y contribuciones bienvenidas via GitHub.

© 2026 OttoyRocky — MIT License
