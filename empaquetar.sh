#!/bin/sh
# Genera en dist/:
# - penalisto.zip: el agente entero, para cargarlo como app personalizada (ADR 0007).
#   Necesita Node. Si hay MATERIAL_COMUN_URL, el agente usa esa carpeta como conocimiento;
#   si no, sale sin acceso a OneDrive. La GitHub Action lo publica en cada cambio.
# - un .zip por skill, para el camino manual del creador de agentes de Copilot.
set -e
raiz="$(cd "$(dirname "$0")" && pwd)"
mkdir -p "$raiz/dist"

cd "$raiz/agente/skills"
for d in */; do
  n="${d%/}"
  rm -f "$raiz/dist/$n.zip"
  zip -qr "$raiz/dist/$n.zip" "$n"
done

cd "$raiz"
paquete=./agente
if [ -z "$MATERIAL_COMUN_URL" ]; then
  echo "Sin MATERIAL_COMUN_URL: penalisto.zip sale sin material común" >&2
  # Sin URL, OneDriveAndSharePoint buscaría en todo su OneDrive y mezclaría Asuntos: se quita
  rm -rf build/agente && mkdir -p build && cp -R agente build/agente
  paquete=./build/agente
  node -e '
    const fs = require("fs"), f = process.argv[1];
    const da = JSON.parse(fs.readFileSync(f, "utf8"));
    da.capabilities = da.capabilities.filter(c => c.name !== "OneDriveAndSharePoint");
    fs.writeFileSync(f, JSON.stringify(da, null, 4) + "\n");
  ' "$paquete/declarativeAgent.json"
fi
# ATK_FRONTIER hace que la CLI meta las skills en el paquete
ATK_FRONTIER=true TEAMSFX_AGENT_SKILLS=true npx -y @microsoft/m365agentstoolkit-cli@1.1.18 package \
  --env dev --manifest-file "$paquete/manifest.json" \
  --output-package-file ./dist/penalisto.zip --output-folder ./build -i false
# La CLI no falla si faltan las skills, así que lo compruebo
unzip -l dist/penalisto.zip | grep -q "skills/.*/SKILL.md" || { echo "penalisto.zip sin skills" >&2; exit 1; }
ls "$raiz/dist"
